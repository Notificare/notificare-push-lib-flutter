import 'package:notificare_push_lib/notificare_models.dart';

/// Wrapper class for all events
class NotificareEvent {
  final String name;
  final dynamic data;
  NotificareEvent(this.name, this.data);
}

///
/// Event: Notificare is ready
/// Platform: iOS, Android
/// Name: ready
/// Data: application info
///
class NotificareReadyEvent {
  NotificareReadyEvent(this.application);
  NotificareApplication application;
}

///
/// Event: A device was registered
/// Platform: iOS, Android
/// Name: deviceRegistered
/// Data: device
///
class NotificareDeviceRegisteredEvent {
  NotificareDeviceRegisteredEvent(this.device);
  NotificareDevice device;
}

///
/// Event: Notification settings changed
/// Platform: iOS
/// Name: notificationSettingsChanged
/// Data: granted
///
class NotificareNotificationSettingsChangedEvent {
  NotificareNotificationSettingsChangedEvent(this.granted);
  bool granted;
}

///
/// Event: inbox was loaded from local storage
/// Platform: iOS, Android
/// Name: inboxLoaded
/// Data: list of inbox items
///
class NotificareInboxLoadedEvent {
  NotificareInboxLoadedEvent(this.inbox);
  List<NotificareInboxItem> inbox;
}

///
/// Event: Unread count changed
/// Platform: iOS, Android
/// Name: badgeUpdated
/// Data: unreadCount
///
class NotificareBadgeUpdatedEvent {
  NotificareBadgeUpdatedEvent(this.unreadCount);
  int unreadCount;
}

///
/// Event: A URL was opened
/// Platform: iOS, Android
/// Name: urlOpened
/// Data: url
///
class NotificareUrlOpenedEvent {
  NotificareUrlOpenedEvent(this.url);
  String url;
}

///
/// Event: Url clicked in notification
/// Platform: iOS, Android
/// Name: urlClickedInNotification
/// Data: url, notification
///
class NotificareUrlClickedInNotificationEvent {
  NotificareUrlClickedInNotificationEvent(this.url, this.notification);
  String url;
  NotificareNotification notification;
}

///
/// Event: application was launched with a URL
/// Platform: iOS
/// Name: launchUrlReceived
/// Data: url
///
class NotificareLaunchUrlReceivedEvent {
  NotificareLaunchUrlReceivedEvent(this.url);
  String url;
}

///
/// Event: notification received in background
/// Platform: iOS, Android
/// Name: remoteNotificationReceivedInBackground
/// Data: notification
///
class NotificareRemoteNotificationReceivedInBackgroundEvent {
  NotificareRemoteNotificationReceivedInBackgroundEvent(this.notification);
  NotificareNotification notification;
}

///
/// Event: notification received in foreground
/// Platform: iOS, Android
/// Name: remoteNotificationReceivedInForeground
/// Data: notification
///
class NotificareRemoteNotificationReceivedInForegroundEvent {
  NotificareRemoteNotificationReceivedInForegroundEvent(this.notification);
  NotificareNotification notification;
}

///
/// Event: system notification received in background
/// Platform: iOS
/// Name: systemNotificationReceivedInBackground
/// Data: notification
///
class NotificareSystemNotificationReceivedInBackgroundEvent {
  NotificareSystemNotificationReceivedInBackgroundEvent(this.notification);
  NotificareSystemNotification notification;
}

///
/// Event: system notification received in foreground
/// Platform: iOS
/// Name: systemNotificationReceivedInForeground
/// Data: notification
///
class NotificareSystemNotificationReceivedInForegroundEvent {
  NotificareSystemNotificationReceivedInForegroundEvent(this.notification);
  NotificareSystemNotification notification;
}

///
/// Event: unknown notification received
/// Platform: iOS
/// Name: unknownNotificationReceived
/// Data: notification
///
class NotificareUnknownNotificationReceivedEvent {
  NotificareUnknownNotificationReceivedEvent(this.notification);
  Map<String, dynamic> notification;
}

///
/// Event: settings should be opened
/// Platform: iOS
/// Name: shouldOpenSettings
/// Data: notification
///
class NotificareShouldOpenSettingsEvent {
  NotificareShouldOpenSettingsEvent(this.notification);
  NotificareNotification notification;
}

///
/// Event: notification will open
/// Platform: iOS
/// Name: notificationWillOpen
/// Data: notification
///
class NotificareNotificationWillOpenEvent {
  NotificareNotificationWillOpenEvent(this.notification);
  NotificareNotification notification;
}

///
/// Event: notification opened
/// Platform: iOS
/// Name: notificationOpened
/// Data: notification
///
class NotificareNotificationOpenedEvent {
  NotificareNotificationOpenedEvent(this.notification);
  NotificareNotification notification;
}

///
/// Event: notification failed to open
/// Platform: iOS
/// Name: notificationFailedToOpen
/// Data: notification
///
class NotificareNotificationFailedToOpenEvent {
  NotificareNotificationFailedToOpenEvent(this.notification);
  NotificareNotification notification;
}

///
/// Event: notification closed
/// Platform: iOS
/// Name: notificationClosed
/// Data: notification
///
class NotificareNotificationClosedEvent {
  NotificareNotificationClosedEvent(this.notification);
  NotificareNotification notification;
}

///
/// Event: action will execute
/// Platform: iOS
/// Name: actionWillExecute
/// Data: action
///
class NotificareActionWillExecuteEvent {
  NotificareActionWillExecuteEvent(this.action);
  NotificareAction action;
}

///
/// Event: action executed
/// Platform: iOS
/// Name: actionExecuted
/// Data: action
///
class NotificareActionExecutedEvent {
  NotificareActionExecutedEvent(this.action);
  NotificareAction action;
}

///
/// Event: should perform selector for action
/// Platform: iOS
/// Name: shouldPerformSelectorWithUrl
/// Data: url, action
///
class NotificareShouldPerformSelectorWithUrlEvent {
  NotificareShouldPerformSelectorWithUrlEvent(this.url, this.action);
  String url;
  NotificareAction action;
}

///
/// Event: action not executed
/// Platform: iOS
/// Name: actionNotExecuted
/// Data: action
///
class NotificareActionNotExecutedEvent {
  NotificareActionNotExecutedEvent(this.action);
  NotificareAction action;
}

///
/// Event: action failed to execute
/// Platform: iOS
/// Name: actionFailedToExecute
/// Data: action
///
class NotificareActionFailedToExecuteEvent {
  NotificareActionFailedToExecuteEvent(this.action);
  NotificareAction action;
}

///
/// Event: unknown action
/// Platform: iOS
/// Name: unknownActionForNotificationReceived
/// Data: action
///
class NotificareUnknownActionForNotificationReceivedEvent {
  NotificareUnknownActionForNotificationReceivedEvent(
      this.action, this.notification);
  Map<String, dynamic> action;
  Map<String, dynamic> notification;
}

///
/// Event: Authorization status received
/// Platform: iOS
/// Name: locationServiceAuthorizationStatusReceived
/// Data: status
///
class NotificareLocationServiceAuthorizationStatusReceived {
  NotificareLocationServiceAuthorizationStatusReceived(this.status);
  String status;
}

///
/// Event:
/// Platform: iOS
/// Name: locationServiceFailedToStart
/// Data: error
///
class NotificareLocationServiceFailedToStart {
  NotificareLocationServiceFailedToStart(this.error);
  String error;
}

///
/// Event: locations updated
/// Platform: iOS
/// Name: locationsUpdated
/// Data: locations
///
class NotificareLocationsUpdatedEvent {
  NotificareLocationsUpdatedEvent(this.locations);
  List<NotificareLocation> locations;
}

///
/// Event: monitoring for region started
/// Platform: iOS
/// Name: monitoringForRegionStarted
/// Data: region or beacon
///
class NotificareMonitoringForRegionStartedEvent {
  NotificareMonitoringForRegionStartedEvent(this.region);
  dynamic region;
}

///
/// Event: monitoring for region failed
/// Platform: iOS
/// Name: monitoringForRegionFailed
/// Data:
///
class NotificareMonitoringForRegionFailedEvent {
  NotificareMonitoringForRegionFailedEvent(this.region, this.error);
  dynamic region;
  String error;
}

///
/// Event: state for region changed
/// Platform: iOS
/// Name: stateForRegionChanged
/// Data: state, region
///
class NotificareStateForRegionChangedEvent {
  NotificareStateForRegionChangedEvent(this.region, this.state);
  String state;
  dynamic region;
}

///
/// Event: region entered
/// Platform: iOS
/// Name: regionEntered
/// Data: region
///
class NotificareRegionEnteredEvent {
  NotificareRegionEnteredEvent(this.region);
  dynamic region;
}

///
/// Event: region exited
/// Platform: iOS
/// Name: regionExited
/// Data: region
///
class NotificareRegionExitedEvent {
  NotificareRegionExitedEvent(this.region);
  dynamic region;
}

///
/// Event:
/// Platform: iOS, Android
/// Name: beaconsInRangeForRegion
/// Data: list of beacons, region
///
class NotificareBeaconsInRangeForRegionEvent {
  NotificareBeaconsInRangeForRegionEvent(this.beacons, this.region);
  NotificareBeacon region;
  List<NotificareBeacon> beacons;
}

///
/// Event:
/// Platform: iOS
/// Name: rangingBeaconsFailed
/// Data:
///
class NotificareRangingBeaconsFailedEvent {
  NotificareRangingBeaconsFailedEvent(this.error, this.region);
  String error;
  NotificareBeacon region;
}

///
/// Event:
/// Platform: iOS
/// Name: headingUpdated
/// Data: heading
///
class NotificareHeadingUpdatedEvent {
  NotificareHeadingUpdatedEvent(this.heading);
  NotificareHeading heading;
}

///
/// Event:
/// Platform: iOS
/// Name: visitReceived
/// Data: visit
///
class NotificareVisitReceivedEvent {
  NotificareVisitReceivedEvent(this.visit);
  NotificareVisit visit;
}

///
/// Event:
/// Platform: iOS
/// Name: activationTokenReceived
/// Data: token
///
class NotificareActivationTokenReceivedEvent {
  NotificareActivationTokenReceivedEvent(this.token);
  String token;
}

///
/// Event:
/// Platform: iOS
/// Name: resetPasswordTokenReceived
/// Data: token
///
class NotificareResetPasswordTokenReceivedEvent {
  NotificareResetPasswordTokenReceivedEvent(this.token);
  String token;
}

///
/// Event:
/// Platform: iOS
/// Name: storeFailedToLoad
/// Data: error
///
class NotificareStoreFailedToLoadEvent {
  NotificareStoreFailedToLoadEvent(this.error);
  String error;
}

///
/// Event:
/// Platform: iOS
/// Name: storeLoaded
/// Data: list of products
///
class NotificareStoreLoadedEvent {
  NotificareStoreLoadedEvent(this.products);
  List<NotificareProduct> products;
}

///
/// Event:
/// Platform: iOS
/// Name:productTransactionCompleted
/// Data:
///
class NotificareProductTransactionCompletedEvent {
  NotificareProductTransactionCompletedEvent(this.product);
  NotificareProduct product;
}

///
/// Event:
/// Platform: iOS
/// Name:productTransactionRestored
/// Data:
///
class NotificareProductTransactionRestoredEvent {
  NotificareProductTransactionRestoredEvent(this.product);
  NotificareProduct product;
}

///
/// Event:
/// Platform: iOS
/// Name:productTransactionFailed
/// Data: error, product
///
class NotificareProductTransactionFailedEvent {
  NotificareProductTransactionFailedEvent(this.error, this.product);
  String error;
  NotificareProduct product;
}

///
/// Event:
/// Platform: iOS
/// Name:productContentDownloadStarted
/// Data: product
///
class NotificareProductContentDownloadStartedEvent {
  NotificareProductContentDownloadStartedEvent(this.product);
  NotificareProduct product;
}

///
/// Event:
/// Platform: iOS
/// Name:productContentDownloadPaused
/// Data: download, product
///
class NotificareProductContentDownloadPausedEvent {
  NotificareProductContentDownloadPausedEvent(this.download, this.product);
  NotificareDownload download;
  NotificareProduct product;
}

///
/// Event:
/// Platform: iOS
/// Name:productContentDownloadCancelled
/// Data: download, product
///
class NotificareProductContentDownloadCancelledEvent {
  NotificareProductContentDownloadCancelledEvent(this.download, this.product);
  NotificareDownload download;
  NotificareProduct product;
}

///
/// Event:
/// Platform: iOS
/// Name: productContentDownloadProgress
/// Data: download, product
///
class NotificareProductContentDownloadProgressEvent {
  NotificareProductContentDownloadProgressEvent(this.download, this.product);
  NotificareDownload download;
  NotificareProduct product;
}

///
/// Event:
/// Platform: iOS
/// Name: productContentDownloadFailed
/// Data: download, product
///
class NotificareProductContentDownloadFailedEvent {
  NotificareProductContentDownloadFailedEvent(this.download, this.product);
  NotificareDownload download;
  NotificareProduct product;
}

///
/// Event:
/// Platform: iOS
/// Name: productContentDownloadFinished
/// Data: download, product
///
class NotificareProductContentDownloadFinishedEvent {
  NotificareProductContentDownloadFinishedEvent(this.download, this.product);
  NotificareDownload download;
  NotificareProduct product;
}

///
/// Event:
/// Platform: iOS
/// Name: qrCodeScannerStarted
/// Data:
///
class NotificareQrCodeScannerStartedEvent {
  NotificareQrCodeScannerStartedEvent();
}

///
/// Event:
/// Platform: iOS
/// Name: scannableDetected
/// Data: scannable
///
class NotificareScannableDetectedEvent {
  NotificareScannableDetectedEvent(this.scannable);
  NotificareScannable scannable;
}

///
/// Event:
/// Platform: iOS
/// Name: scannableSessionInvalidatedWithError
/// Data: error
///
class NotificareScannableSessionInvalidatedWithErrorEvent {
  NotificareScannableSessionInvalidatedWithErrorEvent(this.error);
  String error;
}
