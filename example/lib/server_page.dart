import 'package:flutter/material.dart';
import 'dart:io';
import 'dart:typed_data';

///
/// @description Socket Server sample code
/// @author waitwalker
/// @time 2021/6/30 17:07
///
class ServerPage extends StatefulWidget {
  ServerPage({Key? key}) : super(key: key);
  @override
  _ServerPageState createState() => _ServerPageState();
}

class _ServerPageState extends State<ServerPage> {

  bool connected = false;
  String _host = "192.168.10.63";
  int _port = 10007;
  String receiveMessage = "";
  TextEditingController textEditingController = TextEditingController();

  ServerSocket? _serverSocket;
  Socket? _socketSample;

  @override
  void initState() {

    textEditingController.addListener((){
      print("input text:${textEditingController.text}");
    });
    super.initState();
  }

  ///
  /// @description create socket server
  /// @param
  /// @return
  /// @author waitwalker
  /// @time 2021/6/30 14:42
  ///
  _createSocket() async {
    _serverSocket = await ServerSocket.bind(InternetAddress.anyIPv4, _port, shared: true, v6Only: false);
    print("object:$_serverSocket");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Socket Server",style: TextStyle(fontSize: 18,color: Colors.white),),
        backgroundColor: Colors.lightBlue,
      ),
      body: Column(
        children: <Widget>[
          Expanded(child: ListView(children: [
            Padding(
              padding: EdgeInsets.only(top: 30,left: 20,right: 20),
              child: Row(
                children: <Widget>[
                  Text("Host:",style: TextStyle(fontSize: 22,color: Colors.lightBlueAccent,fontWeight: FontWeight.w600),),
                  Padding(padding: EdgeInsets.only(left: 10),),
                  Container(
                    decoration: BoxDecoration(
                      border: Border(bottom: BorderSide(color: Colors.redAccent,width: 1.0)),
                    ),
                    child: Text(_host,style: TextStyle(fontSize: 18,color: Colors.black87,fontWeight: FontWeight.w300),),
                  ),
                  Padding(padding: EdgeInsets.only(left: 30),),
                  Text("Port:",style: TextStyle(fontSize: 22,color: Colors.lightBlueAccent,fontWeight: FontWeight.w600),),
                  Padding(padding: EdgeInsets.only(left: 10),),
                  Container(
                    decoration: BoxDecoration(
                      border: Border(bottom: BorderSide(color: Colors.redAccent,width: 1.0)),
                    ),
                    child: Text("$_port",style: TextStyle(fontSize: 18,color: Colors.black87,fontWeight: FontWeight.w300),),
                  ),
                ],
              ),
            ),

            Padding(
              padding: EdgeInsets.only(left: 20,right: 20,top: 30),
              child: Row(
                children: <Widget>[
                  ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor: ButtonStyleButton.allOrNull<Color>(Colors.lightBlueAccent),
                    ),
                    child: Text("Listen",style: TextStyle(fontSize: 18,color: Colors.white,fontWeight: FontWeight.w500),),
                    onPressed: () async {
                      _createSocket();
                      // start listen to
                      _serverSocket!.listen((client) {
                        _handleListen(client);
                      });
                    },
                  ),
                ],
              ),
            ),

            Padding(
              padding: EdgeInsets.only(left: 20,right: 20,top: 30,),
              child: Container(
                height: 150,
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.lightBlueAccent,width: 1.0)
                ),
                child: TextField(
                  controller: textEditingController,
                  decoration: InputDecoration(
                      labelText: "Input content",
                      border: InputBorder.none
                  ),
                ),
              ),
            ),

            Padding(
              padding: EdgeInsets.only(left: 20,right: 20,top: 10),
              child: Container(
                alignment: Alignment.centerLeft,
                child: ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor: ButtonStyleButton.allOrNull<Color>(Colors.lightBlueAccent),
                  ),
                  child: Text("Send",style: TextStyle(fontSize: 18,color: Colors.white,fontWeight: FontWeight.w500),),
                  onPressed: (){
                    _socketSample!.write(textEditingController.text);
                  },),
              ),
            ),

            Padding(
              padding: EdgeInsets.only(left: 20,right: 20,top: 30),
              child: Container(
                alignment: Alignment.centerLeft,
                child: ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor: ButtonStyleButton.allOrNull<Color>(Colors.lightBlueAccent),
                  ),
                  child: Text("Receive Data",style: TextStyle(fontSize: 18,color: Colors.white,fontWeight: FontWeight.w500),),
                  onPressed: (){},),
              ),
            ),

            Padding(
              padding: EdgeInsets.only(left: 20,right: 20,top: 10),
              child: Container(
                height: 150,
                width: MediaQuery.of(context).size.width - 40,
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.lightBlueAccent,width: 1.0)
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(child: Text(receiveMessage,style: TextStyle(fontSize: 15,color: Colors.redAccent,fontWeight: FontWeight.w500),),)
                  ],
                ),
              ),
            ),

            Padding(
              padding: EdgeInsets.only(left: 20,right: 20,top: 10),
              child: Container(
                alignment: Alignment.centerLeft,
                child: ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor: ButtonStyleButton.allOrNull<Color>(Colors.lightBlueAccent),
                  ),
                  child: Text("Clear",style: TextStyle(fontSize: 18,color: Colors.white,fontWeight: FontWeight.w500),),
                  onPressed: (){
                    setState(() {
                      receiveMessage = "";
                    });
                  },),
              ),
            ),
          ],),),
        ],
      ),
    );
  }

  ///
  /// @description handle message
  /// @param
  /// @return
  /// @author waitwalker
  /// @time 2021/6/30 14:44
  ///
  _handleListen(Socket client) {
    _socketSample = client;
    print("client ip:${client.address}");
    print("client port:${client.port}");
    print("client remoteAddress:${client.remoteAddress}");
    print("client remotePort:${client.remotePort}");
    client.listen(
          (Uint8List data) {
        var message = String.fromCharCodes(data);
        if (message != "h**eart||hear**t||hear**t") {
          message = message.substring(13);
          message = message.substring(0,message.length-2);
          print(message);
          setState(() {
            receiveMessage = receiveMessage + "\n" + message;
          });
        }
      },
      onError: (error) {
        print("error:$error");
        client.close();
      },
      onDone: (){
        client.close();
      },
    );
  }
}