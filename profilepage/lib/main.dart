import 'package:flutter/material.dart';
import 'homescreen.dart'; // Import the HomeScreen
import 'profile.dart'; // Keep the ProfilePage import for later navigation

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Profile Page',
      theme: ThemeData(primarySwatch: Colors.green),
      home: HomeScreen(), // Start from HomeScreen
    );
  }
}
