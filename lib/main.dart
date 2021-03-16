import 'package:api_and_json_server/screens/home/home_screen.dart';
import 'package:flutter/material.dart';
import 'core/service_locator.dart';

void main() {
  setupLocator();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'API and JSON server',
      home: HomeScreen(),
    );
  }
}
