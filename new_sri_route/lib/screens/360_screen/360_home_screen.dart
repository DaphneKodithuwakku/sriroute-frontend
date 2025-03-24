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
  _ReligionSelectionScreenState createState() =>
      _ReligionSelectionScreenState();
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
      body:
          _isLoading
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
                    leading: IconButton(
                      // Add this IconButton for the drawer
                      icon: Icon(Icons.menu, color: Colors.white),
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
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16.0,
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const SizedBox(height: 40),

                                  // Row with User Info + Icons
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      // Wrap Column in Expanded to allow text truncation
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
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
                                                      builder:
                                                          (context) =>
                                                              const NotificationsScreen(),
                                                    ),
                                                  );
                                                },
                                              ),
                                              if (_unreadNotifications > 0)
                                                Positioned(
                                                  right: 0,
                                                  top: 0,
                                                  child: Container(
                                                    padding:
                                                        const EdgeInsets.all(2),
                                                    decoration: BoxDecoration(
                                                      color: Colors.red,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                            10,
                                                          ),
                                                    ),
                                                    constraints:
                                                        const BoxConstraints(
                                                          minWidth: 18,
                                                          minHeight: 18,
                                                        ),
                                                    child: Text(
                                                      _unreadNotifications > 9
                                                          ? '9+'
                                                          : _unreadNotifications
                                                              .toString(),
                                                      style: const TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 10,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                      textAlign:
                                                          TextAlign.center,
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
                                              final result =
                                                  await Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                      builder:
                                                          (context) =>
                                                              EditProfilePage(),
                                                    ),
                                                  );

                                              // Refresh profile data if needed
                                              if (result == true) {
                                                _refreshProfileData();
                                              }
                                            },
                                            child: CircleAvatar(
                                              radius: 22,
                                              backgroundColor: Colors.grey[300],
                                              backgroundImage:
                                                  _profileImageUrl != null
                                                      ? NetworkImage(
                                                        _profileImageUrl!,
                                                      )
                                                      : null,
                                              child:
                                                  _profileImageUrl == null
                                                      ? Icon(
                                                        Icons.person,
                                                        size: 22,
                                                        color: Colors.grey[700],
                                                      )
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
                                      contentPadding:
                                          const EdgeInsets.symmetric(
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

                  // Main content
                  SliverList(
                    delegate: SliverChildListDelegate([
                      const Padding(
                        padding: EdgeInsets.only(
                          left: _defaultPadding,
                          right: _defaultPadding,
                          top: 20,
                          bottom: 10,
                        ),
                        child: Text(
                          'Virtual Religious Sites',
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      // Religious places cards
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: _defaultPadding,
                        ),
                        child: Column(
                          children: [
                            _buildReligiousPlace(
                              context,
                              'Sri Dalada Maligawa',
                              'Buddhism',
                              '28,467 reviews • 4.7',
                              'assets/sri_dalada_maligawa.jpg',
                              storagePath: 'places/Sri Dalada Maligawa',
                            ),
                            const SizedBox(height: 16),
                            _buildReligiousPlace(
                              context,
                              'Jami Ul-Alfar Mosque',
                              'Islam',
                              '456 reviews • 4.4',
                              'assets/jami_ul_alfar.jpg',
                              storagePath: 'places/Red Mosque',
                            ),
                            const SizedBox(height: 16),
                            _buildReligiousPlace(
                              context,
                              'Ruhunu Maha Kataragama Devalaya',
                              'Hinduism',
                              '1,286 reviews • 4.8',
                              'assets/kataragama_devalaya.jpeg',
                              storagePath:
                                  'places/Ruhunu Maha Kataragama Devalaya - Kandy',
                            ),
                            const SizedBox(height: 16),
                            _buildReligiousPlace(
                              context,
                              'Sambodhi Pagoda Temple',
                              'Buddhism',
                              '599 reviews • 4.6',
                              'assets/sambodhi_pagoda.jpg',
                              storagePath: 'places/Sri Sambodhi Viharaya',
                            ),
                            const SizedBox(height: 16),
                            _buildReligiousPlace(
                              context,
                              'Sacred Heart of Jesus Church',
                              'Christianity',
                              '325 reviews • 4.5',
                              'assets/sacred_heart_church.jpeg',
                              storagePath:
                                  'places/Sacred Heart of Jesus - Rajagiriya',
                            ),
                            const SizedBox(height: 20),
                          ],
                        ),
                      ),
                    ]),
                  ),
                ],
              ),
    );
  }

  // Religious place card builder - using the existing method
  Widget _buildReligiousPlace(
    BuildContext context,
    String name,
    String religion,
    String reviews,
    String imagePath, {
    String? storagePath,
  }) {
    // ...existing code...
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(
          context,
          '/details',
          arguments: {'name': name, 'storagePath': storagePath},
        );
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(_cardBorderRadius),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              spreadRadius: 1,
              blurRadius: 5,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(_cardBorderRadius),
              ),
              child: Image.asset(
                imagePath,
                height: _placeImageHeight,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildReligionTag(religion),
                  const SizedBox(height: 8),
                  Text(
                    name,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  _buildBottomRowWithReviews(reviews),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Extract religion tag to a method
  Widget _buildReligionTag(String religion) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        religion,
        style: TextStyle(color: Colors.grey[700], fontSize: 12),
      ),
    );
  }

  // Extract bottom row with reviews to a method
  Widget _buildBottomRowWithReviews(String reviews) {
    return Row(
      children: [
        const Icon(Icons.star, size: 16, color: Colors.amber),
        const SizedBox(width: 4),
        Text(reviews, style: TextStyle(color: Colors.grey[600], fontSize: 12)),
        const Spacer(),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: Colors.green,
            borderRadius: BorderRadius.circular(4),
          ),
          child: const Text(
            'Start',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ),
      ],
    );
  }
}
