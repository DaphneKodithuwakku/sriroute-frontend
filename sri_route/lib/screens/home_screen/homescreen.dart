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


class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String _username = 'User';
  String? _profileImageUrl;
  bool _isLoading = true;
  final FirebaseAuth _auth = FirebaseAuth.instance;  // Add Firebase Auth instance
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>(); // Create a GlobalKey for the Scaffold
  int _unreadNotifications = 0;

  @override
  void initState() {
    super.initState();
    _loadUserData();
    _listenForNotifications();
  }
  
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Refresh data when returning from other screens
    _refreshProfileData();
  }
  
  // Add this method to refresh profile data when coming back from edit profile
  Future<void> _refreshProfileData() async {
    try {
      final profileImageUrl = await UserService.getProfileImageUrl();
      if (mounted && profileImageUrl != _profileImageUrl) {
        setState(() {
          _profileImageUrl = profileImageUrl;
        });
      }
    } catch (e) {
      debugPrint("Error refreshing profile data: $e");
    }
  }

  Future<void> _loadUserData() async {
    try {
      // Use the centralized method from UserService
      final name = UserService.username;
      final profileImageUrl = await UserService.getProfileImageUrl();
      
      if (mounted) {
        setState(() {
          _username = name;
          _profileImageUrl = profileImageUrl;
          _isLoading = false;
        });
      }
    } catch (e) {
      debugPrint("Error loading user data: $e");
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _listenForNotifications() {
    NotificationService.getUnreadCount().listen((count) {
      if (mounted) {
        setState(() {
          _unreadNotifications = count;
        });
      }
    });
  }
