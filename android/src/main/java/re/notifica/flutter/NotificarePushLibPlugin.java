package re.notifica.flutter;

import android.os.Handler;
import android.os.Looper;
import android.support.annotation.NonNull;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import io.flutter.plugin.common.EventChannel;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;
import io.flutter.plugin.common.PluginRegistry.Registrar;
import re.notifica.Notificare;
import re.notifica.model.NotificareApplicationInfo;
import re.notifica.util.Log;

/** NotificarePushLibPlugin */
public class NotificarePushLibPlugin implements MethodCallHandler, EventChannel.StreamHandler, Notificare.OnNotificareReadyListener {

  private static final String TAG = NotificarePushLibPlugin.class.getSimpleName();
  private MethodChannel mChannel;

  /** Plugin registration. */
  public static void registerWith(Registrar registrar) {
    NotificarePushLibPlugin plugin = new NotificarePushLibPlugin();
    plugin.mChannel = new MethodChannel(registrar.messenger(), "notificare_push_lib");
    plugin.mChannel.setMethodCallHandler(plugin);
    EventChannel eventsChannel = new EventChannel(registrar.messenger(), "notificare_push_lib/events");
    eventsChannel.setStreamHandler(plugin);
  }

  @Override
  public void onMethodCall(@NonNull MethodCall call, @NonNull Result result) {
    Log.i(TAG, call.method);
    switch (call.method) {
      case "initializeWithKeyAndSecret":
        replySuccess(result, null);
        break;
      case "launch":
        Notificare.shared().addNotificareReadyListener(this);
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
    sendEvent("ready", NotificareUtils.applicationInfoMap(notificareApplicationInfo), true);
  }
}
