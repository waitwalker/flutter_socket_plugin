package cn.waitwalker.flutter_socket_plugin.jt808_sdk.oksocket.client.impl.client.action;


import cn.waitwalker.flutter_socket_plugin.jt808_sdk.oksocket.client.impl.exceptions.ManuallyDisconnectException;
import cn.waitwalker.flutter_socket_plugin.jt808_sdk.oksocket.client.sdk.client.ConnectionInfo;
import cn.waitwalker.flutter_socket_plugin.jt808_sdk.oksocket.client.sdk.client.OkSocketOptions;
import cn.waitwalker.flutter_socket_plugin.jt808_sdk.oksocket.client.sdk.client.action.ISocketActionListener;
import cn.waitwalker.flutter_socket_plugin.jt808_sdk.oksocket.client.sdk.client.action.SocketActionAdapter;
import cn.waitwalker.flutter_socket_plugin.jt808_sdk.oksocket.client.sdk.client.connection.IConnectionManager;
import cn.waitwalker.flutter_socket_plugin.jt808_sdk.oksocket.interfaces.common_interfacies.dispatcher.IRegister;

/**
 * Created by xuhao on 2017/5/18.
 */

public class ActionHandler extends SocketActionAdapter {
    private IConnectionManager mManager;

    private OkSocketOptions.IOThreadMode mCurrentThreadMode;

    private boolean iOThreadIsCalledDisconnect = false;

    public ActionHandler() {

    }

    public void attach(IConnectionManager manager, IRegister<ISocketActionListener, IConnectionManager> register) {
        this.mManager = manager;
        register.registerReceiver(this);
    }

    public void detach(IRegister register) {
        register.unRegisterReceiver(this);
    }

    @Override
    public void onSocketIOThreadStart(String action) {
        if (mManager.getOption().getIOThreadMode() != mCurrentThreadMode) {
            mCurrentThreadMode = mManager.getOption().getIOThreadMode();
        }
        iOThreadIsCalledDisconnect = false;
    }

    @Override
    public void onSocketIOThreadShutdown(String action, Exception e) {
        if (mCurrentThreadMode != mManager.getOption().getIOThreadMode()) {//切换线程模式,不需要断开连接
            //do nothing
        } else {//多工模式
            if (!iOThreadIsCalledDisconnect) {//保证只调用一次,多工多线程,会调用两次
                iOThreadIsCalledDisconnect = true;
                if (!(e instanceof ManuallyDisconnectException)) {
                    mManager.disconnect(e);
                }
            }
        }
    }

    @Override
    public void onSocketConnectionFailed(ConnectionInfo info, String action, Exception e) {
        mManager.disconnect(e);
    }
}
