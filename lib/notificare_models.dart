import 'package:json_annotation/json_annotation.dart';

part 'notificare_models.g.dart';

///
/// NotificareApplication
///
@JsonSerializable()
class NotificareApplication {
  NotificareApplication();
  String id;
  String name;
  Map<String, bool> services;
  NotificareInboxConfig inboxConfig;
  NotificareRegionConfig regionConfig;

  factory NotificareApplication.fromJson(Map<String, dynamic> json) =>
      _$NotificareApplicationFromJson(json);
  Map<String, dynamic> toJson() => _$NotificareApplicationToJson(this);
}

@JsonSerializable()
class NotificareInboxConfig {
  NotificareInboxConfig();
  bool autoBadge;
  bool useInbox;
  factory NotificareInboxConfig.fromJson(Map<String, dynamic> json) =>
      _$NotificareInboxConfigFromJson(json);
  Map<String, dynamic> toJson() => _$NotificareInboxConfigToJson(this);
}

@JsonSerializable()
class NotificareRegionConfig {
  NotificareRegionConfig();
  String proximityUUID;
  factory NotificareRegionConfig.fromJson(Map<String, dynamic> json) =>
      _$NotificareRegionConfigFromJson(json);
  Map<String, dynamic> toJson() => _$NotificareRegionConfigToJson(this);
}

@JsonSerializable()
class NotificareUserDataFields {
  NotificareUserDataFields();
  factory NotificareUserDataFields.fromJson(Map<String, dynamic> json) =>
      _$NotificareUserDataFieldsFromJson(json);
  Map<String, dynamic> toJson() => _$NotificareUserDataFieldsToJson(this);
}

///
/// NotificareNotificationSettings
///
@JsonSerializable()
class NotificareNotificationSettings {
  NotificareNotificationSettings();
  String authorizationStatus;
  String alertSetting;
  String badgeSetting;
  String soundSetting;
  String notificationCenterSetting;
  String lockScreenSetting;
  String criticalAlertSetting;
  String alertStyle;
  String showPreviewsSetting;
  bool providesAppNotificationSettings;
  factory NotificareNotificationSettings.fromJson(Map<String, dynamic> json) =>
      _$NotificareNotificationSettingsFromJson(json);
  Map<String, dynamic> toJson() => _$NotificareNotificationSettingsToJson(this);
}

///
/// NotificareDevice
///
@JsonSerializable()
class NotificareDevice {
  NotificareDevice();
  String deviceID;
  String userID;
  String userName;
  double timezone;
  String osVersion;
  String sdkVersion;
  String appVersion;
  String countryCode;
  String language;
  String region;
  String transport;
  double latitude;
  double longitude;
  double altitude;
  double speed;
  double course;
  String locationServicesAuthStatus;
  bool registeredForNotifications;
  bool allowedLocationServices;
  bool allowedUI;
  bool backgroundAppRefresh;
  bool bluetoothON;

  factory NotificareDevice.fromJson(Map<String, dynamic> json) =>
      _$NotificareDeviceFromJson(json);
  Map<String, dynamic> toJson() => _$NotificareDeviceToJson(this);
}

///
/// NotificareDeviceDND
///
@JsonSerializable()
class NotificareDeviceDnD {
  NotificareDeviceDnD();
  String start;
  String end;
  factory NotificareDeviceDnD.fromJson(Map<String, dynamic> json) =>
      _$NotificareDeviceDnDFromJson(json);
  Map<String, dynamic> toJson() => _$NotificareDeviceDnDToJson(this);
}

///
/// NotificareNotification / Content / Action / Attachment
///
@JsonSerializable()
class NotificareNotification {
  NotificareNotification();

  String id;
  String inboxItemId;
  String type;
  String time;
  String title;
  String subtitle;
  String message;
  Map<String, dynamic> extra;
  List<NotificareContent> content;
  List<NotificareAction> actions;
  List<NotificareAttachment> attachments;

  factory NotificareNotification.fromJson(Map<String, dynamic> json) =>
      _$NotificareNotificationFromJson(json);
  Map<String, dynamic> toJson() => _$NotificareNotificationToJson(this);
}

@JsonSerializable()
class NotificareSystemNotification {
  NotificareSystemNotification();

  String notificationID;
  String type;
  Map<String, dynamic> extra;

  factory NotificareSystemNotification.fromJson(Map<String, dynamic> json) =>
      _$NotificareSystemNotificationFromJson(json);
  Map<String, dynamic> toJson() => _$NotificareSystemNotificationToJson(this);
}

@JsonSerializable()
class NotificareContent {
  NotificareContent(this.type, this.data);

  String type;
  String data;

  factory NotificareContent.fromJson(Map<String, dynamic> json) =>
      _$NotificareContentFromJson(json);
  Map<String, dynamic> toJson() => _$NotificareContentToJson(this);
}

@JsonSerializable()
class NotificareAction {
  NotificareAction();

  String label;
  String type;
  String target;
  bool camera;
  bool keyboard;

  factory NotificareAction.fromJson(Map<String, dynamic> json) =>
      _$NotificareActionFromJson(json);
  Map<String, dynamic> toJson() => _$NotificareActionToJson(this);
}

@JsonSerializable()
class NotificareAttachment {
  NotificareAttachment(this.mimeType, this.uri);
  String mimeType;
  String uri;

  factory NotificareAttachment.fromJson(Map<String, dynamic> json) =>
      _$NotificareAttachmentFromJson(json);
  Map<String, dynamic> toJson() => _$NotificareAttachmentToJson(this);
}

///
/// NotificareInboxItem
///
@JsonSerializable()
class NotificareInboxItem {
  NotificareInboxItem(this.inboxId);

  String inboxId;
  String notification;
  String type;
  String message;
  String title;
  String subtitle;
  NotificareAttachment attachment;
  Map<String, String> extra;
  String time;
  bool opened;

  factory NotificareInboxItem.fromJson(Map<String, dynamic> json) =>
      _$NotificareInboxItemFromJson(json);
  Map<String, dynamic> toJson() => _$NotificareInboxItemToJson(this);
}

///
/// NotificareLocation / Region / Beacon / Heading / Visit
///
@JsonSerializable()
class NotificareLocation {
  NotificareLocation();
  double latitude;
  double longitude;
  double altitude;
  double horizontalAccuracy;
  double verticalAccuracy;
  int floor;
  double speed;
  double course;
  String timestamp;
  factory NotificareLocation.fromJson(Map<String, dynamic> json) =>
      _$NotificareLocationFromJson(json);
  Map<String, dynamic> toJson() => _$NotificareLocationToJson(this);
}

@JsonSerializable()
class NotificareBeacon {
  NotificareBeacon();
  String beaconId;
  String beaconName;
  String beaconRegion;
  String beaconUUID;
  int beaconMajor;
  int beaconMinor;
  bool beaconTriggers;
  factory NotificareBeacon.fromJson(Map<String, dynamic> json) =>
      _$NotificareBeaconFromJson(json);
  Map<String, dynamic> toJson() => _$NotificareBeaconToJson(this);
}

@JsonSerializable()
class NotificareRegion {
  NotificareRegion();
  String regionId;
  String regionName;
  int regionMajor;
  NotificarePoint regionGeometry;
  NotificarePolygon regionAdvancedGeometry;
  double regionDistance;
  String regionTimezone;
  factory NotificareRegion.fromJson(Map<String, dynamic> json) =>
      _$NotificareRegionFromJson(json);
  Map<String, dynamic> toJson() => _$NotificareRegionToJson(this);
}

@JsonSerializable()
class NotificarePolygon {
  NotificarePolygon();
  String type;
  List<List<List<double>>> coordinates;
  factory NotificarePolygon.fromJson(Map<String, dynamic> json) =>
      _$NotificarePolygonFromJson(json);
  Map<String, dynamic> toJson() => _$NotificarePolygonToJson(this);
}

@JsonSerializable()
class NotificarePoint {
  NotificarePoint();
  String type;
  List<double> coordinates;
  factory NotificarePoint.fromJson(Map<String, dynamic> json) =>
      _$NotificarePointFromJson(json);
  Map<String, dynamic> toJson() => _$NotificarePointToJson(this);
}

@JsonSerializable()
class NotificareHeading {
  NotificareHeading();
  double magneticHeading;
  double trueHeading;
  double headingAccuracy;
  double headingX;
  double headingY;
  double headingZ;
  factory NotificareHeading.fromJson(Map<String, dynamic> json) =>
      _$NotificareHeadingFromJson(json);
  Map<String, dynamic> toJson() => _$NotificareHeadingToJson(this);
}

@JsonSerializable()
class NotificareVisit {
  NotificareVisit();
  double latitude;
  double longitude;
  String departureDate;
  String arrivalDate;
  factory NotificareVisit.fromJson(Map<String, dynamic> json) =>
      _$NotificareVisitFromJson(json);
  Map<String, dynamic> toJson() => _$NotificareVisitToJson(this);
}

///
/// NotificareUser
///
@JsonSerializable()
class NotificareUser {
  NotificareUser();

  String userID;
  String userName;
  List<String> segments;
  String accessToken;

  factory NotificareUser.fromJson(Map<String, dynamic> json) =>
      _$NotificareUserFromJson(json);
  Map<String, dynamic> toJson() => _$NotificareUserToJson(this);
}

@JsonSerializable()
class NotificareUserSegment {
  NotificareUserSegment();

  String segmentId;
  String segmentLabel;

  factory NotificareUserSegment.fromJson(Map<String, dynamic> json) =>
      _$NotificareUserSegmentFromJson(json);
  Map<String, dynamic> toJson() => _$NotificareUserSegmentToJson(this);
}

@JsonSerializable()
class NotificareUserData {
  NotificareUserData();
  String key;
  String label;
  String data;
  factory NotificareUserData.fromJson(Map<String, dynamic> json) =>
      _$NotificareUserDataFromJson(json);
  Map<String, dynamic> toJson() => _$NotificareUserDataToJson(this);
}

@JsonSerializable()
class NotificareUserPreference {
  NotificareUserPreference();
  String preferenceId;
  String preferenceLabel;
  String preferenceType;
  List<NotificareUserPreferenceOption> preferenceOptions;
  factory NotificareUserPreference.fromJson(Map<String, dynamic> json) =>
      _$NotificareUserPreferenceFromJson(json);
  Map<String, dynamic> toJson() => _$NotificareUserPreferenceToJson(this);
}

@JsonSerializable()
class NotificareUserPreferenceOption {
  NotificareUserPreferenceOption();
  String segmentId;
  String segmentLabel;
  bool selected;
  factory NotificareUserPreferenceOption.fromJson(Map<String, dynamic> json) =>
      _$NotificareUserPreferenceOptionFromJson(json);
  Map<String, dynamic> toJson() => _$NotificareUserPreferenceOptionToJson(this);
}

///
/// NotificareAsset
///
@JsonSerializable()
class NotificareAsset {
  NotificareAsset();
  String assetTitle;
  String assetDescription;
  String assetUrl;
  NotificareAssetMetaData assetMetaData;
  NotificareAssetButton assetButton;
  factory NotificareAsset.fromJson(Map<String, dynamic> json) =>
      _$NotificareAssetFromJson(json);
  Map<String, dynamic> toJson() => _$NotificareAssetToJson(this);
}

@JsonSerializable()
class NotificareAssetMetaData {
  NotificareAssetMetaData();
  String originalFileName;
  String key;
  String contentType;
  int contentLength;
  factory NotificareAssetMetaData.fromJson(Map<String, dynamic> json) =>
      _$NotificareAssetMetaDataFromJson(json);
  Map<String, dynamic> toJson() => _$NotificareAssetMetaDataToJson(this);
}

@JsonSerializable()
class NotificareAssetButton {
  NotificareAssetButton();
  String label;
  String action;
  factory NotificareAssetButton.fromJson(Map<String, dynamic> json) =>
      _$NotificareAssetButtonFromJson(json);
  Map<String, dynamic> toJson() => _$NotificareAssetButtonToJson(this);
}

///
/// NotificarePass
///
@JsonSerializable()
class NotificarePass {
  NotificarePass();
  String passbook;
  String serial;
  String redeem;
  String token;
  String date;
  int limit;
  Map<String, dynamic> data;
  List<NotificarePassRedemption> redeemHistory;
  factory NotificarePass.fromJson(Map<String, dynamic> json) =>
      _$NotificarePassFromJson(json);
  Map<String, dynamic> toJson() => _$NotificarePassToJson(this);
}

@JsonSerializable()
class NotificarePassRedemption {
  NotificarePassRedemption();
  String commments;
  String date;
  factory NotificarePassRedemption.fromJson(Map<String, dynamic> json) =>
      _$NotificarePassRedemptionFromJson(json);
  Map<String, dynamic> toJson() => _$NotificarePassRedemptionToJson(this);
}

///
/// NotificareProduct
///
@JsonSerializable()
class NotificareProduct {
  NotificareProduct();
  String productIdentifier;
  String productType;
  String productName;
  String productDescription;
  String productPrice;
  String productCurrency;
  String productDate;
  bool productActive;
  factory NotificareProduct.fromJson(Map<String, dynamic> json) =>
      _$NotificareProductFromJson(json);
  Map<String, dynamic> toJson() => _$NotificareProductToJson(this);
}

@JsonSerializable()
class NotificareDownload {
  NotificareDownload();
  String contentIdentifier;
  String contentUrl;
  int contentLength;
  String contentVersion;
  double progress;
  double timeRemaining;
  String downloadState;
  factory NotificareDownload.fromJson(Map<String, dynamic> json) =>
      _$NotificareDownloadFromJson(json);
  Map<String, dynamic> toJson() => _$NotificareDownloadToJson(this);
}

///
/// NotificareScannable
///
@JsonSerializable()
class NotificareScannable {
  NotificareScannable();
  String scannableId;
  String name;
  String type;
  String tag;
  Map<String, dynamic> data;
  NotificareNotification notification;
  factory NotificareScannable.fromJson(Map<String, dynamic> json) =>
      _$NotificareScannableFromJson(json);
  Map<String, dynamic> toJson() => _$NotificareScannableToJson(this);
}
