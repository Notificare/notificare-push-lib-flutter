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
  Map<String, dynamic> _application;

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    _notificare.initializeWithKeyAndSecret(null, null);
    _notificare.launch();
    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    _notificare.onEventReceived.listen((NotificareEvent event) {
        switch (event.eventName) {
          case "onReady": {
            print(event.body);
            setState(() {
              _application = event.body;
            });
          }
          break;
        }
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: Center(
          child: Text('Running ${_application["name"]}'),
        ),
      ),
    );
  }
}
