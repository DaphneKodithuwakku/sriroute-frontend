import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../services/user_service.dart';
import 'editprofile.dart';
import '../favorites_screen.dart';
import '../notifications/notifications_screen.dart';

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
        Navigator.of(context)
            .pushNamedAndRemoveUntil('/login', (route) => false);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text('Your account has been successfully deleted')),
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

  // Method to show reauthentication dialog
  void _showReauthenticateDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Reauthentication Required'),
          content: const Text(
              'For security reasons, please log out and log back in before deleting your account.'),
          actions: [
            TextButton(
              child: const Text('OK'),
              onPressed: () async {
                await _auth.signOut();
                Navigator.of(context)
                    .pushNamedAndRemoveUntil('/login', (route) => false);
              },
            ),
          ],
        );
      },
    );
  }

  // Helper method to show error messages
  void _showErrorSnackbar(String message) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message)),
      );
    }
  }

  Future<void> _launchReportProblemForm() async {
    // Google Form URL
    final Uri url = Uri.parse('https://forms.gle/Y2Mb46FVFKArq2DJ8');

    try {
      if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
                content:
                    Text('Could not open the form. Please try again later.')),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.grey[100]!, Colors.white],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: _isLoading || _isDeleting
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              padding: const EdgeInsets.all(16),
              children: [
                // User info section
                Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15)),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        CircleAvatar(
                          radius: 40,
                          backgroundColor: Colors.grey[300],
                          // Use saved profile image or Firebase profile photo, or fallback to icon
                          backgroundImage: _profileImageUrl != null
                              ? NetworkImage(_profileImageUrl!)
                              : null,
                          child: _profileImageUrl == null
                              ? Icon(Icons.person,
                                  size: 40, color: Colors.grey[700])
                              : null,
                        ),
                        const SizedBox(height: 10),
                        Text(
                          _username,
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          _email ?? 'No email',
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                _buildSection(
                  title: 'ACCOUNT',
                  items: [
                    _buildListTile(
                      icon: Icons.person,
                      title: 'Edit Profile',
                      onTap: () async {
                        // Navigate to the EditProfilePage and wait for result
                        final result = await Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => EditProfilePage()),
                        );

                        // If profile was updated, refresh the data
                        if (result == true) {
                          _loadUserData();
                        }
                      },
                    ),
                    // Add Favorites item before Notifications
                    _buildListTile(
                      icon: Icons.favorite,
                      title: 'Favorites',
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const FavoritesScreen(),
                          ),
                        );
                      },
                    ),
                    _buildListTile(
                      icon: Icons.notifications,
                      title: 'Notifications',
                      onTap: () {
                        // Navigate to notifications screen
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const NotificationsScreen(),
                          ),
                        );
                      },
                    ),
                    _buildListTile(
                      icon: Icons.lock,
                      title: 'Privacy',
                      onTap: () {
                        // Show privacy policy or navigate to privacy screen
                        _showPrivacyDialog();
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                _buildSection(
                  title: 'SUPPORT & ABOUT',
                  items: [
                    _buildListTile(
                      icon: Icons.help,
                      title: 'Help & Support',
                      onTap: () {
                        // Show help & support dialog or navigate to help screen
                        _showHelpSupportDialog();
                      },
                    ),
                    _buildListTile(
                      icon: Icons.description,
                      title: 'Terms and Policies',
                      onTap: () {
                        // Show terms and policies dialog
                        _showTermsDialog();
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                _buildSection(
                  title: 'ACTIONS',
                  items: [
                    _buildListTile(
                      icon: Icons.report,
                      title: 'Report a Problem',
                      onTap: _launchReportProblemForm,
                    ),
                    _buildListTile(
                      icon: Icons.no_accounts,
                      title: 'Deactivate Account',
                      onTap: () => _showDeleteAccountConfirmation(),
                    ),
                    _buildListTile(
                      icon: Icons.logout,
                      title: 'Log Out',
                      onTap: () async {
                        try {
                          await _auth.signOut();
                          if (mounted) {
                            Navigator.pushReplacementNamed(context, '/login');
                          }
                        } catch (e) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Error signing out: $e')),
                          );
                        }
                      },
                    ),
                  ],
                ),
              ],
            ),
    );
  }

  // Privacy dialog
  void _showPrivacyDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Privacy Policy'),
        content: const SingleChildScrollView(
          child: Text(
            'SriRoute collects minimal personal information such as your name, email, '
            'and location to personalize your spiritual journey. We may also collect usage data to improve our services. '
            'Your data helps us recommend sacred routes, notify you of nearby temples, and enhance VR tour experiences. '
            'We do not sell your information to third parties.',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  // Help & Support dialog
  void _showHelpSupportDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Help & Support'),
        content: const SingleChildScrollView(
          child: Text(
            'For any questions or issues, please contact us at:\n\n'
            'support@sriroute.com\n\n'
            'Or visit our website at:\n'
            'https://sriroute.com',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  // Terms dialog
  void _showTermsDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Terms and Policies'),
        content: const SingleChildScrollView(
          child: Text(
            'By using SriRoute, you agree to abide by these Terms and Policies. '
            'SriRoute is a spiritual platform designed to connect devotees with sacred destinations. '
            'Users must respect the sanctity of the app. Any misuse, including posting inappropriate content '
            'or disrupting the community, may result in account suspension.',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  Widget _buildSection({required String title, required List<Widget> items}) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Colors.deepPurple,
                letterSpacing: 1.1,
              ),
            ),
            Divider(color: Colors.grey[300]),
            ...items,
          ],
        ),
      ),
    );
  }

  Widget _buildListTile({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
        child: Row(
          children: [
            Icon(icon, color: Colors.black, size: 24),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Colors.grey[800],
                ),
              ),
            ),
            Icon(Icons.chevron_right, color: Colors.grey[400]),
          ],
        ),
      ),
    );
  }
}
