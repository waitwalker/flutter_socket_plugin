package cn.waitwalker.flutter_socket_plugin;

import java.util.HashMap;
import java.util.Map;

import io.flutter.Log;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;
import io.flutter.plugin.common.PluginRegistry.Registrar;

/** FlutterSocketPlugin */
public class FlutterSocketPlugin implements MethodCallHandler {

  private Registrar registrar;

  /** Plugin registration. */
  public static void registerWith(Registrar registrar) {
    final MethodChannel channel = new MethodChannel(registrar.messenger(), "flutter_socket_plugin");
    channel.setMethodCallHandler(new FlutterSocketPlugin(registrar));
  }

  private FlutterSocketPlugin(Registrar registrar) {
    this.registrar = registrar;
  }

  @Override
  public void onMethodCall(MethodCall call, Result result) {
    FlutterSocket.sharedInstance().createChannel(registrar);
    if (call.method.equals("create_socket")) {

      Map dic = (Map) call.arguments;

      if (dic != null) {
        if (dic.containsKey("host") && dic.containsKey("port")) {
          String host = (String) dic.get("host");
          int port = (int) dic.get("port");
          int timeout = 30;
          if (dic.containsKey("timeout")) {
            timeout = (int) dic.get("timeout");
          }

          FlutterSocket.sharedInstance().createSocket(host,port,timeout);
        } else {

          Map<String, String> hashMap = new HashMap<>();
          hashMap.put("error_message","Host or port is required.");
          FlutterSocket.sharedInstance().invoke("error",hashMap.toString());
        }
      } else {
        Map<String, String> hashMap = new HashMap<>();
        hashMap.put("error_message","Host or port is required.");
        FlutterSocket.sharedInstance().invoke("error",hashMap.toString());
      }

    } else if (call.method.equals("try_connect")) {
      FlutterSocket.sharedInstance().tryConnect();

    } else if (call.method.equals("send_message")) {
      Map dic = (Map) call.arguments;
      if (dic.containsKey("message")) {
        String message = (String) dic.get("message");
        if (message != null) {
          FlutterSocket.sharedInstance().send(message);
        } else {
          Map<String, String> hashMap = new HashMap<>();
          hashMap.put("error_message","Sending content cannot be empty.");
          FlutterSocket.sharedInstance().invoke("error",hashMap.toString());
        }
      } else {
        Map<String, String> hashMap = new HashMap<>();
        hashMap.put("error_message","Sending content cannot be empty.");
        FlutterSocket.sharedInstance().invoke("error",hashMap.toString());
      }

    } else if (call.method.equals("try_disconnect")) {
      FlutterSocket.sharedInstance().tryDisconnect();
    } else {
      result.notImplemented();
    }
  }
}
