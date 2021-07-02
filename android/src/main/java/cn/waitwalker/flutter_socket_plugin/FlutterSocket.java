package cn.waitwalker.flutter_socket_plugin;


import android.os.Handler;
import android.os.Looper;
import android.util.Log;

import cn.waitwalker.flutter_socket_plugin.jt808_sdk.oksocket.client.impl.client.action.ActionDispatcher;
import cn.waitwalker.flutter_socket_plugin.jt808_sdk.oksocket.client.sdk.OkSocket;
import cn.waitwalker.flutter_socket_plugin.jt808_sdk.oksocket.client.sdk.client.ConnectionInfo;
import cn.waitwalker.flutter_socket_plugin.jt808_sdk.oksocket.client.sdk.client.OkSocketOptions;
import cn.waitwalker.flutter_socket_plugin.jt808_sdk.oksocket.client.sdk.client.action.SocketActionAdapter;
import cn.waitwalker.flutter_socket_plugin.jt808_sdk.oksocket.client.sdk.client.connection.IConnectionManager;
import cn.waitwalker.flutter_socket_plugin.jt808_sdk.oksocket.client.sdk.client.connection.NoneReconnect;
import cn.waitwalker.flutter_socket_plugin.jt808_sdk.oksocket.core.iocore.interfaces.IPulseSendable;
import cn.waitwalker.flutter_socket_plugin.jt808_sdk.oksocket.core.iocore.interfaces.ISendable;
import cn.waitwalker.flutter_socket_plugin.jt808_sdk.oksocket.core.pojo.OriginalData;
import cn.waitwalker.flutter_socket_plugin.jt808_sdk.oksocket.core.protocol.IReaderProtocol;

import java.nio.ByteBuffer;
import java.nio.ByteOrder;
import java.nio.charset.Charset;
import java.nio.charset.StandardCharsets;
import java.util.HashMap;
import java.util.Map;

import cn.waitwalker.flutter_socket_plugin.jt808_sdk.sdk.SocketConfig;
import cn.waitwalker.flutter_socket_plugin.jt808_sdk.sdk.jt808coding.JTT808Coding;
import cn.waitwalker.flutter_socket_plugin.jt808_sdk.sdk.socketbean.SendDataBean;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.PluginRegistry;

public class FlutterSocket {

    /** connection info */
    private ConnectionInfo info;

    /** socket */
    private IConnectionManager socket;

    /** instance */
    private static FlutterSocket flutterSocket;

    /** method channel */
    private MethodChannel methodChannel;

    private FlutterSocket() {}

    /** Singleton*/
    public static FlutterSocket sharedInstance() {
        return SingletonHolder.instance();
    }

    private static class SingletonHolder {
        public static FlutterSocket instance() {
            if (flutterSocket == null) {
                flutterSocket = new FlutterSocket();
            }
            return flutterSocket;
        }
    }

    /**
     * createChannel
     * */
    public void createChannel(PluginRegistry.Registrar registrar) {
        if (methodChannel == null) {
            methodChannel = new MethodChannel(registrar.messenger(),"flutter_socket_plugin");
        }
    }

    /**
     * create socket
     * */
    public void createSocket(String host, int port, int timeout) {
        info = new ConnectionInfo(host, port);
        final Handler handler = new Handler(Looper.getMainLooper());
        OkSocketOptions.Builder builder = new OkSocketOptions.Builder();
        builder.setReconnectionManager(new NoneReconnect());
        builder.setConnectTimeoutSecond(timeout);
        builder.setCallbackThreadModeToken(new OkSocketOptions.ThreadModeToken() {
            @Override
            public void handleCallbackEvent(ActionDispatcher.ActionRunnable runnable) {
                handler.post(runnable);
            }
        });

        builder.setReaderProtocol(new IReaderProtocol() {
            @Override
            public int getHeaderLength() {
                return 4;
            }

            @Override
            public int getBodyLength(byte[] header, ByteOrder byteOrder) {
                ByteBuffer byteBuffer = ByteBuffer.allocate(header.length);
                byteBuffer.order(byteOrder);
                byteBuffer.put(header);
                int value = byteBuffer.getInt(0);
                return value;
            }
        });
        socket = OkSocket.open(info).option(builder.build());
        socket.registerReceiver(adapter);
    }

    /**
     * try connect
     * */
    public void tryConnect() {
        if (!socket.isConnect()) {
            socket.connect();
        }
    }

    /**
     * send message
     * */
    public void send(String message) {

        if (socket == null) {
            return;
        }
        if (!socket.isConnect()) {
            Log.d("SendTag","have disconnected");
        } else {
            byte[] body = JTT808Coding.generate808(0X0001, SocketConfig.getmPhont(), message.getBytes(Charset.forName("UTF-8")), 0, 0, SocketConfig.getSocketMsgCount());
            socket.send(new SendDataBean(body));
        }
    }

    /**
     * try disconnect
     * */
    public void tryDisconnect() {
        socket.disconnect();
    }

    /**
     * android invoke flutter method
     * */
    public void invoke(String methodName, String arguments) {
        methodChannel.invokeMethod(methodName,arguments);
    }

    /**
     * listen socket status
     *
     * */
    private SocketActionAdapter adapter = new SocketActionAdapter() {

        @Override
        public void onSocketConnectionSuccess(ConnectionInfo info, String action) {
            invoke("connected","connected");
        }

        @Override
        public void onSocketDisconnection(ConnectionInfo info, String action, Exception e) {
            if (e != null) {
                FlutterSocket.sharedInstance().invoke("error",e.getLocalizedMessage());
            } else {
                invoke("disconnect","disconnected");
            }
        }

        @Override
        public void onSocketConnectionFailed(ConnectionInfo info, String action, Exception e) {
            FlutterSocket.sharedInstance().invoke("error",e.getLocalizedMessage());
        }

        @Override
        public void onSocketReadResponse(ConnectionInfo info, String action, OriginalData data) {
            String str = new String(data.getBodyBytes(), Charset.forName("utf-8"));
            Log.d("Receive",str);
            invoke("receive_message",str);
        }

        @Override
        public void onSocketWriteResponse(ConnectionInfo info, String action, ISendable data) {
            SendDataBean msgDataBean = (SendDataBean) data;
            byte[] data1 = msgDataBean.parse();
            String str = new String(data1, Charset.forName("UTF-8"));
            str = str.substring(13);
            str = str.substring(0,str.length() -2);
            Log.d("Write response",str);
        }

        @Override
        public void onPulseSend(ConnectionInfo info, IPulseSendable data) {
            String str = new String(data.parse(), Charset.forName("utf-8"));
            Log.d("Pulse send",str);
        }

        @Override
        public void onSocketIOThreadShutdown(String action, Exception e) {
            FlutterSocket.sharedInstance().invoke("error",e.getLocalizedMessage());
            super.onSocketIOThreadShutdown(action, e);
        }
    };

    public void clearSendSocketData() {
        flutterSocket = null;
    }
}