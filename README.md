

Language: [English](README.md) | [中文简体](README-ZH.md)

# FlutterSocket

[![build status](https://img.shields.io/travis/flutterchina/dio/vm.svg?style=flat-square)](https://waitwalker.cn/2019/08/15/%E4%BA%A4%E6%B5%81%E7%BE%A4%E7%BB%84/)
[![Pub](https://img.shields.io/pub/v/flutter_socket_plugin.svg?style=flat-square)](https://pub.dartlang.org/packages/flutter_socket_plugin)
[![support](https://img.shields.io/badge/platform-flutter%7Cdart%20vm-ff69b4.svg?style=flat-square)](https://waitwalker.cn/2019/08/15/%E4%BA%A4%E6%B5%81%E7%BE%A4%E7%BB%84/)


FlutterSocket is a practical cross-platform socket plugin. At present, it has realized the basic functions of client side: create, connect, send, receive, disconnect and so on.
### If you need other functions, you can expand on this basis.

## Demo 

![Demo](https://github.com/waitwalker/Resources/blob/master/Flutter/FlutterSocket/socket_demo.gif?raw=true)

### Video
video url: https://www.youtube.com/watch?v=fmtwYHeOvE0
<video src="https://www.youtube.com/watch?v=fmtwYHeOvE0" controls="controls" width="500" height="300">Your browser does not support playing this video！</video>

## Add dependency

```yaml
dependencies:
  flutter_socket_plugin: lastest version  
```

## Simple to use

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


### Steps

Create `socket` :

```dart
await flutterSocket.createSocket("192.168.8.120", 10007, timeout: 20);
```

Connect `connect` :

```dart
flutterSocket.tryConnect();
```

Send message `send` :

```dart
flutterSocket.send(textEditingController.text);
```

Disconnect `disconnect` :

```dart
flutterSocket.tryDisconnect();
```


### Examples

you can find all examples code [here](https://github.com/waitwalker/flutter_socket_plugin/tree/master/example).

## Future

FlutterSocket currently implements the sending and receiving of basic String messages on the client. In the future, it will gradually improve its functions if conditions permit. If you need some functions urgently, you can continue to add functions on the basis of FlutterSocket to make the function of FlutterSocket more powerful and perfect.

## Copyright & License

This project is completely open source and the license is MIT. If you like, welcome star.

## Features and bugs

Please file feature requests and bugs at the [issue tracker][tracker].

[tracker]: https://github.com/waitwalker/flutter_socket_plugin/issues

## Flutter Technology and Other Communication Groups

wechat:dbzy_duzhao

Scan QR code👇:

<img src="https://github.com/waitwalker/Resources/blob/master/Flutter/group/flutter_development_0923.JPG?raw=true" width="350" height="500" align=center />

