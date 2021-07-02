package cn.waitwalker.flutter_socket_plugin.jt808_sdk.sdk.socketbean;

import cn.waitwalker.flutter_socket_plugin.jt808_sdk.sdk.interfaces.SocketPulseListener;
import cn.waitwalker.flutter_socket_plugin.jt808_sdk.sdk.jt808coding.JT808Directive;
import cn.waitwalker.flutter_socket_plugin.jt808_sdk.sdk.SocketConfig;
import cn.waitwalker.flutter_socket_plugin.jt808_sdk.oksocket.core.iocore.interfaces.IPulseSendable;


public class PulseData implements IPulseSendable {

    public PulseData(){}
    private SocketPulseListener socketPulseListener;
    public PulseData(SocketPulseListener socketPulseListener){
        this.socketPulseListener = socketPulseListener;
    }

    @Override
    public byte[] parse() {
        byte[] body = JT808Directive.heartPkg(SocketConfig.getmPhont());
        if (socketPulseListener != null) socketPulseListener.parse(body);
        return body;
    }

}