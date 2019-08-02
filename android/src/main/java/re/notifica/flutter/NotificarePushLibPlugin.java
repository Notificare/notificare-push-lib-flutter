package re.notifica.flutter;

import android.app.Activity;
import android.arch.lifecycle.LiveData;
import android.arch.lifecycle.Observer;
import android.content.Intent;
import android.os.Handler;
import android.os.Looper;
import android.support.annotation.NonNull;
import android.support.annotation.Nullable;

import com.google.android.gms.common.api.CommonStatusCodes;

import org.json.JSONException;
import org.json.JSONObject;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.SortedSet;

import io.flutter.plugin.common.EventChannel;
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
import re.notifica.billing.BillingResult;
import re.notifica.billing.Purchase;
import re.notifica.model.NotificareApplicationInfo;
import re.notifica.model.NotificareAsset;
import re.notifica.model.NotificareBeacon;
import re.notifica.model.NotificareInboxItem;
import re.notifica.model.NotificareNotification;
import re.notifica.model.NotificarePass;
import re.notifica.model.NotificareProduct;
import re.notifica.model.NotificareRegion;
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
public class NotificarePushLibPlugin implements MethodCallHandler, EventChannel.StreamHandler, Observer<SortedSet<NotificareInboxItem>>, Notificare.OnNotificareReadyListener, Notificare.OnServiceErrorListener, Notificare.OnNotificationReceivedListener, BeaconRangingListener, Notificare.OnBillingReadyListener, BillingManager.OnRefreshFinishedListener, BillingManager.OnPurchaseFinishedListener, PluginRegistry.ActivityResultListener, PluginRegistry.NewIntentListener {

  private static final String TAG = NotificarePushLibPlugin.class.getSimpleName();
  private static final int SCANNABLE_REQUEST_CODE = 9004;
  private static final String DEFAULT_ERROR_CODE = "notificare_error";
  private Registrar mRegistrar;
  private MethodChannel mChannel;
  private LiveData<SortedSet<NotificareInboxItem>> mInboxItems;
  private boolean mIsBillingReady = false;

  /** Plugin registration. */
  public static void registerWith(Registrar registrar) {
    Log.i(TAG, "registering Notificare plugin with registrar");
    NotificarePushLibPlugin plugin = new NotificarePushLibPlugin();
    registrar.addActivityResultListener(plugin);
    registrar.addNewIntentListener(plugin);
    plugin.mRegistrar = registrar;
    plugin.mChannel = new MethodChannel(registrar.messenger(), "notificare_push_lib");
    plugin.mChannel.setMethodCallHandler(plugin);
    EventChannel eventsChannel = new EventChannel(registrar.messenger(), "notificare_push_lib/events");
    eventsChannel.setStreamHandler(plugin);
    if (registrar.activity() != null && registrar.activity().getIntent() != null) {
      plugin.handleIntent(registrar.activity().getIntent());
    }
  }

  @Override
  public void onMethodCall(@NonNull MethodCall call, @NonNull Result result) {
    Log.i(TAG, call.method);
    if ("initializeWithKeyAndSecret".equals(call.method)) {// make it a noop
      replySuccess(result, null);
    } else if ("launch".equals(call.method)) {
      Notificare.shared().addNotificareReadyListener(this);
      if (Notificare.shared().getInboxManager() != null) {
        mInboxItems = Notificare.shared().getInboxManager().getObservableItems();
        mInboxItems.observeForever(this);
      }
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
    } else if ("isLocationServicesEnabled".equals(call.method)) {
      replySuccess(result, Notificare.shared().isLocationUpdatesEnabled());
    } else if ("enableBeacons".equals(call.method)) {
      Notificare.shared().enableBeacons();
      replySuccess(result, null);
    } else if ("disableBeacons".equals(call.method)) {
      Notificare.shared().disableBeacons();
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
          replySuccess(result, NotificareUtils.mapDevice(Notificare.shared().getRegisteredDevice()));
        }

        @Override
        public void onError(NotificareError notificareError) {
          replyError(result, DEFAULT_ERROR_CODE, notificareError.getMessage(), null);
        }
      });
    } else if ("fetchDevice".equals(call.method)) {
      replySuccess(result, NotificareUtils.mapDevice(Notificare.shared().getRegisteredDevice()));
    } else if ("fetchPreferredLanguage".equals(call.method)) {
      replySuccess(result, Notificare.shared().getPreferredLanguage());
    } else if ("updatePreferredLanguage".equals(call.method)) {
      Notificare.shared().updatePreferredLanguage(call.argument("language"), new NotificareCallback<Boolean>() {
        @Override
        public void onSuccess(Boolean aBoolean) {
          replySuccess(result, null);
        }

        @Override
        public void onError(NotificareError notificareError) {
          replyError(result, DEFAULT_ERROR_CODE, notificareError.getMessage(), null);
        }
      });
    } else if ("fetchTags".equals(call.method)) {
      Notificare.shared().fetchDeviceTags(new NotificareCallback<List<String>>() {
        @Override
        public void onError(NotificareError notificareError) {
          replyError(result, DEFAULT_ERROR_CODE, notificareError.getMessage(), null);
        }

        @Override
        public void onSuccess(List<String> tags) {
          replySuccess(result, tags);
        }
      });
    } else if ("addTag".equals(call.method)) {
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
    } else if ("addTags".equals(call.method)) {
      Notificare.shared().addDeviceTags(call.argument("tags"), new NotificareCallback<Boolean>() {
        @Override
        public void onSuccess(Boolean aBoolean) {
          replySuccess(result, null);
        }

        @Override
        public void onError(NotificareError notificareError) {
          replyError(result, DEFAULT_ERROR_CODE, notificareError.getMessage(), null);
        }
      });
      replySuccess(result, null);
    } else if ("removeTag".equals(call.method)) {
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
      replySuccess(result, null);
    } else if ("removeTags".equals(call.method)) {
      Notificare.shared().removeDeviceTags(call.argument("tags"), new NotificareCallback<Boolean>() {
        @Override
        public void onSuccess(Boolean aBoolean) {
          replySuccess(result, null);
        }

        @Override
        public void onError(NotificareError notificareError) {
          replyError(result, DEFAULT_ERROR_CODE, notificareError.getMessage(), null);
        }
      });
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
          List<Map<String, Object>> userDataFields = new ArrayList<>();
          for (HashMap.Entry<String, NotificareUserDataField> field : Notificare.shared().getApplicationInfo().getUserDataFields().entrySet()) {
            Map<String, Object> userDataMap = new HashMap<>();
            userDataMap.put("key", field.getValue().getKey());
            userDataMap.put("label", field.getValue().getLabel());
            userDataMap.put("value", notificareUserData.getValue(field.getKey()));
            userDataFields.add(userDataMap);
          }
          replySuccess(result, userDataFields);
        }

        @Override
        public void onError(NotificareError notificareError) {
          replyError(result, DEFAULT_ERROR_CODE, notificareError.getMessage(), null);
        }
      });
    } else if ("updateUserData".equals(call.method)) {
      Map<String, Object> fields = call.argument("userData");
      if (fields != null) {
        NotificareUserData data = new NotificareUserData();
        for (String key : fields.keySet()) {
          if (fields.get(key) != null) {
            data.setValue(key, fields.get(key).toString());
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
          replySuccess(result, NotificareUtils.mapTimeOfDayRange(dnd));
        }

        @Override
        public void onError(NotificareError notificareError) {
          replyError(result, DEFAULT_ERROR_CODE, notificareError.getMessage(), null);
        }
      });
    } else if ("updateDoNotDisturb".equals(call.method)) {
      Map<String, Object> deviceDnd = call.argument("dnd");
      if (deviceDnd != null && deviceDnd.get("start") != null && deviceDnd.get("end") != null && deviceDnd.get("start") instanceof String && deviceDnd.get("end") instanceof String) {
        String[] s = ((String)deviceDnd.get("start")).split(":");
        String[] e = ((String)deviceDnd.get("end")).split(":");
        final NotificareTimeOfDayRange range = new NotificareTimeOfDayRange(
                new NotificareTimeOfDay(Integer.parseInt(s[0]),Integer.parseInt(s[1])),
                new NotificareTimeOfDay(Integer.parseInt(e[0]),Integer.parseInt(e[1])));

        Notificare.shared().updateDoNotDisturb(range, new NotificareCallback<Boolean>() {
          @Override
          public void onSuccess(Boolean aBoolean) {
            replySuccess(result, NotificareUtils.mapTimeOfDayRange(range));
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
          replyError(result, DEFAULT_ERROR_CODE, notificareError.getMessage(), null);
        }
      });
    } else if ("fetchNotification".equals(call.method)) {
      replySuccess(result, null);
    } else if ("fetchNotificationForInboxItem".equals(call.method)) {
      if (Notificare.shared().getInboxManager() != null) {
        Map<String, Object> inboxItem = call.argument("inboxItem");
        if (inboxItem != null && inboxItem.get("inboxId") instanceof String && Notificare.shared().getInboxManager() != null) {
          NotificareInboxItem notificareInboxItem = Notificare.shared().getInboxManager().getItem((String) inboxItem.get("inboxId"));
          if (notificareInboxItem != null) {
            replySuccess(result, NotificareUtils.mapNotification(notificareInboxItem.getNotification()));
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
      Map<String, Object> notification = call.argument("notification");
      presentNotification(notification);
      replySuccess(result, null);
    } else if ("fetchInbox".equals(call.method)) {
      if (Notificare.shared().getInboxManager() != null) {
        List<Map<String, Object>> inbox = new ArrayList<>();
        for (NotificareInboxItem item : Notificare.shared().getInboxManager().getItems()) {
          inbox.add(NotificareUtils.mapInboxItem(item));
        }
        replySuccess(result, inbox);
      } else {
        replyError(result, DEFAULT_ERROR_CODE, new NotificareError("inbox not enabled"));
      }
    } else if ("presentInboxItem".equals(call.method)) {
      if (Notificare.shared().getInboxManager() != null) {
        Map<String, Object> inboxItem = call.argument("inboxItem");
        if (inboxItem != null && inboxItem.get("inboxId") instanceof String) {
          NotificareInboxItem notificareInboxItem = Notificare.shared().getInboxManager().getItem((String) inboxItem.get("inboxId"));
          if (notificareInboxItem != null) {
            Notificare.shared().openInboxItem(mRegistrar.activity(), notificareInboxItem);
          }
        }
      }
    } else if ("removeFromInbox".equals(call.method)) {
      if (Notificare.shared().getInboxManager() != null) {
        Map<String, Object> inboxItem = call.argument("inboxItem");
        if (inboxItem != null && inboxItem.get("inboxId") instanceof String) {
          NotificareInboxItem notificareInboxItem = Notificare.shared().getInboxManager().getItem((String) inboxItem.get("inboxId"));
          if (notificareInboxItem != null) {
            Notificare.shared().getInboxManager().removeItem(notificareInboxItem, new NotificareCallback<Boolean>() {
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
        Map<String, Object> inboxItem = call.argument("inboxItem");
        if (inboxItem != null && inboxItem.get("inboxId") instanceof String) {
          NotificareInboxItem notificareInboxItem = Notificare.shared().getInboxManager().getItem((String) inboxItem.get("inboxId"));
          if (notificareInboxItem != null) {
            Notificare.shared().getInboxManager().markItem(notificareInboxItem, new NotificareCallback<Boolean>() {
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
            replyError(result, DEFAULT_ERROR_CODE, new NotificareError("inbox item not found"));
          }
        } else {
          replyError(result, DEFAULT_ERROR_CODE, new NotificareError("inbox item not found"));
        }
      } else {
        replyError(result, DEFAULT_ERROR_CODE, new NotificareError("inbox not enabled"));
      }
    } else if ("clearInbox".equals(call.method)) {
      if (Notificare.shared().getInboxManager() != null) {
        Notificare.shared().getInboxManager().clearInbox(new NotificareCallback<Integer>() {
          @Override
          public void onSuccess(Integer count) {
            replySuccess(result, count);
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
      Notificare.shared().fetchAssets(call.argument("group"), new NotificareCallback<List<NotificareAsset>>() {
        @Override
        public void onSuccess(List<NotificareAsset> notificareAssets) {
          List<Map<String, Object>> assetsArray = new ArrayList<>();
          for (NotificareAsset asset : notificareAssets) {
            assetsArray.add(NotificareUtils.mapAsset(asset));
          }
          replySuccess(result, assetsArray);
        }

        @Override
        public void onError(NotificareError notificareError) {
          replyError(result, DEFAULT_ERROR_CODE, notificareError);
        }
      });
    } else if ("fetchPassWithSerial".equals(call.method)) {
      Notificare.shared().fetchPass(call.argument("serial"), new NotificareCallback<NotificarePass>() {
        @Override
        public void onSuccess(NotificarePass notificarePass) {
          replySuccess(result, NotificareUtils.mapPass(notificarePass));
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
          replySuccess(result, NotificareUtils.mapPass(notificarePass));
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
        List<Purchase> purchases = Notificare.shared().getBillingManager().getPurchases();
        List<NotificareProduct> products = new ArrayList<>();
        for (Purchase purchase : purchases) {
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
        Map<String, Object> product = call.argument("product");
        if (product != null && product.get("productIdentifier") instanceof String) {
          NotificareProduct theProduct = Notificare.shared().getBillingManager().getProduct((String) product.get("productIdentifier"));
          if (theProduct != null) {
            replySuccess(result, NotificareUtils.mapProduct(theProduct));
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
      if (Notificare.shared().getBillingManager() != null && mRegistrar.activity() != null) {
        Map<String, Object> product = call.argument("product");
        if (product != null && product.get("productIdentifier") instanceof String) {
          NotificareProduct notificareProduct = Notificare.shared().getBillingManager().getProduct((String) product.get("identifier"));
          final Activity activity = mRegistrar.activity();
          activity.runOnUiThread(() -> Notificare.shared().getBillingManager().launchPurchaseFlow(activity, notificareProduct, this));
        }
      }
      replySuccess(result, null);
    } else if ("logCustomEvent".equals(call.method)) {
      Map<String, Object> data = call.argument("data");
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
    } else if ("logOpenNotification".equals(call.method)) {
      Map<String, Object> notification = call.argument("notification");
      if (notification != null && notification.get("id") != null && notification.get("id") instanceof String) {
        Notificare.shared().getEventLogger().logOpenNotification((String)notification.get("id"), new NotificareCallback<Boolean>() {
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
      Map<String, Object> notification = call.argument("notification");
      if (notification != null && notification.get("id") != null && notification.get("id") instanceof String) {
        Notificare.shared().getEventLogger().logOpenNotificationInfluenced((String)notification.get("id"), new NotificareCallback<Boolean>() {
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
      Map<String, Object> body  = call.argument("body");
      Map<String, Object> params = call.argument("params");
      Map<String, Object> headers = call.argument("headers");

      JSONObject jsonData = new JSONObject(body);
      Map<String,String> paramsMap = new HashMap<>();
      if (params != null) {
        for (String key : params.keySet()) {
          paramsMap.put(key, (String)params.get(key));
        }
      }
      Map<String,String> headersMap = new HashMap<>();
      if (headers != null) {
        for (String key : headers.keySet()) {
          headersMap.put(key, (String)headers.get(key));
        }
      }
      Notificare.shared().doCloudRequest(call.argument("verb"), call.argument("path"), paramsMap, jsonData, headersMap, new NotificareCallback<JSONObject>() {
        @Override
        public void onSuccess(JSONObject jsonObject) {
          try {
            replySuccess(result, NotificareUtils.mapJSONObject(jsonObject));
          } catch (JSONException e) {
            replyError(result, DEFAULT_ERROR_CODE, new NotificareError("invalid response"));
          }
        }

        @Override
        public void onError(NotificareError notificareError) {
          replyError(result, DEFAULT_ERROR_CODE, notificareError);
        }
      });
    } else if ("createAccount".equals(call.method)) {
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
    } else if ("validateAccount".equals(call.method)) {
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
    } else if ("resetPassword".equals(call.method)) {
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
    } else if ("sendPassword".equals(call.method)) {
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
    } else if ("login".equals(call.method)) {
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
          replySuccess(result, NotificareUtils.mapUser(notificareUser));
        }

        @Override
        public void onError(NotificareError notificareError) {
          replyError(result, DEFAULT_ERROR_CODE, notificareError);
        }
      });
    } else if ("changePassword".equals(call.method)) {
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
    } else if ("fetchAccountDetails".equals(call.method)) {
      Notificare.shared().fetchUserDetails(new NotificareCallback<NotificareUser>() {
        @Override
        public void onSuccess(NotificareUser notificareUser) {
          replySuccess(result, NotificareUtils.mapUser(notificareUser));
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
          List<Map<String, Object>> preferencesArray = new ArrayList<>();
          for (NotificareUserPreference preference : notificareUserPreferences) {
            preferencesArray.add(NotificareUtils.mapUserPreference(preference));
          }
          replySuccess(result, preferencesArray);
        }

        @Override
        public void onError(NotificareError notificareError) {
          replyError(result, DEFAULT_ERROR_CODE, notificareError);
        }
      });
    } else if ("addSegmentToUserPreference".equals(call.method)) {
      Map<String, Object> segment = call.argument("segment");
      Map<String, Object> preference = call.argument("userPreference");
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
      Map<String, Object> segment = call.argument("segment");
      Map<String, Object> preference = call.argument("userPreference");
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
      if (mRegistrar.activity() != null) {
        Notificare.shared().startScannableActivity(mRegistrar.activity(), SCANNABLE_REQUEST_CODE);
      }
      replySuccess(result, null);
    } else if ("presentScannable".equals(call.method)) {
      Map<String, Object> scannable = call.argument("scannable");
      if (scannable != null && scannable.get("notification") != null && scannable.get("notification") instanceof Map) {
        Map notification = (Map)scannable.get("notification");
        presentNotification(notification);
      }
    } else {
      replyNotImplemented(result);
    }
  }

  private void presentNotification(Map<String, Object> notification) {
    if (notification != null && notification.containsKey("id")) {
      String notificationId = (String) notification.get("id");
      if (notification.containsKey("inboxItemId") && notification.get("inboxItemId") != null && Notificare.shared().getInboxManager() != null) {
        // This is an item opened with inboxItemId, so coming from NotificationManager open
        NotificareInboxItem notificareInboxItem = Notificare.shared().getInboxManager().getItem((String) notification.get("inboxItemId"));
        if (notificareInboxItem != null) {
          Notificare.shared().openInboxItem(mRegistrar.activity(), notificareInboxItem);
        }
      } else if (notificationId != null && !notificationId.isEmpty()) {
        // We have a notificationId, let's see if we can create a notification from the payload, otherwise fetch from API
        NotificareNotification notificareNotification = NotificareUtils.createNotification(notification);
        if (notificareNotification != null) {
          Notificare.shared().openNotification(mRegistrar.activity(), notificareNotification);
        } else {
          Notificare.shared().fetchNotification(notificationId, new NotificareCallback<NotificareNotification>() {
            @Override
            public void onSuccess(NotificareNotification notificareNotification) {
              Notificare.shared().openNotification(mRegistrar.activity(), notificareNotification);
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
    final MethodChannel channel = mChannel;
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
   */
  private void sendValidateUserToken(String token) {
    if (token != null && !token.isEmpty()) {
      Map<String, Object> tokenMap = new HashMap<>();
      tokenMap.put("token", token);
      sendEvent("activationTokenReceived", tokenMap, true);
    }
  }

  /**
   * Send a password reset token received event
   * @param token
   */
  private void sendResetPasswordToken(String token) {
    if (token != null && !token.isEmpty()) {
      Map<String, Object> tokenMap = new HashMap<>();
      tokenMap.put("token", token);
      sendEvent("resetPasswordTokenReceived", tokenMap, true);
    }
  }

  protected Map<String, Object> parseNotificationIntent(Intent intent) {
    NotificareNotification notification = intent.getParcelableExtra(Notificare.INTENT_EXTRA_NOTIFICATION);
    if (notification != null) {
      Map<String, Object> notificationMap = NotificareUtils.mapNotification(notification);
      // Add inbox item id if present
      if (intent.hasExtra(Notificare.INTENT_EXTRA_INBOX_ITEM_ID)) {
        notificationMap.put("inboxItemId", intent.getStringExtra(Notificare.INTENT_EXTRA_INBOX_ITEM_ID));
      }
      return notificationMap;
    }
    return null;
  }

  protected void handleIntent(Intent intent) {
    Map<String, Object> notificationMap = parseNotificationIntent(intent);
    if (notificationMap != null) {
      sendEvent("remoteNotificationReceivedInBackground", notificationMap, true);
    } else {
      sendValidateUserToken(Notificare.shared().parseValidateUserIntent(intent));
      sendResetPasswordToken(Notificare.shared().parseResetPasswordIntent(intent));
    }
  }

  @Override
  public void onListen(Object o, EventChannel.EventSink eventSink) {
    Notificare.shared().addServiceErrorListener(this);
    Notificare.shared().setForeground(true);
    Notificare.shared().addNotificationReceivedListener(this);
    Notificare.shared().getEventLogger().logStartSession();
    if (Notificare.shared().getBeaconClient() != null) {
      Notificare.shared().getBeaconClient().addRangingListener(this);
    }
    Notificare.shared().addBillingReadyListener(this);
    NotificareEventEmitter.getInstance().onListen(eventSink);
  }

  @Override
  public void onCancel(Object o) {
    Notificare.shared().removeServiceErrorListener(this);
    Notificare.shared().removeNotificationReceivedListener(this);
    Notificare.shared().setForeground(false);
    Notificare.shared().getEventLogger().logEndSession();
    if (Notificare.shared().getBeaconClient() != null) {
      Notificare.shared().getBeaconClient().removeRangingListener(this);
    }
    Notificare.shared().removeBillingReadyListener(this);
    NotificareEventEmitter.getInstance().onCancel();
  }

  @Override
  public void onNotificareReady(NotificareApplicationInfo notificareApplicationInfo) {
    Log.i(TAG, "ready");
    sendEvent("ready", NotificareUtils.mapApplicationInfo(notificareApplicationInfo), true);
  }

  @Override
  public void onChanged(@Nullable SortedSet<NotificareInboxItem> notificareInboxItems) {
    List<Map<String, Object>> inbox = new ArrayList<>();
    if (notificareInboxItems != null) {
      for (NotificareInboxItem item : notificareInboxItems) {
        inbox.add(NotificareUtils.mapInboxItem(item));
      }
      sendEvent("inboxLoaded", inbox, false);
      sendEvent("badgeUpdated", Notificare.shared().getInboxManager().getUnreadCount(), false);
    }
  }

  @Override
  public void onBillingReady() {
    if (!mIsBillingReady) {
      Notificare.shared().getBillingManager().refresh(this);
    }
  }

  @Override
  public void onNotificationReceived(NotificareNotification notification) {
    if (notification != null) {
      sendEvent("remoteNotificationReceivedInForeground", NotificareUtils.mapNotification(notification), true);
    }
  }

  @Override
  public void onServiceError(int errorCode, int requestCode) {
    if (Notificare.isUserRecoverableError(errorCode) && mRegistrar != null && mRegistrar.activity() != null) {
      final Activity activity = mRegistrar.activity();
      activity.runOnUiThread(() -> Notificare.getErrorDialog(errorCode, activity, requestCode).show());
    }
  }

  @Override
  public void onRangingBeacons(List<NotificareBeacon> beacons) {
    Map<String, Object> payload = new HashMap<>();
    List<Map<String,Object>> beaconsArray = new ArrayList<>();
    for (NotificareBeacon beacon : beacons) {
      beaconsArray.add(NotificareUtils.mapBeacon(beacon));
    }
    payload.put("beacons", beaconsArray);
    if (beacons.size() > 0) {
      NotificareRegion region = beacons.get(0).getRegion();
      if (region != null) {
        payload.put("region", NotificareUtils.mapRegion(region));
      }
    }
    sendEvent("beaconsInRangeForRegion", payload, false);
  }

  @Override
  public void onPurchaseFinished(BillingResult billingResult, Purchase purchase) {
    mIsBillingReady = false;
    Map<String, Object> payload = new HashMap<>();
    NotificareProduct product = Notificare.shared().getBillingManager().getProduct(purchase.getProductId());
    if (product != null) {
      payload.put("product", NotificareUtils.mapProduct(product));
    }
    if (billingResult.isFailure()) {
      payload.put("error", billingResult.getMessage());
      sendEvent("productTransactionFailed", payload, true);
    } else if (billingResult.isSuccess()) {
      sendEvent("productTransactionCompleted", payload, true);
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
              sendEvent("scannableDetected", NotificareUtils.mapScannable(scannable), true);
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
      } else if (Notificare.shared().getBillingManager() != null && Notificare.shared().getBillingManager().handleActivityResult(requestCode, resultCode, data)) {
        // Billingmanager handled the result
        mIsBillingReady = true; // wait for purchase to finish before doing other calls
      } else {
        return false;
      }
    }
    return true;
  }

  @Override
  public boolean onNewIntent(Intent intent) {
    Map<String, Object> notificationMap = parseNotificationIntent(intent);
    if (notificationMap != null) {
      sendEvent("remoteNotificationReceivedInBackground", notificationMap, true);
      return true;
    }
    return false;
  }
}
