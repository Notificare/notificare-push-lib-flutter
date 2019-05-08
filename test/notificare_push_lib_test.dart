import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:notificare_push_lib/notificare_push_lib.dart';

void main() {
  const MethodChannel channel = MethodChannel('notificare_push_lib');

  setUp(() {
    channel.setMockMethodCallHandler((MethodCall methodCall) async {
      return '42';
    });
  });

  tearDown(() {
    channel.setMockMethodCallHandler(null);
  });

  test('initializeWithKeyAndSecret', () async {
    //expect(await NotificarePushLib().initializeWithKeyAndSecret('asdf', 'sadf'), '42');
  });
}
