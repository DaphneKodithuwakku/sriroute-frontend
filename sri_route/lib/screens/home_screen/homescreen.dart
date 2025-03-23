import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';  // Import Firebase Auth
import 'package:url_launcher/url_launcher.dart';  // Add url_launcher import
import 'package:shared_preferences/shared_preferences.dart'; // Add shared_preferences import
import 'map_screen.dart'; // Import the map screen
import '../../services/user_service.dart'; // Import UserService
import '../360_screen/360_home_screen.dart';  // Import the 360 home screen
import '../religious_sites/religious_sites_screen.dart'; // Import the religious sites screen
import '../event_calander_screen.dart'; // Import Event Calendar screen
import '../cultural_guide/cultural_guide_screen.dart'; // Import Cultural Guide screen
import '../pilgrimage_planner/pilgrimage_planner_screen.dart'; // Import Pilgrimage Planner screen
import '../360_screen/detail_screen.dart'; // Import the temple detail screen
import '../../services/notification_service.dart'; // Import NotificationService
import '../notifications/notifications_screen.dart'; // Import NotificationService
import '../settings/editprofile.dart'; // Add import for edit profile page

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'SriRoute',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const HomeScreen(),
    );
  }
}
