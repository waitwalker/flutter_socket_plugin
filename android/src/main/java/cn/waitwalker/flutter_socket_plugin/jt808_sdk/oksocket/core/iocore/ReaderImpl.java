package cn.waitwalker.flutter_socket_plugin.jt808_sdk.oksocket.core.iocore;

import cn.waitwalker.flutter_socket_plugin.jt808_sdk.oksocket.core.exceptions.ReadException;
import cn.waitwalker.flutter_socket_plugin.jt808_sdk.oksocket.core.iocore.interfaces.IOAction;
import cn.waitwalker.flutter_socket_plugin.jt808_sdk.oksocket.core.pojo.OriginalData;

import java.io.ByteArrayOutputStream;
import java.io.DataInputStream;
import java.io.InputStream;


/**
 * Created by xuhao on 2017/5/31.
 */

public class ReaderImpl extends AbsReader {
    /*
    * CCB改： 必须有消息头的接收方式 ， 不符合JT808协议；
    private ByteBuffer mRemainingBuf;

    @Override
    public void read() throws RuntimeException {
        OriginalData originalData = new OriginalData();
        IReaderProtocol headerProtocol = mOkOptions.getReaderProtocol();
        int headerLength = headerProtocol.getHeaderLength();
        ByteBuffer headBuf = ByteBuffer.allocate(headerLength);
        headBuf.order(mOkOptions.getReadByteOrder());
        try {
            if (mRemainingBuf != null) {
                mRemainingBuf.flip();
                int length = Math.min(mRemainingBuf.remaining(), headerLength);
                headBuf.put(mRemainingBuf.array(), 0, length);
                if (length < headerLength) {
                    //there are no data left
                    mRemainingBuf = null;
                    readHeaderFromChannel(headBuf, headerLength - length);
                } else {
                    mRemainingBuf.position(headerLength);
                }
            } else {
                readHeaderFromChannel(headBuf, headBuf.capacity());
            }
            originalData.setHeadBytes(headBuf.array());
            if (SLog.isDebug()) {
                SLog.i("read head: " + BytesUtils.toHexStringForLog(headBuf.array()));
            }
            int bodyLength = headerProtocol.getBodyLength(originalData.getHeadBytes(), mOkOptions.getReadByteOrder());
            if (SLog.isDebug()) {
                SLog.i("need read body length: " + bodyLength);
            }
            if (bodyLength > 0) {
                if (bodyLength > mOkOptions.getMaxReadDataMB() * 1024 * 1024) {
                    throw new ReadException("Need to follow the transmission protocol.\r\n" +
                            "Please check the client/server code.\r\n" +
                            "According to the packet header data in the transport protocol, the package length is " + bodyLength + " Bytes.\r\n" +
                            "You need check your <ReaderProtocol> definition");
                }
                ByteBuffer byteBuffer = ByteBuffer.allocate(bodyLength);
                byteBuffer.order(mOkOptions.getReadByteOrder());
                if (mRemainingBuf != null) {
                    int bodyStartPosition = mRemainingBuf.position();
                    int length = Math.min(mRemainingBuf.remaining(), bodyLength);
                    byteBuffer.put(mRemainingBuf.array(), bodyStartPosition, length);
                    mRemainingBuf.position(bodyStartPosition + length);
                    if (length == bodyLength) {
                        if (mRemainingBuf.remaining() > 0) {//there are data left
                            ByteBuffer temp = ByteBuffer.allocate(mRemainingBuf.remaining());
                            temp.order(mOkOptions.getReadByteOrder());
                            temp.put(mRemainingBuf.array(), mRemainingBuf.position(), mRemainingBuf.remaining());
                            mRemainingBuf = temp;
                        } else {//there are no data left
                            mRemainingBuf = null;
                        }
                        //cause this time data from remaining buffer not from channel.
                        originalData.setBodyBytes(byteBuffer.array());
                        mStateSender.sendBroadcast(IOAction.ACTION_READ_COMPLETE, originalData);
                        return;
                    } else {//there are no data left in buffer and some data pieces in channel
                        mRemainingBuf = null;
                    }
                }
                readBodyFromChannel(byteBuffer);
                originalData.setBodyBytes(byteBuffer.array());
            } else if (bodyLength == 0) {
                originalData.setBodyBytes(new byte[0]);
                if (mRemainingBuf != null) {
                    //the body is empty so header remaining buf need set null
                    if (mRemainingBuf.hasRemaining()) {
                        ByteBuffer temp = ByteBuffer.allocate(mRemainingBuf.remaining());
                        temp.order(mOkOptions.getReadByteOrder());
                        temp.put(mRemainingBuf.array(), mRemainingBuf.position(), mRemainingBuf.remaining());
                        mRemainingBuf = temp;
                    } else {
                        mRemainingBuf = null;
                    }
                }
            } else if (bodyLength < 0) {
                throw new ReadException(
                        "read body is wrong,this socket input stream is end of file read " + bodyLength + " ,that mean this socket is disconnected by server");
            }
            mStateSender.sendBroadcast(IOAction.ACTION_READ_COMPLETE, originalData);
        } catch (Exception e) {
            ReadException readException = new ReadException(e);
            throw readException;
        }
    }

    private void readHeaderFromChannel(ByteBuffer headBuf, int readLength) throws IOException {
        for (int i = 0; i < readLength; i++) {
            byte[] bytes = new byte[1];
            int value = mInputStream.read(bytes);
            if (value == -1) {
                throw new ReadException(
                        "read head is wrong, this socket input stream is end of file read " + value + " ,that mean this socket is disconnected by server");
            }
            headBuf.put(bytes);
        }
    }


    private void readBodyFromChannel(ByteBuffer byteBuffer) throws IOException {
        while (byteBuffer.hasRemaining()) {
            try {
                byte[] bufArray = new byte[mOkOptions.getReadPackageBytes()];
                int len = mInputStream.read(bufArray);
                if (len == -1) {
                    break;
                }
                int remaining = byteBuffer.remaining();
                if (len > remaining) {
                    byteBuffer.put(bufArray, 0, remaining);
                    mRemainingBuf = ByteBuffer.allocate(len - remaining);
                    mRemainingBuf.order(mOkOptions.getReadByteOrder());
                    mRemainingBuf.put(bufArray, remaining, len - remaining);
                } else {
                    byteBuffer.put(bufArray, 0, len);
                }
            } catch (Exception e) {
                throw e;
            }
        }
        if (SLog.isDebug()) {
            SLog.i("read total bytes: " + BytesUtils.toHexStringForLog(byteBuffer.array()));
            SLog.i("read total length:" + (byteBuffer.capacity() - byteBuffer.remaining()));
        }
    }
    */

    //接收byte数组
    @Override
    public void read() throws RuntimeException {
        OriginalData originalData = new OriginalData();
        try {
            InputStream is = mInputStream;
            DataInputStream input = new DataInputStream(is);
            byte[] b = new byte[1024 * 1024];
            ByteArrayOutputStream bos = new ByteArrayOutputStream();

            int len = 0;
            while (true) {
                len = input.read(b);
                bos.write(b, 0, len);
                originalData.setBodyBytes(bos.toByteArray());
                mStateSender.sendBroadcast(IOAction.ACTION_READ_COMPLETE, originalData);
                bos.reset();
            }
        } catch (Exception e) {
            ReadException readException = new ReadException(e);
            throw readException;
        }
    }
}
