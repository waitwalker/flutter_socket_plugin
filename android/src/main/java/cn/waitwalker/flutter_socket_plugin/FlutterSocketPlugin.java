package cn.waitwalker.flutter_socket_plugin;

import java.util.Map;

import io.flutter.Log;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;
import io.flutter.plugin.common.PluginRegistry.Registrar;

/** FlutterSocketPlugin */
public class FlutterSocketPlugin implements MethodCallHandler {
  /** Plugin registration. */
  public static void registerWith(Registrar registrar) {
    final MethodChannel channel = new MethodChannel(registrar.messenger(), "flutter_socket_plugin");
    channel.setMethodCallHandler(new FlutterSocketPlugin());
    FlutterSocket.sharedInstance().createChannel(registrar);
  }

  @Override
  public void onMethodCall(MethodCall call, Result result) {
    if (call.method.equals("create_socket")) {

      Map dic = (Map) call.arguments;

      if (dic != null) {
        if (dic.containsKey("host") && dic.containsKey("port")) {
          String host = (String) dic.get("host");
          int port = (int) dic.get("port");
          int timeout = 30000;
          if (dic.containsKey("timeout")) {
            timeout = (int) dic.get("timeout");
            timeout = timeout * 1000;
          }

          FlutterSocket.sharedInstance().createSocket(host,port,timeout);
        } else {

        }
      } else {

      }

    } else {
      result.notImplemented();
    }
  }
}
