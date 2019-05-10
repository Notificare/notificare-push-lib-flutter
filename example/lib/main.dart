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

  final NotificarePushLib _notificare = NotificarePushLib();

  @override
  void initState() {
    super.initState();

    _notificare.initializeWithKeyAndSecret(null, null);
    _notificare.launch();

    _notificare.onEventReceived.listen((NotificareEvent event) {
      switch (event.eventName) {
        case "ready": {
          print("Application is Ready: " + event.body['name']);
          _notificare.registerForNotifications();
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
      }
    });

    initPlatformState();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {

//    bool isRemoteNotificationsEnabled = await _notificare.isRemoteNotificationsEnabled();
//
//    if (isRemoteNotificationsEnabled) {
//      print("Notifications Enabled");
//    } else {
//      print("Notifications Disabled");
//    }
//
//    Map<String, dynamic> settings = await _notificare.fetchNotificationSettings();
//    print("Settings: " + settings.toString());

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    //if (!mounted) return;

  }

  void _fetchNotificationSettings() async {
    Map<String, dynamic> settings = await _notificare.fetchNotificationSettings();
    print("Settings: " + settings.toString());
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