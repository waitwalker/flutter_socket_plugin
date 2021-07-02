package cn.waitwalker.flutter_socket_plugin.jt808_sdk.oksocket.core.iocore.interfaces;


import java.io.OutputStream;

/**
 * Created by xuhao on 2017/5/16.
 */

public interface IWriter<T extends IIOCoreOptions> {

    void initialize(OutputStream outputStream, IStateSender stateSender);

    boolean write() throws RuntimeException;

    void setOption(T option);

    void offer(ISendable sendable);

    void close();

}
