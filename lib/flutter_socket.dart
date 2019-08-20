import 'dart:async';

import 'package:flutter/services.dart';


class FlutterSocket {

  static const MethodChannel _channel =
  const MethodChannel('flutter_socket_plugin');
  
  FlutterSocket() {
    _createSocket();
    _channel.setMethodCallHandler((call){
      if (call.method == "createSocketCallBack") {

      }
      return;
    });
  }



  Future<void> _createSocket() async {
    await _channel.invokeMethod("createSocket");
  }

  Future<void> tryConnect(String host, int port, int timeout) async {
    Map arguments = {
      "host":host,
      "port":port,
      "timeout":timeout
    };
    await _channel.invokeMethod("tryConnect",arguments);
  }

}