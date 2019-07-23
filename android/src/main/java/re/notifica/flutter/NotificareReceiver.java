package re.notifica.flutter;

import re.notifica.Notificare;
import re.notifica.app.DefaultIntentReceiver;

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
}
