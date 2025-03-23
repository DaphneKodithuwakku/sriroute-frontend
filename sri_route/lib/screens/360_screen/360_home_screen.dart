import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../services/user_service.dart';
import '../../services/notification_service.dart';
import '../notifications/notifications_screen.dart';
import '../settings/editprofile.dart';

class ReligionSelectionScreen extends StatefulWidget {
  const ReligionSelectionScreen({Key? key}) : super(key: key);

  @override
  _ReligionSelectionScreenState createState() => _ReligionSelectionScreenState();
}

class _ReligionSelectionScreenState extends State<ReligionSelectionScreen> {
  // Define constants for margins and paddings
  static const double _defaultPadding = 16.0;
  static const double _cardBorderRadius = 12.0;
  static const double _placeImageHeight = 200.0;
  static const double _headerHeight = 200.0;
  
  final FirebaseAuth _auth = FirebaseAuth.instance;
  String _username = 'User';
  String? _profileImageUrl;
  bool _isLoading = true;
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
    // Refresh profile data when returning from other screens
    _refreshProfileData();
  }
  
  // Add this method to refresh profile data when coming back
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : CustomScrollView(
        slivers: [
          // Header with user info - matching the homescreen design
          SliverAppBar(
            expandedHeight: _headerHeight,
            floating: false,
            pinned: true,
            backgroundColor: Colors.transparent,
            elevation: 0,
            leading: IconButton(  // Add this IconButton for the drawer
              icon: Icon(
                Icons.menu,
                color: Colors.white,
              ),
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
            ),
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                fit: StackFit.expand,
                children: [
                  // Background Image with Curved Corners
                  ClipRRect(
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(30),
                      bottomRight: Radius.circular(30),
                    ),
                    child: Image.asset(
                      'assets/header_bg.png',
                      fit: BoxFit.cover,
                    ),
                  ),

                  // Dark Overlay for better visibility
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.black.withAlpha(153),
                      borderRadius: const BorderRadius.only(
                        bottomLeft: Radius.circular(30),
                        bottomRight: Radius.circular(30),
                      ),
                    ),
                  ),

                  // Header Content (User greeting + Icons + Search)
                  SafeArea(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 40),

                          // Row with User Info + Icons
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              // Wrap Column in Expanded to allow text truncation
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Hi, $_username',
                                      style: const TextStyle(
                                        fontSize: 24,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 1,
                                    ),
                                    const SizedBox(height: 5),
                                    const Text(
                                      'Sri Lanka',
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: Colors.white70,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 10),
                              Row(
                                children: [
                                  // Notification icon with badge
                                  Stack(
                                    children: [
                                      IconButton(
                                        icon: const Icon(
                                          Icons.notifications,
                                          color: Colors.white,
                                        ),
                                        onPressed: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) => const NotificationsScreen(),
                                            ),
                                          );
                                        },
                                      ),
                                      if (_unreadNotifications > 0)
                                        Positioned(
                                          right: 0,
                                          top: 0,
                                          child: Container(
                                            padding: const EdgeInsets.all(2),
                                            decoration: BoxDecoration(
                                              color: Colors.red,
                                              borderRadius: BorderRadius.circular(10),
                                            ),
                                            constraints: const BoxConstraints(
                                              minWidth: 18,
                                              minHeight: 18,
                                            ),
                                            child: Text(
                                              _unreadNotifications > 9 ? '9+' : _unreadNotifications.toString(),
                                              style: const TextStyle(
                                                color: Colors.white,
                                                fontSize: 10,
                                                fontWeight: FontWeight.bold,
                                              ),
                                              textAlign: TextAlign.center,
                                            ),
                                          ),
                                        ),
                                    ],
                                  ),
                                  const SizedBox(width: 10),
                                  // Make profile image tappable to navigate to edit profile
                                  GestureDetector(
                                    onTap: () async {
                                      // Navigate to EditProfilePage and refresh data if profile was updated
                                      final result = await Navigator.push(
                                        context,
                                        MaterialPageRoute(builder: (context) => EditProfilePage()),
                                      );
                                      
                                      // Refresh profile data if needed
                                      if (result == true) {
                                        _refreshProfileData();
                                      }
                                    },
                                    child: CircleAvatar(
                                      radius: 22,
                                      backgroundColor: Colors.grey[300],
                                      backgroundImage: _profileImageUrl != null 
                                          ? NetworkImage(_profileImageUrl!) 
                                          : null,
                                      child: _profileImageUrl == null
                                          ? Icon(Icons.person, size: 22, color: Colors.grey[700])
                                          : null,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),

                          const SizedBox(height: 15),

                          // Search Bar inside the header
                          TextField(
                            decoration: InputDecoration(
                              hintText: 'Search for religious sites...',
                              prefixIcon: const Icon(Icons.search),
                              filled: true,
                              fillColor: Colors.white,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30),
                                borderSide: BorderSide.none,
                              ),
                              contentPadding: const EdgeInsets.symmetric(
                                vertical: 10,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          