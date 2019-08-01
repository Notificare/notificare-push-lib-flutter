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
import re.notifica.model.NotificareBeacon;
import re.notifica.model.NotificareInboxItem;
import re.notifica.model.NotificareNotification;
import re.notifica.model.NotificareProduct;
import re.notifica.model.NotificareRegion;
import re.notifica.model.NotificareScannable;
import re.notifica.util.Log;

/** NotificarePushLibPlugin */
public class NotificarePushLibPlugin implements MethodCallHandler, EventChannel.StreamHandler, Observer<SortedSet<NotificareInboxItem>>, Notificare.OnNotificareReadyListener, Notificare.OnServiceErrorListener, Notificare.OnNotificationReceivedListener, BeaconRangingListener, Notificare.OnBillingReadyListener, BillingManager.OnRefreshFinishedListener, BillingManager.OnPurchaseFinishedListener, PluginRegistry.ActivityResultListener, PluginRegistry.NewIntentListener {

  private static final String TAG = NotificarePushLibPlugin.class.getSimpleName();
  private static final int SCANNABLE_REQUEST_CODE = 9004;
  private static final String DEFAULT_ERROR_CODE = "notificare_error";
  private Registrar mRegistrar;
  private MethodChannel mChannel;
  private LiveData<SortedSet<NotificareInboxItem>> inboxItems;
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
      Log.i(TAG, "launched with intent: " + registrar.activity().getIntent());
    }
  }

  @Override
  public void onMethodCall(@NonNull MethodCall call, @NonNull Result result) {
    Log.i(TAG, call.method);
    switch (call.method) {
      case "initializeWithKeyAndSecret":
        // make it a noop
        replySuccess(result, null);
        break;
      case "launch":
        Notificare.shared().addNotificareReadyListener(this);
        if (Notificare.shared().getInboxManager() != null) {
          inboxItems = Notificare.shared().getInboxManager().getObservableItems();
          inboxItems.observeForever(this);
        }
        replySuccess(result, null);
        break;
      case "registerForNotifications":
        Notificare.shared().enableNotifications();
        replySuccess(result, null);
        break;
      case "unregisterForNotifications":
        Notificare.shared().disableNotifications();
        replySuccess(result, null);
        break;
      case "isRemoteNotificationsEnabled":
        replySuccess(result, Notificare.shared().isNotificationsEnabled());
        break;
      case "isAllowedUIEnabled":
        replySuccess(result, Notificare.shared().checkAllowedUI());
        break;
      case "isNotificationFromNotificare":
        replySuccess(result, true);
        break;
      case "fetchNotificationSettings":
        replySuccess(result, new HashMap<String, Object>());
        break;
      case "startLocationUpdates":
        replySuccess(result, null);
        break;
      case "stopLocationUpdates":
        replySuccess(result, null);
        break;
      case "isLocationServicesEnabled":
        replySuccess(result, Notificare.shared().isLocationUpdatesEnabled());
        break;
      case "registerDevice":
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
        break;
      case "fetchDevice":
        replySuccess(result, null);
        break;
      case "fetchPreferredLanguage":
        replySuccess(result, null);
        break;
      case "updatePreferredLanguage":
        replySuccess(result, null);
        break;
      case "fetchTags":
        replySuccess(result, null);
        break;
      case "addTag":
        replySuccess(result, null);
        break;
      case "addTags":
        replySuccess(result, null);
        break;
      case "removeTag":
        replySuccess(result, null);
        break;
      case "removeTags":
        replySuccess(result, null);
        break;
      case "clearTags":
        replySuccess(result, null);
        break;
      case "fetchUserData":
        replySuccess(result, null);
        break;
      case "updateUserData":
        replySuccess(result, null);
        break;
      case "fetchDoNotDisturb":
        replySuccess(result, null);
        break;
      case "updateDoNotDisturb":
        replySuccess(result, null);
        break;
      case "clearDoNotDisturb":
        replySuccess(result, null);
        break;
      case "fetchNotification":
        replySuccess(result, null);
        break;
      case "fetchNotificationForInboxItem":
        replySuccess(result, null);
        break;
      case "presentNotification":
        replySuccess(result, null);
        break;
      case "fetchInbox":
        replySuccess(result, null);
        break;
      case "presentInboxItem":
        replySuccess(result, null);
        break;
      case "removeFromInbox":
        replySuccess(result, null);
        break;
      case "markAsRead":
        replySuccess(result, null);
        break;
      case "clearInbox":
        replySuccess(result, null);
        break;
      case "fetchAssets":
        replySuccess(result, null);
        break;
      case "fetchPassWithSerial":
        replySuccess(result, null);
        break;
      case "fetchPassWithBarcode":
        replySuccess(result, null);
        break;
      case "fetchProducts":
        replySuccess(result, null);
        break;
      case "fetchPurchasedProducts":
        replySuccess(result, null);
        break;
      case "fetchProduct":
        replySuccess(result, null);
        break;
      case "buyProduct":
        replySuccess(result, null);
        break;
      case "logCustomEvent":
        replySuccess(result, null);
        break;
      case "logOpenNotification":
        replySuccess(result, null);
        break;
      case "logInfluencedNotification":
        replySuccess(result, null);
        break;
      case "doCloudHostOperation":
        replySuccess(result, null);
        break;
      case "createAccount":
        replySuccess(result, null);
        break;
      case "validateAccount":
        replySuccess(result, null);
        break;
      case "resetPassword":
        replySuccess(result, null);
        break;
      case "login":
        replySuccess(result, null);
        break;
      case "logout":
        replySuccess(result, null);
        break;
      case "isLoggedIn":
        replySuccess(result, null);
        break;
      case "generateAccessToken":
        replySuccess(result, null);
        break;
      case "changePassword":
        replySuccess(result, null);
        break;
      case "fetchAccountDetails":
        replySuccess(result, null);
        break;
      case "fetchUserPreferences":
        replySuccess(result, null);
        break;
      case "addSegmentToUserPreference":
        replySuccess(result, null);
        break;
      case "removeSegmentFromUserPreference":
        replySuccess(result, null);
        break;
      case "startScannableSession":
        replySuccess(result, null);
        break;
      case "presentScannable":
        replySuccess(result, null);
        break;
      default:
        replyNotImplemented(result);
        break;
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

  @Override
  public void onListen(Object o, EventChannel.EventSink eventSink) {
    NotificareEventEmitter.getInstance().onListen(eventSink);
  }

  @Override
  public void onCancel(Object o) {
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
    List<NotificareProduct> list = Notificare.shared().getBillingManager().getProducts();
    sendEvent("storeLoaded", NotificareUtils.mapProducts(list), true);
  }

  @Override
  public void onRefreshFailed(NotificareError notificareError) {
    Map<String, Object> payload = new HashMap<>();
    payload.put("error", notificareError.getMessage());
    sendEvent("storeFailedToLoad", payload, true);
  }

  @Override
  public boolean onActivityResult(int requestCode, int resultCode, Intent data) {
    if (!Notificare.shared().handleServiceErrorResolution(requestCode, resultCode, data)) {
      if (requestCode == SCANNABLE_REQUEST_CODE) {
        Map<String, Object> payload = new HashMap<>();
        if (resultCode == CommonStatusCodes.SUCCESS) {
          if (data != null) {
            NotificareScannable scannable = Notificare.shared().extractScannableFromActivityResult(data);
            if (scannable != null) {
              sendEvent("scannableDetected", NotificareUtils.mapScannable(scannable), true);
            } else {
              payload.put("error", "scannable not found");
              sendEvent("scannableSessionInvalidatedWithError", payload, true);
            }
          } else {
            payload.put("error", "scan did not return any results");
            sendEvent("scannableSessionInvalidatedWithError", payload, true);
          }
        } else if (resultCode == CommonStatusCodes.CANCELED) {
          payload.put("error", "scan was canceled");
          sendEvent("scannableSessionInvalidatedWithError", payload, true);
        } else {
          payload.put("error", "unknown error");
          sendEvent("scannableSessionInvalidatedWithError", payload, true);
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
