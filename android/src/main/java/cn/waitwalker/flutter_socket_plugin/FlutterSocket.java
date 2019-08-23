package cn.waitwalker.flutter_socket_plugin;


import android.os.Handler;
import android.os.Looper;
import android.util.Log;

import com.xuhao.didi.core.iocore.interfaces.IPulseSendable;
import com.xuhao.didi.core.iocore.interfaces.ISendable;
import com.xuhao.didi.core.pojo.OriginalData;
import com.xuhao.didi.core.protocol.IReaderProtocol;
import com.xuhao.didi.socket.client.impl.client.action.ActionDispatcher;
import com.xuhao.didi.socket.client.sdk.OkSocket;
import com.xuhao.didi.socket.client.sdk.client.ConnectionInfo;
import com.xuhao.didi.socket.client.sdk.client.OkSocketOptions;
import com.xuhao.didi.socket.client.sdk.client.action.SocketActionAdapter;
import com.xuhao.didi.socket.client.sdk.client.connection.IConnectionManager;
import com.xuhao.didi.socket.client.sdk.client.connection.NoneReconnect;

import java.nio.ByteBuffer;
import java.nio.ByteOrder;
import java.nio.charset.Charset;

public class FlutterSocket {

    private ConnectionInfo info;
    private IConnectionManager socket;
    private static FlutterSocket flutterSocket;

    private FlutterSocket() {

    }

    /*单例*/
    public static FlutterSocket sharedInstance() {
        return SingletonHolder.instance();
    }

    String uri = "192.168.8.120";

    /**
     * create socket
     *
     * */
    public void createSocket() {
        info = new ConnectionInfo(uri, 10007);
        final Handler handler = new Handler(Looper.getMainLooper());
        OkSocketOptions.Builder builder = new OkSocketOptions.Builder();
        builder.setReconnectionManager(new NoneReconnect());
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
     *
     * */
    public void tryConnect() {
        if (socket == null) {
            return;
        }
        if (!socket.isConnect()) {
            socket.connect();
        }
    }

    /**
     * send
     * */
    public void send(String message) {

        if (socket == null) {
            return;
        }
        if (!socket.isConnect()) {
            Log.d("SendTag","have disconnected");
        } else {
            MsgDataBean msgDataBean = new MsgDataBean(message);
            socket.send(msgDataBean);
        }
    }

    public void tryDisconnect() {
        socket.disconnect();
    }

    /**
     * 监听socket状态
     *
     * */
    private SocketActionAdapter adapter = new SocketActionAdapter() {

        @Override
        public void onSocketConnectionSuccess(ConnectionInfo info, String action) {
            //socket.send(new HandShakeBean());
            Log.d("Connect","have connected");
        }

        @Override
        public void onSocketDisconnection(ConnectionInfo info, String action, Exception e) {
            if (e != null) {
                Log.d("Disconnect","disconnected error");
            } else {
                Log.d("Disconnect","have disconnected");
            }
        }

        @Override
        public void onSocketConnectionFailed(ConnectionInfo info, String action, Exception e) {
            Log.d("Connect","connected error");
        }

        @Override
        public void onSocketReadResponse(ConnectionInfo info, String action, OriginalData data) {

            byte[] bodyBytes  = data.getBodyBytes();
            byte[] headBytes = data.getHeadBytes();

            String string = new String(data.getHeadBytes(), Charset.forName("utf-8"));
            String str = new String(data.getBodyBytes(), Charset.forName("utf-8"));
            Log.d("Receive",str);
        }

        @Override
        public void onSocketWriteResponse(ConnectionInfo info, String action, ISendable data) {

            MsgDataBean msgDataBean = (MsgDataBean) data;
            String str = msgDataBean.content;
            Log.d("Write response",str);
        }

        @Override
        public void onPulseSend(ConnectionInfo info, IPulseSendable data) {
            String str = new String(data.parse(), Charset.forName("utf-8"));
            Log.d("Pulse send",str);
        }

        @Override
        public void onSocketIOThreadShutdown(String action, Exception e) {

            Log.d("Exception",e.getLocalizedMessage());
            super.onSocketIOThreadShutdown(action, e);
        }
    };


    public void clearSendSocketData() {
        flutterSocket = null;
    }

    private static class SingletonHolder {
        public static FlutterSocket instance() {
            if (flutterSocket == null) {
                flutterSocket = new FlutterSocket();
            }
            return flutterSocket;
        }
    }
}