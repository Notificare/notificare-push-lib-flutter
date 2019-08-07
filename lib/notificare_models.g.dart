// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notificare_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

NotificareApplication _$NotificareApplicationFromJson(
    Map<String, dynamic> json) {
  return NotificareApplication()
    ..id = json['id'] as String
    ..name = json['name'] as String
    ..services = (json['services'] as Map<String, dynamic>)?.map(
      (k, e) => MapEntry(k, e as bool),
    )
    ..inboxConfig = json['inboxConfig'] == null
        ? null
        : NotificareInboxConfig.fromJson(
            json['inboxConfig'] as Map<String, dynamic>)
    ..regionConfig = json['regionConfig'] == null
        ? null
        : NotificareRegionConfig.fromJson(
            json['regionConfig'] as Map<String, dynamic>);
}

Map<String, dynamic> _$NotificareApplicationToJson(
        NotificareApplication instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'services': instance.services,
      'inboxConfig': instance.inboxConfig,
      'regionConfig': instance.regionConfig
    };

NotificareInboxConfig _$NotificareInboxConfigFromJson(
    Map<String, dynamic> json) {
  return NotificareInboxConfig()
    ..autoBadge = json['autoBadge'] as bool
    ..useInbox = json['useInbox'] as bool;
}

Map<String, dynamic> _$NotificareInboxConfigToJson(
        NotificareInboxConfig instance) =>
    <String, dynamic>{
      'autoBadge': instance.autoBadge,
      'useInbox': instance.useInbox
    };

NotificareRegionConfig _$NotificareRegionConfigFromJson(
    Map<String, dynamic> json) {
  return NotificareRegionConfig()
    ..proximityUUID = json['proximityUUID'] as String;
}

Map<String, dynamic> _$NotificareRegionConfigToJson(
        NotificareRegionConfig instance) =>
    <String, dynamic>{'proximityUUID': instance.proximityUUID};

NotificareUserDataFields _$NotificareUserDataFieldsFromJson(
    Map<String, dynamic> json) {
  return NotificareUserDataFields();
}

Map<String, dynamic> _$NotificareUserDataFieldsToJson(
        NotificareUserDataFields instance) =>
    <String, dynamic>{};

NotificareDevice _$NotificareDeviceFromJson(Map<String, dynamic> json) {
  return NotificareDevice()
    ..deviceID = json['deviceID'] as String
    ..userID = json['userID'] as String
    ..userName = json['userName'] as String
    ..timezone = (json['timezone'] as num)?.toDouble()
    ..osVersion = json['osVersion'] as String
    ..sdkVersion = json['sdkVersion'] as String
    ..appVersion = json['appVersion'] as String
    ..countryCode = json['countryCode'] as String
    ..language = json['language'] as String
    ..region = json['region'] as String
    ..transport = json['transport'] as String
    ..latitude = (json['latitude'] as num)?.toDouble()
    ..longitude = (json['longitude'] as num)?.toDouble()
    ..altitude = (json['altitude'] as num)?.toDouble()
    ..speed = (json['speed'] as num)?.toDouble()
    ..course = (json['course'] as num)?.toDouble()
    ..locationServicesAuthStatus = json['locationServicesAuthStatus'] as String
    ..registeredForNotifications = json['registeredForNotifications'] as bool
    ..allowedLocationServices = json['allowedLocationServices'] as bool
    ..allowedUI = json['allowedUI'] as bool
    ..backgroundAppRefresh = json['backgroundAppRefresh'] as bool
    ..bluetoothON = json['bluetoothON'] as bool;
}

Map<String, dynamic> _$NotificareDeviceToJson(NotificareDevice instance) =>
    <String, dynamic>{
      'deviceID': instance.deviceID,
      'userID': instance.userID,
      'userName': instance.userName,
      'timezone': instance.timezone,
      'osVersion': instance.osVersion,
      'sdkVersion': instance.sdkVersion,
      'appVersion': instance.appVersion,
      'countryCode': instance.countryCode,
      'language': instance.language,
      'region': instance.region,
      'transport': instance.transport,
      'latitude': instance.latitude,
      'longitude': instance.longitude,
      'altitude': instance.altitude,
      'speed': instance.speed,
      'course': instance.course,
      'locationServicesAuthStatus': instance.locationServicesAuthStatus,
      'registeredForNotifications': instance.registeredForNotifications,
      'allowedLocationServices': instance.allowedLocationServices,
      'allowedUI': instance.allowedUI,
      'backgroundAppRefresh': instance.backgroundAppRefresh,
      'bluetoothON': instance.bluetoothON
    };

NotificareNotification _$NotificareNotificationFromJson(
    Map<String, dynamic> json) {
  return NotificareNotification()
    ..id = json['id'] as String
    ..inboxItemId = json['inboxItemId'] as String
    ..type = json['type'] as String
    ..time = json['time'] as String
    ..title = json['title'] as String
    ..subtitle = json['subtitle'] as String
    ..message = json['message'] as String
    ..extra = json['extra'] as Map<String, dynamic>
    ..content = (json['content'] as List)
        ?.map((e) => e == null
            ? null
            : NotificareContent.fromJson(e as Map<String, dynamic>))
        ?.toList()
    ..actions = (json['actions'] as List)
        ?.map((e) => e == null
            ? null
            : NotificareAction.fromJson(e as Map<String, dynamic>))
        ?.toList()
    ..attachments = (json['attachments'] as List)
        ?.map((e) => e == null
            ? null
            : NotificareAttachment.fromJson(e as Map<String, dynamic>))
        ?.toList();
}

Map<String, dynamic> _$NotificareNotificationToJson(
        NotificareNotification instance) =>
    <String, dynamic>{
      'id': instance.id,
      'inboxItemId': instance.inboxItemId,
      'type': instance.type,
      'time': instance.time,
      'title': instance.title,
      'subtitle': instance.subtitle,
      'message': instance.message,
      'extra': instance.extra,
      'content': instance.content,
      'actions': instance.actions,
      'attachments': instance.attachments
    };

NotificareContent _$NotificareContentFromJson(Map<String, dynamic> json) {
  return NotificareContent(json['type'] as String, json['data'] as String);
}

Map<String, dynamic> _$NotificareContentToJson(NotificareContent instance) =>
    <String, dynamic>{'type': instance.type, 'data': instance.data};

NotificareAction _$NotificareActionFromJson(Map<String, dynamic> json) {
  return NotificareAction()
    ..label = json['label'] as String
    ..type = json['type'] as String
    ..target = json['target'] as String
    ..camera = json['camera'] as bool
    ..keyboard = json['keyboard'] as bool;
}

Map<String, dynamic> _$NotificareActionToJson(NotificareAction instance) =>
    <String, dynamic>{
      'label': instance.label,
      'type': instance.type,
      'target': instance.target,
      'camera': instance.camera,
      'keyboard': instance.keyboard
    };

NotificareAttachment _$NotificareAttachmentFromJson(Map<String, dynamic> json) {
  return NotificareAttachment(
      json['mimeType'] as String, json['uri'] as String);
}

Map<String, dynamic> _$NotificareAttachmentToJson(
        NotificareAttachment instance) =>
    <String, dynamic>{'mimeType': instance.mimeType, 'uri': instance.uri};

NotificareInboxItem _$NotificareInboxItemFromJson(Map<String, dynamic> json) {
  return NotificareInboxItem(json['inboxId'] as String)
    ..notification = json['notification'] as String
    ..message = json['message'] as String
    ..time = json['time'] as String
    ..opened = json['opened'] as bool;
}

Map<String, dynamic> _$NotificareInboxItemToJson(
        NotificareInboxItem instance) =>
    <String, dynamic>{
      'inboxId': instance.inboxId,
      'notification': instance.notification,
      'message': instance.message,
      'time': instance.time,
      'opened': instance.opened
    };

NotificareUser _$NotificareUserFromJson(Map<String, dynamic> json) {
  return NotificareUser()
    ..userID = json['userID'] as String
    ..userName = json['userName'] as String
    ..segments = (json['segments'] as List)
        ?.map((e) => e == null
            ? null
            : NotificareUserSegment.fromJson(e as Map<String, dynamic>))
        ?.toList();
}

Map<String, dynamic> _$NotificareUserToJson(NotificareUser instance) =>
    <String, dynamic>{
      'userID': instance.userID,
      'userName': instance.userName,
      'segments': instance.segments
    };

NotificareUserSegment _$NotificareUserSegmentFromJson(
    Map<String, dynamic> json) {
  return NotificareUserSegment()
    ..segmentId = json['segmentId'] as String
    ..segmentLabel = json['segmentLabel'] as String;
}

Map<String, dynamic> _$NotificareUserSegmentToJson(
        NotificareUserSegment instance) =>
    <String, dynamic>{
      'segmentId': instance.segmentId,
      'segmentLabel': instance.segmentLabel
    };

NotificareUserData _$NotificareUserDataFromJson(Map<String, dynamic> json) {
  return NotificareUserData()
    ..key = json['key'] as String
    ..label = json['label'] as String
    ..data = json['data'] as String;
}

Map<String, dynamic> _$NotificareUserDataToJson(NotificareUserData instance) =>
    <String, dynamic>{
      'key': instance.key,
      'label': instance.label,
      'data': instance.data
    };

NotificareAsset _$NotificareAssetFromJson(Map<String, dynamic> json) {
  return NotificareAsset()
    ..assetTitle = json['assetTitle'] as String
    ..assetDescription = json['assetDescription'] as String
    ..assetUrl = json['assetUrl'] as String
    ..assetMetaData = json['assetMetaData'] == null
        ? null
        : NotificareAssetMetaData.fromJson(
            json['assetMetaData'] as Map<String, dynamic>)
    ..assetButton = json['assetButton'] == null
        ? null
        : NotificareAssetButton.fromJson(
            json['assetButton'] as Map<String, dynamic>);
}

Map<String, dynamic> _$NotificareAssetToJson(NotificareAsset instance) =>
    <String, dynamic>{
      'assetTitle': instance.assetTitle,
      'assetDescription': instance.assetDescription,
      'assetUrl': instance.assetUrl,
      'assetMetaData': instance.assetMetaData,
      'assetButton': instance.assetButton
    };

NotificareAssetMetaData _$NotificareAssetMetaDataFromJson(
    Map<String, dynamic> json) {
  return NotificareAssetMetaData()
    ..originalFileName = json['originalFileName'] as String
    ..key = json['key'] as String
    ..contentType = json['contentType'] as String
    ..contentLength = json['contentLength'] as String;
}

Map<String, dynamic> _$NotificareAssetMetaDataToJson(
        NotificareAssetMetaData instance) =>
    <String, dynamic>{
      'originalFileName': instance.originalFileName,
      'key': instance.key,
      'contentType': instance.contentType,
      'contentLength': instance.contentLength
    };

NotificareAssetButton _$NotificareAssetButtonFromJson(
    Map<String, dynamic> json) {
  return NotificareAssetButton()
    ..label = json['label'] as String
    ..action = json['action'] as String;
}

Map<String, dynamic> _$NotificareAssetButtonToJson(
        NotificareAssetButton instance) =>
    <String, dynamic>{'label': instance.label, 'action': instance.action};

NotificarePass _$NotificarePassFromJson(Map<String, dynamic> json) {
  return NotificarePass()
    ..passbook = json['passbook'] as String
    ..serial = json['serial'] as String
    ..redeem = json['redeem'] as String
    ..token = json['token'] as String
    ..date = json['date'] as String
    ..limit = json['limit'] as int
    ..data = json['data'] as Map<String, dynamic>
    ..redeemHistory = (json['redeemHistory'] as List)
        ?.map((e) => e == null
            ? null
            : NotificarePassRedemption.fromJson(e as Map<String, dynamic>))
        ?.toList();
}

Map<String, dynamic> _$NotificarePassToJson(NotificarePass instance) =>
    <String, dynamic>{
      'passbook': instance.passbook,
      'serial': instance.serial,
      'redeem': instance.redeem,
      'token': instance.token,
      'date': instance.date,
      'limit': instance.limit,
      'data': instance.data,
      'redeemHistory': instance.redeemHistory
    };

NotificarePassRedemption _$NotificarePassRedemptionFromJson(
    Map<String, dynamic> json) {
  return NotificarePassRedemption()
    ..commments = json['commments'] as String
    ..date = json['date'] as String;
}

Map<String, dynamic> _$NotificarePassRedemptionToJson(
        NotificarePassRedemption instance) =>
    <String, dynamic>{'commments': instance.commments, 'date': instance.date};

NotificareProduct _$NotificareProductFromJson(Map<String, dynamic> json) {
  return NotificareProduct()
    ..productIdentifier = json['productIdentifier'] as String
    ..productType = json['productType'] as String
    ..productName = json['productName'] as String
    ..productDescription = json['productDescription'] as String
    ..productPrice = json['productPrice'] as String
    ..productCurrency = json['productCurrency'] as String
    ..productDate = json['productDate'] as String
    ..productActive = json['productActive'] as bool;
}

Map<String, dynamic> _$NotificareProductToJson(NotificareProduct instance) =>
    <String, dynamic>{
      'productIdentifier': instance.productIdentifier,
      'productType': instance.productType,
      'productName': instance.productName,
      'productDescription': instance.productDescription,
      'productPrice': instance.productPrice,
      'productCurrency': instance.productCurrency,
      'productDate': instance.productDate,
      'productActive': instance.productActive
    };

NotificareScannable _$NotificareScannableFromJson(Map<String, dynamic> json) {
  return NotificareScannable()
    ..scannableId = json['scannableId'] as String
    ..name = json['name'] as String
    ..type = json['type'] as String
    ..tag = json['tag'] as String
    ..data = json['data'] as Map<String, dynamic>
    ..notification = json['notification'] == null
        ? null
        : NotificareNotification.fromJson(
            json['notification'] as Map<String, dynamic>);
}

Map<String, dynamic> _$NotificareScannableToJson(
        NotificareScannable instance) =>
    <String, dynamic>{
      'scannableId': instance.scannableId,
      'name': instance.name,
      'type': instance.type,
      'tag': instance.tag,
      'data': instance.data,
      'notification': instance.notification
    };
