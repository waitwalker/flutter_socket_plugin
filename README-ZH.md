

文档语言: [English](https://github.com/waitwalker/flutter_socket_plugin) | [中文简体](README-ZH.md)

# FlutterSocket

[![build status](https://img.shields.io/travis/flutterchina/dio/vm.svg?style=flat-square)](https://waitwalker.cn/2019/08/15/%E4%BA%A4%E6%B5%81%E7%BE%A4%E7%BB%84/)
[![Pub](https://img.shields.io/pub/v/flutter_socket_plugin.svg?style=flat-square)](https://pub.dartlang.org/packages/flutter_socket_plugin)
[![support](https://img.shields.io/badge/platform-flutter%7Cdart%20vm-ff69b4.svg?style=flat-square)](https://waitwalker.cn/2019/08/15/%E4%BA%A4%E6%B5%81%E7%BE%A4%E7%BB%84/)


FlutterSocket是一个实用的跨平台socket插件,目前已经实现client端的基本功能:创建,连接,发送消息,收消息,断开连接,心跳等功能...

## 添加依赖

```yaml
dependencies:
  flutter_socket_plugin: 0.0.1  
```

## 使用示例

```dart
import 'package:flutter_socket_plugin/flutter_socket_plugin.dart';
///
  /// @Method: initSocket
  /// @Parameter:
  /// @ReturnType:
  /// @Description: init socket
  /// @author: waitwalker
  /// @Date: 2019-08-23
  ///
  initSocket() {
    
    /// init socket
    flutterSocket = FlutterSocket();

    /// listen connect callback
    flutterSocket.connectListener((data){
      print("connect listener data:$data");
    });

    /// listen error callback
    flutterSocket.errorListener((data){
      print("error listener data:$data");
    });

    /// listen receive callback
    flutterSocket.receiveListener((data){
      print("receive listener data:$data");
      if (data != null) {
        receiveMessage = receiveMessage + "\n" + data;
      }
      setState(() {

      });
    });

    /// listen disconnect callback
    flutterSocket.disconnectListener((data){
      print("disconnect listener data:$data");
    });

  }
```


### 示例

创建 `socket` :

```dart
await flutterSocket.createSocket("192.168.8.120", 10007, timeout: 20);
```

发起连接 `connect` :

```dart
flutterSocket.tryConnect();
```

发送消息 `send` :

```dart
flutterSocket.send(textEditingController.text);
```

断开连接 `disconnect` :

```dart
flutterSocket.tryDisconnect();
```


### 示例目录

你可以在这里查看FlutterSocket的[全部示例](https://github.com/waitwalker/flutter_socket_plugin/tree/master/example).

## 未来

FlutterSocket目前实现了客户端基本String消息的收发,未来在条件允许的情况下,逐步完善功能,如果你急需一些功能,你可以在FlutterSocket的基础上继续添加功能,让FlutterSocket功能更加强大和完善!

## Copyright & License

此项目为完全开源 ，license 是 MIT.   如果您喜欢，欢迎star.

## Features and bugs

Please file feature requests and bugs at the [issue tracker][tracker].

[tracker]: https://github.com/waitwalker/flutter_socket_plugin


