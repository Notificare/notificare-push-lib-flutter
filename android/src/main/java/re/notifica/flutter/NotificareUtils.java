package re.notifica.flutter;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import re.notifica.Notificare;
import re.notifica.model.NotificareApplicationInfo;
import re.notifica.model.NotificareBeacon;
import re.notifica.model.NotificareDevice;
import re.notifica.model.NotificareInboxConfig;
import re.notifica.model.NotificareInboxItem;
import re.notifica.model.NotificareNotification;
import re.notifica.model.NotificareProduct;
import re.notifica.model.NotificareRegion;
import re.notifica.model.NotificareScannable;

public class NotificareUtils {

    public static Map<String, Object> mapApplicationInfo(NotificareApplicationInfo applicationInfo) {
        Map<String, Object> result = new HashMap<>();
        result.put("name", applicationInfo.getName());
        return result;
    }

    public static Map<String, Object> mapDevice(NotificareDevice device) {
        Map<String, Object> result = new HashMap<>();
        result.put("deviceID", device.getDeviceId());
        return result;
    }

    public static Map<String, Object> mapNotification(NotificareNotification notification) {
        Map<String, Object> result = new HashMap<>();
        result.put("id", notification.getNotificationId());
        result.put("message", notification.getMessage());
        return result;
    }

    public static Map<String, Object> mapRegion(NotificareRegion region) {
        Map<String, Object> result = new HashMap<>();
        result.put("id", region.getRegionId());
        return result;
    }

    public static Map<String, Object> mapBeacon(NotificareBeacon beacon) {
        Map<String, Object> result = new HashMap<>();
        result.put("id", beacon.getBeaconId());
        return result;
    }

    public static Map<String, Object> mapProduct(NotificareProduct product) {
        Map<String, Object> result = new HashMap<>();
        result.put("id", product.getIdentifier());
        return result;
    }

    public static Map<String, Object> mapProducts(List<NotificareProduct> products) {
        Map<String, Object> result = new HashMap<>();
        return result;
    }

    public static Map<String, Object> mapInboxItem(NotificareInboxItem inboxItem) {
        Map<String, Object> result = new HashMap<>();
        result.put("id", inboxItem.getItemId());
        return result;
    }

    public static Map<String, Object> mapScannable(NotificareScannable scannable) {
        Map<String, Object> result = new HashMap<>();
        result.put("id", scannable.getScannableId());
        return result;
    }


}
