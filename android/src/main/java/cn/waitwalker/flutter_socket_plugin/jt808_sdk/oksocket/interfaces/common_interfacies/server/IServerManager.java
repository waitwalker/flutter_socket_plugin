package cn.waitwalker.flutter_socket_plugin.jt808_sdk.oksocket.interfaces.common_interfacies.server;

import cn.waitwalker.flutter_socket_plugin.jt808_sdk.oksocket.core.iocore.interfaces.IIOCoreOptions;

public interface IServerManager<E extends IIOCoreOptions> extends IServerShutdown {

    void listen();

    void listen(E options);

    boolean isLive();

    IClientPool<String, IClient> getClientPool();
}
