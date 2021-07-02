import 'package:flutter/material.dart';
import 'package:flutter_socket_plugin/flutter_socket_plugin.dart';

///
/// @description Socket Client sample code
/// @author waitwalker
/// @time 2021/6/30 17:07
///
class ClientPage extends StatefulWidget {
  @override
  _ClientPageState createState() => _ClientPageState();
}

class _ClientPageState extends State<ClientPage> {

  TextEditingController textEditingController = TextEditingController();

  FlutterSocket? flutterSocket;
  bool connected = false;
  String _host = "192.168.10.63";
  int _port = 10007;
  String receiveMessage = "";

  @override
  void initState() {
    initSocket();
    textEditingController.addListener((){
      print("input text:${textEditingController.text}");
    });
    super.initState();
  }

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
    flutterSocket!.connectListener((data){
      print("connect listener data:$data");
    });

    /// listen error callback
    flutterSocket!.errorListener((data){
      print("error listener data:$data");
    });

    /// listen receive callback
    flutterSocket!.receiveListener((data){
      print("receive listener data:$data");
      if (data != null) {
        receiveMessage = receiveMessage + "\n" + data;
      }
      setState(() {

      });
    });

    /// listen disconnect callback
    flutterSocket!.disconnectListener((data){
      print("disconnect listener data:$data");
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("FlutterSocket client",style: TextStyle(fontSize: 18,color: Colors.white),),
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
                    child: Text("Create",style: TextStyle(fontSize: 18,color: Colors.white,fontWeight: FontWeight.w500),),
                    onPressed: () async {
                      await flutterSocket!.createSocket(_host, _port, timeout: 20);
                    },
                  ),
                  Padding(padding: EdgeInsets.only(left: 20)),
                  ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor: ButtonStyleButton.allOrNull<Color>(Colors.lightBlueAccent),
                    ),
                    child: Text("Connect",style: TextStyle(fontSize: 18,color: Colors.white,fontWeight: FontWeight.w500),),
                    onPressed: (){
                      flutterSocket!.tryConnect();
                    },
                  ),
                  Padding(padding: EdgeInsets.only(left: 20)),
                  ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor: ButtonStyleButton.allOrNull<Color>(Colors.lightBlueAccent),
                    ),
                    child: Text("Disconnect",style: TextStyle(fontSize: 18,color: Colors.white,fontWeight: FontWeight.w500),),
                    onPressed: (){
                      flutterSocket!.tryDisconnect();
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
                    print("will send message:${textEditingController.text}");
                    flutterSocket!.send(textEditingController.text);
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
                    Expanded(child: Text(receiveMessage,style: TextStyle(fontSize: 15,color: Colors.redAccent, fontWeight: FontWeight.w500),),)
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

}