package cn.waitwalker.flutter_socket_plugin.jt808_sdk.oksocket.interfaces.common_interfacies.server;

import cn.waitwalker.flutter_socket_plugin.jt808_sdk.oksocket.interfaces.common_interfacies.client.IDisConnectable;
import cn.waitwalker.flutter_socket_plugin.jt808_sdk.oksocket.interfaces.common_interfacies.client.ISender;
import cn.waitwalker.flutter_socket_plugin.jt808_sdk.oksocket.core.protocol.IReaderProtocol;

import java.io.Serializable;

public interface IClient extends IDisConnectable, ISender<IClient>, Serializable {

    String getHostIp();

    String getHostName();

    String getUniqueTag();

    void setReaderProtocol(IReaderProtocol protocol);

    void addIOCallback(IClientIOCallback clientIOCallback);

    void removeIOCallback(IClientIOCallback clientIOCallback);

    void removeAllIOCallback();

}
