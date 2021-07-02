import 'package:flutter/material.dart';
import 'package:flutter_socket_plugin_example/environment_config.dart';
import 'package:flutter_socket_plugin_example/server_page.dart';
import 'client_page.dart';

void main() => runApp(App());

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    bool isClient = EnvironmentConfig.APP_SOCKET == "Client";
    return MaterialApp(
      title: "Socket",
      home: isClient ? ClientPage() : ServerPage(),
      theme: ThemeData(primaryColor: Colors.lightGreen),
    );
  }
}



