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
      SystemChannels.lifecycle.setMessageHandler((message) async {
        await methodChannel
            .invokeMethod('didChangeAppLifecycleState', {'message': message});
        return null;
      });
      _instance = NotificarePushLib._private(methodChannel, eventChannel);
    }
    return _instance;
  }

  NotificarePushLib._private(this._methodChannel, this._eventChannel);

  static NotificarePushLib _instance;

  final MethodChannel _methodChannel;
  final EventChannel _eventChannel;
  Stream<NotificareEvent> _onEventReceived;

  Future<void> launch() async {
    await _methodChannel.invokeMethod('launch');
  }

  Future<void> unlaunch() async {
    await _methodChannel.invokeMethod('unlaunch');
  }

  Future<void> setAuthorizationOptions(List options) async {
    await _methodChannel.invokeMapMethod('setAuthorizationOptions', {'options': options});
  }

  Future<void> setPresentationOptions(List options) async {
    await _methodChannel.invokeMapMethod('setPresentationOptions', {'options': options});
  }

  Future<void> setCategoryOptions(List options) async {
    await _methodChannel.invokeMapMethod('setCategoryOptions', {'options': options});
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
    return NotificareNotificationSettings.fromJson(
        await _methodChannel.invokeMapMethod('fetchNotificationSettings'));
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
      String userID, String userName) async {
    if (userID != null && userName != null) {
      return NotificareDevice.fromJson(await _methodChannel.invokeMapMethod(
          'registerDevice', {'userID': userID, 'userName': userName}));
    } else if (userID != null && userName == null) {
      return NotificareDevice.fromJson(await _methodChannel
          .invokeMapMethod('registerDevice', {'userID': userID}));
    } else {
      return NotificareDevice.fromJson(
          await _methodChannel.invokeMapMethod('registerDevice'));
    }
  }

  Future<NotificareDevice> fetchDevice() async {
    return NotificareDevice.fromJson(
        await _methodChannel.invokeMapMethod('fetchDevice'));
  }

  Future<String> fetchPreferredLanguage() async {
    var response = await _methodChannel.invokeMethod('fetchPreferredLanguage');
    return response as String;
  }

  Future<void> updatePreferredLanguage(String preferredLanguage) async {
    if (preferredLanguage != null) {
      await _methodChannel.invokeMapMethod(
          'updatePreferredLanguage', {'preferredLanguage': preferredLanguage});
    } else {
      await _methodChannel.invokeMethod('updatePreferredLanguage');
    }
  }

  Future<List> fetchTags() async {
    List response = await _methodChannel.invokeListMethod('fetchTags');
    return response;
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
    List response = await _methodChannel.invokeListMethod('fetchUserData');
    return response.map((value) => NotificareUserData.fromJson(value)).toList();
  }

  Future<List> updateUserData(List userData) async {
    List response = await _methodChannel
        .invokeListMethod('updateUserData', {'userData': userData});
    return response;
  }

  Future<NotificareDeviceDnD> fetchDoNotDisturb() async {
    return NotificareDeviceDnD.fromJson(
        await _methodChannel.invokeMapMethod('fetchDoNotDisturb'));
  }

  Future<NotificareDeviceDnD> updateDoNotDisturb(
      NotificareDeviceDnD dnd) async {
    return NotificareDeviceDnD.fromJson(await _methodChannel
        .invokeMapMethod('updateDoNotDisturb', {'dnd': dnd}));
  }

  Future<void> clearDoNotDisturb() async {
    await _methodChannel.invokeMapMethod('clearDoNotDisturb');
  }

  Future<NotificareNotification> fetchNotificationForInboxItem(
      NotificareInboxItem inboxItem) async {
    return NotificareNotification.fromJson(await _methodChannel.invokeMapMethod(
        'fetchNotificationForInboxItem', {'inboxItem': inboxItem}));
  }

  Future<void> presentNotification(NotificareNotification notification) async {
    await _methodChannel
        .invokeMethod('presentNotification', {'notification': notification});
  }

  Future<List<NotificareInboxItem>> fetchInbox() async {
    List response = await _methodChannel.invokeListMethod('fetchInbox');
    return response
        .map((value) => NotificareInboxItem.fromJson(value))
        .toList();
  }

  Future<void> presentInboxItem(NotificareInboxItem inboxItem) async {
    return await _methodChannel
        .invokeMapMethod('presentInboxItem', {'inboxItem': inboxItem});
  }

  Future<NotificareInboxItem> removeFromInbox(NotificareInboxItem inboxItem) async {
    return NotificareInboxItem.fromJson(await _methodChannel
        .invokeMapMethod('removeFromInbox', {'inboxItem': inboxItem}));
  }

  Future<NotificareInboxItem> markAsRead(NotificareInboxItem inboxItem) async {
    return NotificareInboxItem.fromJson(await _methodChannel
        .invokeMapMethod('markAsRead', {'inboxItem': inboxItem}));
  }

  Future<void> markAllAsRead() async {
    return await _methodChannel.invokeMapMethod('markAllAsRead');
  }

  Future<void> clearInbox() async {
    return await _methodChannel.invokeMapMethod('clearInbox');
  }

  Future<List<NotificareAsset>> fetchAssets(String group) async {
    List response =
        await _methodChannel.invokeListMethod('fetchAssets', {'group': group});
    return response.map((value) => NotificareAsset.fromJson(value)).toList();
  }

  Future<NotificarePass> fetchPassWithSerial(String serial) async {
    return NotificarePass.fromJson(await _methodChannel
        .invokeMapMethod('fetchPassWithSerial', {'serial': serial}));
  }

  Future<NotificarePass> fetchPassWithBarcode(String barcode) async {
    return NotificarePass.fromJson(await _methodChannel
        .invokeMapMethod('fetchPassWithBarcode', {'barcode': barcode}));
  }

  Future<List<NotificareProduct>> fetchProducts() async {
    List response = await _methodChannel.invokeListMethod('fetchProducts');
    return response.map((value) => NotificareProduct.fromJson(value)).toList();
  }

  Future<List<NotificareProduct>> fetchPurchasedProducts() async {
    List response =
        await _methodChannel.invokeListMethod('fetchPurchasedProducts');
    return response.map((value) => NotificareProduct.fromJson(value)).toList();
  }

  Future<NotificareProduct> fetchProduct(NotificareProduct product) async {
    return NotificareProduct.fromJson(await _methodChannel
        .invokeMapMethod('fetchProduct', {'product': product}));
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

  Future<Map<String, dynamic>> doCloudHostOperation(
      String verb,
      String path,
      Map<String, String> params,
      Map<String, String> headers,
      Map<String, dynamic> body) async {
    Map<String, dynamic> response = await _methodChannel.invokeMapMethod(
        'doCloudHostOperation', {
      'verb': verb,
      'path': path,
      'params': params,
      'headers': headers,
      'body': body
    });
    return response.cast<String, dynamic>();
  }

  Future<void> createAccount(String email, String name, String password) async {
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
    return new NotificareUser.fromJson(
        await _methodChannel.invokeMapMethod('generateAccessToken'));
  }

  Future<void> changePassword(String password) async {
    return await _methodChannel
        .invokeMapMethod('changePassword', {'password': password});
  }

  Future<NotificareUser> fetchAccountDetails() async {
    return new NotificareUser.fromJson(
        await _methodChannel.invokeMapMethod('fetchAccountDetails'));
  }

  Future<List<NotificareUserPreference>> fetchUserPreferences() async {
    List response =
        await _methodChannel.invokeListMethod('fetchUserPreferences');
    return response
        .map((value) => NotificareUserPreference.fromJson(value))
        .toList();
  }

  Future<void> addSegmentToUserPreference(NotificareUserSegment segment,
      NotificareUserPreference userPreference) async {
    return await _methodChannel.invokeMapMethod('addSegmentToUserPreference',
        {'segment': segment, 'userPreference': userPreference});
  }

  Future<void> removeSegmentFromUserPreference(NotificareUserSegment segment,
      NotificareUserPreference userPreference) async {
    return await _methodChannel.invokeMapMethod(
        'removeSegmentFromUserPreference',
        {'segment': segment, 'userPreference': userPreference});
  }

  Future<void> startScannableSession() async {
    await _methodChannel.invokeMethod('startScannableSession');
  }

  Future<void> presentScannable(NotificareScannable scannable) async {
    await _methodChannel
        .invokeMethod('presentScannable', {'scannable': scannable});
  }

  Stream<NotificareEvent> get onEventReceived {
    if (_onEventReceived == null) {
      _onEventReceived =
          _eventChannel.receiveBroadcastStream().map(_toEventMessage);
    }
    return _onEventReceived;
  }

  NotificareEvent _toEventMessage(dynamic map) {
    if (map is Map) {
      String eventName = map['event'];
      switch (eventName) {
        case 'ready':
          return new NotificareEvent(
              eventName,
              new NotificareReadyEvent(
                  NotificareApplication.fromJson(map['body'])));
          break;
        case 'urlOpened':
          return new NotificareEvent(
              eventName, new NotificareUrlOpenedEvent(map['body']['url']));
          break;
        case 'launchUrlReceived':
          return new NotificareEvent(eventName,
              new NotificareLaunchUrlReceivedEvent(map['body']['url']));
          break;
        case 'deviceRegistered':
          return new NotificareEvent(
              eventName,
              new NotificareDeviceRegisteredEvent(
                  NotificareDevice.fromJson(map['body'])));
          break;
        case 'notificationSettingsChanged':
          return new NotificareEvent(
              eventName,
              new NotificareNotificationSettingsChangedEvent(
                  map['body']['granted']));
          break;
        case 'remoteNotificationReceivedInBackground':
          return new NotificareEvent(
              eventName,
              new NotificareRemoteNotificationReceivedInBackgroundEvent(
                  NotificareNotification.fromJson(map['body'])));
          break;
        case 'remoteNotificationReceivedInForeground':
          return new NotificareEvent(
              eventName,
              new NotificareRemoteNotificationReceivedInForegroundEvent(
                  NotificareNotification.fromJson(map['body'])));
          break;
        case 'systemNotificationReceivedInBackground':
          return new NotificareEvent(
              eventName,
              new NotificareSystemNotificationReceivedInBackgroundEvent(
                  NotificareSystemNotification.fromJson(map['body'])));
          break;
        case 'systemNotificationReceivedInForeground':
          return new NotificareEvent(
              eventName,
              new NotificareSystemNotificationReceivedInForegroundEvent(
                  NotificareSystemNotification.fromJson(map['body'])));
          break;
        case 'unknownNotificationReceived':
          return new NotificareEvent(eventName,
              new NotificareUnknownNotificationReceivedEvent(map['body']));
          break;
        case 'unknownActionForNotificationReceived':
          return new NotificareEvent(
              eventName,
              new NotificareUnknownActionForNotificationReceivedEvent(
                  map['body']['action'], map['body']['notification']));
          break;
        case 'notificationWillOpen':
          return new NotificareEvent(
              eventName,
              new NotificareNotificationWillOpenEvent(
                  NotificareNotification.fromJson(map['body'])));
          break;
        case 'notificationOpened':
          return new NotificareEvent(
              eventName,
              new NotificareNotificationOpenedEvent(
                  NotificareNotification.fromJson(map['body'])));
          break;
        case 'notificationClosed':
          return new NotificareEvent(
              eventName,
              new NotificareNotificationClosedEvent(
                  NotificareNotification.fromJson(map['body'])));
          break;
        case 'notificationFailedToOpen':
          return new NotificareEvent(
              eventName,
              new NotificareNotificationFailedToOpenEvent(
                  NotificareNotification.fromJson(map['body'])));
          break;
        case 'urlClickedInNotification':
          return new NotificareEvent(
              eventName,
              new NotificareUrlClickedInNotificationEvent(
                  map['body']['url'],
                  NotificareNotification.fromJson(
                      map['body']['notification'])));
          break;
        case 'actionWillExecute':
          return new NotificareEvent(
              eventName,
              new NotificareActionWillExecuteEvent(
                  NotificareAction.fromJson(map['body'])));
          break;
        case 'actionExecuted':
          return new NotificareEvent(
              eventName,
              new NotificareActionExecutedEvent(
                  NotificareAction.fromJson(map['body'])));
          break;
        case 'shouldPerformSelectorWithUrl':
          return new NotificareEvent(
              eventName,
              new NotificareShouldPerformSelectorWithUrlEvent(
                  map['body']['url'],
                  NotificareAction.fromJson(map['body']['action'])));
          break;
        case 'actionNotExecuted':
          return new NotificareEvent(
              eventName,
              new NotificareActionNotExecutedEvent(
                  NotificareAction.fromJson(map['body'])));
          break;
        case 'actionFailedToExecute':
          return new NotificareEvent(
              eventName,
              new NotificareActionFailedToExecuteEvent(
                  NotificareAction.fromJson(map['body'])));
          break;
        case 'shouldOpenSettings':
          return new NotificareEvent(
              eventName,
              new NotificareShouldOpenSettingsEvent(
                  NotificareNotification.fromJson(map['body'])));
          break;
        case 'inboxLoaded':
          List inbox = map['body'] as List;
          return new NotificareEvent(
              eventName,
              new NotificareInboxLoadedEvent(inbox
                  .map((value) => NotificareInboxItem.fromJson(value))
                  .toList()));
          break;
        case 'badgeUpdated':
          return new NotificareEvent(
              eventName, new NotificareBadgeUpdatedEvent(map['body']));
          break;
        case 'locationServiceAuthorizationStatusReceived':
          return new NotificareEvent(
              eventName,
              new NotificareLocationServiceAuthorizationStatusReceived(
                  map['body']['status']));
          break;
        case 'locationServiceFailedToStart':
          return new NotificareEvent(eventName,
              new NotificareLocationServiceFailedToStart(map['body']['error']));
          break;
        case 'locationsUpdated':
          List locations = map['body'] as List;
          return new NotificareEvent(
              eventName,
              new NotificareLocationsUpdatedEvent(locations
                  .map((value) => NotificareLocation.fromJson(value))
                  .toList()));
          break;
        case 'monitoringForRegionStarted':
          if (map['body']['region']['beaconId'] != null) {
            return new NotificareEvent(eventName,
                new NotificareMonitoringForRegionStartedEvent(
                    NotificareBeacon.fromJson(map['body']['region'])));
          } else {
            return new NotificareEvent(eventName,
                new NotificareMonitoringForRegionStartedEvent(
                    NotificareRegion.fromJson(map['body']['region'])));
          }
          break;
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
                    null,
                    map['body']['error']));
          }
          break;
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
          break;
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
          break;
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
          break;
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
          break;
        case 'headingUpdated':
          return new NotificareEvent(
              eventName,
              new NotificareHeadingUpdatedEvent(
                  NotificareHeading.fromJson(map['body'])));
          break;
        case 'visitReceived':
          return new NotificareEvent(
              eventName,
              new NotificareVisitReceivedEvent(
                  NotificareVisit.fromJson(map['body'])));
          break;
        case 'activationTokenReceived':
          return new NotificareEvent(eventName,
              new NotificareActivationTokenReceivedEvent(map['body']['token']));
          break;
        case 'resetPasswordTokenReceived':
          return new NotificareEvent(
              eventName,
              new NotificareResetPasswordTokenReceivedEvent(
                  map['body']['token']));
          break;
        case 'storeLoaded':
          List products = map['body'] as List;
          return new NotificareEvent(
              eventName,
              new NotificareStoreLoadedEvent(products
                  .map((value) => NotificareProduct.fromJson(value))
                  .toList()));
          break;
        case 'storeFailedToLoad':
          return new NotificareEvent(eventName,
              new NotificareStoreFailedToLoadEvent(map['body']['error']));
          break;
        case 'productTransactionCompleted':
          return new NotificareEvent(
              eventName,
              new NotificareProductTransactionCompletedEvent(
                  NotificareProduct.fromJson(map['body'])));
          break;
        case 'productTransactionRestored':
          return new NotificareEvent(
              eventName,
              new NotificareProductTransactionRestoredEvent(
                  NotificareProduct.fromJson(map['body'])));
          break;
        case 'productTransactionFailed':
          return new NotificareEvent(
              eventName,
              new NotificareProductTransactionFailedEvent(map['body']['error'],
                  NotificareProduct.fromJson(map['body'])));
          break;
        case 'productContentDownloadStarted':
          return new NotificareEvent(
              eventName,
              new NotificareProductContentDownloadStartedEvent(
                  NotificareProduct.fromJson(map['body'])));
          break;
        case 'productContentDownloadPaused':
          return new NotificareEvent(
              eventName,
              new NotificareProductContentDownloadPausedEvent(
                  NotificareDownload.fromJson(map['body']['download']),
                  NotificareProduct.fromJson(map['body']['product'])));
          break;
        case 'productContentDownloadCancelled':
          return new NotificareEvent(
              eventName,
              new NotificareProductContentDownloadCancelledEvent(
                  NotificareDownload.fromJson(map['body']['download']),
                  NotificareProduct.fromJson(map['body']['product'])));
          break;
        case 'productContentDownloadProgress':
          return new NotificareEvent(
              eventName,
              new NotificareProductContentDownloadProgressEvent(
                  NotificareDownload.fromJson(map['body']['download']),
                  NotificareProduct.fromJson(map['body']['product'])));
          break;
        case 'productContentDownloadFailed':
          return new NotificareEvent(
              eventName,
              new NotificareProductContentDownloadFailedEvent(
                  NotificareDownload.fromJson(map['body']['download']),
                  NotificareProduct.fromJson(map['body']['product'])));
          break;
        case 'productContentDownloadFinished':
          return new NotificareEvent(
              eventName,
              new NotificareProductContentDownloadFinishedEvent(
                  NotificareDownload.fromJson(map['body']['download']),
                  NotificareProduct.fromJson(map['body']['product'])));
          break;
        case 'qrCodeScannerStarted':
          return new NotificareEvent(
              eventName, new NotificareQrCodeScannerStartedEvent());
          break;
        case 'scannableDetected':
          return new NotificareEvent(
              eventName,
              new NotificareScannableDetectedEvent(
                  NotificareScannable.fromJson(map['body'])));
          break;
        case 'scannableSessionInvalidatedWithError':
          return new NotificareEvent(
              eventName,
              new NotificareScannableSessionInvalidatedWithErrorEvent(
                  map['body']['error']));
          break;
        default:
          return new NotificareEvent(eventName, map['body']);
          break;
      }
    }
    return null;
  }
}
