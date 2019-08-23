import 'dart:async';
import 'package:flutter/services.dart';

/// Call back closure
typedef void CallBackClosure(dynamic data);

///
/// @Class: FlutterSocket
/// @Description: FlutterSocket class
/// @author: lca
/// @Date: 2019-08-21
///
class FlutterSocket {

  /// method channel
  static const MethodChannel _channel = const MethodChannel('flutter_socket_plugin');

  /// Create socket
  static const String create_socket = "create_socket";

  /// Socket try connect
  static const String try_connect = "try_connect";

  /// Socket connected
  static const String connected = "connected";

  ///  Socket error
  static const String error = "error";

  ///  Socket connect error
  static const String connect_error = "connect_error";

  /// Socket send message
  static const String send_message = "send_message";

  /// Socket send error
  static const String send_error = "send_error";

  /// Socket receive message
  static const String receive_message = "receive_message";

  /// Socket try disconnect
  static const String try_disconnect = "try_disconnect";

  /// Socket disconnect
  static const String disconnect = "disconnect";

  /// _closures (key: methodName, value:CallBackClosure)
  Map<String, Function> _closures = {};

  ///
  /// @Method: FlutterSocket()
  /// @Parameter: 
  /// @ReturnType: 
  /// @Description: create instance
  /// @author: lca
  /// @Date: 2019-08-21
  ///
  FlutterSocket() {
    _channel.setMethodCallHandler((call) async {
      var method = call.method;
      var arguments = call.arguments;
      print("method:$method; arguments:$arguments");
      _handleCallBack(method, arguments);
    });
  }

  ///
  /// @Method: _listen
  /// @Parameter: String methodName, CallBackClosure closure
  /// @ReturnType:
  /// @Description: listen call back closure
  /// @author: lca
  /// @Date: 2019-08-21
  ///
  _listen(String methodName, CallBackClosure closure) async {
    _closures[methodName] = closure;
  }

  ///
  /// @Method: _handleCallBack
  /// @Parameter: String methodName, var arguments
  /// @ReturnType: null
  /// @Description: handle native to flutter and call back to user
  /// @author: lca
  /// @Date: 2019-08-21
  ///
  _handleCallBack(String methodName, var arguments) {
    print("_listeners:${_closures.length}");
    var function = _closures[methodName];
    /// 调用函数
    Function.apply(function, [arguments]);
  }

  ///
  /// @Method: createSocket
  /// @Parameter: null
  /// @ReturnType: Future<bool>
  /// @Description: create socket
  /// @author: lca
  /// @Date: 2019-08-21
  ///
  Future<bool> createSocket() async {
    return await _channel.invokeMethod(create_socket);
  }

  ///
  /// @Method: tryConnect
  /// @Parameter: String host, int port, int timeout
  /// @ReturnType: Future<void>
  /// @Description: try connect,to not time out use a negative time interval
  /// @author: lca
  /// @Date: 2019-08-21
  ///
  Future<void> tryConnect(String host, int port, {timeout = 30}) async {
    Map arguments = {
      "host":host,
      "port":port,
      "timeout":timeout
    };
    await _channel.invokeMethod(try_connect,arguments);
  }

  ///
  /// @Method: send
  /// @Parameter: String message
  /// @ReturnType:
  /// @Description: send message
  /// @author: lca
  /// @Date: 2019-08-21
  ///
  Future<void> send(String message) async {
    await _channel.invokeMethod(send_message,{"message":message});
  }

  /// @Method: tryDisconnect
  /// @Parameter: null
  /// @ReturnType: null
  /// @Description: socket try disconnect
  /// @author: lca
  /// @Date: 2019-08-21
  ///
  Future<void> tryDisconnect() async {
    await _channel.invokeMethod(try_disconnect);
  }

  ///
  /// @Method: connectListener
  /// @Parameter: CallBackClosure closure
  /// @ReturnType: 
  /// @Description: listen socket connect status
  /// @author: lca
  /// @Date: 2019-08-21
  ///
  connectListener(CallBackClosure closure) async => await _listen(connected, closure);

  ///
  /// @Method: errorListener
  /// @Parameter: CallBackClosure closure
  /// @ReturnType:
  /// @Description: listen socket errors
  /// @author: lca
  /// @Date: 2019-08-21
  ///
  errorListener(CallBackClosure closure) async => await _listen(error, closure);

  ///
  /// @Method: receiveListener
  /// @Parameter: CallBackClosure closure
  /// @ReturnType:
  /// @Description: listen socket receive message status
  /// @author: lca
  /// @Date: 2019-08-21
  ///
  receiveListener(CallBackClosure closure) async => await _listen(receive_message, closure);


  ///
  /// @Method: disconnectListener
  /// @Parameter: CallBackClosure closure
  /// @ReturnType:
  /// @Description: listen socket disconnect status
  /// @author: lca
  /// @Date: 2019-08-21
  ///
  disconnectListener(CallBackClosure closure) async => await _listen(disconnect, closure);
  



}