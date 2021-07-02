package cn.waitwalker.flutter_socket_plugin.jt808_sdk.oksocket.core.iocore.interfaces;

import cn.waitwalker.flutter_socket_plugin.jt808_sdk.oksocket.core.protocol.IReaderProtocol;

import java.nio.ByteOrder;

public interface IIOCoreOptions {

    ByteOrder getReadByteOrder();

    int getMaxReadDataMB();

    IReaderProtocol getReaderProtocol();

    ByteOrder getWriteByteOrder();

    int getReadPackageBytes();

    int getWritePackageBytes();

    boolean isDebug();

}
