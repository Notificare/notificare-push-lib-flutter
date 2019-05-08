import 'dart:async';

import 'package:flutter/services.dart';

class NotificarePushLib {
  static const MethodChannel _channel =
      const MethodChannel('notificare_push_lib');

  static Future<String> get platformVersion async {
    final String version = await _channel.invokeMethod('getPlatformVersion');
    return version;
  }
}
