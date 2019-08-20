import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_socket_plugin/flutter_socket_plugin.dart';

void main() {
  const MethodChannel channel = MethodChannel('flutter_socket_plugin');

  setUp(() {
    channel.setMockMethodCallHandler((MethodCall methodCall) async {
      return '42';
    });
  });

  tearDown(() {
    channel.setMockMethodCallHandler(null);
  });

  test('getPlatformVersion', () async {
    expect(await FlutterSocketPlugin.platformVersion, '42');
  });
}
