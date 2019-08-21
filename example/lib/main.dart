import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter_socket_plugin/flutter_socket_plugin.dart';

void main() => runApp(App());

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "home",
      home: HomePage(),
      theme: ThemeData(primaryColor: Colors.lightGreen),
    );
  }
}


class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Map> chatList = [];
  TextEditingController textEditingController = TextEditingController();
  FlutterSocket flutterSocket;
  bool connected = false;

  @override
  void initState() {
    textEditingController.addListener((){
      print("text:${textEditingController.text}");
    });
    initSocket();
    super.initState();
  }

  initSocket() async {
    flutterSocket = FlutterSocket();
    var result = await flutterSocket.createSocket();
    print(result);
    if (result == true) {

      flutterSocket.tryConnect("192.168.8.120", 10007, timeout: 20);


      flutterSocket.connectListener((data){
        print("data:");
        connected = true;
      });

      flutterSocket.connectErrorListener((data){
        print(data);
      });

      flutterSocket.sendErrorListener((data){

      });

      flutterSocket.receiveListener((data){
        print("receive data:$data");
      });

      flutterSocket.disconnectListener((data){
        print("disconnect data:$data");
      });
    }

  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("开始聊天",style: TextStyle(fontSize: 18,color: Colors.white),),
        backgroundColor: Colors.lightBlue,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[

          Expanded(
            child: ListView.builder(
              itemBuilder: itemBuilder,
              itemCount: chatList.length,
            ),
          ),

          Padding(
            padding: EdgeInsets.only(top: 30,bottom: 30,left: 10,right: 10),
            child: Container(
              height: 200,
              decoration: BoxDecoration(
                  border: Border.all(width: 1,color: Colors.lightBlue)
              ),
              child: TextField(
                controller: textEditingController,
                decoration: InputDecoration(
                    labelText: "输入内容在发送",
                    border: InputBorder.none
                ),
              ),
            ),
          ),

        ],
      ),
      floatingActionButton: FloatingActionButton(child: Icon(Icons.send,size: 30,color: Colors.white,),onPressed: (){
        if (connected) {
          //flutterSocket.send("hello socket");
          flutterSocket.tryDisconnect();
        }
      },),
    );
  }

  Widget itemBuilder(BuildContext buildContext, int index) {
    return Column(
      children: <Widget>[
        Row(
          children: <Widget>[
            Icon(Icons.account_circle,size: 35,color: Colors.lime,),
            Column(
              children: <Widget>[
                Text("张三",style: TextStyle(fontSize: 12,color: Colors.orangeAccent),),
                Text("时间",style: TextStyle(fontSize: 10,color: Colors.deepPurpleAccent),),
              ],
            )
          ],
        ),
        Text("内容",style: TextStyle(fontSize: 13,color: Colors.black),),
      ],
    );
  }
}
