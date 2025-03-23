import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../widgets/bottom_nav_bar.dart';
import 'settings/settings_screen.dart';
import '../services/user_service.dart';
import 'home_screen/homescreen.dart' hide Text;
import '360_screen/360_home_screen.dart';
import 'cultural_guide/cultural_guide_screen.dart';
import 'pilgrimage_planner/pilgrimage_planner_screen.dart';
import 'home_screen/sidepanel.dart';
import 'favorites_screen.dart'; // Add this import

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;
  bool _isLoading = true;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _loadUserData();
    _checkAuthState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    // Check if we were passed a tab index as an argument
    final args = ModalRoute.of(context)?.settings.arguments;
    if (args != null && args is int) {
      setState(() {
        _selectedIndex = args;
      });
    }
  }

  void _checkAuthState() {
    // Listen to auth state changes
    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      if (user == null && mounted) {
        // User is signed out, navigate to login
        Navigator.pushReplacementNamed(context, '/login');
      }
    });
  }

  Future<void> _loadUserData() async {
    try {
      await UserService.loadUserData();
    } catch (e) {
      debugPrint("Error loading user data: $e");
      // If there's an authentication error, handle it
      if (e.toString().contains("unauthenticated") ||
          e.toString().contains("permission-denied")) {
        FirebaseAuth.instance.signOut();
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  // Updated widget list - ensure this order matches TabIndex in sidepanel.dart
  final List<Widget> _widgetOptions = <Widget>[
    const HomeScreen(), // index 0 - TabIndex.home
    const ReligionSelectionScreen(), // index 1 - TabIndex.virtualTours
    const PilgrimagePlannerScreen(), // index 2 - TabIndex.pilgrimagePlanner
    const CulturalSensitivityPage(), // index 3 - TabIndex.culturalGuide
    const FavoritesScreen(), // index 4 - TabIndex.favorites
    const SettingsScreen(), // index 5 - TabIndex.settings
  ];

  void _onItemTapped(int index) {
    setState(() {
      // When clicking the profile icon/settings button (index 5)
      // we need to make sure it correctly shows the settings screen
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    // Update this line to show drawer for Home, VR Tours, and Pilgrimage Planner
    final bool showCustomDrawer =
        _selectedIndex == 0 || _selectedIndex == 1 || _selectedIndex == 2;

    return WillPopScope(
      onWillPop: () async {
        // If not on the home tab, go to home tab instead of exiting
        if (_selectedIndex != 0) {
          setState(() {
            _selectedIndex = 0;
          });
          return false; // Don't close the app
        }
        return true; // Allow app to close if on home tab
      },
      child: Scaffold(
        key: _scaffoldKey,
        drawer:
            showCustomDrawer
                ? SidePanel(
                  onTabSelected: (index) {
                    // Update the selected index when side panel item is clicked
                    setState(() {
                      _selectedIndex = index;
                    });
                  },
                )
                : null,
        appBar:
            _shouldShowAppBar()
                ? AppBar(
                  leading:
                      _selectedIndex == 0 ||
                              _selectedIndex == 1 ||
                              _selectedIndex == 2
                          ? IconButton(
                            icon: const Icon(Icons.menu),
                            onPressed: () {
                              _scaffoldKey.currentState?.openDrawer();
                            },
                          )
                          : null,
                  title: Text(_getAppBarTitle()),
                  backgroundColor: Colors.black,
                  foregroundColor: Colors.white,
                )
                : null,
        // Since _selectedIndex could be 5 (settings) but _widgetOptions only has
        // indices 0-5, we need to ensure we don't go out of bounds
        body:
            _selectedIndex < _widgetOptions.length
                ? _widgetOptions.elementAt(_selectedIndex)
                : _widgetOptions.last, // Fallback to last item (Settings)
        bottomNavigationBar: CustomBottomNavBar(
          selectedIndex: _selectedIndex,
          onItemTapped: _onItemTapped,
        ),
      ),
    );
  }

  // Determine if we should show the AppBar for the current screen
  bool _shouldShowAppBar() {
    // No AppBar for Home, VR Tour, and Pilgrimage Planner
    return !(_selectedIndex == 0 || _selectedIndex == 1 || _selectedIndex == 2);
  }

  // Get appropriate title for AppBar based on selected tab
  String _getAppBarTitle() {
    switch (_selectedIndex) {
      case 0:
        return 'Home';
      case 1:
        return 'VR Tours';
      case 2:
        return 'Pilgrimage Planner';
      case 3:
        return 'Cultural Guide';
      case 4:
        return 'Favorites';
      case 5:
        return 'Settings';
      default:
        return 'Sri Route';
    }
  }
}
