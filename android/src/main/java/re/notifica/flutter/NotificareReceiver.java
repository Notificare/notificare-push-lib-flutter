package re.notifica.flutter;

import android.net.Uri;
import android.os.Bundle;

import java.util.HashMap;
import java.util.Map;

import re.notifica.Notificare;
import re.notifica.app.DefaultIntentReceiver;
import re.notifica.model.NotificareDevice;
import re.notifica.model.NotificareNotification;

public class NotificareReceiver extends DefaultIntentReceiver {
    @Override
    public void onReady() {
        // Event is emitted by the onReady listener in the module
        // Check if notifications are enabled, by default they are not.
        if (Notificare.shared().isNotificationsEnabled()) {
            Notificare.shared().enableNotifications();
        }
        // Check if location updates are enabled, by default they are not.
        if (Notificare.shared().isLocationUpdatesEnabled()) {
            Notificare.shared().enableLocationUpdates();
        }
    }

    @Override
    public void onUrlClicked(Uri urlClicked, Bundle extras) {
        // emit "urlClickedInNotification" event with url and notification
        Map<String, Object> payload = new HashMap<>();
        payload.put("url", urlClicked.toString());
        NotificareNotification notification = extras.getParcelable(Notificare.INTENT_EXTRA_NOTIFICATION);
        if (notification != null) {
            payload.put("notification", NotificareUtils.notificationMap(notification));
        }
        NotificareEventEmitter.getInstance().sendEvent("urlClickedInNotification", payload, true);
    }

    @Override
    public void onDeviceRegistered(NotificareDevice device) {
        // emit "deviceRegistered" event with device
        NotificareEventEmitter.getInstance().sendEvent("deviceRegistered", NotificareUtils.deviceMap(device), true);
    }

}
