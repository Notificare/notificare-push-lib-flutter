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
      await _methodChannel.invokeMethod('initializeWithKeyAndSecret', {'key': key, 'secret': secret});
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
    var status = await _methodChannel.invokeMethod('isNotificationFromNotificare', userInfo);
    return status as bool;
  }

  Future<Map<String, dynamic>> fetchNotificationSettings() async {
    Map<dynamic, dynamic> response = await _methodChannel.invokeMapMethod('fetchNotificationSettings');
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
      Map<String, dynamic> response = await _methodChannel.invokeMapMethod('registerDevice');
      return response.cast<String, dynamic>();
    }
  }

  Future<Map<String, dynamic>> fetchDevice() async {
    Map<String, dynamic> response = await _methodChannel.invokeMapMethod('fetchDevice');
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
    List response = await _methodChannel.invokeListMethod('fetchTags');
    return response;
  }

  Future<dynamic> addTag(String tag) async {
    return await _methodChannel.invokeMapMethod('addTag', {'tag': tag});
  }

  Future<dynamic> addTags(List tags) async {
    return await _methodChannel.invokeMapMethod('addTags', {'tags': tags});
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

  Future<Map<String, dynamic>> fetchDoNotDisturb() async {
    Map<String, dynamic> response = await _methodChannel.invokeMapMethod('fetchDoNotDisturb');
    return response.cast<String, dynamic>();
  }

  Future<Map<String, dynamic>> updateDoNotDisturb(Map<String, dynamic> dnd) async {
    Map<String, dynamic> response = await _methodChannel.invokeMapMethod('updateDoNotDisturb', {'dnd': dnd});
    return response.cast<String, dynamic>();
  }

  Future<Map<String, dynamic>> clearDoNotDisturb() async {
    Map<String, dynamic> response = await _methodChannel.invokeMapMethod('clearDoNotDisturb');
    return response.cast<String, dynamic>();
  }

  Future<Map<String, dynamic>> fetchNotification(Map<String, dynamic> notification) async {
    Map<String, dynamic> response = await _methodChannel.invokeMapMethod('fetchNotification', {'notification': notification});
    return response.cast<String, dynamic>();
  }

  Future<Map<String, dynamic>> fetchNotificationForInboxItem(Map<dynamic, dynamic> inboxItem) async {
    Map<String, dynamic> response = await _methodChannel.invokeMapMethod('fetchNotificationForInboxItem', {'inboxItem': inboxItem});
    return response.cast<String, dynamic>();
  }

  Future<Map<String, dynamic>> clearPrivateNotification(Map<String, dynamic> notification) async {
    Map<String, dynamic> response = await _methodChannel.invokeMapMethod('clearPrivateNotification', {'notification': notification});
    return response.cast<String, dynamic>();
  }

  Future<void> presentNotification(Map<String, dynamic> notification) async {
    await _methodChannel.invokeMethod('presentNotification', {'notification': notification});
  }

  Future<dynamic> reply(Map<String, dynamic> notification, Map<String, dynamic> action, Map<String, dynamic> data) async {
    return await _methodChannel.invokeMapMethod('reply', {'notification': notification, 'action': action, 'data': data});
  }

  Future<List> fetchInbox() async {
    List response = await _methodChannel.invokeListMethod('fetchInbox');
    return response;
    //return response.map(NotificareInboxItem.fromJSON).toList();
  }

  Future<void> presentInboxItem(Map<dynamic, dynamic> inboxItem) async {
    await _methodChannel.invokeMapMethod('presentInboxItem', {'inboxItem': inboxItem});
  }

  Future<Map<String, dynamic>> removeFromInbox(Map<dynamic, dynamic> inboxItem) async {
    Map<String, dynamic> response = await _methodChannel.invokeMapMethod('removeFromInbox', {'inboxItem': inboxItem});
    return response.cast<String, dynamic>();
  }

  Future<Map<String, dynamic>> markAsRead(Map<dynamic, dynamic> inboxItem) async {
    Map<String, dynamic> response = await _methodChannel.invokeMapMethod('markAsRead', {'inboxItem': inboxItem});
    return response.cast<String, dynamic>();
  }

  Future<dynamic> clearInbox() async {
    return await _methodChannel.invokeMapMethod('clearInbox');
  }

  Future<List> fetchAssets(String group) async {
    List response = await _methodChannel.invokeListMethod('fetchAssets', {'group': group});
    return response;
  }

  Future<Map<String, dynamic>> fetchPassWithSerial(String serial) async {
    Map<String, dynamic> response = await _methodChannel.invokeMapMethod('fetchPassWithSerial', {'serial': serial});
    return response.cast<String, dynamic>();
  }

  Future<Map<String, dynamic>> fetchPassWithBarcode(String barcode) async {
    Map<String, dynamic> response = await _methodChannel.invokeMapMethod('fetchPassWithBarcode', {'barcode': barcode});
    return response.cast<String, dynamic>();
  }

  Future<List> fetchProducts() async {
    List response = await _methodChannel.invokeListMethod('fetchProducts');
    return response;
  }

  Future<List> fetchPurchasedProducts() async {
    List response = await _methodChannel.invokeListMethod('fetchPurchasedProducts');
    return response;
  }

  Future<Map<String, dynamic>> fetchProduct(Map<String, dynamic> product) async {
    Map<String, dynamic> response = await _methodChannel.invokeMapMethod('fetchProduct', {'product': product});
    return response.cast<String, dynamic>();
  }

  Future<void> buyProduct(Map<dynamic, dynamic> product) async {
    await _methodChannel.invokeMethod('buyProduct', {'product': product});
  }

  Future<dynamic> logCustomEvent(String name, Map<String, dynamic> data) async {
    return await _methodChannel.invokeMapMethod('logCustomEvent', {'name': name, 'data': data});
  }

  Future<dynamic> logOpenNotification(Map<dynamic, dynamic> notification) async {
    return await _methodChannel.invokeMapMethod('logOpenNotification', {'notification': notification});
  }

  Future<dynamic> logInfluencedNotification(Map<dynamic, dynamic> notification) async {
    return  await _methodChannel.invokeMapMethod('logInfluencedNotification', {'notification': notification});
  }

  Future<dynamic> logReceiveNotification(Map<dynamic, dynamic> notification) async {
    return await _methodChannel.invokeMapMethod('logReceiveNotification', {'notification': notification});
  }

  Future<Map<String, dynamic>> doPushHostOperation(String verb, String path, Map<String, dynamic> params, Map<String, dynamic> body) async {
    Map<String, dynamic> response = await _methodChannel.invokeMapMethod('doPushHostOperation', {'verb': verb, 'path': path, 'params': params, 'body': body});
    return response.cast<String, dynamic>();
  }

  Future<Map<String, dynamic>> doCloudHostOperation(String verb, String path, Map<String, String> params, Map<String, String> headers, Map<String, dynamic> body) async {
    Map<String, dynamic> response = await _methodChannel.invokeMapMethod('doPushHostOperation', {'verb': verb, 'path': path, 'params': params, 'headers': headers, 'body': body});
    return response.cast<String, dynamic>();
  }

  Future<dynamic> createAccount(String email, String name, String password) async {
    return await _methodChannel.invokeMapMethod('createAccount', {'email': email, 'name': name, 'password': password});
  }

  Future<dynamic> validateAccount(String token) async {
    return await _methodChannel.invokeMapMethod('validateAccount', {'token': token});
  }

  Future<dynamic> resetPassword(String password, String token) async {
    return await _methodChannel.invokeMapMethod('resetPassword', {'password': password, 'token': token});
  }

  Future<dynamic> login(String email, String password) async {
    return await _methodChannel.invokeMapMethod('login', {'email': email, 'password': password});
  }

  Future<dynamic> logout() async {
    return await _methodChannel.invokeMethod('logout');
  }

  Future<bool> isLoggedIn() async {
    var status = await _methodChannel.invokeMethod("isLoggedIn");
    return status as bool;
  }

  Future<Map<String, dynamic>> generateAccessToken() async {
    Map<String, dynamic> response = await _methodChannel.invokeMapMethod('generateAccessToken');
    return response.cast<String, dynamic>();
  }

  Future<dynamic> changePassword(String password) async {
    return await _methodChannel.invokeMapMethod('changePassword', {'password': password});
  }

  Future<Map<String, dynamic>> fetchAccountDetails() async {
    Map<String, dynamic> response = await _methodChannel.invokeMapMethod('fetchAccountDetails');
    return response.cast<String, dynamic>();
  }

  Future<Map<String, dynamic>> fetchUserPreferences() async {
    Map<String, dynamic> response = await _methodChannel.invokeMapMethod('fetchUserPreferences');
    return response.cast<String, dynamic>();
  }

  Future<dynamic> addSegmentToUserPreference(Map<String, dynamic> segment, Map<String, dynamic> userPreference) async {
    return await _methodChannel.invokeMapMethod('addSegmentToUserPreference', {'segment': segment, 'userPreference': userPreference});
  }

  Future<dynamic> removeSegmentFromUserPreference(Map<String, dynamic> segment, Map<String, dynamic> userPreference) async {
    return await _methodChannel.invokeMapMethod('removeSegmentFromUserPreference', {'segment': segment, 'userPreference': userPreference});
  }

  Future<void> startScannableSessionWithQRCode() async {
    await _methodChannel.invokeMethod('startScannableSessionWithQRCode');
  }

  Future<void> presentScannable(Map<String, dynamic> scannable) async {
    await _methodChannel.invokeMethod('presentScannable', {'scannable': scannable});
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
      return new NotificareEvent(map['event'], map['body']);
    }
    return null;
  }
}

class NotificareEvent {
  final String eventName;
  final dynamic body;
  NotificareEvent(this.eventName, this.body);
}

//class NotificareInboxItem {
//  NotificareInboxItem(this.inboxId);
//  final String inboxId;
//
//  static NotificareInboxItem fromJSON(dynamic json) {
//    return new NotificareInboxItem(json['inboxId']);
//  }
//
//  dynamic toJSON() {
//    return <String, dynamic> {
//      'inboxId': inboxId
//    };
//  }
//}
