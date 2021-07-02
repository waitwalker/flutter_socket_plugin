package cn.waitwalker.flutter_socket_plugin.jt808_sdk.oksocket.client.impl.client.abilities;


import cn.waitwalker.flutter_socket_plugin.jt808_sdk.oksocket.client.sdk.client.ConnectionInfo;
import cn.waitwalker.flutter_socket_plugin.jt808_sdk.oksocket.client.sdk.client.connection.IConnectionManager;

/**
 * Created by xuhao on 2017/6/30.
 */

public interface IConnectionSwitchListener {
    void onSwitchConnectionInfo(IConnectionManager manager, ConnectionInfo oldInfo, ConnectionInfo newInfo);
}
