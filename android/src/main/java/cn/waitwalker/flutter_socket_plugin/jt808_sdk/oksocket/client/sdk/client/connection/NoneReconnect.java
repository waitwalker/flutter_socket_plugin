package cn.waitwalker.flutter_socket_plugin.jt808_sdk.oksocket.client.sdk.client.connection;


import cn.waitwalker.flutter_socket_plugin.jt808_sdk.oksocket.client.sdk.client.ConnectionInfo;

/**
 * 不进行重新连接的重连管理器
 * Created by Tony on 2017/10/24.
 */
public class NoneReconnect extends AbsReconnectionManager {
    @Override
    public void onSocketDisconnection(ConnectionInfo info, String action, Exception e) {

    }

    @Override
    public void onSocketConnectionSuccess(ConnectionInfo info, String action) {

    }

    @Override
    public void onSocketConnectionFailed(ConnectionInfo info, String action, Exception e) {

    }
}
