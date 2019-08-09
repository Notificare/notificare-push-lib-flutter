import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:notificare_push_lib/notificare_push_lib.dart';
import 'package:notificare_push_lib/notificare_models.dart';
import 'package:notificare_push_lib/notificare_events.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  final NotificarePushLib notificare = NotificarePushLib();

  @override
  void initState() {
    super.initState();

    print("Launching...");
    notificare.launch();

    notificare.onEventReceived.listen((NotificareEvent event) async {
      switch (event.name) {
        case "ready": {
          NotificareReadyEvent readyEvent = event.data as NotificareReadyEvent;
          print("Application is Ready: " + readyEvent.application.name);
          await notificare.registerForNotifications();
          await _registerDevice("1234567890", "Joel Oliveira");
          List inbox = await _fetchInbox();
//          await _fetchAssets("TEST");

          if (await notificare.isRemoteNotificationsEnabled()) {
            print("Remote Notifications Enabled");
          }


          if (await notificare.isAllowedUIEnabled()) {
            print("Allowed UI Enabled");
          }

          if (inbox.isNotEmpty) {
            notificare.presentInboxItem(inbox[0]);
          }

        }
        break;
        case "urlOpened": {
          NotificareUrlOpenedEvent urlOpenedEvent = event.data as NotificareUrlOpenedEvent;
          print("URL: " + urlOpenedEvent.url);
          //Handle Deep Link
        }
        break;
        case "launchUrlReceived": {
          NotificareLaunchUrlReceivedEvent launchUrlReceivedEvent = event.data as NotificareLaunchUrlReceivedEvent;
          print("URL: " + launchUrlReceivedEvent.url);
          //Handle Deep Link
        }
        break;
        case "deviceRegistered": {
          NotificareDeviceRegisteredEvent deviceRegisteredEvent = event.data as NotificareDeviceRegisteredEvent;
          print("Device: " + deviceRegisteredEvent.device.deviceID);
          _fetchNotificationSettings();
          _fetchTags();
          _addTag("tag_flutter");
          _fetchPreferredLanguage();
        }
        break;
        case "notificationSettingsChanged": {
          NotificareNotificationSettingsChangedEvent notificationSettingsChangedEvent = event.data as NotificareNotificationSettingsChangedEvent;
          if (notificationSettingsChangedEvent.granted) {
            print("Allowed UI: Granted");
          } else {
            print("Allowed UI: Not Granted");
          }
        }
        break;
        case "remoteNotificationReceivedInBackground": {
          NotificareRemoteNotificationReceivedInBackgroundEvent remoteNotificationReceivedInBackgroundEvent = event.data as NotificareRemoteNotificationReceivedInBackgroundEvent;
          print("Notification: " + remoteNotificationReceivedInBackgroundEvent.notification.message);
          notificare.presentNotification(remoteNotificationReceivedInBackgroundEvent.notification);
        }
        break;
        case "remoteNotificationReceivedInForeground": {
          NotificareRemoteNotificationReceivedInForegroundEvent remoteNotificationReceivedInForegroundEvent = event.data as NotificareRemoteNotificationReceivedInForegroundEvent;
          print("Notification: " + remoteNotificationReceivedInForegroundEvent.notification.message);
        }
        break;
        case "systemNotificationReceivedInBackground": {
          NotificareSystemNotificationReceivedInBackgroundEvent systemNotificationReceivedInBackgroundEvent = event.data as NotificareSystemNotificationReceivedInBackgroundEvent;
          print("System Notification: " + systemNotificationReceivedInBackgroundEvent.notification.type);
        }
        break;
        case "systemNotificationReceivedInForeground": {
          NotificareSystemNotificationReceivedInForegroundEvent systemNotificationReceivedInForegroundEvent = event.data as NotificareSystemNotificationReceivedInForegroundEvent;
          print("System Notification: " + systemNotificationReceivedInForegroundEvent.notification.type);
        }
        break;
        case "unknownNotificationReceived": {
          NotificareUnknownNotificationReceivedEvent unknownNotificationReceivedEvent = event.data as NotificareUnknownNotificationReceivedEvent;
          print("Unknown Notification: " + unknownNotificationReceivedEvent.notification.toString());
        }
        break;
        case "unknownActionForNotificationReceived": {
          print("Unknown Notification: " + event.data.toString());
        }
        break;
        case "notificationWillOpen": {
          NotificareNotificationWillOpenEvent notificationWillOpenEvent = event.data as NotificareNotificationWillOpenEvent;
          print("Notification: " + notificationWillOpenEvent.notification.message);
        }
        break;
        case "notificationOpened": {
          NotificareNotificationOpenedEvent notificationOpenedEvent = event.data as NotificareNotificationOpenedEvent;
          print("Notification: " + notificationOpenedEvent.notification.message);
        }
        break;
        case "notificationClosed": {
          NotificareNotificationClosedEvent notificationClosedEvent = event.data as NotificareNotificationClosedEvent;
          print("Notification: " + notificationClosedEvent.notification.message);
        }
        break;
        case "notificationFailedToOpen": {
          NotificareNotificationFailedToOpenEvent notificationFailedToOpenEvent = event.data as NotificareNotificationFailedToOpenEvent;
          print("Notification: " + notificationFailedToOpenEvent.notification.message);
        }
        break;
        case "urlClickedInNotification": {
          NotificareUrlClickedInNotificationEvent urlClickedInNotificationEvent = event.data as NotificareUrlClickedInNotificationEvent;
          print("URL: " + urlClickedInNotificationEvent.url);
          //Handle Deep Link
        }
        break;
        case "actionWillExecute": {
          NotificareActionWillExecuteEvent actionWillExecuteEvent = event.data as NotificareActionWillExecuteEvent;
          print("Action: " + actionWillExecuteEvent.action.label);
        }
        break;
        case "actionExecuted": {
          NotificareActionWillExecuteEvent actionWillExecuteEvent = event.data as NotificareActionWillExecuteEvent;
          print("Action: " + actionWillExecuteEvent.action.label);
        }
        break;
        case "shouldPerformSelectorWithUrl": {
          NotificareShouldPerformSelectorWithUrlEvent shouldPerformSelectorWithUrlEvent = event.data as NotificareShouldPerformSelectorWithUrlEvent;
          print("URL: " + shouldPerformSelectorWithUrlEvent.url);
          //Handle Deep Link
        }
        break;
        case "actionNotExecuted": {
          NotificareActionNotExecutedEvent actionNotExecutedEvent = event.data as NotificareActionNotExecutedEvent;
          print("Action: " + actionNotExecutedEvent.action.label);
        }
        break;
        case "actionFailedToExecute": {
          NotificareActionFailedToExecuteEvent actionFailedToExecuteEvent = event.data as NotificareActionFailedToExecuteEvent;
          print("Action: " + actionFailedToExecuteEvent.action.label);
        }
        break;
        case "shouldOpenSettings": {
          NotificareShouldOpenSettingsEvent shouldOpenSettingsEvent = event.data as NotificareShouldOpenSettingsEvent;
          print("Notification: " + shouldOpenSettingsEvent.notification.message);
          //Go to settings
        }
        break;
        case "inboxLoaded": {
          NotificareInboxLoadedEvent inboxLoadedEvent = event.data as NotificareInboxLoadedEvent;
          print("Inbox loaded with size " + inboxLoadedEvent.inbox.length.toString());
          _fetchInbox();
        }
        break;
        case "badgeUpdated": {
          NotificareBadgeUpdatedEvent badgeUpdatedEvent = event.data as NotificareBadgeUpdatedEvent;
          print("Unread Count: " + badgeUpdatedEvent.unreadCount.toString());
        }
        break;
        case "locationServiceAuthorizationStatusReceived": {
          print("Location Services Authorization Status: " + event.data.toString());
        }
        break;
        case "locationServiceFailedToStart": {
          print("Location Services Error: " + event.data.toString());
        }
        break;
        case "locationsUpdated": {
          print("Locations Updated: " + event.data.toString());
        }
        break;
        case "monitoringForRegionStarted": {
          print("Monitoring For Region: " + event.data.toString());
        }
        break;
        case "monitoringForRegionFailed": {
          print("Monitoring for Region Failed: " + event.data.toString());
        }
        break;
        case "stateForRegionChanged": {
          print("State for Region: " + event.data.toString());
        }
        break;
        case "stateForBeaconRegionChanged": {
          print("State for Region: " + event.data.toString());
        }
        break;
        case "regionEntered": {
          print("Enter Region: " + event.data.toString());
        }
        break;
        case "beaconRegionEntered": {
          print("Enter Region: " + event.data.toString());
        }
        break;
        case "regionExited": {
          print("Exit Region: " + event.data.toString());
        }
        break;
        case "beaconRegionExited": {
          print("Exit Region: " + event.data.toString());
        }
        break;
        case "beaconsInRangeForRegion": {
          print("Beacons in Range for Region: " + event.data.toString());
        }
        break;
        case "rangingBeaconsFailed": {
          print("Ranging Beacons Failed: " + event.data.toString());
        }
        break;
        case "headingUpdated": {
          print("Heading: " + event.data.toString());
        }
        break;
        case "visitReceived": {
          print("Visit Received: " + event.data.toString());
        }
        break;
        case "accountStateChanged": {
          print("Account State Changed: " + event.data.toString());
        }
        break;
        case "accountSessionFailedToRenewWithError": {
          print("Account Session Failed to Renew: " + event.data.toString());
        }
        break;
        case "activationTokenReceived": {
          print("Activation Token: " + event.data.toString());
        }
        break;
        case "resetPasswordTokenReceived": {
          print("Reset Pass Token: " + event.data.toString());
        }
        break;
        case "storeLoaded": {
          print("In-App Store Loaded: " + event.data.toString());
        }
        break;
        case "storeFailedToLoad": {
          print("In-App Store Failed to Load: " + event.data.toString());
        }
        break;
        case "productTransactionCompleted": {
          print("Product: " + event.data.toString());
        }
        break;
        case "productTransactionRestored": {
          print("Product: " + event.data.toString());
        }
        break;
        case "productTransactionFailed": {
          print("Product: " + event.data.toString());
        }
        break;
        case "productContentDownloadStarted": {
          print("Product: " + event.data.toString());
        }
        break;
        case "productContentDownloadPaused": {
          print("Product: " + event.data.toString());
        }
        break;
        case "productContentDownloadCancelled": {
          print("Product: " + event.data.toString());
        }
        break;
        case "productContentDownloadProgress": {
          print("Product: " + event.data.toString());
        }
        break;
        case "productContentDownloadFailed": {
          print("Product: " + event.data.toString());
        }
        break;
        case "productContentDownloadFinished": {
          print("Product: " + event.data.toString());
        }
        break;
        case "qrCodeScannerStarted": {
          //Opened Built-in QR Code Scanner
        }
        break;
        case "scannableDetected": {
          print("Scannable: " + event.data.toString());
        }
        break;
        case "scannableSessionInvalidatedWithError": {
          print("Scannable Session Failed: " + event.data.toString());
        }
        break;
      }
    });

    initPlatformState();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

  }

  Future<void> _fetchNotificationSettings() async {
    NotificareNotificationSettings settings = await notificare.fetchNotificationSettings();
    print("Settings: " + settings.toJson().toString());
  }

  Future<void> _fetchPreferredLanguage() async {
    String preferredLanguage = await notificare.fetchPreferredLanguage();
    print("Preferred Language: " + preferredLanguage.toString());
  }

  Future<void> _registerDevice(String userID, String userName) async {
    NotificareDevice response = await notificare.registerDevice(userID, userName);
    print("Register Device: " + response.toJson().toString());
  }


  Future<void> _fetchTags() async {
    List tags = await notificare.fetchTags();
    print("Tags: " + tags.toString());
  }

  Future<void> _addTag(String tag) async {
    try {
      await notificare.addTag(tag);
      print("Added Tag: " + tag);
    } catch(e){
      print("Failed to add Tag: " + tag);
    }
  }

  Future<List> _fetchInbox() async {
    List response = await notificare.fetchInbox();
    print("Inbox: " + response.toString());
    return response;
  }

  Future<void> _fetchAssets(String group) async {
    List response = await notificare.fetchAssets(group);
    print("Assets: " + response.toString());

    if  (response != null && response.length > 0) {
      response.forEach((asset) => {

      });
    }
  }

  Future<void> _isRemoteNotificationsEnabled() async {
    bool status = await notificare.isRemoteNotificationsEnabled();
    if (status) {
      print("Remote Notifications are enabled");
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: Center(
          child: Text('Running...'),
        ),
      ),
    );
  }
}
