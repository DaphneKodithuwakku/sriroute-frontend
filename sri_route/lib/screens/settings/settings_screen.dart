class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;
  String _username = 'User';
  String? _email;
  String? _profileImageUrl;
  bool _isLoading = true;
  bool _isDeleting = false;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }
  
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Refresh profile data when returning from edit profile
    _refreshData();
  }
  
  // Add this method to refresh when returning from edit profile
  Future<void> _refreshData() async {
    // Only refresh if we're not already loading
    if (!_isLoading) {
      _loadUserData();
    }
  }

  Future<void> _loadUserData() async {
    setState(() {
      _isLoading = true;
    });

    try {
      // Get email from Firebase Auth
      final user = _auth.currentUser;
      if (user != null && mounted) {
        setState(() {
          _email = user.email;
        });
      }
      
      // Get username from UserService
      final username = UserService.username;
      
      // Get profile image URL from UserService
      final profileImageUrl = await UserService.getProfileImageUrl();
      
      if (mounted) {
        setState(() {
          _username = username;
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