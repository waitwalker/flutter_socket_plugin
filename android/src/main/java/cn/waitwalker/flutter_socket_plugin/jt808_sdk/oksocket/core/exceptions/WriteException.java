package cn.waitwalker.flutter_socket_plugin.jt808_sdk.oksocket.core.exceptions;

import android.annotation.SuppressLint;

/**
 * 写异常
 * Created by xuhao on 2017/5/16.
 */

public class WriteException extends RuntimeException {
    public WriteException() {
        super();
    }

    public WriteException(String message) {
        super(message);
    }

    public WriteException(String message, Throwable cause) {
        super(message, cause);
    }

    public WriteException(Throwable cause) {
        super(cause);
    }

    @SuppressLint("NewApi")
    protected WriteException(String message, Throwable cause, boolean enableSuppression, boolean writableStackTrace) {
        super(message, cause, enableSuppression, writableStackTrace);
    }
}
