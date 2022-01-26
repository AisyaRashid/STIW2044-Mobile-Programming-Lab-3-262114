import 'package:flutter/material.dart';
import 'package:lab3_26114/page/mainpage.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.blueGrey,
      ),
      title: "PaneBakery",
      home: const Scaffold(
        backgroundColor: Colors.grey,
        body: MainPage(title:"PaneBakery"),
      ));
  }
}

