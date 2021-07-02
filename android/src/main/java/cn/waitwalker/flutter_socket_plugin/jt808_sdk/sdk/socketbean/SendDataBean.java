package cn.waitwalker.flutter_socket_plugin.jt808_sdk.sdk.socketbean;

import cn.waitwalker.flutter_socket_plugin.jt808_sdk.oksocket.core.iocore.interfaces.ISendable;


public class SendDataBean implements ISendable {
    private byte[] body;

    public SendDataBean(byte[] body) {
        this.body = body;
    }

    @Override
    public byte[] parse() {
       return body;
    }



}