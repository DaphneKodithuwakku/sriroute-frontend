import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../services/user_service.dart';
import '../../services/notification_service.dart';
import 'homescreen.dart' hide Text, MyApp;
import '../settings/settings_screen.dart';
import '../360_screen/360_home_screen.dart';
import '../cultural_guide/cultural_guide_screen.dart';
import '../pilgrimage_planner/pilgrimage_planner_screen.dart';
import '../favorites_screen.dart';
import '../notifications/notifications_screen.dart';
import '../settings/editprofile.dart';

// Ensure these tab indices match the order in MainScreen's _widgetOptions list
class TabIndex {
  static const int home = 0;
  static const int virtualTours = 1;
  static const int pilgrimagePlanner = 2;
  static const int culturalGuide = 3;
  static const int favorites = 4; // Add favorites tab index
  static const int settings = 5;   // Adjust settings index
}

class SidePanel extends StatefulWidget {
  final Function(int)? onTabSelected;
  
  const SidePanel({Key? key, this.onTabSelected}) : super(key: key);

  @override
  State<SidePanel> createState() => _SidePanelState();
}

class _SidePanelState extends State<SidePanel> {
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
  
  Future<void> _loadUserData() async {
    try {
      // Use UserService to get user data
      final username = UserService.username;
      final profileImageUrl = await UserService.getProfileImageUrl();
      
      if (mounted) {
        setState(() {
          _username = username;
          _profileImageUrl = profileImageUrl;
          _isLoading = false;
        });
      }
    } catch (e) {
      debugPrint("Error loading user data for side panel: $e");
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
    return Drawer(
      child: _isLoading 
          ? const Center(child: CircularProgressIndicator())
          : Column(
        children: [
          // User header with tappable profile image
          InkWell(
            onTap: () async {
              // Close the drawer first
              Navigator.pop(context);
              
              // Navigate to EditProfilePage and refresh data if needed
              final result = await Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => EditProfilePage()),
              );
              
              if (result == true) {
                _loadUserData(); // Reload data if profile was updated
              }
            },
            child: UserAccountsDrawerHeader(
              decoration: const BoxDecoration(
                color: Colors.blueGrey,
              ),
              currentAccountPicture: CircleAvatar(
                backgroundColor: Colors.white,
                backgroundImage: _profileImageUrl != null 
                    ? NetworkImage(_profileImageUrl!) 
                    : null,
                child: _profileImageUrl == null
                    ? Icon(Icons.person, color: Colors.grey[700])
                    : null,
              ),
              accountName: Text(_username),
              accountEmail: Text(FirebaseAuth.instance.currentUser?.email ?? 'Guest User'),
            ),
          ),
          
          // Menu items with proper tab index values
          _buildMenuItem(
            context, 
            Icons.home, 
            "Home", 
            Colors.blue, 
            () => _selectTab(TabIndex.home)
          ),
          
          _buildMenuItem(
            context, 
            Icons.vrpano, 
            "Virtual Tours", 
            Colors.orange, 
            () => _selectTab(TabIndex.virtualTours)
          ),
          
          _buildMenuItem(
            context, 
            Icons.map, 
            "Pilgrimage Planner", 
            Colors.green, 
            () => _selectTab(TabIndex.pilgrimagePlanner)
          ),
          
          _buildMenuItem(
            context, 
            Icons.menu_book, 
            "Cultural Guide", 
            Colors.amber, 
            () => _selectTab(TabIndex.culturalGuide)
          ),
          
          // Add a Favorites menu item
          _buildMenuItem(
            context, 
            Icons.favorite, 
            "Favorites", 
            Colors.red, 
            () => _selectTab(TabIndex.favorites)
          ),
          
          // Add a Notifications menu item with badge
          _buildNotificationMenuItem(
            context, 
            "Notifications", 
            Colors.purple, 
            _unreadNotifications, 
            () {
              Navigator.pop(context); // Close drawer
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const NotificationsScreen()),
              );
            }
          ),
          
          const Divider(),
          
          _buildMenuItem(
            context, 
            Icons.settings, 
            "Settings", 
            Colors.grey, 
            () => _selectTab(TabIndex.settings)
          ),
          
          _buildMenuItem(
            context, 
            Icons.logout, 
            "Logout", 
            Colors.redAccent, 
            _handleLogout
          ),
        ],
      ),
    );
  }
  
  // Handle logout separately to maintain proper flow
  void _handleLogout() async {
    // First close the drawer
    Navigator.pop(context);
    
    // Show confirmation dialog
    final shouldLogout = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Logout Confirmation'),
        content: const Text('Are you sure you want to log out?'),
        actions: [
          TextButton(
            child: const Text('Cancel'),
            onPressed: () => Navigator.of(context).pop(false),
          ),
          TextButton(
            child: const Text('Logout'),
            onPressed: () => Navigator.of(context).pop(true),
          ),
        ],
      ),
    ) ?? false;
    
    // If confirmed, perform logout
    if (shouldLogout) {
      try {
        await FirebaseAuth.instance.signOut();
        if (context.mounted) {
          Navigator.of(context).pushNamedAndRemoveUntil('/login', (route) => false);
        }
      } catch (e) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error logging out: $e'))
          );
        }
      }
    }
  }
  
  // Helper method to handle tab selection
  void _selectTab(int index) {
    // Close the drawer
    Navigator.pop(context);
    
    // Use the callback if provided
    if (widget.onTabSelected != null) {
      widget.onTabSelected!(index);
    } else {
      // Fallback: Navigate to MainScreen with selected tab
      Navigator.of(context).pushReplacementNamed('/home', arguments: index);
    }
  }

  Widget _buildMenuItem(
    BuildContext context, 
    IconData icon, 
    String title, 
    Color color, 
    VoidCallback onTap
  ) {
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: color.withOpacity(0.2),
        child: Icon(icon, color: color),
      ),
      title: Text(title),
      onTap: onTap,
    );
  }
  
  // Special menu item for notifications with badge
  Widget _buildNotificationMenuItem(
    BuildContext context,
    String title,
    Color color,
    int badgeCount,
    VoidCallback onTap
  ) {
    return ListTile(
      leading: Stack(
        children: [
          CircleAvatar(
            backgroundColor: color.withOpacity(0.2),
            child: Icon(Icons.notifications, color: color),
          ),
          if (badgeCount > 0)
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
                  minWidth: 16,
                  minHeight: 16,
                ),
                child: Text(
                  badgeCount > 9 ? '9+' : badgeCount.toString(),
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
      title: Text(title),
      onTap: onTap,
    );
  }
}
