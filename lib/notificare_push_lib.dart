import 'dart:async';
import 'dart:io' show Platform;

import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:notificare_push_lib/notificare_events.dart';
import 'package:notificare_push_lib/notificare_models.dart';

class NotificarePushLib with WidgetsBindingObserver {
  factory NotificarePushLib() {
    if (_instance == null) {
      final MethodChannel methodChannel =
          const MethodChannel('notificare_push_lib', JSONMethodCodec());
      final EventChannel eventChannel =
          const EventChannel('notificare_push_lib/events', JSONMethodCodec());
      _instance = NotificarePushLib._private(methodChannel, eventChannel);
    }
    return _instance!;
  }

  NotificarePushLib._private(this._methodChannel, this._eventChannel);

  static NotificarePushLib? _instance;

  final MethodChannel _methodChannel;
  final EventChannel _eventChannel;
  Stream<NotificareEvent?>? _onEventReceived;

  Future<void> launch() async {
    await _methodChannel.invokeMethod('launch');
  }

  Future<void> unlaunch() async {
    await _methodChannel.invokeMethod('unlaunch');
  }

  Future<void> setAuthorizationOptions(List options) async {
    await _methodChannel
        .invokeMapMethod('setAuthorizationOptions', {'options': options});
  }

  Future<void> setPresentationOptions(List options) async {
    await _methodChannel
        .invokeMapMethod('setPresentationOptions', {'options': options});
  }

  Future<void> setCategoryOptions(List options) async {
    await _methodChannel
        .invokeMapMethod('setCategoryOptions', {'options': options});
  }

  Future<void> registerForNotifications() async {
    await _methodChannel.invokeMethod('registerForNotifications');
  }

  Future<void> unregisterForNotifications() async {
    await _methodChannel.invokeMethod('unregisterForNotifications');
  }

  Future<bool> isRemoteNotificationsEnabled() async {
    var status =
        await _methodChannel.invokeMethod("isRemoteNotificationsEnabled");
    return status as bool;
  }

  Future<bool> isAllowedUIEnabled() async {
    var status = await _methodChannel.invokeMethod("isAllowedUIEnabled");
    return status as bool;
  }

  Future<bool> isNotificationFromNotificare(
      Map<String, dynamic> userInfo) async {
    var status = await _methodChannel.invokeMethod(
        'isNotificationFromNotificare', userInfo);
    return status as bool;
  }

  Future<NotificareNotificationSettings> fetchNotificationSettings() async {
    final json = await _methodChannel
        .invokeMapMethod<String, dynamic>('fetchNotificationSettings');
    return NotificareNotificationSettings.fromJson(json!);
  }

  Future<void> startLocationUpdates() async {
    await _methodChannel.invokeMethod('startLocationUpdates');
  }

  Future<void> stopLocationUpdates() async {
    await _methodChannel.invokeMethod('stopLocationUpdates');
  }

  Future<void> clearLocation() async {
    await _methodChannel.invokeMapMethod('clearLocation');
  }

  Future<void> enableBeacons() async {
    if (Platform.isAndroid) {
      await _methodChannel.invokeMethod('enableBeacons');
    }
  }

  Future<void> disableBeacons() async {
    if (Platform.isAndroid) {
      await _methodChannel.invokeMethod('disableBeacons');
    }
  }

  Future<void> enableBeaconForegroundService() async {
    if (Platform.isAndroid) {
      await _methodChannel.invokeMethod('enableBeaconForegroundService');
    }
  }

  Future<void> disableBeaconForegroundService() async {
    if (Platform.isAndroid) {
      await _methodChannel.invokeMethod('disableBeaconForegroundService');
    }
  }

  Future<void> enableBilling() async {
    if (Platform.isAndroid) {
      await _methodChannel.invokeMethod('enableBilling');
    }
  }

  Future<void> disableBilling() async {
    if (Platform.isAndroid) {
      await _methodChannel.invokeMethod('disableBilling');
    }
  }

  Future<bool> isLocationServicesEnabled() async {
    var status = await _methodChannel.invokeMethod("isLocationServicesEnabled");
    return status as bool;
  }

  Future<NotificareDevice> registerDevice(
      String? userID, String? userName) async {
    if (userID != null && userName != null) {
      final json = await _methodChannel.invokeMapMethod<String, dynamic>(
          'registerDevice', {'userID': userID, 'userName': userName});
      return NotificareDevice.fromJson(json!);
    } else if (userID != null && userName == null) {
      final json = await _methodChannel.invokeMapMethod<String, dynamic>(
          'registerDevice', {'userID': userID});
      return NotificareDevice.fromJson(json!);
    } else {
      final json = await _methodChannel
          .invokeMapMethod<String, dynamic>('registerDevice');
      return NotificareDevice.fromJson(json!);
    }
  }

  Future<NotificareDevice> fetchDevice() async {
    final json =
        await _methodChannel.invokeMapMethod<String, dynamic>('fetchDevice');
    return NotificareDevice.fromJson(json!);
  }

  Future<String?> fetchPreferredLanguage() async {
    var response = await _methodChannel.invokeMethod('fetchPreferredLanguage');
    return response as String?;
  }

  Future<void> updatePreferredLanguage(String? preferredLanguage) async {
    await _methodChannel.invokeMapMethod(
        'updatePreferredLanguage', {'preferredLanguage': preferredLanguage});
  }

  Future<List<String>> fetchTags() async {
    List<String>? response = await _methodChannel.invokeListMethod('fetchTags');
    return response!;
  }

  Future<void> addTag(String tag) async {
    await _methodChannel.invokeMapMethod('addTag', {'tag': tag});
  }

  Future<void> addTags(List tags) async {
    await _methodChannel.invokeMapMethod('addTags', {'tags': tags});
  }

  Future<void> removeTag(String tag) async {
    await _methodChannel.invokeMapMethod('removeTag', {'tag': tag});
  }

  Future<void> removeTags(List tags) async {
    await _methodChannel.invokeMapMethod('removeTags', {'tags': tags});
  }

  Future<void> clearTags() async {
    await _methodChannel.invokeMethod('clearTags');
  }

  Future<List<NotificareUserData>> fetchUserData() async {
    List<dynamic>? response =
        await _methodChannel.invokeListMethod('fetchUserData');
    return response!
        .map((value) => NotificareUserData.fromJson(value))
        .toList();
  }

  Future<void> updateUserData(List<NotificareUserData> userData) async {
    await _methodChannel.invokeMethod('updateUserData', {'userData': userData});
  }

  Future<NotificareDeviceDnD?> fetchDoNotDisturb() async {
    Map<String, dynamic>? json =
        await _methodChannel.invokeMapMethod('fetchDoNotDisturb');
    if (json == null) return null;

    return NotificareDeviceDnD.fromJson(json);
  }

  Future<NotificareDeviceDnD> updateDoNotDisturb(
      NotificareDeviceDnD dnd) async {
    Map<String, dynamic>? json = await _methodChannel
        .invokeMapMethod('updateDoNotDisturb', {'dnd': dnd});
    return NotificareDeviceDnD.fromJson(json!);
  }

  Future<void> clearDoNotDisturb() async {
    await _methodChannel.invokeMapMethod('clearDoNotDisturb');
  }

  Future<NotificareNotification> fetchNotificationForInboxItem(
      NotificareInboxItem inboxItem) async {
    Map<String, dynamic>? json = await _methodChannel.invokeMapMethod(
        'fetchNotificationForInboxItem', {'inboxItem': inboxItem});
    return NotificareNotification.fromJson(json!);
  }

  Future<void> presentNotification(NotificareNotification notification) async {
    await _methodChannel
        .invokeMethod('presentNotification', {'notification': notification});
  }

  Future<List<NotificareInboxItem>> fetchInbox() async {
    List<dynamic>? response =
        await _methodChannel.invokeListMethod('fetchInbox');
    return response!
        .map((value) => NotificareInboxItem.fromJson(value))
        .toList();
  }

  Future<void> presentInboxItem(NotificareInboxItem inboxItem) async {
    await _methodChannel
        .invokeMapMethod('presentInboxItem', {'inboxItem': inboxItem});
  }

  Future<NotificareInboxItem> removeFromInbox(
      NotificareInboxItem inboxItem) async {
    Map<String, dynamic>? json = await _methodChannel
        .invokeMapMethod('removeFromInbox', {'inboxItem': inboxItem});
    return NotificareInboxItem.fromJson(json!);
  }

  Future<NotificareInboxItem> markAsRead(NotificareInboxItem inboxItem) async {
    Map<String, dynamic>? json = await _methodChannel
        .invokeMapMethod('markAsRead', {'inboxItem': inboxItem});
    return NotificareInboxItem.fromJson(json!);
  }

  Future<void> markAllAsRead() async {
    await _methodChannel.invokeMapMethod('markAllAsRead');
  }

  Future<void> clearInbox() async {
    await _methodChannel.invokeMapMethod('clearInbox');
  }

  Future<List<NotificareAsset>> fetchAssets(String group) async {
    List response =
        await (_methodChannel.invokeListMethod('fetchAssets', {'group': group})
            as FutureOr<List<dynamic>>);
    return response.map((value) => NotificareAsset.fromJson(value)).toList();
  }

  Future<NotificarePass> fetchPassWithSerial(String serial) async {
    final json = await _methodChannel.invokeMapMethod<String, dynamic>(
        'fetchPassWithSerial', {'serial': serial});
    return NotificarePass.fromJson(json!);
  }

  Future<NotificarePass> fetchPassWithBarcode(String barcode) async {
    final json = await _methodChannel.invokeMapMethod<String, dynamic>(
        'fetchPassWithBarcode', {'barcode': barcode});
    return NotificarePass.fromJson(json!);
  }

  Future<List<NotificareProduct>> fetchProducts() async {
    List response = await (_methodChannel.invokeListMethod('fetchProducts')
        as FutureOr<List<dynamic>>);
    return response.map((value) => NotificareProduct.fromJson(value)).toList();
  }

  Future<List<NotificareProduct>> fetchPurchasedProducts() async {
    List response = await (_methodChannel
        .invokeListMethod('fetchPurchasedProducts') as FutureOr<List<dynamic>>);
    return response.map((value) => NotificareProduct.fromJson(value)).toList();
  }

  Future<NotificareProduct> fetchProduct(NotificareProduct product) async {
    final json = await _methodChannel
        .invokeMapMethod<String, dynamic>('fetchProduct', {'product': product});
    return NotificareProduct.fromJson(json!);
  }

  Future<void> buyProduct(NotificareProduct product) async {
    await _methodChannel.invokeMethod('buyProduct', {'product': product});
  }

  Future<void> logCustomEvent(String name, Map<String, dynamic> data) async {
    await _methodChannel
        .invokeMapMethod('logCustomEvent', {'name': name, 'data': data});
  }

  Future<void> logOpenNotification(NotificareNotification notification) async {
    await _methodChannel
        .invokeMapMethod('logOpenNotification', {'notification': notification});
  }

  Future<void> logInfluencedNotification(
      NotificareNotification notification) async {
    await _methodChannel.invokeMapMethod(
        'logInfluencedNotification', {'notification': notification});
  }

  Future<void> logReceiveNotification(
      NotificareNotification notification) async {
    await _methodChannel.invokeMapMethod(
        'logReceiveNotification', {'notification': notification});
  }

  Future<Map<String, dynamic>?> doCloudHostOperation(
      String verb,
      String path,
      Map<String, String> params,
      Map<String, String> headers,
      Map<String, dynamic> body) async {
    final response = await _methodChannel.invokeMapMethod(
        'doCloudHostOperation', {
      'verb': verb,
      'path': path,
      'params': params,
      'headers': headers,
      'body': body
    });
    return response?.cast<String, dynamic>();
  }

  Future<void> createAccount(
      String email, String? name, String password) async {
    await _methodChannel.invokeMapMethod(
        'createAccount', {'email': email, 'name': name, 'password': password});
  }

  Future<void> validateAccount(String token) async {
    await _methodChannel.invokeMapMethod('validateAccount', {'token': token});
  }

  Future<void> sendPassword(String email) async {
    await _methodChannel.invokeMapMethod(
      'sendPassword',
      {'email': email},
    );
  }

  Future<void> resetPassword(String password, String token) async {
    await _methodChannel.invokeMapMethod(
        'resetPassword', {'password': password, 'token': token});
  }

  Future<void> login(String email, String password) async {
    await _methodChannel
        .invokeMapMethod('login', {'email': email, 'password': password});
  }

  Future<void> logout() async {
    await _methodChannel.invokeMethod('logout');
  }

  Future<bool> isLoggedIn() async {
    var status = await _methodChannel.invokeMethod("isLoggedIn");
    return status as bool;
  }

  Future<NotificareUser> generateAccessToken() async {
    final Map<String, dynamic>? json =
        await _methodChannel.invokeMapMethod('generateAccessToken');
    return NotificareUser.fromJson(json!);
  }

  Future<void> changePassword(String password) async {
    await _methodChannel
        .invokeMapMethod('changePassword', {'password': password});
  }

  Future<NotificareUser> fetchAccountDetails() async {
    Map<String, dynamic>? json =
        await _methodChannel.invokeMapMethod('fetchAccountDetails');
    return NotificareUser.fromJson(json!);
  }

  Future<List<NotificareUserPreference>> fetchUserPreferences() async {
    List response = await (_methodChannel
        .invokeListMethod('fetchUserPreferences') as FutureOr<List<dynamic>>);
    return response
        .map((value) => NotificareUserPreference.fromJson(value))
        .toList();
  }

  Future<void> addSegmentToUserPreference(NotificareUserSegment segment,
      NotificareUserPreference userPreference) async {
    await _methodChannel.invokeMapMethod('addSegmentToUserPreference',
        {'segment': segment, 'userPreference': userPreference});
  }

  Future<void> removeSegmentFromUserPreference(NotificareUserSegment segment,
      NotificareUserPreference userPreference) async {
    await _methodChannel.invokeMapMethod('removeSegmentFromUserPreference',
        {'segment': segment, 'userPreference': userPreference});
  }

  Future<void> startScannableSession() async {
    await _methodChannel.invokeMethod('startScannableSession');
  }

  Future<void> presentScannable(NotificareScannable scannable) async {
    await _methodChannel
        .invokeMethod('presentScannable', {'scannable': scannable});
  }

  Future<void> requestAlwaysAuthorizationForLocationUpdates() async {
    await _methodChannel
        .invokeMethod('requestAlwaysAuthorizationForLocationUpdates');
  }

  Future<void> requestTemporaryFullAccuracyAuthorization(
      String purposeKey) async {
    await _methodChannel.invokeMethod(
        'requestTemporaryFullAccuracyAuthorization',
        {'purposeKey': purposeKey});
  }

  Future<String?> fetchLink(String url) async {
    return await _methodChannel.invokeMethod('fetchLink', {'url': url});
  }

  Stream<NotificareEvent?> get onEventReceived {
    if (_onEventReceived == null) {
      _onEventReceived =
          _eventChannel.receiveBroadcastStream().map(_toEventMessage);
    }
    return _onEventReceived!;
  }

  NotificareEvent? _toEventMessage(dynamic map) {
    if (map is Map) {
      String eventName = map['event'];
      switch (eventName) {
        case 'ready':
          return new NotificareEvent(
              eventName,
              new NotificareReadyEvent(
                  NotificareApplication.fromJson(map['body'])));
        case 'urlOpened':
          return new NotificareEvent(
              eventName, new NotificareUrlOpenedEvent(map['body']['url']));
        case 'launchUrlReceived':
          return new NotificareEvent(eventName,
              new NotificareLaunchUrlReceivedEvent(map['body']['url']));
        case 'deviceRegistered':
          return new NotificareEvent(
              eventName,
              new NotificareDeviceRegisteredEvent(
                  NotificareDevice.fromJson(map['body'])));
        case 'notificationSettingsChanged':
          return new NotificareEvent(
              eventName,
              new NotificareNotificationSettingsChangedEvent(
                  map['body']['granted']));
        case 'remoteNotificationReceivedInBackground':
          return new NotificareEvent(
              eventName,
              new NotificareRemoteNotificationReceivedInBackgroundEvent(
                  NotificareNotification.fromJson(map['body'])));
        case 'remoteNotificationReceivedInForeground':
          return new NotificareEvent(
              eventName,
              new NotificareRemoteNotificationReceivedInForegroundEvent(
                  NotificareNotification.fromJson(map['body'])));
        case 'systemNotificationReceivedInBackground':
          return new NotificareEvent(
              eventName,
              new NotificareSystemNotificationReceivedInBackgroundEvent(
                  NotificareSystemNotification.fromJson(map['body'])));
        case 'systemNotificationReceivedInForeground':
          return new NotificareEvent(
              eventName,
              new NotificareSystemNotificationReceivedInForegroundEvent(
                  NotificareSystemNotification.fromJson(map['body'])));
        case 'unknownNotificationReceived':
          return new NotificareEvent(eventName,
              new NotificareUnknownNotificationReceivedEvent(map['body']));
        case 'unknownNotificationReceivedInBackground':
          return new NotificareEvent(eventName,
              new NotificareUnknownNotificationReceivedEvent(map['body']));
        case 'unknownNotificationReceivedInForeground':
          return new NotificareEvent(eventName,
              new NotificareUnknownNotificationReceivedEvent(map['body']));
        case 'unknownActionForNotificationReceived':
          return new NotificareEvent(
              eventName,
              new NotificareUnknownActionForNotificationReceivedEvent(
                  map['body']['action'], map['body']['notification']));
        case 'notificationWillOpen':
          return new NotificareEvent(
              eventName,
              new NotificareNotificationWillOpenEvent(
                  NotificareNotification.fromJson(map['body'])));
        case 'notificationOpened':
          return new NotificareEvent(
              eventName,
              new NotificareNotificationOpenedEvent(
                  NotificareNotification.fromJson(map['body'])));
        case 'notificationClosed':
          return new NotificareEvent(
              eventName,
              new NotificareNotificationClosedEvent(
                  NotificareNotification.fromJson(map['body'])));
        case 'notificationFailedToOpen':
          return new NotificareEvent(
              eventName,
              new NotificareNotificationFailedToOpenEvent(
                  NotificareNotification.fromJson(map['body'])));
        case 'urlClickedInNotification':
          return new NotificareEvent(
              eventName,
              new NotificareUrlClickedInNotificationEvent(
                  map['body']['url'],
                  NotificareNotification.fromJson(
                      map['body']['notification'])));
        case 'actionWillExecute':
          return new NotificareEvent(
              eventName,
              new NotificareActionWillExecuteEvent(
                  NotificareAction.fromJson(map['body'])));
        case 'actionExecuted':
          return new NotificareEvent(
              eventName,
              new NotificareActionExecutedEvent(
                  NotificareAction.fromJson(map['body'])));
        case 'shouldPerformSelectorWithUrl':
          return new NotificareEvent(
              eventName,
              new NotificareShouldPerformSelectorWithUrlEvent(
                  map['body']['url'],
                  NotificareAction.fromJson(map['body']['action'])));
        case 'actionNotExecuted':
          return new NotificareEvent(
              eventName,
              new NotificareActionNotExecutedEvent(
                  NotificareAction.fromJson(map['body'])));
        case 'actionFailedToExecute':
          return new NotificareEvent(
              eventName,
              new NotificareActionFailedToExecuteEvent(
                  NotificareAction.fromJson(map['body'])));
        case 'shouldOpenSettings':
          return new NotificareEvent(
              eventName,
              new NotificareShouldOpenSettingsEvent(
                  NotificareNotification.fromJson(map['body'])));
        case 'inboxLoaded':
          List inbox = map['body'] as List;
          return new NotificareEvent(
              eventName,
              new NotificareInboxLoadedEvent(inbox
                  .map((value) => NotificareInboxItem.fromJson(value))
                  .toList()));
        case 'badgeUpdated':
          return new NotificareEvent(
              eventName, new NotificareBadgeUpdatedEvent(map['body']));
        case 'locationServiceAuthorizationStatusReceived':
          return new NotificareEvent(
              eventName,
              new NotificareLocationServiceAuthorizationStatusReceived(
                  map['body']['status']));
        case 'locationServiceAccuracyAuthorizationReceived':
          return new NotificareEvent(
              eventName,
              new NotificareLocationServiceAccuracyAuthorizationReceivedEvent(
                  map['body']['accuracy']));
        case 'locationServiceFailedToStart':
          return new NotificareEvent(eventName,
              new NotificareLocationServiceFailedToStart(map['body']['error']));
        case 'locationsUpdated':
          List locations = map['body'] as List;
          return new NotificareEvent(
              eventName,
              new NotificareLocationsUpdatedEvent(locations
                  .map((value) => NotificareLocation.fromJson(value))
                  .toList()));
        case 'monitoringForRegionStarted':
          if (map['body']['region']['beaconId'] != null) {
            return new NotificareEvent(
                eventName,
                new NotificareMonitoringForRegionStartedEvent(
                    NotificareBeacon.fromJson(map['body']['region'])));
          } else {
            return new NotificareEvent(
                eventName,
                new NotificareMonitoringForRegionStartedEvent(
                    NotificareRegion.fromJson(map['body']['region'])));
          }
        case 'monitoringForRegionFailed':
          if (map['body']['region'] != null) {
            if (map['body']['region']['beaconId'] != null) {
              return new NotificareEvent(
                  eventName,
                  new NotificareMonitoringForRegionFailedEvent(
                      NotificareBeacon.fromJson(map['body']['region']),
                      map['body']['error']));
            } else {
              return new NotificareEvent(
                  eventName,
                  new NotificareMonitoringForRegionFailedEvent(
                      NotificareRegion.fromJson(map['body']['region']),
                      map['body']['error']));
            }
          } else {
            return new NotificareEvent(
                eventName,
                new NotificareMonitoringForRegionFailedEvent(
                    null, map['body']['error']));
          }
        case 'stateForRegionChanged':
          if (map['body']['region']['beaconId'] != null) {
            return new NotificareEvent(
                eventName,
                new NotificareStateForRegionChangedEvent(
                    NotificareBeacon.fromJson(map['body']['region']),
                    map['body']['state']));
          } else {
            return new NotificareEvent(
                eventName,
                new NotificareStateForRegionChangedEvent(
                    NotificareRegion.fromJson(map['body']['region']),
                    map['body']['state']));
          }
        case 'regionEntered':
          if (map['body']['region']['beaconId'] != null) {
            return new NotificareEvent(
                eventName,
                new NotificareRegionEnteredEvent(
                    NotificareBeacon.fromJson(map['body']['region'])));
          } else {
            return new NotificareEvent(
                eventName,
                new NotificareRegionEnteredEvent(
                    NotificareRegion.fromJson(map['body']['region'])));
          }
        case 'regionExited':
          if (map['body']['region']['beaconId'] != null) {
            return new NotificareEvent(
                eventName,
                new NotificareRegionExitedEvent(
                    NotificareBeacon.fromJson(map['body']['region'])));
          } else {
            return new NotificareEvent(
                eventName,
                new NotificareRegionExitedEvent(
                    NotificareRegion.fromJson(map['body']['region'])));
          }
        case 'beaconsInRangeForRegion':
          List beacons = map['body']['beacons'] as List;
          final region = map['body']['region'];
          return new NotificareEvent(
              eventName,
              new NotificareBeaconsInRangeForRegionEvent(
                beacons
                    .map((value) => NotificareBeacon.fromJson(value))
                    .toList(),
                region != null ? NotificareBeacon.fromJson(region) : null,
              ));
        case 'headingUpdated':
          return new NotificareEvent(
              eventName,
              new NotificareHeadingUpdatedEvent(
                  NotificareHeading.fromJson(map['body'])));
        case 'visitReceived':
          return new NotificareEvent(
              eventName,
              new NotificareVisitReceivedEvent(
                  NotificareVisit.fromJson(map['body'])));
        case 'activationTokenReceived':
          return new NotificareEvent(eventName,
              new NotificareActivationTokenReceivedEvent(map['body']['token']));
        case 'resetPasswordTokenReceived':
          return new NotificareEvent(
              eventName,
              new NotificareResetPasswordTokenReceivedEvent(
                  map['body']['token']));
        case 'storeLoaded':
          List products = map['body'] as List;
          return new NotificareEvent(
              eventName,
              new NotificareStoreLoadedEvent(products
                  .map((value) => NotificareProduct.fromJson(value))
                  .toList()));
        case 'storeFailedToLoad':
          return new NotificareEvent(eventName,
              new NotificareStoreFailedToLoadEvent(map['body']['error']));
        case 'productTransactionCompleted':
          return new NotificareEvent(
              eventName,
              new NotificareProductTransactionCompletedEvent(
                  NotificareProduct.fromJson(map['body'])));
        case 'productTransactionRestored':
          return new NotificareEvent(
              eventName,
              new NotificareProductTransactionRestoredEvent(
                  NotificareProduct.fromJson(map['body'])));
        case 'productTransactionFailed':
          return new NotificareEvent(
              eventName,
              new NotificareProductTransactionFailedEvent(map['body']['error'],
                  NotificareProduct.fromJson(map['body'])));
        case 'productContentDownloadStarted':
          return new NotificareEvent(
              eventName,
              new NotificareProductContentDownloadStartedEvent(
                  NotificareProduct.fromJson(map['body'])));
        case 'productContentDownloadPaused':
          return new NotificareEvent(
              eventName,
              new NotificareProductContentDownloadPausedEvent(
                  NotificareDownload.fromJson(map['body']['download']),
                  NotificareProduct.fromJson(map['body']['product'])));
        case 'productContentDownloadCancelled':
          return new NotificareEvent(
              eventName,
              new NotificareProductContentDownloadCancelledEvent(
                  NotificareDownload.fromJson(map['body']['download']),
                  NotificareProduct.fromJson(map['body']['product'])));
        case 'productContentDownloadProgress':
          return new NotificareEvent(
              eventName,
              new NotificareProductContentDownloadProgressEvent(
                  NotificareDownload.fromJson(map['body']['download']),
                  NotificareProduct.fromJson(map['body']['product'])));
        case 'productContentDownloadFailed':
          return new NotificareEvent(
              eventName,
              new NotificareProductContentDownloadFailedEvent(
                  NotificareDownload.fromJson(map['body']['download']),
                  NotificareProduct.fromJson(map['body']['product'])));
        case 'productContentDownloadFinished':
          return new NotificareEvent(
              eventName,
              new NotificareProductContentDownloadFinishedEvent(
                  NotificareDownload.fromJson(map['body']['download']),
                  NotificareProduct.fromJson(map['body']['product'])));
        case 'qrCodeScannerStarted':
          return new NotificareEvent(
              eventName, new NotificareQrCodeScannerStartedEvent());
        case 'scannableDetected':
          return new NotificareEvent(
              eventName,
              new NotificareScannableDetectedEvent(
                  NotificareScannable.fromJson(map['body'])));
        case 'scannableSessionInvalidatedWithError':
          return new NotificareEvent(
              eventName,
              new NotificareScannableSessionInvalidatedWithErrorEvent(
                  map['body']['error']));
        default:
          return new NotificareEvent(eventName, map['body']);
      }
    }
    return null;
  }
}
