package re.notifica.flutter;

import java.util.HashMap;
import java.util.Map;

import re.notifica.Notificare;
import re.notifica.model.NotificareApplicationInfo;
import re.notifica.model.NotificareDevice;
import re.notifica.model.NotificareNotification;

public class NotificareUtils {

    public static Map<String, Object> applicationInfoMap(NotificareApplicationInfo applicationInfo) {
        Map<String, Object> result = new HashMap<>();
        result.put("name", applicationInfo.getName());
        return result;
    }

    public static Map<String, Object> deviceMap(NotificareDevice device) {
        Map<String, Object> result = new HashMap<>();
        result.put("deviceID", device.getDeviceId());
        return result;
    }

    public static Map<String, Object> notificationMap(NotificareNotification notification) {
        Map<String, Object> result = new HashMap<>();
        result.put("id", notification.getNotificationId());
        return result;
    }
}
