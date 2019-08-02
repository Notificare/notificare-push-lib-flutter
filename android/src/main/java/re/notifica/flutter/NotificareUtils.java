package re.notifica.flutter;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;

import re.notifica.Notificare;
import re.notifica.model.NotificareAction;
import re.notifica.model.NotificareApplicationInfo;
import re.notifica.model.NotificareAsset;
import re.notifica.model.NotificareAttachment;
import re.notifica.model.NotificareBeacon;
import re.notifica.model.NotificareContent;
import re.notifica.model.NotificareCoordinates;
import re.notifica.model.NotificareDevice;
import re.notifica.model.NotificareInboxItem;
import re.notifica.model.NotificareNotification;
import re.notifica.model.NotificarePass;
import re.notifica.model.NotificarePassRedemption;
import re.notifica.model.NotificarePoint;
import re.notifica.model.NotificarePolygon;
import re.notifica.model.NotificareProduct;
import re.notifica.model.NotificareRegion;
import re.notifica.model.NotificareScannable;
import re.notifica.model.NotificareTimeOfDayRange;
import re.notifica.model.NotificareUser;
import re.notifica.model.NotificareUserPreference;
import re.notifica.model.NotificareUserPreferenceOption;
import re.notifica.model.NotificareUserSegment;
import re.notifica.util.ISODateFormatter;

public class NotificareUtils {

    /**
     * Map JSON object
     * @param jsonObject
     * @return
     * @throws JSONException
     */
    public static Map<String, Object> mapJSONObject(JSONObject jsonObject)  throws JSONException {
        Map<String, Object> map = new HashMap<>();
        Iterator<String> keys = jsonObject.keys();
        while(keys.hasNext()) {
            String key = keys.next();
            Object value = jsonObject.get(key);
            if (value instanceof JSONArray) {
                value = mapJSONArray((JSONArray) value);
            } else if (value instanceof JSONObject) {
                value = mapJSONObject((JSONObject) value);
            }
            map.put(key, value);
        }   return map;
    }

    /**
     * Map JSON array to List
     * @param jsonArray
     * @return
     * @throws JSONException
     */
    public static List<Object> mapJSONArray(JSONArray jsonArray) throws JSONException {
        List<Object> list = new ArrayList<>();
        for(int i = 0; i < jsonArray.length(); i++) {
            Object value = jsonArray.get(i);
            if (value instanceof JSONArray) {
                value = mapJSONArray((JSONArray) value);
            }
            else if (value instanceof JSONObject) {
                value = mapJSONObject((JSONObject) value);
            }
            list.add(value);
        }   return list;
    }

    /**
     * Map application info
     * @param applicationInfo
     * @return
     */
    public static Map<String, Object> mapApplicationInfo(NotificareApplicationInfo applicationInfo) {
        Map<String, Object> infoMap = new HashMap<>();
        infoMap.put("id", applicationInfo.getId());
        infoMap.put("name", applicationInfo.getName());
        Map<String, Object> servicesMap = new HashMap<>();
        for (String key : applicationInfo.getServices().keySet()) {
            servicesMap.put(key, applicationInfo.getServices().get(key));
        }
        infoMap.put("services", servicesMap);

        if (applicationInfo.getInboxConfig() != null) {
            Map<String, Object> inboxConfigMap = new HashMap<>();
            inboxConfigMap.put("autoBadge", applicationInfo.getInboxConfig().getAutoBadge());
            inboxConfigMap.put("useInbox", applicationInfo.getInboxConfig().getUseInbox());
            infoMap.put("inboxConfig", inboxConfigMap);
        }

        if (applicationInfo.getRegionConfig() != null) {
            Map<String, Object> regionConfigMap = new HashMap<>();
            regionConfigMap.put("proximityUUID", applicationInfo.getRegionConfig().getProximityUUID());
            infoMap.put("regionConfig", regionConfigMap);
        }


        List<Map<String, Object>> userDataFieldsArray = new ArrayList<>();
        for (String key : applicationInfo.getUserDataFields().keySet()){
            Map<String, Object> userDataFieldMap = new HashMap<>();
            userDataFieldMap.put("key", key);
            userDataFieldMap.put("label", applicationInfo.getUserDataFields().get(key).getLabel());
            userDataFieldsArray.add(userDataFieldMap);
        }
        infoMap.put("userDataFields", userDataFieldsArray);

        return infoMap;
    }

    /**
     * Map a device
     * @param device
     * @return
     */
    public static Map<String, Object> mapDevice(NotificareDevice device) {
        Map<String, Object> deviceMap = new HashMap<>();
        deviceMap.put("deviceID", device.getDeviceId());
        deviceMap.put("userID", device.getUserId());
        deviceMap.put("userName", device.getUserName());
        deviceMap.put("timezone", device.getTimeZoneOffset());
        deviceMap.put("osVersion", device.getOsVersion());
        deviceMap.put("sdkVersion", device.getSdkVersion());
        deviceMap.put("appVersion", device.getAppVersion());
        deviceMap.put("deviceString", device.getDeviceString());
        deviceMap.put("deviceModel", device.getDeviceString());
        deviceMap.put("countryCode", device.getCountry());
        deviceMap.put("language", device.getLanguage());
        deviceMap.put("region", device.getRegion());
        deviceMap.put("transport", device.getTransport());
        deviceMap.put("latitude", device.getLatitude());
        deviceMap.put("longitude", device.getLongitude());
        deviceMap.put("altitude", device.getAltitude());
        deviceMap.put("speed", device.getSpeed());
        deviceMap.put("course", device.getCourse());
        deviceMap.put("lastRegistered", ISODateFormatter.format(device.getLastActive()));
        deviceMap.put("locationServicesAuthStatus", device.getLocationServicesAuthStatus() ? "always" : "none");
        deviceMap.put("registeredForNotifications", Notificare.shared().isNotificationsEnabled());
        deviceMap.put("allowedLocationServices", device.getLocationServicesAuthStatus());
        deviceMap.put("allowedUI", device.getAllowedUI());
        deviceMap.put("bluetoothEnabled", device.getBluetoothEnabled());
        deviceMap.put("bluetoothON", device.getBluetoothEnabled());
        return deviceMap;
    }

    /**
     * Map a notification
     * @param notification
     * @return
     */
    public static Map<String, Object> mapNotification(NotificareNotification notification) {
        Map<String, Object> notificationMap = new HashMap<>();
        notificationMap.put("id", notification.getNotificationId());
        notificationMap.put("message", notification.getMessage());
        notificationMap.put("title", notification.getTitle());
        notificationMap.put("subtitle", notification.getSubtitle());
        notificationMap.put("type", notification.getType());
        notificationMap.put("time", ISODateFormatter.format(notification.getTime()));
        if (notification.getExtra() != null) {
            Map<String, Object> extraMap = new HashMap<>();
            for (HashMap.Entry<String, String> prop : notification.getExtra().entrySet()) {
                extraMap.put(prop.getKey(), prop.getValue());
            }
            notificationMap.put("extra", extraMap);
        }
        if (notification.getContent().size() > 0) {
            List<Map<String,Object>> contentArray = new ArrayList<>();
            for (NotificareContent c : notification.getContent()) {
                Map<String, Object> contentMap = new HashMap<>();
                contentMap.put("type", c.getType());
                contentMap.put("data", c.getData().toString());
                contentArray.add(contentMap);
            }
            notificationMap.put("content", contentArray);
        }
        if (notification.getAttachments().size() > 0) {
            List<Map<String,Object>> attachmentsArray = new ArrayList<>();
            for (NotificareAttachment a : notification.getAttachments()) {
                Map<String, Object> attachmentsMap = new HashMap<>();
                attachmentsMap.put("mimeType", a.getMimeType());
                attachmentsMap.put("uri", a.getUri());
                attachmentsArray.add(attachmentsMap);
            }
            notificationMap.put("attachments", attachmentsArray);
        }
        if (notification.getActions().size() > 0) {
            List<Map<String, Object>> actionsArray = new ArrayList<>();
            for (NotificareAction a : notification.getActions()) {
                Map<String, Object> actionMap = new HashMap<>();
                actionMap.put("label", a.getLabel());
                actionMap.put("type", a.getType());
                actionMap.put("target", a.getTarget());
                actionMap.put("camera", a.getCamera());
                actionMap.put("keyboard", a.getKeyboard());
                actionsArray.add(actionMap);
            }
            notificationMap.put("actions", actionsArray);
        }
        notificationMap.put("partial", notification.isPartial());
        return notificationMap;
    }

    /**
     * Create a notification instance from a map
     * @param notificationMap
     * @return
     */
    public static NotificareNotification createNotification(Map<String, Object> notificationMap) {
        if (notificationMap.get("partial") != null && (boolean)notificationMap.get("partial")) {
            return null;
        } else {
            try {
                JSONObject json = new JSONObject(notificationMap);
                if (notificationMap.containsKey("id")) {
                    json.put("_id", notificationMap.get("id"));
                }
                return new NotificareNotification(json);
            } catch (JSONException e) {
                return null;
            }
        }
    }

    /**
     * Map an asset
     * @param asset
     * @return
     */
    public static Map<String, Object> mapAsset(NotificareAsset asset) {
        Map<String, Object> assetMap = new HashMap<>();
        assetMap.put("assetTitle", asset.getTitle());
        assetMap.put("assetDescription", asset.getDescription());
        assetMap.put("assetUrl", asset.getUrl().toString());

        Map<String, Object> metaMap = new HashMap<>();
        metaMap.put("originalFileName", asset.getOriginalFileName());
        metaMap.put("key", asset.getKey());
        metaMap.put("contentType", asset.getContentType());
        metaMap.put("contentLength", asset.getContentLength());
        assetMap.put("assetMetaData", metaMap);

        Map<String, Object> buttonMap = new HashMap<>();
        buttonMap.put("label", asset.getButtonLabel());
        buttonMap.put("action", asset.getButtonAction());
        assetMap.put("assetButton", buttonMap);
        return assetMap;
    }

    /**
     * Map time of day range
     * @param notificareTimeOfDayRange
     * @return
     */
    public static Map<String, Object> mapTimeOfDayRange(NotificareTimeOfDayRange notificareTimeOfDayRange) {
        Map<String, Object> timeOfDayRangeMap = new HashMap<>();
        timeOfDayRangeMap.put("start", notificareTimeOfDayRange.getStart().toString());
        timeOfDayRangeMap.put("end", notificareTimeOfDayRange.getEnd().toString());
        return timeOfDayRangeMap;
    }

    /**
     * Map a point
     * @param point
     * @return
     */
    public static Map<String, Object> mapPoint(NotificarePoint point) {
        Map<String, Object> pointMap = new HashMap<>();
        pointMap.put("type", point.getType());
        pointMap.put("coordinates", Arrays.asList(point.getLongitude(), point.getLatitude()));
        return pointMap;
    }

    /**
     * Map a polygon
     * @param polygon
     * @return
     */
    public static Map<String, Object> mapPolygon(NotificarePolygon polygon) {
        Map<String, Object> polygonMap = new HashMap<>();
        polygonMap.put("type", polygon.getType());
        List<List<Double>> coordinatesList = new ArrayList<>();
        for (NotificareCoordinates coordinates : polygon.getCoordinates()) {
            coordinatesList.add(Arrays.asList(coordinates.getLongitude(), coordinates.getLatitude()));
        }
        polygonMap.put("coordinates", Arrays.asList(coordinatesList));
        return polygonMap;
    }

    /**
     * Map a region
     * @param region
     * @return
     */
    public static Map<String, Object> mapRegion(NotificareRegion region) {
        Map<String, Object> regionMap = new HashMap<>();
        regionMap.put("id", region.getRegionId());
        regionMap.put("regionId", region.getRegionId());
        regionMap.put("regionName", region.getName());
        regionMap.put("regionMajor", region.getMajor());
        if (region.getGeometry() != null) {
            regionMap.put("regionGeometry", mapPoint(region.getGeometry()));
        }
        if (region.getAdvancedGeometry() != null) {
            regionMap.put("regionAdvancedGeometry", mapPolygon(region.getAdvancedGeometry()));
        }
        regionMap.put("regionDistance", region.getDistance());
        regionMap.put("regionTimezone", region.getTimezone());
        return regionMap;
    }

    /**
     * Map a beacon
     * @param beacon
     * @return
     */
    public static Map<String, Object> mapBeacon(NotificareBeacon beacon) {
        Map<String, Object> beaconMap = new HashMap<>();
        beaconMap.put("beaconId", beacon.getBeaconId());
        beaconMap.put("beaconName", beacon.getName());
        beaconMap.put("beaconRegion", beacon.getRegionId());
        beaconMap.put("beaconUUID", Notificare.shared().getApplicationInfo().getRegionConfig().getProximityUUID());
        beaconMap.put("beaconMajor", beacon.getMajor());
        beaconMap.put("beaconMinor", beacon.getMinor());
        beaconMap.put("beaconTriggers", beacon.getTriggers());
        return beaconMap;
    }

    /**
     * Map a pass
     * @param pass
     * @return
     */
    public static Map<String, Object> mapPass(NotificarePass pass) {
        Map<String, Object> passMap = new HashMap<>();
        passMap.put("passbook", pass.getPassbook());
        passMap.put("serial", pass.getSerial());
        if (pass.getRedeem() == NotificarePass.Redeem.ALWAYS) {
            passMap.put("redeem", "always");
        } else if (pass.getRedeem() == NotificarePass.Redeem.LIMIT) {
            passMap.put("redeem", "limit");
        } else if (pass.getRedeem() == NotificarePass.Redeem.ONCE) {
            passMap.put("redeem", "once");
        }
        passMap.put("token", pass.getToken());
        if (pass.getData() != null) {
            try {
                passMap.put("data", mapJSONObject(pass.getData()));
            } catch (JSONException e) {
                // ignore
                passMap.put("data", new HashMap<String, Object>());
            }
        }
        passMap.put("date", ISODateFormatter.format(pass.getDate()));
        passMap.put("limit", pass.getLimit());
        List<Map<String, Object>> redeemHistory = new ArrayList<>();
        for (NotificarePassRedemption redemption : pass.getRedeemHistory()) {
            Map<String, Object> redemptionMap = new HashMap<>();
            redemptionMap.put("comments", redemption.getComments());
            redemptionMap.put("date", ISODateFormatter.format(redemption.getDate()));
            redeemHistory.add(redemptionMap);
        }
        passMap.put("redeemHistory", redeemHistory);
        return passMap;
    }

    /**
     * Map a product
     * @param product
     * @return
     */
    public static Map<String, Object> mapProduct(NotificareProduct product) {
        Map<String, Object> productItemMap = new HashMap<>();
        productItemMap.put("productType", product.getType());
        productItemMap.put("productIdentifier", product.getIdentifier());
        productItemMap.put("productName", product.getName());
        productItemMap.put("productDescription", product.getSkuDetails().getDescription());
        productItemMap.put("productPrice", product.getSkuDetails().getPrice());
        productItemMap.put("productCurrency", product.getSkuDetails().getPriceCurrencyCode());
        productItemMap.put("productDate", ISODateFormatter.format(product.getDate()));
        productItemMap.put("productActive", true);
        return productItemMap;
    }

    /**
     * Map products
     * @param products
     * @return
     */
    public static List<Map<String, Object>> mapProducts(List<NotificareProduct> products) {
        List<Map<String, Object>> productList = new ArrayList<>();
        for (NotificareProduct product : products){
            productList.add(mapProduct(product));
        }
        return productList;
    }

    /**
     * Map inbox item
     * @param notificareInboxItem
     * @return
     */
    public static Map<String, Object> mapInboxItem(NotificareInboxItem notificareInboxItem) {
        Map<String, Object> inboxItemMap = new HashMap<>();
        inboxItemMap.put("inboxId", notificareInboxItem.getItemId());
        inboxItemMap.put("notification", notificareInboxItem.getNotification().getNotificationId());
        inboxItemMap.put("message", notificareInboxItem.getNotification().getMessage());
        inboxItemMap.put("time", ISODateFormatter.format(notificareInboxItem.getTimestamp()));
        inboxItemMap.put("opened", notificareInboxItem.getStatus());
        return inboxItemMap;
    }

    /**
     * Map user
     * @param user
     * @return
     */
    public static Map<String, Object> mapUser(NotificareUser user) {
        Map<String, Object> userMap = new HashMap<>();
        userMap.put("userID", user.getUserId());
        userMap.put("userName", user.getUserName());
        userMap.put("segments", user.getSegments());
        return userMap;
    }

    /**
     * Map user segment
     * @param userSegment
     * @return
     */
    public static Map<String, Object> mapUserSegment(NotificareUserSegment userSegment) {
        Map<String, Object> userSegmentMap = new HashMap<>();
        userSegmentMap.put("segmentId", userSegment.getId());
        userSegmentMap.put("segmentLabel", userSegment.getName());
        return userSegmentMap;
    }

    /**
     * Map user segments
     * @param userSegments
     * @return
     */
    public static List<Map<String, Object>> mapUserSegments(List<NotificareUserSegment> userSegments) {
        List<Map<String, Object>> userSegmentsArray = new ArrayList<>();
        for (NotificareUserSegment userSegment : userSegments) {
            userSegmentsArray.add(mapUserSegment(userSegment));
        }
        return userSegmentsArray;
    }

    /**
     * Create user segment from map
     * @param userSegmentMap
     * @return
     */
    public static NotificareUserSegment createUserSegment(Map<String, Object> userSegmentMap) {
        try {
            JSONObject json = new JSONObject();
            json.put("_id", userSegmentMap.get("segmentId"));
            json.put("name", userSegmentMap.get("segmentLabel"));
            return new NotificareUserSegment(json);
        } catch (JSONException e) {
            return null;
        }
    }

    /**
     * Map user preferences
     * @param userPreference
     * @return
     */
    public static Map<String, Object> mapUserPreference(NotificareUserPreference userPreference) {
        Map<String, Object> userPreferenceMap = new HashMap<>();
        userPreferenceMap.put("preferenceId", userPreference.getId());
        userPreferenceMap.put("preferenceLabel", userPreference.getLabel());
        userPreferenceMap.put("preferenceType", userPreference.getPreferenceType());
        List<Map<String, Object>> options = new ArrayList<>();
        for (NotificareUserPreferenceOption option : userPreference.getPreferenceOptions()) {
            Map<String, Object> optionMap = new HashMap<>();
            optionMap.put("segmentId", option.getUserSegmentId());
            optionMap.put("segmentLabel", option.getLabel());
            optionMap.put("selected", option.isSelected());
            options.add(optionMap);
        }
        userPreferenceMap.put("preferenceOptions", options);
        return userPreferenceMap;
    }

    /**
     * Create user preference from map
     * @param userPreferenceMap
     * @return
     */
    public static NotificareUserPreference createUserPreference(Map<String, Object> userPreferenceMap) {
        try {
            JSONObject json = new JSONObject();
            json.put("_id", userPreferenceMap.get("preferenceId"));
            json.put("label", userPreferenceMap.get("preferenceLabel"));
            json.put("preferenceType", userPreferenceMap.get("preferenceType"));
            return new NotificareUserPreference(json);
        } catch (JSONException e) {
            return null;
        }
    }

    /**
     * Map scannable
     * @param scannable
     * @return
     */
    public static Map<String, Object> mapScannable(NotificareScannable scannable) {
        Map<String, Object> result = new HashMap<>();
        result.put("scannableId", scannable.getScannableId());
        result.put("name", scannable.getName());
        result.put("type", scannable.getType());
        result.put("tag", scannable.getTag());
        try {
            result.put("data", mapJSONObject(scannable.getData()));
        } catch (JSONException e) {
            // ignore the data
            result.put("data", new HashMap<String, Object>());
        }
        result.put("notification", mapNotification(scannable.getNotification()));
        return result;
    }


}
