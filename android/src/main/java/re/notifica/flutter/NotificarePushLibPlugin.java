package re.notifica.flutter;

import android.app.Activity;
import android.app.Application;
import android.content.Context;
import android.content.Intent;
import android.content.SharedPreferences;
import android.net.Uri;
import android.os.Bundle;
import android.os.Handler;
import android.os.Looper;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;
import androidx.lifecycle.DefaultLifecycleObserver;
import androidx.lifecycle.LifecycleOwner;
import androidx.lifecycle.LiveData;
import androidx.lifecycle.Observer;

import com.google.android.gms.common.api.CommonStatusCodes;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import java.util.SortedSet;

import io.flutter.embedding.engine.plugins.FlutterPlugin;
import io.flutter.embedding.engine.plugins.activity.ActivityAware;
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding;
import io.flutter.embedding.engine.plugins.lifecycle.FlutterLifecycleAdapter;
import io.flutter.plugin.common.BinaryMessenger;
import io.flutter.plugin.common.EventChannel;
import io.flutter.plugin.common.JSONMethodCodec;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;
import io.flutter.plugin.common.PluginRegistry;
import io.flutter.plugin.common.PluginRegistry.Registrar;
import re.notifica.Notificare;
import re.notifica.NotificareCallback;
import re.notifica.NotificareError;
import re.notifica.beacon.BeaconRangingListener;
import re.notifica.billing.BillingManager;
import re.notifica.billing.NotificareBillingResult;
import re.notifica.billing.NotificarePurchase;
import re.notifica.model.NotificareApplicationInfo;
import re.notifica.model.NotificareAsset;
import re.notifica.model.NotificareBeacon;
import re.notifica.model.NotificareDynamicLink;
import re.notifica.model.NotificareInboxItem;
import re.notifica.model.NotificareNotification;
import re.notifica.model.NotificarePass;
import re.notifica.model.NotificareProduct;
import re.notifica.model.NotificareScannable;
import re.notifica.model.NotificareTimeOfDay;
import re.notifica.model.NotificareTimeOfDayRange;
import re.notifica.model.NotificareUser;
import re.notifica.model.NotificareUserData;
import re.notifica.model.NotificareUserDataField;
import re.notifica.model.NotificareUserPreference;
import re.notifica.model.NotificareUserSegment;
import re.notifica.util.Log;

/** NotificarePushLibPlugin */
public class NotificarePushLibPlugin implements FlutterPlugin, ActivityAware, Application.ActivityLifecycleCallbacks, DefaultLifecycleObserver, PluginRegistry.ActivityResultListener, PluginRegistry.NewIntentListener, MethodCallHandler, EventChannel.StreamHandler, Observer<SortedSet<NotificareInboxItem>>, Notificare.OnNotificareReadyListener, Notificare.OnServiceErrorListener, Notificare.OnNotificareNotificationListener, BeaconRangingListener, Notificare.OnBillingReadyListener, BillingManager.OnRefreshFinishedListener, BillingManager.OnPurchaseFinishedListener {

  private static final String TAG = NotificarePushLibPlugin.class.getSimpleName();

  private static final int SCANNABLE_REQUEST_CODE = 9004;
  private static final String DEFAULT_ERROR_CODE = "notificare_error";
  private Activity mActivity;
  private MethodChannel mMethodChannel;
  private EventChannel mEventChannel;
  private LiveData<SortedSet<NotificareInboxItem>> mInboxItems;
  private boolean mIsBillingReady = false;

  /**
   * Shared prefs name for settings
   */
  private static final String SETTINGS_PREFERENCES = "re.notifica.flutter.preferences.Settings";

  /**
   * Plugin registration.
   * v1
   */
  public static void registerWith(Registrar registrar) {
    Log.i(TAG, "registering Notificare plugin with registrar");
    NotificarePushLibPlugin plugin = new NotificarePushLibPlugin();
    registrar.addActivityResultListener(plugin);
    registrar.addNewIntentListener(plugin);
    plugin.mActivity = registrar.activity();
    plugin.setupChannels(registrar.messenger());
    if (registrar.context() != null) {
      Application application = (Application) (registrar.context().getApplicationContext());
      application.registerActivityLifecycleCallbacks(plugin);
    }
    if (plugin.mActivity.getIntent() != null) {
      plugin.handleIntent(plugin.mActivity.getIntent());
    }
  }

  private void setupChannels(@NonNull BinaryMessenger messenger) {
    mMethodChannel = new MethodChannel(messenger, "notificare_push_lib", JSONMethodCodec.INSTANCE);
    mMethodChannel.setMethodCallHandler(this);
    mEventChannel = new EventChannel(messenger, "notificare_push_lib/events", JSONMethodCodec.INSTANCE);
    mEventChannel.setStreamHandler(this);
  }

  // Plugin registration methods for v2

  @Override
  public void onAttachedToEngine(@NonNull FlutterPluginBinding binding) {
    Log.i(TAG, "attaching Notificare plugin");
    setupChannels(binding.getBinaryMessenger());
  }

  @Override
  public void onDetachedFromEngine(@NonNull FlutterPluginBinding binding) {
    Log.i(TAG, "detaching Notificare plugin");
    mMethodChannel.setMethodCallHandler(null);
    mMethodChannel = null;
    mEventChannel.setStreamHandler(null);
    mEventChannel = null;
  }

  // ActivityAware methods for v2

  @Override
  public void onAttachedToActivity(@NonNull ActivityPluginBinding binding) {
    Log.i(TAG, "attaching Notificare plugin to activity");
    binding.addActivityResultListener(this);
    binding.addOnNewIntentListener(this);
    mActivity = binding.getActivity();
    FlutterLifecycleAdapter.getActivityLifecycle(binding).addObserver(this);
    if (mActivity.getIntent() != null) {
      handleIntent(mActivity.getIntent());
    }
  }

  @Override
  public void onDetachedFromActivityForConfigChanges() {
    onDetachedFromActivity();
  }

  @Override
  public void onReattachedToActivityForConfigChanges(@NonNull ActivityPluginBinding binding) {
    onAttachedToActivity(binding);
  }

  @Override
  public void onDetachedFromActivity() {
    Log.i(TAG, "detaching Notificare plugin from activity");
    mActivity = null;
  }

  // Lifecycle listeners for v2

  @Override
  public void onCreate(@NonNull LifecycleOwner owner) {

  }

  @Override
  public void onStart(@NonNull LifecycleOwner owner) {

  }

  @Override
  public void onResume(@NonNull LifecycleOwner owner) {
    onActivityResumed(mActivity);
  }

  @Override
  public void onPause(@NonNull LifecycleOwner owner) {
    onActivityPaused(mActivity);
  }

  @Override
  public void onStop(@NonNull LifecycleOwner owner) {

  }

  @Override
  public void onDestroy(@NonNull LifecycleOwner owner) {

  }

  // ActivityLifecycle listeners for v1

  @Override
  public void onActivityCreated(@NonNull Activity activity, @Nullable Bundle savedInstanceState) {
  }

  @Override
  public void onActivityStarted(@NonNull Activity activity) {

  }

  @Override
  public void onActivityResumed(@NonNull Activity activity) {
    if (activity == mActivity) {
      Notificare.shared().addServiceErrorListener(this);
      Notificare.shared().addNotificareNotificationListener(this);
      if (Notificare.shared().getBeaconClient() != null) {
        Notificare.shared().getBeaconClient().addRangingListener(this);
      }
      Notificare.shared().addBillingReadyListener(this);
    }
  }

  @Override
  public void onActivityPaused(@NonNull Activity activity) {
    if (activity == mActivity) {
      Notificare.shared().removeServiceErrorListener(this);
      Notificare.shared().removeNotificareNotificationListener(this);
      if (Notificare.shared().getBeaconClient() != null) {
        Notificare.shared().getBeaconClient().removeRangingListener(this);
      }
      Notificare.shared().removeBillingReadyListener(this);
    }
  }

  @Override
  public void onActivityStopped(@NonNull Activity activity) {

  }

  @Override
  public void onActivitySaveInstanceState(@NonNull Activity activity, @NonNull Bundle outState) {

  }

  @Override
  public void onActivityDestroyed(@NonNull Activity activity) {

  }

  @Override
  public void onMethodCall(@NonNull MethodCall call, @NonNull Result result) {
    if ("launch".equals(call.method)) {
      Notificare.shared().addNotificareReadyListener(this);
      replySuccess(result, null);
    } else if ("unlaunch".equals(call.method)) {
      Notificare.shared().unlaunch();
      replySuccess(result, null);
    } else if ("setAuthorizationOptions".equals(call.method)) {
      replySuccess(result, null);
    } else if ("setPresentationOptions".equals(call.method)) {
      replySuccess(result, null);
    } else if ("setCategoryOptions".equals(call.method)) {
      replySuccess(result, null);
    } else if ("didChangeAppLifecycleState".equals(call.method)) {
      replySuccess(result, null);
    } else if ("registerForNotifications".equals(call.method)) {
      Notificare.shared().enableNotifications();
      replySuccess(result, null);
    } else if ("unregisterForNotifications".equals(call.method)) {
      Notificare.shared().disableNotifications();
      replySuccess(result, null);
    } else if ("isRemoteNotificationsEnabled".equals(call.method)) {
      replySuccess(result, Notificare.shared().isNotificationsEnabled());
    } else if ("isAllowedUIEnabled".equals(call.method)) {
      replySuccess(result, Notificare.shared().checkAllowedUI());
    } else if ("isNotificationFromNotificare".equals(call.method)) {
      replySuccess(result, true);
    } else if ("fetchNotificationSettings".equals(call.method)) {
      replySuccess(result, new HashMap<String, Object>());
    } else if ("startLocationUpdates".equals(call.method)) {
      Notificare.shared().enableLocationUpdates();
      replySuccess(result, null);
    } else if ("stopLocationUpdates".equals(call.method)) {
      Notificare.shared().disableLocationUpdates();
      replySuccess(result, null);
    } else if ("clearLocation".equals(call.method)) {
      Notificare.shared().clearLocation(new NotificareCallback<Boolean>() {

        @Override
        public void onError(NotificareError notificareError) {
          replyError(result, DEFAULT_ERROR_CODE, notificareError);
        }

        @Override
        public void onSuccess(Boolean aBoolean) {
          replySuccess(result, null);
        }
      });
    } else if ("isLocationServicesEnabled".equals(call.method)) {
      replySuccess(result, Notificare.shared().isLocationUpdatesEnabled());
    } else if ("enableBeacons".equals(call.method)) {
      Notificare.shared().enableBeacons();
      setPluginSetting("enableBeacons", true);
      replySuccess(result, null);
    } else if ("disableBeacons".equals(call.method)) {
      Notificare.shared().disableBeacons();
      setPluginSetting("enableBeacons", false);
      replySuccess(result, null);
    } else if ("enableBilling".equals(call.method)) {
      Notificare.shared().enableBilling();
      replySuccess(result, null);
    } else if ("disableBilling".equals(call.method)) {
      Notificare.shared().disableBilling();
      replySuccess(result, null);
    } else if ("registerDevice".equals(call.method)) {
      Notificare.shared().setUserId(call.argument("userID"));
      Notificare.shared().setUserName(call.argument("userName"));
      Notificare.shared().registerDevice(new NotificareCallback<String>() {
        @Override
        public void onSuccess(String s) {
          try {
            replySuccess(result, NotificareUtils.mapDevice(Notificare.shared().getRegisteredDevice()));
          } catch (JSONException e) {
            replyError(result, DEFAULT_ERROR_CODE, new NotificareError("invalid response"));
          }
        }

        @Override
        public void onError(NotificareError notificareError) {
          replyError(result, DEFAULT_ERROR_CODE, notificareError);
        }
      });
    } else if ("fetchDevice".equals(call.method)) {
      try {
        replySuccess(result, NotificareUtils.mapDevice(Notificare.shared().getRegisteredDevice()));
      } catch (JSONException e) {
        replyError(result, DEFAULT_ERROR_CODE, new NotificareError("invalid response"));
      }
    } else if ("fetchPreferredLanguage".equals(call.method)) {
      replySuccess(result, Notificare.shared().getPreferredLanguage());
    } else if ("updatePreferredLanguage".equals(call.method)) {
      if (call.hasArgument("language") && call.argument("language") instanceof String) {
        Notificare.shared().updatePreferredLanguage(call.argument("language"), new NotificareCallback<Boolean>() {
          @Override
          public void onSuccess(Boolean aBoolean) {
            replySuccess(result, null);
          }

          @Override
          public void onError(NotificareError notificareError) {
            replyError(result, DEFAULT_ERROR_CODE, notificareError);
          }
        });
      } else {
        replyError(result, DEFAULT_ERROR_CODE, new NotificareError("invalid parameters"));
      }
    } else if ("fetchTags".equals(call.method)) {
      Notificare.shared().fetchDeviceTags(new NotificareCallback<List<String>>() {
        @Override
        public void onError(NotificareError notificareError) {
          replyError(result, DEFAULT_ERROR_CODE, notificareError);
        }

        @Override
        public void onSuccess(List<String> tags) {
          replySuccess(result, new JSONArray(tags));
        }
      });
    } else if ("addTag".equals(call.method)) {
      if (call.hasArgument("tag") && call.argument("tag") instanceof String) {
        Notificare.shared().addDeviceTag(call.argument("tag"), new NotificareCallback<Boolean>() {
          @Override
          public void onSuccess(Boolean aBoolean) {
            replySuccess(result, null);
          }

          @Override
          public void onError(NotificareError notificareError) {
            replyError(result, DEFAULT_ERROR_CODE, notificareError.getMessage(), null);
          }
        });
      } else {
        replyError(result, DEFAULT_ERROR_CODE, new NotificareError("invalid parameters"));
      }
    } else if ("addTags".equals(call.method)) {
      JSONArray tags = call.argument("tags");
      if (tags != null) {
        List<String> tagsList = new ArrayList<>();
        for (int i = 0; i < tags.length(); i++) {
          tagsList.add(tags.optString(i));
        }
        Notificare.shared().addDeviceTags(tagsList, new NotificareCallback<Boolean>() {
          @Override
          public void onSuccess(Boolean aBoolean) {
            replySuccess(result, null);
          }

          @Override
          public void onError(NotificareError notificareError) {
            replyError(result, DEFAULT_ERROR_CODE, notificareError.getMessage(), null);
          }
        });
      } else {
        replyError(result, DEFAULT_ERROR_CODE, new NotificareError("invalid parameters"));
      }
    } else if ("removeTag".equals(call.method)) {
      if (call.hasArgument("tag") && call.argument("tag") instanceof String) {
        Notificare.shared().removeDeviceTag(call.argument("tag"), new NotificareCallback<Boolean>() {
          @Override
          public void onSuccess(Boolean aBoolean) {
            replySuccess(result, null);
          }

          @Override
          public void onError(NotificareError notificareError) {
            replyError(result, DEFAULT_ERROR_CODE, notificareError.getMessage(), null);
          }
        });
      } else {
        replyError(result, DEFAULT_ERROR_CODE, new NotificareError("invalid parameters"));
      }
    } else if ("removeTags".equals(call.method)) {
      JSONArray tags = call.argument("tags");
      if (tags != null) {
        List<String> tagsList = new ArrayList<>();
        for (int i = 0; i < tags.length(); i++) {
          tagsList.add(tags.optString(i));
        }

        Notificare.shared().removeDeviceTags(tagsList, new NotificareCallback<Boolean>() {
          @Override
          public void onSuccess(Boolean aBoolean) {
            replySuccess(result, null);
          }

          @Override
          public void onError(NotificareError notificareError) {
            replyError(result, DEFAULT_ERROR_CODE, notificareError.getMessage(), null);
          }
        });
      } else {
        replyError(result, DEFAULT_ERROR_CODE, new NotificareError("invalid parameters"));
      }
    } else if ("clearTags".equals(call.method)) {
      Notificare.shared().clearDeviceTags(new NotificareCallback<Boolean>() {
        @Override
        public void onSuccess(Boolean aBoolean) {
          replySuccess(result, null);
        }

        @Override
        public void onError(NotificareError notificareError) {
          replyError(result, DEFAULT_ERROR_CODE, notificareError.getMessage(), null);
        }
      });
    } else if ("fetchUserData".equals(call.method)) {
      Notificare.shared().fetchUserData(new NotificareCallback<NotificareUserData>() {
        @Override
        public void onSuccess(NotificareUserData notificareUserData) {
          JSONArray userDataFields = new JSONArray();
          try {
            for (HashMap.Entry<String, NotificareUserDataField> field : Notificare.shared().getApplicationInfo().getUserDataFields().entrySet()) {
              JSONObject userDataMap = new JSONObject();
              userDataMap.put("key", field.getValue().getKey());
              userDataMap.put("label", field.getValue().getLabel());
              userDataMap.put("value", notificareUserData.getValue(field.getKey()));
              userDataFields.put(userDataMap);
            }
          } catch (JSONException e) {
            // ignore, send list as is
          }
          replySuccess(result, userDataFields);
        }

        @Override
        public void onError(NotificareError notificareError) {
          replyError(result, DEFAULT_ERROR_CODE, notificareError.getMessage(), null);
        }
      });
    } else if ("updateUserData".equals(call.method)) {
      JSONObject fields = call.argument("userData");
      if (fields != null) {
        NotificareUserData data = new NotificareUserData();
        while (fields.keys().hasNext()) {
          String key = fields.keys().next();
          if (!fields.optString(key).isEmpty()) {
            data.setValue(key, fields.optString(key));
          }
        }
        Notificare.shared().updateUserData(data, new NotificareCallback<Boolean>() {
          @Override
          public void onSuccess(Boolean aBoolean) {
            replySuccess(result, null);
          }

          @Override
          public void onError(NotificareError notificareError) {
            replyError(result, DEFAULT_ERROR_CODE, notificareError);
          }
        });
      } else {
        replyError(result, DEFAULT_ERROR_CODE, new NotificareError("invalid user data"));
      }
    } else if ("fetchDoNotDisturb".equals(call.method)) {
      Notificare.shared().fetchDoNotDisturb(new NotificareCallback<NotificareTimeOfDayRange>() {
        @Override
        public void onSuccess(NotificareTimeOfDayRange dnd) {
          try {
            replySuccess(result, NotificareUtils.mapTimeOfDayRange(dnd));
          } catch (JSONException e) {
            replyError(result, DEFAULT_ERROR_CODE, new NotificareError("invalid response"));
          }
        }

        @Override
        public void onError(NotificareError notificareError) {
          replyError(result, DEFAULT_ERROR_CODE, notificareError);
        }
      });
    } else if ("updateDoNotDisturb".equals(call.method)) {
      JSONObject deviceDnd = call.argument("dnd");
      if (deviceDnd != null && !deviceDnd.optString("start").isEmpty() && !deviceDnd.optString("end").isEmpty()) {
        String[] s = deviceDnd.optString("start").split(":");
        String[] e = deviceDnd.optString("end").split(":");
        final NotificareTimeOfDayRange range = new NotificareTimeOfDayRange(
                new NotificareTimeOfDay(Integer.parseInt(s[0]),Integer.parseInt(s[1])),
                new NotificareTimeOfDay(Integer.parseInt(e[0]),Integer.parseInt(e[1])));

        Notificare.shared().updateDoNotDisturb(range, new NotificareCallback<Boolean>() {
          @Override
          public void onSuccess(Boolean aBoolean) {
            try {
              replySuccess(result, NotificareUtils.mapTimeOfDayRange(range));
            } catch (JSONException e) {
              replyError(result, DEFAULT_ERROR_CODE, new NotificareError("invalid response"));
            }
          }

          @Override
          public void onError(NotificareError notificareError) {
            replyError(result, DEFAULT_ERROR_CODE, notificareError);
          }
        });
      } else {
        replyError(result, DEFAULT_ERROR_CODE, new NotificareError("invalid device dnd"));
      }
    } else if ("clearDoNotDisturb".equals(call.method)) {
      Notificare.shared().clearDoNotDisturb(new NotificareCallback<Boolean>() {
        @Override
        public void onSuccess(Boolean aBoolean) {
          replySuccess(result, null);
        }

        @Override
        public void onError(NotificareError notificareError) {
          replyError(result, DEFAULT_ERROR_CODE, notificareError);
        }
      });
    } else if ("fetchNotificationForInboxItem".equals(call.method)) {
      if (Notificare.shared().getInboxManager() != null) {
        JSONObject inboxItem = call.argument("inboxItem");
        if (inboxItem != null && !inboxItem.optString("inboxId").isEmpty() && Notificare.shared().getInboxManager() != null) {
          NotificareInboxItem notificareInboxItem = Notificare.shared().getInboxManager().getItem(inboxItem.optString("inboxId"));
          if (notificareInboxItem != null) {
            Notificare.shared().fetchInboxItem(notificareInboxItem, new NotificareCallback<NotificareInboxItem>() {
              @Override
              public void onSuccess(NotificareInboxItem fetchedInboxItem) {
                try {
                  replySuccess(result, NotificareUtils.mapNotification(fetchedInboxItem.getNotification()));
                } catch (JSONException e) {
                  replyError(result, DEFAULT_ERROR_CODE, new NotificareError("invalid inbox item"));
                }
              }

              @Override
              public void onError(NotificareError notificareError) {
                replyError(result, DEFAULT_ERROR_CODE, notificareError);
              }
            });
          } else {
            replyError(result, DEFAULT_ERROR_CODE, "inbox item not found", null);
          }
        } else {
          replyError(result, DEFAULT_ERROR_CODE, "inbox item not found", null);
        }
      } else {
        replyError(result, DEFAULT_ERROR_CODE, "inbox not enabled", null);
      }
    } else if ("presentNotification".equals(call.method)) {
      JSONObject notification = call.argument("notification");
      presentNotification(notification);
      replySuccess(result, null);
    } else if ("fetchInbox".equals(call.method)) {
      if (Notificare.shared().getInboxManager() != null) {
        JSONArray inbox = new JSONArray();
        try {
            for (NotificareInboxItem item : Notificare.shared().getInboxManager().getItems()) {
                inbox.put(NotificareUtils.mapInboxItem(item));
            }
        } catch (JSONException e) {
            // ignore exceptions, just return the list as is
        }
        replySuccess(result, inbox);
      } else {
        replyError(result, DEFAULT_ERROR_CODE, new NotificareError("inbox not enabled"));
      }
    } else if ("presentInboxItem".equals(call.method)) {
      if (Notificare.shared().getInboxManager() != null) {
        JSONObject inboxItem = call.argument("inboxItem");
        if (inboxItem != null && !inboxItem.optString("inboxId").isEmpty()) {
          NotificareInboxItem notificareInboxItem = Notificare.shared().getInboxManager().getItem(inboxItem.optString("inboxId"));
          if (notificareInboxItem != null && mActivity != null) {
            Notificare.shared().openInboxItem(mActivity, notificareInboxItem);
            replySuccess(result, null);
          } else {
            replyError(result, DEFAULT_ERROR_CODE, new NotificareError("inbox item not found"));
          }
        } else {
          replyError(result, DEFAULT_ERROR_CODE, new NotificareError("inbox item not found"));
        }
      } else {
        replyError(result, DEFAULT_ERROR_CODE, new NotificareError("inbox not enabled"));
      }
    } else if ("removeFromInbox".equals(call.method)) {
      if (Notificare.shared().getInboxManager() != null) {
        JSONObject inboxItem = call.argument("inboxItem");
        if (inboxItem != null && !inboxItem.optString("inboxId").isEmpty()) {
          NotificareInboxItem notificareInboxItem = Notificare.shared().getInboxManager().getItem(inboxItem.optString("inboxId"));
          if (notificareInboxItem != null) {
            Notificare.shared().getInboxManager().removeItem(notificareInboxItem, new NotificareCallback<Boolean>() {
              @Override
              public void onSuccess(Boolean aBoolean) {
                try {
                  replySuccess(result, NotificareUtils.mapInboxItem(notificareInboxItem));
                } catch (JSONException e) {
                  replyError(result, DEFAULT_ERROR_CODE, new NotificareError("invalid response"));
                }
              }

              @Override
              public void onError(NotificareError error) {
                replyError(result, DEFAULT_ERROR_CODE, error);
              }
            });
          } else {
            replyError(result, DEFAULT_ERROR_CODE, new NotificareError("inbox item not found"));
          }
        } else {
          replyError(result, DEFAULT_ERROR_CODE, new NotificareError("inbox item not found"));
        }
      } else {
        replyError(result, DEFAULT_ERROR_CODE, new NotificareError("inbox not enabled"));
      }
    } else if ("markAsRead".equals(call.method)) {
      if (Notificare.shared().getInboxManager() != null) {
        JSONObject inboxItem = call.argument("inboxItem");
        if (inboxItem != null && !inboxItem.optString("inboxId").isEmpty()) {
          NotificareInboxItem notificareInboxItem = Notificare.shared().getInboxManager().getItem(inboxItem.optString("inboxId"));
          if (notificareInboxItem != null) {
            Notificare.shared().getInboxManager().markItem(notificareInboxItem, new NotificareCallback<Boolean>() {
              @Override
              public void onSuccess(Boolean aBoolean) {
                try {
                  replySuccess(result, NotificareUtils.mapInboxItem(notificareInboxItem));
                } catch (JSONException e) {
                  replyError(result, DEFAULT_ERROR_CODE, new NotificareError("invalid response"));
                }
              }

              @Override
              public void onError(NotificareError error) {
                replyError(result, DEFAULT_ERROR_CODE, error);
              }
            });
          } else {
            replyError(result, DEFAULT_ERROR_CODE, new NotificareError("inbox item not found"));
          }
        } else {
          replyError(result, DEFAULT_ERROR_CODE, new NotificareError("inbox item not found"));
        }
      } else {
        replyError(result, DEFAULT_ERROR_CODE, new NotificareError("inbox not enabled"));
      }
    } else if ("markAllAsRead".equals(call.method)) {
      if (Notificare.shared().getInboxManager() != null) {
        Notificare.shared().getInboxManager().markAll(new NotificareCallback<Boolean>() {
          @Override
          public void onSuccess(Boolean aBoolean) {
            replySuccess(result, null);
          }

          @Override
          public void onError(NotificareError error) {
            replyError(result, DEFAULT_ERROR_CODE, error);
          }
        });
      } else {
        replyError(result, DEFAULT_ERROR_CODE, new NotificareError("inbox not enabled"));
      }
    } else if ("clearInbox".equals(call.method)) {
      if (Notificare.shared().getInboxManager() != null) {
        Notificare.shared().getInboxManager().clearInbox(new NotificareCallback<Integer>() {
          @Override
          public void onSuccess(Integer count) {
            replySuccess(result, null);
          }

          @Override
          public void onError(NotificareError error) {
            replyError(result, DEFAULT_ERROR_CODE, error);
          }
        });
      } else {
        replyError(result, DEFAULT_ERROR_CODE, new NotificareError("inbox not enabled"));
      }
    } else if ("fetchAssets".equals(call.method)) {
      if (call.hasArgument("group") && call.argument("group") instanceof String) {
        Notificare.shared().fetchAssets(call.argument("group"), new NotificareCallback<List<NotificareAsset>>() {
          @Override
          public void onSuccess(List<NotificareAsset> notificareAssets) {
            JSONArray assetsArray = new JSONArray();
            try {
              for (NotificareAsset asset : notificareAssets) {
                assetsArray.put(NotificareUtils.mapAsset(asset));
              }
            } catch (JSONException e) {
              // ignore, send list of assets as is
            }
            replySuccess(result, assetsArray);
          }

          @Override
          public void onError(NotificareError notificareError) {
            replyError(result, DEFAULT_ERROR_CODE, notificareError);
          }
        });
      } else {
        replyError(result, DEFAULT_ERROR_CODE, new NotificareError("invalid parameters"));
      }
    } else if ("fetchPassWithSerial".equals(call.method)) {
      Notificare.shared().fetchPass(call.argument("serial"), new NotificareCallback<NotificarePass>() {
        @Override
        public void onSuccess(NotificarePass notificarePass) {
          try {
            replySuccess(result, NotificareUtils.mapPass(notificarePass));
          } catch (JSONException e) {
            replyError(result, DEFAULT_ERROR_CODE, new NotificareError("invalid response"));
          }
        }

        @Override
        public void onError(NotificareError notificareError) {
          replyError(result, DEFAULT_ERROR_CODE, notificareError);
        }
      });
    } else if ("fetchPassWithBarcode".equals(call.method)) {
      Notificare.shared().fetchPass(call.argument("barcode"), new NotificareCallback<NotificarePass>() {
        @Override
        public void onSuccess(NotificarePass notificarePass) {
          try {
            replySuccess(result, NotificareUtils.mapPass(notificarePass));
          } catch (JSONException e) {
            replyError(result, DEFAULT_ERROR_CODE, new NotificareError("invalid response"));
          }
        }

        @Override
        public void onError(NotificareError notificareError) {
          replyError(result, DEFAULT_ERROR_CODE, notificareError);
        }
      });
    } else if ("fetchProducts".equals(call.method)) {
      if (Notificare.shared().getBillingManager() != null) {
        replySuccess(result, NotificareUtils.mapProducts(Notificare.shared().getBillingManager().getProducts()));
      } else {
        replyError(result, DEFAULT_ERROR_CODE, new NotificareError("billing not enabled"));
      }
    } else if ("fetchPurchasedProducts".equals(call.method)) {
      if (Notificare.shared().getBillingManager() != null) {
        List<NotificarePurchase> purchases = Notificare.shared().getBillingManager().getPurchases();
        List<NotificareProduct> products = new ArrayList<>();
        for (NotificarePurchase purchase : purchases) {
          NotificareProduct product = Notificare.shared().getBillingManager().getProduct(purchase.getProductId());
          if (product != null) {
            products.add(product);
          }
        }
        replySuccess(result, NotificareUtils.mapProducts(products));
      } else {
        replyError(result, DEFAULT_ERROR_CODE, new NotificareError("billing not enabled"));
      }
    } else if ("fetchProduct".equals(call.method)) {
      if (Notificare.shared().getBillingManager() != null) {
        JSONObject product = call.argument("product");
        if (product != null && !product.optString("productIdentifier").isEmpty()) {
          NotificareProduct theProduct = Notificare.shared().getBillingManager().getProduct(product.optString("productIdentifier"));
          if (theProduct != null) {
            try {
              replySuccess(result, NotificareUtils.mapProduct(theProduct));
            } catch (JSONException e) {
              replyError(result, DEFAULT_ERROR_CODE, new NotificareError("invalid response"));
            }
          } else {
            replyError(result, DEFAULT_ERROR_CODE, new NotificareError("product not found"));
          }
        } else {
          replyError(result, DEFAULT_ERROR_CODE, new NotificareError("product not found"));
        }
      } else {
        replyError(result, DEFAULT_ERROR_CODE, new NotificareError("billing not enabled"));
      }
    } else if ("buyProduct".equals(call.method)) {
      if (Notificare.shared().getBillingManager() != null && mActivity != null) {
        JSONObject product = call.argument("product");
        if (product != null && !product.optString("productIdentifier").isEmpty()) {
          NotificareProduct notificareProduct = Notificare.shared().getBillingManager().getProduct(product.optString("identifier"));
          final Activity activity = mActivity;
          activity.runOnUiThread(() -> Notificare.shared().getBillingManager().launchPurchaseFlow(activity, notificareProduct, this));
        }
      }
      replySuccess(result, null);
    } else if ("logCustomEvent".equals(call.method)) {
      JSONObject data = call.argument("data");
      if (call.hasArgument("name") && call.argument("name") != null && call.argument("name") instanceof String) {
        Notificare.shared().getEventLogger().logCustomEvent(call.argument("name"), data, new NotificareCallback<Boolean>() {
          @Override
          public void onSuccess(Boolean aBoolean) {
            replySuccess(result, null);
          }

          @Override
          public void onError(NotificareError notificareError) {
            replyError(result, DEFAULT_ERROR_CODE, notificareError);
          }
        });
      } else {
        replyError(result, DEFAULT_ERROR_CODE, new NotificareError("invalid parameters"));
      }
    } else if ("logOpenNotification".equals(call.method)) {
      JSONObject notification = call.argument("notification");
      if (notification != null && !notification.optString("id").isEmpty()) {
        Notificare.shared().getEventLogger().logOpenNotification(notification.optString("id"), new NotificareCallback<Boolean>() {
          @Override
          public void onSuccess(Boolean aBoolean) {
            replySuccess(result, null);
          }

          @Override
          public void onError(NotificareError notificareError) {
            replyError(result, DEFAULT_ERROR_CODE, notificareError);
          }
        });
      } else {
        replyError(result, DEFAULT_ERROR_CODE, new NotificareError("invalid notification"));
      }
    } else if ("logInfluencedNotification".equals(call.method)) {
      JSONObject notification = call.argument("notification");
      if (notification != null && !notification.optString("id").isEmpty()) {
        Notificare.shared().getEventLogger().logOpenNotificationInfluenced(notification.optString("id"), new NotificareCallback<Boolean>() {
          @Override
          public void onSuccess(Boolean aBoolean) {
            replySuccess(result, null);
          }

          @Override
          public void onError(NotificareError notificareError) {
            replyError(result, DEFAULT_ERROR_CODE, notificareError);
          }
        });
      } else {
        replyError(result, DEFAULT_ERROR_CODE, new NotificareError("invalid notification"));
      }
    } else if ("doCloudHostOperation".equals(call.method)) {
      if (call.hasArgument("verb") && call.hasArgument("path") && call.argument("verb") != null && call.argument("path") != null) {
        JSONObject body = call.hasArgument("body") && call.argument("body") != JSONObject.NULL ? call.argument("body") : null;
        JSONObject params = call.hasArgument("params") && call.argument("params") != JSONObject.NULL ? call.argument("params")  : null;
        JSONObject headers = call.hasArgument("headers") && call.argument("headers") != JSONObject.NULL ? call.argument("headers") : null;
        String path = "/api" + call.argument("path");

        Map<String, String> paramsMap = new HashMap<>();
        if (params != null) {
          Iterator<String> keys = params.keys();
          while (keys.hasNext()) {
            String key = keys.next();
            paramsMap.put(key, params.optString(key, null));
          }
        }

        Map<String, String> headersMap = new HashMap<>();
        if (headers != null) {
          Iterator<String> keys = headers.keys();
          while (keys.hasNext()) {
            String key = keys.next();
            headersMap.put(key, headers.optString(key, null));
          }
        }

        Notificare.shared().doCloudRequest(call.argument("verb"), path, paramsMap, body, headersMap, new NotificareCallback<JSONObject>() {
          @Override
          public void onSuccess(JSONObject jsonObject) {
            replySuccess(result, jsonObject);
          }

          @Override
          public void onError(NotificareError notificareError) {
            replyError(result, DEFAULT_ERROR_CODE, notificareError);
          }
        });
      } else {
        replyError(result, DEFAULT_ERROR_CODE, new NotificareError("invalid parameters"));
      }
    } else if ("createAccount".equals(call.method)) {
      if (call.hasArgument("email") && call.hasArgument("password") && call.hasArgument("name") && call.argument("email") != null && call.argument("password") != null && call.argument("name") != null) {
        Notificare.shared().createAccount(call.argument("email"), call.argument("password"), call.argument("name"), new NotificareCallback<Boolean>() {
          @Override
          public void onSuccess(Boolean aBoolean) {
            replySuccess(result, null);
          }

          @Override
          public void onError(NotificareError notificareError) {
            replyError(result, DEFAULT_ERROR_CODE, notificareError);
          }
        });
      } else {
        replyError(result, DEFAULT_ERROR_CODE, new NotificareError("invalid parameters"));
      }
    } else if ("validateAccount".equals(call.method)) {
      if (call.hasArgument("token") && call.argument("token") != null) {
        Notificare.shared().validateUser(call.argument("token"), new NotificareCallback<Boolean>() {
          @Override
          public void onSuccess(Boolean aBoolean) {
            replySuccess(result, null);
          }

          @Override
          public void onError(NotificareError notificareError) {
            replyError(result, DEFAULT_ERROR_CODE, notificareError);
          }
        });
      } else {
        replyError(result, DEFAULT_ERROR_CODE, new NotificareError("invalid parameters"));
      }
    } else if ("resetPassword".equals(call.method)) {
      if (call.hasArgument("token") && call.hasArgument("password") && call.argument("token") != null && call.argument("password") != null) {
        Notificare.shared().resetPassword(call.argument("password"), call.argument("token"), new NotificareCallback<Boolean>() {
          @Override
          public void onSuccess(Boolean aBoolean) {
            replySuccess(result, null);
          }

          @Override
          public void onError(NotificareError notificareError) {
            replyError(result, DEFAULT_ERROR_CODE, notificareError);
          }
        });
      } else {
        replyError(result, DEFAULT_ERROR_CODE, new NotificareError("invalid parameters"));
      }
    } else if ("sendPassword".equals(call.method)) {
      if (call.hasArgument("email") && call.argument("email") != null) {
        Notificare.shared().sendPassword(call.argument("email"), new NotificareCallback<Boolean>() {
          @Override
          public void onSuccess(Boolean aBoolean) {
            replySuccess(result, null);
          }

          @Override
          public void onError(NotificareError notificareError) {
            replyError(result, DEFAULT_ERROR_CODE, notificareError);
          }
        });
      } else {
        replyError(result, DEFAULT_ERROR_CODE, new NotificareError("invalid parameters"));
      }
    } else if ("login".equals(call.method)) {
      if (call.hasArgument("email") && call.hasArgument("password") && call.argument("email") != null && call.argument("password") != null) {
        Notificare.shared().userLogin(call.argument("email"), call.argument("password"), new NotificareCallback<Boolean>() {
          @Override
          public void onSuccess(Boolean aBoolean) {
            replySuccess(result, null);
          }

          @Override
          public void onError(NotificareError notificareError) {
            replyError(result, DEFAULT_ERROR_CODE, notificareError);
          }
        });
      } else {
        replyError(result, DEFAULT_ERROR_CODE, new NotificareError("invalid parameters"));
      }
    } else if ("logout".equals(call.method)) {
      Notificare.shared().userLogout(new NotificareCallback<Boolean>() {
        @Override
        public void onSuccess(Boolean aBoolean) {
          replySuccess(result, null);
        }

        @Override
        public void onError(NotificareError notificareError) {
          replyError(result, DEFAULT_ERROR_CODE, notificareError);
        }
      });
    } else if ("isLoggedIn".equals(call.method)) {
      replySuccess(result, Notificare.shared().isLoggedIn());
    } else if ("generateAccessToken".equals(call.method)) {
      Notificare.shared().generateAccessToken(new NotificareCallback<NotificareUser>() {
        @Override
        public void onSuccess(NotificareUser notificareUser) {
          try {
            replySuccess(result, NotificareUtils.mapUser(notificareUser));
          } catch (JSONException e) {
            replyError(result, DEFAULT_ERROR_CODE, new NotificareError("invalid response"));
          }
        }

        @Override
        public void onError(NotificareError notificareError) {
          replyError(result, DEFAULT_ERROR_CODE, notificareError);
        }
      });
    } else if ("changePassword".equals(call.method)) {
      if (call.hasArgument("password") && call.argument("password") != null) {
        Notificare.shared().changePassword(call.argument("password"), new NotificareCallback<Boolean>() {
          @Override
          public void onSuccess(Boolean aBoolean) {
            replySuccess(result, null);
          }

          @Override
          public void onError(NotificareError notificareError) {
            replyError(result, DEFAULT_ERROR_CODE, notificareError);
          }
        });
      } else {
        replyError(result, DEFAULT_ERROR_CODE, new NotificareError("invalid parameters"));
      }
    } else if ("fetchAccountDetails".equals(call.method)) {
      Notificare.shared().fetchUserDetails(new NotificareCallback<NotificareUser>() {
        @Override
        public void onSuccess(NotificareUser notificareUser) {
          try {
            replySuccess(result, NotificareUtils.mapUser(notificareUser));
          } catch (JSONException e) {
            replyError(result, DEFAULT_ERROR_CODE, new NotificareError("invalid response"));
          }
        }

        @Override
        public void onError(NotificareError notificareError) {
          replyError(result, DEFAULT_ERROR_CODE, notificareError);
        }
      });
    } else if ("fetchUserPreferences".equals(call.method)) {
      Notificare.shared().fetchUserPreferences(new NotificareCallback<List<NotificareUserPreference>>() {
        @Override
        public void onSuccess(List<NotificareUserPreference> notificareUserPreferences) {
          JSONArray preferencesArray = new JSONArray();
          try {
            for (NotificareUserPreference preference : notificareUserPreferences) {
              preferencesArray.put(NotificareUtils.mapUserPreference(preference));
            }
          } catch (JSONException e) {
            // ignore, send list as is
          }
          replySuccess(result, preferencesArray);
        }

        @Override
        public void onError(NotificareError notificareError) {
          replyError(result, DEFAULT_ERROR_CODE, notificareError);
        }
      });
    } else if ("addSegmentToUserPreference".equals(call.method)) {
      JSONObject segment = call.argument("segment");
      JSONObject preference = call.argument("userPreference");
      if (segment != null && preference != null) {
        NotificareUserSegment userSegment = NotificareUtils.createUserSegment(segment);
        NotificareUserPreference userPreference = NotificareUtils.createUserPreference(preference);
        if (userSegment != null && userPreference != null) {
          Notificare.shared().userSegmentAddToUserPreference(userSegment, userPreference, new NotificareCallback<Boolean>() {
            @Override
            public void onSuccess(Boolean aBoolean) {
              replySuccess(result, null);
            }

            @Override
            public void onError(NotificareError notificareError) {
              replyError(result, DEFAULT_ERROR_CODE, notificareError);
            }
          });
        } else {
          replyError(result, DEFAULT_ERROR_CODE, new NotificareError("invalid parameters"));
        }
      } else {
        replyError(result, DEFAULT_ERROR_CODE, new NotificareError("invalid parameters"));
      }
    } else if ("removeSegmentFromUserPreference".equals(call.method)) {
      JSONObject segment = call.argument("segment");
      JSONObject preference = call.argument("userPreference");
      if (segment != null && preference != null) {
        NotificareUserSegment userSegment = NotificareUtils.createUserSegment(segment);
        NotificareUserPreference userPreference = NotificareUtils.createUserPreference(preference);
        if (userSegment != null && userPreference != null) {
          Notificare.shared().userSegmentRemoveFromUserPreference(userSegment, userPreference, new NotificareCallback<Boolean>() {
            @Override
            public void onSuccess(Boolean aBoolean) {
              replySuccess(result, null);
            }

            @Override
            public void onError(NotificareError notificareError) {
              replyError(result, DEFAULT_ERROR_CODE, notificareError);
            }
          });
        } else {
          replyError(result, DEFAULT_ERROR_CODE, new NotificareError("invalid parameters"));
        }
      } else {
        replyError(result, DEFAULT_ERROR_CODE, new NotificareError("invalid parameters"));
      }
    } else if ("startScannableSession".equals(call.method)) {
      if (mActivity != null) {
        Notificare.shared().startScannableActivity(mActivity, SCANNABLE_REQUEST_CODE);
      }
      replySuccess(result, null);
    } else if ("presentScannable".equals(call.method)) {
      JSONObject scannable = call.argument("scannable");
      if (scannable != null && scannable.optJSONObject("notification") != null) {
        presentNotification(scannable.optJSONObject("notification"));
      }
    } else if ("requestAlwaysAuthorizationForLocationUpdates".equals(call.method)) {
      replySuccess(result, null);
    } else if ("requestTemporaryFullAccuracyAuthorization".equals(call.method)) {
      replySuccess(result, null);
    } else if ("fetchLink".equals(call.method)) {
      Uri uri = Uri.parse(call.argument("url"));

      Notificare.shared().fetchDynamicLink(uri, new NotificareCallback<NotificareDynamicLink>() {
        @Override
        public void onSuccess(NotificareDynamicLink notificareDynamicLink) {
          replySuccess(result, notificareDynamicLink.getTarget());
        }

        @Override
        public void onError(NotificareError notificareError) {
          replyError(result, DEFAULT_ERROR_CODE, notificareError);
        }
      });
    } else {
      replyNotImplemented(result);
    }
  }

  /**
   * @return the settings preferences
   */
  private static SharedPreferences getSettings() {
    return Notificare.shared().getApplicationContext().getSharedPreferences(SETTINGS_PREFERENCES, Context.MODE_PRIVATE);
  }

  /**
   * Get a plugin setting
   * @param name
   * @return
   */
  static Boolean getPluginSetting(String name) {
    return getSettings().getBoolean(name, false);
  }

  /**
   * Set a plugin setting
   * @param name
   * @param value
   */
  private static void setPluginSetting(String name, Boolean value) {
    getSettings().edit().putBoolean(name, value).apply();
  }

  /**
   * Present the notification in NotificationActivity, check if there was an inboxItemId
   * @param notification
   */
  private void presentNotification(JSONObject notification) {
    if (notification != null && notification.has("id")) {
      String notificationId = notification.optString("id");
      if (!notification.isNull("inboxItemId") && !notification.optString("inboxItemId").isEmpty() && Notificare.shared().getInboxManager() != null) {
        // This is an item opened with inboxItemId, so coming from NotificationManager open
        NotificareInboxItem notificareInboxItem = Notificare.shared().getInboxManager().getItem(notification.optString("inboxItemId"));
        if (notificareInboxItem != null && mActivity != null) {
          Notificare.shared().openInboxItem(mActivity, notificareInboxItem);
        }
      } else if (!notificationId.isEmpty() && mActivity != null) {
        // We have a notificationId, let's see if we can create a notification from the payload, otherwise fetch from API
        NotificareNotification notificareNotification = NotificareUtils.createNotification(notification);
        if (notificareNotification != null) {
          Notificare.shared().openNotification(mActivity, notificareNotification);
        } else {
          Notificare.shared().fetchNotification(notificationId, new NotificareCallback<NotificareNotification>() {
            @Override
            public void onSuccess(NotificareNotification notificareNotification) {
              Notificare.shared().openNotification(mActivity, notificareNotification);
            }

            @Override
            public void onError(NotificareError notificareError) {
              Log.e(TAG, "error fetching notification: " + notificareError.getMessage());
            }
          });
        }
      }
    }
  }

  /**
   * Reply as success on main thread
   * @param reply
   * @param response
   */
  private void replySuccess(final MethodChannel.Result reply, final Object response) {
    new Handler(Looper.getMainLooper()).post(() -> reply.success(response));
  }

  /**
   * Reply as error on main thread
   * @param reply
   * @param tag
   * @param message
   * @param response
   */
  private void replyError(final MethodChannel.Result reply, final String tag, final String message, final Object response) {
    new Handler(Looper.getMainLooper()).post(() -> reply.error(tag, message, response));
  }

  /**
   * Reply as error on main thread
   * @param reply
   * @param tag
   * @param error
   */
  private void replyError(final MethodChannel.Result reply, final String tag, final Throwable error) {
    new Handler(Looper.getMainLooper()).post(() -> reply.error(tag, error.getMessage(), null));
  }

  /**
   * Create an error payload to send with events
   * @param message
   * @return
   */
  private Map<String, Object> createErrorPayload(String message) {
    Map<String,Object> result = new HashMap<>();
    result.put("error", message);
    return result;
  }

  /**
   * Create an error payload to send with events
   * @param error
   * @return
   */
  private Map<String, Object> createErrorPayload(Throwable error) {
    return createErrorPayload(error.getMessage());
  }

  /**
   * Reply as not iplemented on main thread
   * @param reply
   */
  private void replyNotImplemented(final MethodChannel.Result reply) {
    new Handler(Looper.getMainLooper()).post(reply::notImplemented);
  }

  /**
   * Invoke method on main thread
   * @param methodName
   * @param map
   */
  private void invokeMethodOnUiThread(final String methodName, final HashMap map) {
    final MethodChannel channel = mMethodChannel;
    new Handler(Looper.getMainLooper()).post(() -> channel.invokeMethod(methodName, map));
  }

  /**
   * Send event on main thread
   * @param event The event name
   * @param payload The event payload
   * @param queue Should the event be queued if the EventSink is not ready yet?
   */
  private void sendEvent(String event, Object payload, boolean queue) {
    NotificareEventEmitter.getInstance().sendEvent(event, payload, queue);
  }

  /**
   * Send a validate user token received event
   * @param token
   * @return true if the event was handled successfully.
   */
  private boolean sendValidateUserToken(String token) {
    if (token != null && !token.isEmpty()) {
      JSONObject tokenMap = new JSONObject();
      try {
        tokenMap.put("token", token);
        sendEvent("activationTokenReceived", tokenMap, true);
        return true;
      } catch (JSONException e) {
        // ignore
      }
    }

    return false;
  }

  /**
   * Send a password reset token received event
   * @param token
   * @return true if the event was handled successfully.
   */
  private boolean sendResetPasswordToken(String token) {
    if (token != null && !token.isEmpty()) {
      JSONObject tokenMap = new JSONObject();
      try {
        tokenMap.put("token", token);
        sendEvent("resetPasswordTokenReceived", tokenMap, true);
        return true;
      } catch (JSONException e) {
        // ignore
      }
    }

    return false;
  }

  private JSONObject parseNotificationIntent(Intent intent) {
    NotificareNotification notification = intent.getParcelableExtra(Notificare.INTENT_EXTRA_NOTIFICATION);
    if (notification != null) {
      try {
        JSONObject notificationMap = NotificareUtils.mapNotification(notification);
        // Add inbox item id if present
        if (intent.hasExtra(Notificare.INTENT_EXTRA_INBOX_ITEM_ID)) {
          notificationMap.put("inboxItemId", intent.getStringExtra(Notificare.INTENT_EXTRA_INBOX_ITEM_ID));
        }
        return notificationMap;
      } catch (JSONException e) {
        return null;
      }
    }
    return null;
  }

  private boolean handleIntent(Intent intent) {
    JSONObject notificationMap = parseNotificationIntent(intent);
    if (notificationMap != null) {
      sendEvent("remoteNotificationReceivedInBackground", notificationMap, true);
      return true;
    } else {
      if (sendValidateUserToken(Notificare.shared().parseValidateUserIntent(intent))) return true;
      if (sendResetPasswordToken(Notificare.shared().parseResetPasswordIntent(intent))) return true;
      if (mActivity != null && Notificare.shared().handleDynamicLinkIntent(mActivity, intent)) return true;

      if (intent.getData() != null) {
        try {
          JSONObject payload = new JSONObject();
          payload.put("url", intent.getData().toString());
          sendEvent("urlOpened", payload, true);
          return true;
        } catch (JSONException e) {
          // ignore
        }
      }
    }

    return false;
  }

  @Override
  public void onListen(Object o, EventChannel.EventSink eventSink) {
    if (Notificare.shared().getInboxManager() != null) {
      Handler handler = new Handler(Looper.getMainLooper());
      handler.post(() -> {
        mInboxItems = Notificare.shared().getInboxManager().getObservableItems();
        mInboxItems.observeForever(this);
      });
    }
    NotificareEventEmitter.getInstance().onListen(eventSink);
  }

  @Override
  public void onCancel(Object o) {
    if (mInboxItems != null) {
      Handler handler = new Handler(Looper.getMainLooper());
      handler.post(() -> mInboxItems.removeObserver(this));
    }
    NotificareEventEmitter.getInstance().onCancel();
  }

  @Override
  public void onNotificareReady(NotificareApplicationInfo notificareApplicationInfo) {
    try {
      sendEvent("ready", NotificareUtils.mapApplicationInfo(notificareApplicationInfo), true);
    } catch (JSONException e) {
      // ignore
    }
  }

  @Override
  public void onChanged(@Nullable SortedSet<NotificareInboxItem> notificareInboxItems) {
    JSONArray inbox = new JSONArray();
    if (notificareInboxItems != null) {
      try {
        for (NotificareInboxItem item : notificareInboxItems) {
          inbox.put(NotificareUtils.mapInboxItem(item));
        }
      } catch (JSONException e) {
        // ignore, send list as is
      }
      sendEvent("inboxLoaded", inbox, false);
      sendEvent("badgeUpdated", Notificare.shared().getInboxManager().getUnreadCount(), false);
    }
  }

  @Override
  public void onBillingReady() {
    Notificare.shared().getBillingManager().refresh(this);
  }

  @Override
  public void onNotificareNotification(NotificareNotification notification, NotificareInboxItem inboxItem, Boolean shouldPresent) {
    if (notification != null) {
      try {
        JSONObject notificationMap = NotificareUtils.mapNotification(notification);
        // Add inbox item id if present
        if (inboxItem != null) {
          notificationMap.put("inboxItemId", inboxItem.getItemId());
        }
        sendEvent("remoteNotificationReceivedInForeground", notificationMap, true);
      } catch (JSONException e) {
        // ignore
      }
    }
  }

  @Override
  public void onServiceError(int errorCode, int requestCode) {
    if (mActivity == null || Notificare.shared().getServiceManager() == null) return;
    if (Notificare.shared().getServiceManager().isUserRecoverableError(errorCode)) {
      final Activity activity = mActivity;
      activity.runOnUiThread(() -> Notificare.shared().getServiceManager().getErrorDialog(errorCode, activity, requestCode).show());
    }
  }

  @Override
  public void onRangingBeacons(List<NotificareBeacon> beacons) {
    try {
      JSONObject payload = new JSONObject();
      JSONArray beaconsArray = new JSONArray();
        for (NotificareBeacon beacon : beacons) {
          beaconsArray.put(NotificareUtils.mapBeacon(beacon));
        }
      payload.put("beacons", beaconsArray);
      if (beacons.size() > 0) {
        if (beacons.get(0).getRegion() != null) {
          payload.put("region", NotificareUtils.mapRegionForBeacon(beacons.get(0)));
        }
      }
      sendEvent("beaconsInRangeForRegion", payload, false);
    } catch (JSONException e) {
      // ignore
    }
  }

  @Override
  public void onPurchaseFinished(NotificareBillingResult billingResult, NotificarePurchase purchase) {
    JSONObject payload = new JSONObject();
    NotificareProduct product = Notificare.shared().getBillingManager().getProduct(purchase.getProductId());
    try {
      if (product != null) {
        payload.put("product", NotificareUtils.mapProduct(product));
      }
      if (billingResult.isFailure()) {
        payload.put("error", billingResult.getMessage());
        sendEvent("productTransactionFailed", payload, true);
      } else if (billingResult.isSuccess()) {
        sendEvent("productTransactionCompleted", payload, true);
      }
    } catch (JSONException e) {
      //ignore
    }
  }

  @Override
  public void onRefreshFinished() {
    sendEvent("storeLoaded", NotificareUtils.mapProducts(Notificare.shared().getBillingManager().getProducts()), true);
  }

  @Override
  public void onRefreshFailed(NotificareError notificareError) {
    sendEvent("storeFailedToLoad", createErrorPayload(notificareError), true);
  }

  @Override
  public boolean onActivityResult(int requestCode, int resultCode, Intent data) {
    if (!Notificare.shared().handleServiceErrorResolution(requestCode, resultCode, data)) {
      if (requestCode == SCANNABLE_REQUEST_CODE) {
        if (resultCode == CommonStatusCodes.SUCCESS) {
          if (data != null) {
            NotificareScannable scannable = Notificare.shared().extractScannableFromActivityResult(data);
            if (scannable != null) {
              try {
                sendEvent("scannableDetected", NotificareUtils.mapScannable(scannable), true);
              } catch (JSONException e) {
                // ignore
              }
            } else {
              sendEvent("scannableSessionInvalidatedWithError", createErrorPayload("scannable not found"), true);
            }
          } else {
            sendEvent("scannableSessionInvalidatedWithError", createErrorPayload("scan did not return any results"), true);
          }
        } else if (resultCode == CommonStatusCodes.CANCELED) {
          sendEvent("scannableSessionInvalidatedWithError", createErrorPayload("scan was canceled"), true);
        } else {
          sendEvent("scannableSessionInvalidatedWithError", createErrorPayload("unknown error"), true);
        }
      } else {
        return false;
      }
    }
    return true;
  }

  @Override
  public boolean onNewIntent(Intent intent) {
    return handleIntent(intent);
  }
}
