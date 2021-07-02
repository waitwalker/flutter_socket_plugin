package cn.waitwalker.flutter_socket_plugin.jt808_sdk.oksocket.client.sdk.client.connection.abilities;


import cn.waitwalker.flutter_socket_plugin.jt808_sdk.oksocket.client.sdk.client.OkSocketOptions;
import cn.waitwalker.flutter_socket_plugin.jt808_sdk.oksocket.client.sdk.client.connection.IConnectionManager;

/**
 * Created by xuhao on 2017/5/16.
 */

public interface IConfiguration {
    /**
     * 修改参数配置
     *
     * @param okOptions 新的参数配置
     * @return 当前的链接管理器
     */
    IConnectionManager option(OkSocketOptions okOptions);

    /**
     * 获得当前连接管理器的参数配置
     *
     * @return 参数配置
     */
    OkSocketOptions getOption();
}
