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
  // Method to show account deletion confirmation dialog
  void _showDeleteAccountConfirmation() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Delete Account'),
          content: const Text(
              'Are you sure you want to delete your account? This action cannot be undone and all your data will be permanently removed.'),
          actions: [
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              style: TextButton.styleFrom(
                foregroundColor: Colors.red,
              ),
              child: const Text('Delete'),
              onPressed: () {
                Navigator.of(context).pop();
                _deleteAccount();
              },
            ),
          ],
        );
      },
    );
  }

  // Method to delete user account and all associated data
  Future<void> _deleteAccount() async {
    if (_isDeleting) return; // Prevent multiple deletion attempts
    
    setState(() {
      _isDeleting = true;
    });
    
    try {
      final user = _auth.currentUser;
      if (user == null) {
        throw Exception('No user logged in');
      }
      
      // 1. Delete user data from Firestore
      await _deleteUserData(user.uid);
      
      // 2. Delete profile picture from Storage
      await _deleteProfilePicture(user.uid);
      
      // 3. Delete the user authentication account
      await user.delete();
      
      // 4. Clear SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      await prefs.clear();
      
      // 5. Navigate to login page
      if (mounted) {
        Navigator.of(context).pushNamedAndRemoveUntil('/login', (route) => false);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Your account has been successfully deleted')),
        );
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'requires-recent-login') {
        // If deletion requires recent authentication
        _showReauthenticateDialog();
      } else {
        _showErrorSnackbar('Error deleting account: ${e.message}');
      }
    } catch (e) {
      _showErrorSnackbar('Error deleting account: $e');
    } finally {
      if (mounted) {
        setState(() {
          _isDeleting = false;
        });
      }
    }
  }

  // Method to delete user data from Firestore
  Future<void> _deleteUserData(String userId) async {
    try {
      // Delete user document
      await _firestore.collection('users').doc(userId).delete();
      
      // Here you could also delete other collections related to the user
      // For example: user posts, saved locations, etc.
    } catch (e) {
      debugPrint('Error deleting Firestore data: $e');
      // Continue with account deletion even if Firestore deletion fails
    }
  }

  // Method to delete profile picture from Firebase Storage
  Future<void> _deleteProfilePicture(String userId) async {
    try {
      final ref = _storage.ref().child('profile_pictures/$userId');
      await ref.delete();
    } catch (e) {
      debugPrint('Error deleting profile picture: $e');
      // Continue with account deletion even if picture deletion fails
    }
  }
  