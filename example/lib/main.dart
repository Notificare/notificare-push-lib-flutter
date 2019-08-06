import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:notificare_push_lib/notificare_push_lib.dart';

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
      switch (event.eventName) {
        case "ready": {
          print("Application is Ready: " + event.body['name']);
          await notificare.registerForNotifications();
          await _registerDevice("1234567890", "Joel Oliveira");
          List inbox = await _fetchInbox();
          //await _fetchAssets("TEST");

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
          print("URL: " + event.body['url']);
          //Handle Deep Link
        }
        break;
        case "launchUrlReceived": {
          print("URL: " + event.body['url']);
          //Handle Deep Link
        }
        break;
        case "deviceRegistered": {
          print("Device: " + event.body['deviceID']);
          _fetchNotificationSettings();
          _fetchTags();
          _addTag("tag_flutter");
          _fetchPreferredLanguage();
        }
        break;
        case "notificationSettingsChanged": {
          if (event.body['granted']) {
            print("Allowed UI: Granted");
          } else {
            print("Allowed UI: Not Granted");
          }
        }
        break;
        case "remoteNotificationReceivedInBackground": {
          print("Notification: " + event.body['message']);
          notificare.presentNotification(event.body);
        }
        break;
        case "remoteNotificationReceivedInForeground": {
          print("Notification: " + event.body['message']);
        }
        break;
        case "systemNotificationReceivedInBackground": {
          print("System Notification: " + event.body['notificationID']);
        }
        break;
        case "systemNotificationReceivedInForeground": {
          print("System Notification: " + event.body['notificationID']);
        }
        break;
        case "unknownNotificationReceived": {
          print("Unknown Notification: " + event.body.toString());
        }
        break;
        case "unknownActionForNotificationReceived": {
          print("Unknown Notification: " + event.body.toString());
        }
        break;
        case "notificationWillOpen": {
          print("Notification: " + event.body['message']);
        }
        break;
        case "notificationOpened": {
          print("Notification: " + event.body['message']);
        }
        break;
        case "notificationClosed": {
          print("Notification: " + event.body['message']);
        }
        break;
        case "notificationFailedToOpen": {
          print("Notification: " + event.body['message']);
        }
        break;
        case "urlClickedInNotification": {
          print("URL: " + event.body['url']);
          //Handle Deep Link
        }
        break;
        case "notificationFailedToOpen": {
          print("Notification: " + event.body['message']);
        }
        break;
        case "urlClickedInNotification": {
          print("URL: " + event.body['url']);
          //Handle Deep Link
        }
        break;
        case "actionWillExecute": {
          print("Action: " + event.body['label']);
        }
        break;
        case "actionExecuted": {
          print("Action: " + event.body['label']);
        }
        break;
        case "shouldPerformSelectorWithUrl": {
          print("URL: " + event.body['url']);
          //Handle Deep Link
        }
        break;
        case "actionNotExecuted": {
          print("Action: " + event.body['label']);
        }
        break;
        case "actionFailedToExecute": {
          print("Action: " + event.body['label']);
        }
        break;
        case "shouldOpenSettings": {
          print("Notification: " + event.body.toString());
          //Go to settings
        }
        break;
        case "inboxLoaded": {
          _fetchInbox();
        }
        break;
        case "badgeUpdated": {
          print("Unread Count: " + event.body.toString());
        }
        break;
        case "locationServiceAuthorizationStatusReceived": {
          print("Location Services Authorization Status: " + event.body.toString());
        }
        break;
        case "locationServiceFailedToStart": {
          print("Location Services Error: " + event.body.toString());
        }
        break;
        case "locationsUpdated": {
          print("Locations Updated: " + event.body.toString());
        }
        break;
        case "monitoringForRegionStarted": {
          print("Monitoring For Region: " + event.body.toString());
        }
        break;
        case "monitoringForRegionFailed": {
          print("Monitoring for Region Failed: " + event.body.toString());
        }
        break;
        case "stateForRegionChanged": {
          print("State for Region: " + event.body.toString());
        }
        break;
        case "regionEntered": {
          print("Enter Region: " + event.body.toString());
        }
        break;
        case "regionExited": {
          print("Exit Region: " + event.body.toString());
        }
        break;
        case "beaconsInRangeForRegion": {
          print("Beacons in Range for Region: " + event.body.toString());
        }
        break;
        case "rangingBeaconsFailed": {
          print("Ranging Beacons Failed: " + event.body.toString());
        }
        break;
        case "headingUpdated": {
          print("Heading: " + event.body.toString());
        }
        break;
        case "visitReceived": {
          print("Visit Received: " + event.body.toString());
        }
        break;
        case "accountStateChanged": {
          print("Account State Changed: " + event.body.toString());
        }
        break;
        case "accountSessionFailedToRenewWithError": {
          print("Account Session Failed to Renew: " + event.body.toString());
        }
        break;
        case "activationTokenReceived": {
          print("Activation Token: " + event.body.toString());
        }
        break;
        case "resetPasswordTokenReceived": {
          print("Reset Pass Token: " + event.body.toString());
        }
        break;
        case "storeLoaded": {
          print("In-App Store Loaded: " + event.body.toString());
        }
        break;
        case "storeFailedToLoad": {
          print("In-App Store Failed to Load: " + event.body.toString());
        }
        break;
        case "productTransactionCompleted": {
          print("Product: " + event.body.toString());
        }
        break;
        case "productTransactionRestored": {
          print("Product: " + event.body.toString());
        }
        break;
        case "productTransactionFailed": {
          print("Product: " + event.body.toString());
        }
        break;
        case "productContentDownloadStarted": {
          print("Product: " + event.body.toString());
        }
        break;
        case "productContentDownloadPaused": {
          print("Product: " + event.body.toString());
        }
        break;
        case "productContentDownloadCancelled": {
          print("Product: " + event.body.toString());
        }
        break;
        case "productContentDownloadProgress": {
          print("Product: " + event.body.toString());
        }
        break;
        case "productContentDownloadFailed": {
          print("Product: " + event.body.toString());
        }
        break;
        case "productContentDownloadFinished": {
          print("Product: " + event.body.toString());
        }
        break;
        case "qrCodeScannerStarted": {
          //Opened Built-in QR Code Scanner
        }
        break;
        case "scannableDetected": {
          print("Scannable: " + event.body.toString());
        }
        break;
        case "scannableSessionInvalidatedWithError": {
          print("Scannable Session Failed: " + event.body.toString());
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
    Map<String, dynamic> settings = await notificare.fetchNotificationSettings();
    print("Settings: " + settings.toString());
  }

  Future<void> _fetchPreferredLanguage() async {
    String preferredLanguage = await notificare.fetchPreferredLanguage();
    print("Preferred Language: " + preferredLanguage.toString());
  }

  Future<void> _registerDevice(String userID, String userName) async {
    Map<String, dynamic> response = await notificare.registerDevice(userID, userName);
    print("Register Device: " + response.toString());
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
