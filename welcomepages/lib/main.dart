import 'package:flutter/material.dart';
import 'welcomepage1.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'WelcomePage1',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: WelcomePage1(),
    );
  }
}
