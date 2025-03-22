import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SignupSuccessPage extends StatefulWidget {
  const SignupSuccessPage({super.key});

  @override
  State<SignupSuccessPage> createState() => _SignupSuccessPageState();
}

class _SignupSuccessPageState extends State<SignupSuccessPage> {
  bool _isAutoNavigating = true;
  String _username = 'User';

  @override
  void initState() {
    super.initState();
    _loadUsername();

    // Automatically navigate to home screen after 3 seconds
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted && _isAutoNavigating) {
        Navigator.pushNamedAndRemoveUntil(context, "/home", (route) => false);
      }
    });
  }

  // Load username from SharedPreferences first, then try Firebase
  Future<void> _loadUsername() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final savedUsername = prefs.getString('username');

      if (savedUsername != null && savedUsername.isNotEmpty && mounted) {
        setState(() {
          _username = savedUsername;
        });
        return;
      }

      // Fallback to Firebase display name if available
      final user = FirebaseAuth.instance.currentUser;
      if (user?.displayName != null &&
          user!.displayName!.isNotEmpty &&
          mounted) {
        setState(() {
          _username = user.displayName!;
        });

        // Save to shared preferences for easier access
        await prefs.setString('username', user.displayName!);
      }
    } catch (e) {
      debugPrint("Error loading username: $e");
    }
  }

  @override
  void dispose() {
    _isAutoNavigating = false;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false, // Prevent back button
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Success Icon with Animation
                TweenAnimationBuilder<double>(
                  tween: Tween<double>(begin: 0, end: 1),
                  duration: const Duration(milliseconds: 800),
                  builder: (context, value, child) {
                    return Transform.scale(scale: value, child: child);
                  },
                  child: const Icon(
                    Icons.check_circle,
                    color: Colors.green,
                    size: 100,
                  ),
                ),
                const SizedBox(height: 20),

                // Success Text with username
                Text(
                  "Welcome, $_username!",
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 10),

                // Subtitle
                const Text(
                  "Your account has been created successfully. Enjoy exploring Sri Route!",
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.black54, fontSize: 16),
                ),
                const SizedBox(height: 30),

                // Auto-navigation progress indicator
                TweenAnimationBuilder<double>(
                  tween: Tween<double>(begin: 0, end: 1),
                  duration: const Duration(seconds: 3),
                  builder: (context, value, child) {
                    return Column(
                      children: [
                        LinearProgressIndicator(
                          value: value,
                          backgroundColor: Colors.grey[200],
                          valueColor: const AlwaysStoppedAnimation<Color>(
                            Colors.green,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          "Redirecting to home screen in ${(3 - value * 3).ceil()} seconds...",
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 12,
                          ),
                        ),
                      ],
                    );
                  },
                ),

                const SizedBox(height: 30),

                // Done Button → Navigates to Home Page immediately
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                    minimumSize: const Size(double.infinity, 50),
                  ),
                  onPressed: () {
                    _isAutoNavigating = false;
                    Navigator.pushNamedAndRemoveUntil(
                      context,
                      "/home",
                      (route) => false,
                    );
                  },
                  child: const Text(
                    "Go to Home",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
