package cn.waitwalker.flutter_socket_plugin.jt808_sdk.sdk.interfaces;

public interface SocketPulseListener {
// 每次心跳发送成功的回调
    void parse(byte[] bytes);

}