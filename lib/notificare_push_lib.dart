import 'dart:async';

import 'package:flutter/services.dart';
import 'package:meta/meta.dart' show visibleForTesting;

class NotificarePushLib {

  factory NotificarePushLib() {
    if (_instance == null) {
      final MethodChannel methodChannel = const MethodChannel('notificare_push_lib');
      final EventChannel eventChannel = const EventChannel('notificare_push_lib/events');
      _instance = NotificarePushLib.private(methodChannel, eventChannel);
    }
    return _instance;
  }

  @visibleForTesting
  NotificarePushLib.private(this._methodChannel, this._eventChannel);

  static NotificarePushLib _instance;

  final MethodChannel _methodChannel;
  final EventChannel _eventChannel;
  Stream<NotificareEvent> _onEventReceived;

  Future<void> initializeWithKeyAndSecret(String key, String secret) async {
    await _methodChannel.invokeMethod('initializeWithKeyAndSecret', {'key': key, 'secret': secret});
  }

  Future<void> launch() async {
    await _methodChannel.invokeMethod('launch');
  }

  Future<void> registerForNotifications() async {
    await _methodChannel.invokeMethod('registerForNotifications');
  }

  Future<void> unregisterForNotifications() async {
    await _methodChannel.invokeMethod('unregisterForNotifications');
  }

  Future<bool> isRemoteNotificationsEnabled() async {
    var status = await _methodChannel.invokeMethod("isRemoteNotificationsEnabled");
    return status as bool;
  }

  Future<bool> isAllowedUIEnabled() async {
    var status = await _methodChannel.invokeMethod("isAllowedUIEnabled");
    return status as bool;
  }

  Future<bool> isNotificationFromNotificare(Map<String, dynamic> userInfo) async {
    var status = await _methodChannel.invokeMethod('isNotificationFromNotificare', userInfo);
    return status as bool;
  }

  Future<Map<String, dynamic>> fetchNotificationSettings() async {
    Map<dynamic, dynamic> response = await _methodChannel.invokeMethod('fetchNotificationSettings');
    return response.cast<String, dynamic>();
  }

  Future<void> startLocationUpdates() async {
    await _methodChannel.invokeMethod('startLocationUpdates');
  }

  Future<void> stopLocationUpdates() async {
    await _methodChannel.invokeMethod('stopLocationUpdates');
  }

  Future<bool> isLocationServicesEnabled() async {
    var status = await _methodChannel.invokeMethod("isLocationServicesEnabled");
    return status as bool;
  }

  Stream<NotificareEvent> get onEventReceived {
    if (_onEventReceived == null) {
      _onEventReceived = _eventChannel
          .receiveBroadcastStream()
          .map(_toEventMessage);
    }
    return _onEventReceived;
  }

  NotificareEvent _toEventMessage(dynamic map) {
    if (map is Map) {
      var body = new Map<String, dynamic>.from(map['body']);
      return new NotificareEvent(map['event'], body);
    }
    return null;
  }
}

class NotificareEvent {
  final String eventName;
  final Map<String, dynamic> body;

  NotificareEvent(this.eventName, this.body);
}
