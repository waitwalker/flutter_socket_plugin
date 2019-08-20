import 'dart:async';

import 'package:flutter/services.dart';

class FlutterSocketPlugin {
  static const MethodChannel _channel =
      const MethodChannel('flutter_socket_plugin');

  static Future<String> get platformVersion async {
    final String version = await _channel.invokeMethod('getPlatformVersion');
    return version;
  }
}
