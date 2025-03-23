import 'package:flutter/foundation.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserService {
  // Static user data cached for quick access
  static String _username = 'User';
  static Map<String, dynamic> _userData = {};
  static final FirebaseAuth _auth = FirebaseAuth.instance;

  // Get the current user's username
  static String get username => _username;

  // Get all user data
  static Map<String, dynamic> get userData => _userData;

  // Save username to SharedPreferences
  static Future<void> saveUsername(String username) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('username', username);
      _username = username;
    } catch (e) {
      debugPrint("Error saving username: $e");
    }
  }

  // Load user data from SharedPreferences and Firestore
  static Future<void> loadUserData() async {
    try {
      // First try to load from SharedPreferences for speed
      final prefs = await SharedPreferences.getInstance();
      final savedUsername = prefs.getString('username');
      if (savedUsername != null && savedUsername.isNotEmpty) {
        _username = savedUsername;
      }

      // Then try to get complete data from Firestore
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        // If we have Firebase user, try to get their Firestore data
        try {
          final docSnapshot =
              await FirebaseFirestore.instance
                  .collection('users')
                  .doc(user.uid)
                  .get();

          if (docSnapshot.exists) {
            _userData = docSnapshot.data() ?? {};

            // Update username if available in Firestore
            if (_userData['username'] != null &&
                _userData['username'].isNotEmpty) {
              _username = _userData['username'];
              await saveUsername(_username);
            }
            // Or update Firestore if we have a username but Firestore doesn't
            else if (_username != 'User') {
              await FirebaseFirestore.instance
                  .collection('users')
                  .doc(user.uid)
                  .set({
                    'username': _username,
                    'updatedAt': FieldValue.serverTimestamp(),
                  }, SetOptions(merge: true));
            }
          } else {
            // Create user document if it doesn't exist
            await FirebaseFirestore.instance
                .collection('users')
                .doc(user.uid)
                .set({
                  'username': _username,
                  'email': user.email,
                  'createdAt': FieldValue.serverTimestamp(),
                });
          }
        } catch (e) {
          debugPrint("Error loading user data from Firestore: $e");
        }

        // If no username yet, try Firebase display name
        if (_username == 'User' &&
            user.displayName != null &&
            user.displayName!.isNotEmpty) {
          _username = user.displayName!;
          await saveUsername(_username);
        }
      }
    } catch (e) {
      debugPrint("Error in loadUserData: $e");
    }
  }

  /// Gets the user's profile image URL with proper priority:
  /// 1. Firestore photoURL (highest priority - custom uploaded image)
  /// 2. Firebase Auth photoURL (Google account profile image)
  /// 3. Returns null if no profile image is available
  static Future<String?> getProfileImageUrl() async {
    try {
      final user = _auth.currentUser;
      if (user == null) return null;

      // Check Firestore first (highest priority)
      try {
        final docSnapshot =
            await FirebaseFirestore.instance
                .collection('users')
                .doc(user.uid)
                .get();

        if (docSnapshot.exists && docSnapshot.data()?['photoURL'] != null) {
          final firestorePhotoUrl = docSnapshot.data()!['photoURL'] as String;
          if (firestorePhotoUrl.isNotEmpty) {
            // Save to SharedPreferences for faster access next time
            final prefs = await SharedPreferences.getInstance();
            await prefs.setString('profileImageUrl', firestorePhotoUrl);
            return firestorePhotoUrl;
          }
        }
      } catch (e) {
        debugPrint("Error getting photo from Firestore: $e");
        // Continue to next option if Firestore fails
      }

      // If not in Firestore, check Firebase Auth (Google profile picture)
      if (user.photoURL != null && user.photoURL!.isNotEmpty) {
        return user.photoURL;
      }

      // Try SharedPreferences as last resort (might have cached value)
      final prefs = await SharedPreferences.getInstance();
      String? profileImageUrl = prefs.getString('profileImageUrl');
      if (profileImageUrl != null && profileImageUrl.isNotEmpty) {
        return profileImageUrl;
      }

      // If no profile image is found anywhere, return null
      return null;
    } catch (e) {
      debugPrint("Error getting profile image URL: $e");
      return null;
    }
  }
}
