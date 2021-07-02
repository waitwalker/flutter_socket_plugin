package cn.waitwalker.flutter_socket_plugin.jt808_sdk.oksocket.interfaces.common_interfacies.server;


import cn.waitwalker.flutter_socket_plugin.jt808_sdk.oksocket.core.iocore.interfaces.ISendable;

public interface IClientPool<T, K> {

    void cache(T t);

    T findByUniqueTag(K key);

    int size();

    void sendToAll(ISendable sendable);
}
