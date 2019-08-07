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


  factory NotificareApplication.fromJson(Map<String, dynamic> json) => _$NotificareApplicationFromJson(json);
  Map<String, dynamic> toJson() => _$NotificareApplicationToJson(this);
}

@JsonSerializable()
class NotificareInboxConfig {
  NotificareInboxConfig();
  bool autoBadge;
  bool useInbox;
  factory NotificareInboxConfig.fromJson(Map<String, dynamic> json) => _$NotificareInboxConfigFromJson(json);
  Map<String, dynamic> toJson() => _$NotificareInboxConfigToJson(this);
}

@JsonSerializable()
class NotificareRegionConfig {
  NotificareRegionConfig();
  String proximityUUID;
  factory NotificareRegionConfig.fromJson(Map<String, dynamic> json) => _$NotificareRegionConfigFromJson(json);
  Map<String, dynamic> toJson() => _$NotificareRegionConfigToJson(this);
}

@JsonSerializable()
class NotificareUserDataFields {
  NotificareUserDataFields();
  factory NotificareUserDataFields.fromJson(Map<String, dynamic> json) => _$NotificareUserDataFieldsFromJson(json);
  Map<String, dynamic> toJson() => _$NotificareUserDataFieldsToJson(this);
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

  factory NotificareDevice.fromJson(Map<String, dynamic> json) => _$NotificareDeviceFromJson(json);
  Map<String, dynamic> toJson() => _$NotificareDeviceToJson(this);
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

  factory NotificareNotification.fromJson(Map<String, dynamic> json) => _$NotificareNotificationFromJson(json);
  Map<String, dynamic> toJson() => _$NotificareNotificationToJson(this);
}

@JsonSerializable()
class NotificareContent {
  NotificareContent(this.type, this.data);

  String type;
  String data;

  factory NotificareContent.fromJson(Map<String, dynamic> json) => _$NotificareContentFromJson(json);
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

  factory NotificareAction.fromJson(Map<String, dynamic> json) => _$NotificareActionFromJson(json);
  Map<String, dynamic> toJson() => _$NotificareActionToJson(this);
}

@JsonSerializable()
class NotificareAttachment {
  NotificareAttachment(this.mimeType, this.uri);
  String mimeType;
  String uri;

  factory NotificareAttachment.fromJson(Map<String, dynamic> json) => _$NotificareAttachmentFromJson(json);
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
  String message;
  String time;
  bool opened;

  factory NotificareInboxItem.fromJson(dynamic json) => _$NotificareInboxItemFromJson(json);
  Map<String, dynamic> toJson() => _$NotificareInboxItemToJson(this);
}

///
/// NotificareUser
///
@JsonSerializable()
class NotificareUser {
  NotificareUser();

  String userID;
  String userName;
  List<NotificareUserSegment> segments;

  factory NotificareUser.fromJson(Map<String, dynamic> json) => _$NotificareUserFromJson(json);
  Map<String, dynamic> toJson() => _$NotificareUserToJson(this);
}

@JsonSerializable()
class NotificareUserSegment {
  NotificareUserSegment();

  String segmentId;
  String segmentLabel;

  factory NotificareUserSegment.fromJson(Map<String, dynamic> json) => _$NotificareUserSegmentFromJson(json);
  Map<String, dynamic> toJson() => _$NotificareUserSegmentToJson(this);
}

@JsonSerializable()
class NotificareUserData {
  NotificareUserData();
  String key;
  String label;
  String data;
  factory NotificareUserData.fromJson(Map<String, dynamic> json) => _$NotificareUserDataFromJson(json);
  Map<String, dynamic> toJson() => _$NotificareUserDataToJson(this);
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
  factory NotificareAsset.fromJson(Map<String, dynamic> json) => _$NotificareAssetFromJson(json);
  Map<String, dynamic> toJson() => _$NotificareAssetToJson(this);
}

@JsonSerializable()
class NotificareAssetMetaData {
  NotificareAssetMetaData();
  String originalFileName;
  String key;
  String contentType;
  String contentLength;
  factory NotificareAssetMetaData.fromJson(Map<String, dynamic> json) => _$NotificareAssetMetaDataFromJson(json);
  Map<String, dynamic> toJson() => _$NotificareAssetMetaDataToJson(this);
}

@JsonSerializable()
class NotificareAssetButton {
  NotificareAssetButton();
  String label;
  String action;
  factory NotificareAssetButton.fromJson(Map<String, dynamic> json) => _$NotificareAssetButtonFromJson(json);
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
  factory NotificarePass.fromJson(Map<String, dynamic> json) => _$NotificarePassFromJson(json);
  Map<String, dynamic> toJson() => _$NotificarePassToJson(this);
}

@JsonSerializable()
class NotificarePassRedemption {
  NotificarePassRedemption();
  String commments;
  String date;
  factory NotificarePassRedemption.fromJson(Map<String, dynamic> json) => _$NotificarePassRedemptionFromJson(json);
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
  factory NotificareProduct.fromJson(Map<String, dynamic> json) => _$NotificareProductFromJson(json);
  Map<String, dynamic> toJson() => _$NotificareProductToJson(this);
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
  factory NotificareScannable.fromJson(Map<String, dynamic> json) => _$NotificareScannableFromJson(json);
  Map<String, dynamic> toJson() => _$NotificareScannableToJson(this);
}