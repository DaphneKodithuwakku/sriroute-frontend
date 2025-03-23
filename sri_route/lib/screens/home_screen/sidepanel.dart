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