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
    if (key != null && secret != null) {
      await _methodChannel.invokeMapMethod('initializeWithKeyAndSecret', {'key': key, 'secret': secret});
    } else {
      await _methodChannel.invokeMethod('initializeWithKeyAndSecret');
    }
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
    var status = await _methodChannel.invokeMapMethod('isNotificationFromNotificare', userInfo);
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

  Future<Map<String, dynamic>> registerDevice(String userID, String userName) async {
    if (userID != null && userName != null) {
      Map<String, dynamic> response = await _methodChannel.invokeMapMethod('registerDevice', {'userID': userID, 'userName': userName});
      return response.cast<String, dynamic>();
    } else if (userID != null && userName == null) {
      Map<String, dynamic> response = await _methodChannel.invokeMapMethod('registerDevice', {'userID': userID});
      return response.cast<String, dynamic>();
    } else {
      Map<String, dynamic> response = await _methodChannel.invokeMethod('registerDevice');
      return response.cast<String, dynamic>();
    }
  }

  Future<Map<String, dynamic>> fetchDevice() async {
    Map<String, dynamic> response = await _methodChannel.invokeMethod('fetchDevice');
    return response.cast<String, dynamic>();
  }

  Future<dynamic> fetchPreferredLanguage() async {
    var response = await _methodChannel.invokeMethod('fetchPreferredLanguage');
    return response;
  }

  Future<Map<String, dynamic>> updatePreferredLanguage(String preferredLanguage) async {
    Map<String, dynamic> response;
    if (preferredLanguage != null) {
      response = await _methodChannel.invokeMapMethod('updatePreferredLanguage', {'preferredLanguage': preferredLanguage});
    } else {
      response = await _methodChannel.invokeMethod('updatePreferredLanguage');
    }
    return response.cast<String, dynamic>();
  }

  Future<List> fetchTags() async {
    List response = await _methodChannel.invokeMethod('fetchTags');
    return response;
  }

  Future<Map<String, dynamic>> addTag(String tag) async {
    Map<String, dynamic> response = await _methodChannel.invokeMapMethod('addTag', {'tag': tag});
    return response.cast<String, dynamic>();
  }

  Future<Map<String, dynamic>> addTags(List tags) async {
    Map<String, dynamic> response = await _methodChannel.invokeMapMethod('addTags', {'tags': tags});
    return response.cast<String, dynamic>();
  }

  Future<Map<String, dynamic>> removeTag(String tag) async {
    Map<String, dynamic> response = await _methodChannel.invokeMapMethod('removeTag', {'tag': tag});
    return response.cast<String, dynamic>();
  }

  Future<Map<String, dynamic>> removeTags(List tags) async {
    Map<String, dynamic> response = await _methodChannel.invokeMapMethod('removeTags', {'tags': tags});
    return response.cast<String, dynamic>();
  }

  Future<Map<String, dynamic>> clearTags() async {
    Map<String, dynamic> response = await _methodChannel.invokeMethod('clearTags');
    return response.cast<String, dynamic>();
  }

  Future<List> fetchUserData() async {
    List response = await _methodChannel.invokeListMethod('fetchUserData');
    return response;
  }

  Future<List> updateUserData(List userData) async {
    List response = await _methodChannel.invokeListMethod('updateUserData', {'userData': userData});
    return response;
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
