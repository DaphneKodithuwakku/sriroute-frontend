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

  // Function to open Google Maps to Sri Lanka
  Future<void> _launchGoogleMaps() async {
    // Coordinates for Sri Lanka (approximate center)
    const double latitude = 7.8731;
    const double longitude = 80.7718;
    // Zoom level 7 is appropriate for viewing the entire country
    const int zoom = 7;
    final Uri url = Uri.parse('https://www.google.com/maps/@$latitude,$longitude,${zoom}z');
    
    if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
      throw Exception('Could not launch $url');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey, // Keep the scaffold key
      // Remove the drawer here since it's now managed by MainScreen
      backgroundColor: Colors.white,
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : CustomScrollView(
              slivers: [
                // Header with user info
                SliverAppBar(
                  expandedHeight: 200,
                  floating: false,
                  pinned: true,
                  automaticallyImplyLeading: false, // Don't automatically add back button
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
                            color: Colors.black.withAlpha(153), // 0.6 * 255 = ~153
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

                                // FIX: Modify the Row with username to handle overflow
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
                                            // Add overflow handling
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
                                    // Add a small SizedBox to ensure spacing
                                    const SizedBox(width: 10),
                                    // Notification and profile section
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
                                    hintText: 'Search for places...',
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
                        // Add hamburger menu on top of everything
                        Positioned(
                          top: MediaQuery.of(context).padding.top + 10,
                          left: 16,
                          child: GestureDetector(
                            onTap: () {
                              Scaffold.of(context).openDrawer();
                            },
                            child: Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: Colors.black.withOpacity(0.3),
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.menu,
                                color: Colors.white,
                                size: 24,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // Main content body
                SliverList(
                  delegate: SliverChildListDelegate([
                    const SizedBox(height: 20),
                    
                    // Categories
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      child: Text(
                        'Categories',
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                    ),

                    // Grid of Categories
                    GridView.count(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      crossAxisCount: 3,
                      childAspectRatio: 1.20,
                      children: [
                        categoryItem('Religious Sites', Icons.place, Colors.red, onTap: () {
                          // Navigate to Religious Sites screen when clicked
                          Navigator.push(
                            context, 
                            MaterialPageRoute(builder: (context) => const ReligiousSitesScreen()),
                          );
                        }),
                        categoryItem('Virtual Tours', Icons.vrpano, Colors.orange, onTap: () {
                          // Navigate to VR Tour screen when clicked
                          Navigator.push(
                            context, 
                            MaterialPageRoute(builder: (context) => const ReligionSelectionScreen()),
                          );
                        }),
                        categoryItem(
                          'Pilgrimage Planner',
                          Icons.event,
                          Colors.yellow,
                          onTap: () {
                            // Navigate to Pilgrimage Planner screen
                            Navigator.push(
                              context, 
                              MaterialPageRoute(builder: (context) => const PilgrimagePlannerScreen()),
                            );
                          },
                        ),
                        categoryItem(
                          'Event Calendar',
                          Icons.calendar_month,
                          Colors.green,
                          onTap: () {
                            // Navigate to Event Calendar screen
                            Navigator.push(
                              context, 
                              MaterialPageRoute(builder: (context) => const EventCalendarScreen()),
                            );
                          },
                        ),
                        categoryItem(
                          'Cultural Guide',
                          Icons.menu_book,
                          Colors.lightGreen,
                          onTap: () {
                            // Navigate to Cultural Guide screen
                            Navigator.push(
                              context, 
                              MaterialPageRoute(builder: (context) => const CulturalSensitivityPage()),
                            );
                          },
                        ),
                      ],
                    ),

                    const SizedBox(height: 5),
                    
                    // Popular Virtual Tours
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      child: Text(
                        'Popular (Virtual Tours)',
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                    ),
                    const SizedBox(height: 10),

                    SizedBox(
                      height: 130,
                      child: ListView(
                        scrollDirection: Axis.horizontal,
                        padding: const EdgeInsets.only(left: 16),
                        children: [
                          tourCard(
                            'Sri Dalada Maligawa',
                            'Kandy',
                            'assets/sri_dalada.png',
                            onTap: () => _navigateToTempleDetail('Sri Dalada Maligawa', 'buddhism/sri_dalada_maligawa'),
                          ),
                          tourCard(
                            'Jami Ul-Alfar Mosque',
                            'Colombo',
                            'assets/red_mosque.png',
                            onTap: () => _navigateToTempleDetail('Jami Ul-Alfar Mosque', 'islam/jami_ul_alfar'),
                          ),
                          tourCard(
                            'Sambodhi Pagoda Temple',
                            'Colombo',
                            'assets/sambodhi_pagoda.jpg',
                            onTap: () => _navigateToTempleDetail('Sambodhi Pagoda Temple', 'buddhism/sambodhi_pagoda'),
                          ),
                          tourCard(
                            'Sacred Heart Church',
                            'Rajagiriya',
                            'assets/sacred_heart_church.jpeg',
                            onTap: () => _navigateToTempleDetail('Sacred Heart of Jesus Church', 'christianity/sacred_heart'),
                          ),
                          tourCard(
                            'Kataragama Devalaya',
                            'Kandy',
                            'assets/kataragama_devalaya.jpeg',
                            onTap: () => _navigateToTempleDetail('Ruhunu Maha Kataragama Devalaya', 'hinduism/kataragama_devalaya'),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 25),

                    // Maps Section
                    GestureDetector(
                      onTap: () {
                        // Launch Google Maps instead of navigating to MapScreen
                        _launchGoogleMaps();
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Maps',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 10),
                            Container(
                              height: 200,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                image: const DecorationImage(
                                  image: AssetImage('assets/map.png'),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 30), // Prevent bottom cut-off
                  ]),
                ),
              ],
            ),
    );
  }

  // Navigate to temple detail page
  void _navigateToTempleDetail(String templeName, String storagePath) {
    Navigator.push(
      context,
      MaterialPageRoute(
        settings: RouteSettings(name: 'temple_detail/$templeName'),
        builder: (context) => TempleDetailScreen(
          templeName: templeName, 
          storagePath: storagePath,
        ),
      ),
    );
  }

  // Category Item Widget with optional onTap handler
  Widget categoryItem(String title, IconData icon, Color color, {VoidCallback? onTap}) {
    return InkWell(
      onTap: onTap,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircleAvatar(
            radius: 35,
            backgroundColor: color,
            child: Icon(
              icon,
              color: const Color.fromARGB(255, 0, 0, 0),
              size: 35,
            ),
          ),
          const SizedBox(height: 5),
          Text(
            title,
            textAlign: TextAlign.center,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
          ),
        ],
      ),
    );
  }

  // Updated tourCard Widget with onTap functionality
  Widget tourCard(String title, String location, String image, {VoidCallback? onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 120,
        margin: const EdgeInsets.only(right: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.asset(
                image,
                height: 80,
                width: 120,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(height: 5),
            Text(
              title,
              style: const TextStyle(fontWeight: FontWeight.bold),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            Text(location, style: const TextStyle(color: Colors.grey, fontSize: 12)),
          ],
        ),
      ),
    );
  }
}
