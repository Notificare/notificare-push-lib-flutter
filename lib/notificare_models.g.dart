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
      'regionConfig': instance.regionConfig,
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
      'useInbox': instance.useInbox,
    };

NotificareRegionConfig _$NotificareRegionConfigFromJson(
    Map<String, dynamic> json) {
  return NotificareRegionConfig()
    ..proximityUUID = json['proximityUUID'] as String;
}

Map<String, dynamic> _$NotificareRegionConfigToJson(
        NotificareRegionConfig instance) =>
    <String, dynamic>{
      'proximityUUID': instance.proximityUUID,
    };

NotificareUserDataFields _$NotificareUserDataFieldsFromJson(
    Map<String, dynamic> json) {
  return NotificareUserDataFields();
}

Map<String, dynamic> _$NotificareUserDataFieldsToJson(
        NotificareUserDataFields instance) =>
    <String, dynamic>{};

NotificareNotificationSettings _$NotificareNotificationSettingsFromJson(
    Map<String, dynamic> json) {
  return NotificareNotificationSettings()
    ..authorizationStatus = json['authorizationStatus'] as String
    ..alertSetting = json['alertSetting'] as String
    ..badgeSetting = json['badgeSetting'] as String
    ..soundSetting = json['soundSetting'] as String
    ..notificationCenterSetting = json['notificationCenterSetting'] as String
    ..lockScreenSetting = json['lockScreenSetting'] as String
    ..criticalAlertSetting = json['criticalAlertSetting'] as String
    ..alertStyle = json['alertStyle'] as String
    ..showPreviewsSetting = json['showPreviewsSetting'] as String
    ..providesAppNotificationSettings =
        json['providesAppNotificationSettings'] as bool;
}

Map<String, dynamic> _$NotificareNotificationSettingsToJson(
        NotificareNotificationSettings instance) =>
    <String, dynamic>{
      'authorizationStatus': instance.authorizationStatus,
      'alertSetting': instance.alertSetting,
      'badgeSetting': instance.badgeSetting,
      'soundSetting': instance.soundSetting,
      'notificationCenterSetting': instance.notificationCenterSetting,
      'lockScreenSetting': instance.lockScreenSetting,
      'criticalAlertSetting': instance.criticalAlertSetting,
      'alertStyle': instance.alertStyle,
      'showPreviewsSetting': instance.showPreviewsSetting,
      'providesAppNotificationSettings':
          instance.providesAppNotificationSettings,
    };

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
    ..accuracy = (json['accuracy'] as num)?.toDouble()
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
      'accuracy': instance.accuracy,
      'locationServicesAuthStatus': instance.locationServicesAuthStatus,
      'registeredForNotifications': instance.registeredForNotifications,
      'allowedLocationServices': instance.allowedLocationServices,
      'allowedUI': instance.allowedUI,
      'backgroundAppRefresh': instance.backgroundAppRefresh,
      'bluetoothON': instance.bluetoothON,
    };

NotificareDeviceDnD _$NotificareDeviceDnDFromJson(Map<String, dynamic> json) {
  return NotificareDeviceDnD()
    ..start = json['start'] as String
    ..end = json['end'] as String;
}

Map<String, dynamic> _$NotificareDeviceDnDToJson(
        NotificareDeviceDnD instance) =>
    <String, dynamic>{
      'start': instance.start,
      'end': instance.end,
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
      'attachments': instance.attachments,
    };

NotificareSystemNotification _$NotificareSystemNotificationFromJson(
    Map<String, dynamic> json) {
  return NotificareSystemNotification()
    ..notificationID = json['notificationID'] as String
    ..type = json['type'] as String
    ..extra = json['extra'] as Map<String, dynamic>;
}

Map<String, dynamic> _$NotificareSystemNotificationToJson(
        NotificareSystemNotification instance) =>
    <String, dynamic>{
      'notificationID': instance.notificationID,
      'type': instance.type,
      'extra': instance.extra,
    };

NotificareContent _$NotificareContentFromJson(Map<String, dynamic> json) {
  return NotificareContent(
    json['type'] as String,
    json['data'] as String,
  );
}

Map<String, dynamic> _$NotificareContentToJson(NotificareContent instance) =>
    <String, dynamic>{
      'type': instance.type,
      'data': instance.data,
    };

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
      'keyboard': instance.keyboard,
    };

NotificareAttachment _$NotificareAttachmentFromJson(Map<String, dynamic> json) {
  return NotificareAttachment(
    json['mimeType'] as String,
    json['uri'] as String,
  );
}

Map<String, dynamic> _$NotificareAttachmentToJson(
        NotificareAttachment instance) =>
    <String, dynamic>{
      'mimeType': instance.mimeType,
      'uri': instance.uri,
    };

NotificareInboxItem _$NotificareInboxItemFromJson(Map<String, dynamic> json) {
  return NotificareInboxItem(
    json['inboxId'] as String,
  )
    ..notification = json['notification'] as String
    ..type = json['type'] as String
    ..message = json['message'] as String
    ..title = json['title'] as String
    ..subtitle = json['subtitle'] as String
    ..attachment = json['attachment'] == null
        ? null
        : NotificareAttachment.fromJson(
            json['attachment'] as Map<String, dynamic>)
    ..extra = (json['extra'] as Map<String, dynamic>)?.map(
      (k, e) => MapEntry(k, e as String),
    )
    ..time = json['time'] as String
    ..opened = json['opened'] as bool;
}

Map<String, dynamic> _$NotificareInboxItemToJson(
        NotificareInboxItem instance) =>
    <String, dynamic>{
      'inboxId': instance.inboxId,
      'notification': instance.notification,
      'type': instance.type,
      'message': instance.message,
      'title': instance.title,
      'subtitle': instance.subtitle,
      'attachment': instance.attachment,
      'extra': instance.extra,
      'time': instance.time,
      'opened': instance.opened,
    };

NotificareLocation _$NotificareLocationFromJson(Map<String, dynamic> json) {
  return NotificareLocation()
    ..latitude = (json['latitude'] as num)?.toDouble()
    ..longitude = (json['longitude'] as num)?.toDouble()
    ..altitude = (json['altitude'] as num)?.toDouble()
    ..horizontalAccuracy = (json['horizontalAccuracy'] as num)?.toDouble()
    ..verticalAccuracy = (json['verticalAccuracy'] as num)?.toDouble()
    ..floor = json['floor'] as int
    ..speed = (json['speed'] as num)?.toDouble()
    ..course = (json['course'] as num)?.toDouble()
    ..timestamp = json['timestamp'] as String;
}

Map<String, dynamic> _$NotificareLocationToJson(NotificareLocation instance) =>
    <String, dynamic>{
      'latitude': instance.latitude,
      'longitude': instance.longitude,
      'altitude': instance.altitude,
      'horizontalAccuracy': instance.horizontalAccuracy,
      'verticalAccuracy': instance.verticalAccuracy,
      'floor': instance.floor,
      'speed': instance.speed,
      'course': instance.course,
      'timestamp': instance.timestamp,
    };

NotificareBeacon _$NotificareBeaconFromJson(Map<String, dynamic> json) {
  return NotificareBeacon()
    ..beaconId = json['beaconId'] as String
    ..beaconName = json['beaconName'] as String
    ..beaconRegion = json['beaconRegion'] as String
    ..beaconUUID = json['beaconUUID'] as String
    ..beaconMajor = json['beaconMajor'] as int
    ..beaconMinor = json['beaconMinor'] as int
    ..beaconTriggers = json['beaconTriggers'] as bool;
}

Map<String, dynamic> _$NotificareBeaconToJson(NotificareBeacon instance) =>
    <String, dynamic>{
      'beaconId': instance.beaconId,
      'beaconName': instance.beaconName,
      'beaconRegion': instance.beaconRegion,
      'beaconUUID': instance.beaconUUID,
      'beaconMajor': instance.beaconMajor,
      'beaconMinor': instance.beaconMinor,
      'beaconTriggers': instance.beaconTriggers,
    };

NotificareRegion _$NotificareRegionFromJson(Map<String, dynamic> json) {
  return NotificareRegion()
    ..regionId = json['regionId'] as String
    ..regionName = json['regionName'] as String
    ..regionMajor = json['regionMajor'] as int
    ..regionGeometry = json['regionGeometry'] == null
        ? null
        : NotificarePoint.fromJson(
            json['regionGeometry'] as Map<String, dynamic>)
    ..regionAdvancedGeometry = json['regionAdvancedGeometry'] == null
        ? null
        : NotificarePolygon.fromJson(
            json['regionAdvancedGeometry'] as Map<String, dynamic>)
    ..regionDistance = (json['regionDistance'] as num)?.toDouble()
    ..regionTimezone = json['regionTimezone'] as String;
}

Map<String, dynamic> _$NotificareRegionToJson(NotificareRegion instance) =>
    <String, dynamic>{
      'regionId': instance.regionId,
      'regionName': instance.regionName,
      'regionMajor': instance.regionMajor,
      'regionGeometry': instance.regionGeometry,
      'regionAdvancedGeometry': instance.regionAdvancedGeometry,
      'regionDistance': instance.regionDistance,
      'regionTimezone': instance.regionTimezone,
    };

NotificarePolygon _$NotificarePolygonFromJson(Map<String, dynamic> json) {
  return NotificarePolygon()
    ..type = json['type'] as String
    ..coordinates = (json['coordinates'] as List)
        ?.map((e) => (e as List)
            ?.map((e) =>
                (e as List)?.map((e) => (e as num)?.toDouble())?.toList())
            ?.toList())
        ?.toList();
}

Map<String, dynamic> _$NotificarePolygonToJson(NotificarePolygon instance) =>
    <String, dynamic>{
      'type': instance.type,
      'coordinates': instance.coordinates,
    };

NotificarePoint _$NotificarePointFromJson(Map<String, dynamic> json) {
  return NotificarePoint()
    ..type = json['type'] as String
    ..coordinates = (json['coordinates'] as List)
        ?.map((e) => (e as num)?.toDouble())
        ?.toList();
}

Map<String, dynamic> _$NotificarePointToJson(NotificarePoint instance) =>
    <String, dynamic>{
      'type': instance.type,
      'coordinates': instance.coordinates,
    };

NotificareHeading _$NotificareHeadingFromJson(Map<String, dynamic> json) {
  return NotificareHeading()
    ..magneticHeading = (json['magneticHeading'] as num)?.toDouble()
    ..trueHeading = (json['trueHeading'] as num)?.toDouble()
    ..headingAccuracy = (json['headingAccuracy'] as num)?.toDouble()
    ..headingX = (json['headingX'] as num)?.toDouble()
    ..headingY = (json['headingY'] as num)?.toDouble()
    ..headingZ = (json['headingZ'] as num)?.toDouble();
}

Map<String, dynamic> _$NotificareHeadingToJson(NotificareHeading instance) =>
    <String, dynamic>{
      'magneticHeading': instance.magneticHeading,
      'trueHeading': instance.trueHeading,
      'headingAccuracy': instance.headingAccuracy,
      'headingX': instance.headingX,
      'headingY': instance.headingY,
      'headingZ': instance.headingZ,
    };

NotificareVisit _$NotificareVisitFromJson(Map<String, dynamic> json) {
  return NotificareVisit()
    ..latitude = (json['latitude'] as num)?.toDouble()
    ..longitude = (json['longitude'] as num)?.toDouble()
    ..departureDate = json['departureDate'] as String
    ..arrivalDate = json['arrivalDate'] as String;
}

Map<String, dynamic> _$NotificareVisitToJson(NotificareVisit instance) =>
    <String, dynamic>{
      'latitude': instance.latitude,
      'longitude': instance.longitude,
      'departureDate': instance.departureDate,
      'arrivalDate': instance.arrivalDate,
    };

NotificareUser _$NotificareUserFromJson(Map<String, dynamic> json) {
  return NotificareUser()
    ..userID = json['userID'] as String
    ..userName = json['userName'] as String
    ..segments = (json['segments'] as List)?.map((e) => e as String)?.toList()
    ..accessToken = json['accessToken'] as String;
}

Map<String, dynamic> _$NotificareUserToJson(NotificareUser instance) =>
    <String, dynamic>{
      'userID': instance.userID,
      'userName': instance.userName,
      'segments': instance.segments,
      'accessToken': instance.accessToken,
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
      'segmentLabel': instance.segmentLabel,
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
      'data': instance.data,
    };

NotificareUserPreference _$NotificareUserPreferenceFromJson(
    Map<String, dynamic> json) {
  return NotificareUserPreference()
    ..preferenceId = json['preferenceId'] as String
    ..preferenceLabel = json['preferenceLabel'] as String
    ..preferenceType = json['preferenceType'] as String
    ..preferenceOptions = (json['preferenceOptions'] as List)
        ?.map((e) => e == null
            ? null
            : NotificareUserPreferenceOption.fromJson(
                e as Map<String, dynamic>))
        ?.toList();
}

Map<String, dynamic> _$NotificareUserPreferenceToJson(
        NotificareUserPreference instance) =>
    <String, dynamic>{
      'preferenceId': instance.preferenceId,
      'preferenceLabel': instance.preferenceLabel,
      'preferenceType': instance.preferenceType,
      'preferenceOptions': instance.preferenceOptions,
    };

NotificareUserPreferenceOption _$NotificareUserPreferenceOptionFromJson(
    Map<String, dynamic> json) {
  return NotificareUserPreferenceOption()
    ..segmentId = json['segmentId'] as String
    ..segmentLabel = json['segmentLabel'] as String
    ..selected = json['selected'] as bool;
}

Map<String, dynamic> _$NotificareUserPreferenceOptionToJson(
        NotificareUserPreferenceOption instance) =>
    <String, dynamic>{
      'segmentId': instance.segmentId,
      'segmentLabel': instance.segmentLabel,
      'selected': instance.selected,
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
      'assetButton': instance.assetButton,
    };

NotificareAssetMetaData _$NotificareAssetMetaDataFromJson(
    Map<String, dynamic> json) {
  return NotificareAssetMetaData()
    ..originalFileName = json['originalFileName'] as String
    ..key = json['key'] as String
    ..contentType = json['contentType'] as String
    ..contentLength = json['contentLength'] as int;
}

Map<String, dynamic> _$NotificareAssetMetaDataToJson(
        NotificareAssetMetaData instance) =>
    <String, dynamic>{
      'originalFileName': instance.originalFileName,
      'key': instance.key,
      'contentType': instance.contentType,
      'contentLength': instance.contentLength,
    };

NotificareAssetButton _$NotificareAssetButtonFromJson(
    Map<String, dynamic> json) {
  return NotificareAssetButton()
    ..label = json['label'] as String
    ..action = json['action'] as String;
}

Map<String, dynamic> _$NotificareAssetButtonToJson(
        NotificareAssetButton instance) =>
    <String, dynamic>{
      'label': instance.label,
      'action': instance.action,
    };

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
      'redeemHistory': instance.redeemHistory,
    };

NotificarePassRedemption _$NotificarePassRedemptionFromJson(
    Map<String, dynamic> json) {
  return NotificarePassRedemption()
    ..commments = json['commments'] as String
    ..date = json['date'] as String;
}

Map<String, dynamic> _$NotificarePassRedemptionToJson(
        NotificarePassRedemption instance) =>
    <String, dynamic>{
      'commments': instance.commments,
      'date': instance.date,
    };

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
      'productActive': instance.productActive,
    };

NotificareDownload _$NotificareDownloadFromJson(Map<String, dynamic> json) {
  return NotificareDownload()
    ..contentIdentifier = json['contentIdentifier'] as String
    ..contentUrl = json['contentUrl'] as String
    ..contentLength = json['contentLength'] as int
    ..contentVersion = json['contentVersion'] as String
    ..progress = (json['progress'] as num)?.toDouble()
    ..timeRemaining = (json['timeRemaining'] as num)?.toDouble()
    ..downloadState = json['downloadState'] as String;
}

Map<String, dynamic> _$NotificareDownloadToJson(NotificareDownload instance) =>
    <String, dynamic>{
      'contentIdentifier': instance.contentIdentifier,
      'contentUrl': instance.contentUrl,
      'contentLength': instance.contentLength,
      'contentVersion': instance.contentVersion,
      'progress': instance.progress,
      'timeRemaining': instance.timeRemaining,
      'downloadState': instance.downloadState,
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
      'notification': instance.notification,
    };
