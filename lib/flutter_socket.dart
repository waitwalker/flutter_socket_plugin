import 'dart:async';
import 'dart:convert';
import 'package:flutter/services.dart';

typedef void SocketEventListener(dynamic data);

class FlutterSocket {

  static const MethodChannel _channel = const MethodChannel('flutter_socket_plugin');

  ///  Socket Connect event
  static const String CONNECT = "connect";

  ///  Socket Disconnect event
  static const String DISCONNECT = "disconnect";

  ///  Socket Connection Error event
  static const String CONNECT_ERROR = "connect_error";

  ///  Socket Connection timeout event
  static const String CONNECT_TIMEOUT = "connect_timeout";

  ///  Socket Error event
  static const String ERROR = "error";

  ///  Socket Connecting event
  static const String CONNECTING = "connecting";

  ///  Socket Reconnect event
  static const String RECONNECT = "reconnect";

  ///  Socket Reconnect Error event
  static const String RECONNECT_ERROR = "reconnect_error";

  ///  Socket Reconnect Failed event
  static const String RECONNECT_FAILED = "reconnect_failed";

  ///  Socket Reconnecting event
  static const String RECONNECTING = "reconnecting";

  ///  Socket Ping event
  static const String PING = "ping";

  ///  Socket Pong event
  static const String PONG = "pong";

  ///Store listeners
  Map<String, List<Function>> _listeners = {};


  ///listen to an event
  on(String eventName, SocketEventListener listener) async {
    if (_listeners[eventName] == null) {
      _listeners[eventName] = [];
      _channel.invokeMethod("on", {"eventName": eventName});
    }
    _listeners[eventName].add(listener);
  }

  FlutterSocket() {
    _channel.setMethodCallHandler((call) async {
      _handleData(call.method, call.arguments);
    });
  }

  ///Data listener called by platform API
  _handleData(String eventName, List arguments) {
    _listeners[eventName]?.forEach((Function listener) {
      if (arguments.length == 0) {
        arguments = [null];
      } else {
        arguments = arguments.map((_) {
          try {
            return jsonDecode(_);
          } catch (e) {
            return _;
          }
        }).toList();
      }
      Function.apply(listener, arguments);
    });
  }



  static Future<bool> createSocket() async {
    return await _channel.invokeMethod("createSocket");
  }

  ///Listen to connect event
  onConnect(SocketEventListener listener) async {
    await on(CONNECT, listener);
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