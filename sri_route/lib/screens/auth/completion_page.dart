import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

// StatefulWidget for completing signup details
class SignupCompletionPage extends StatefulWidget {
  const SignupCompletionPage({super.key});

  @override
  State<SignupCompletionPage> createState() => _SignupCompletionPageState();
}

class _SignupCompletionPageState extends State<SignupCompletionPage> {
  // Controller for the additional information input field
  final TextEditingController _additionalInfoController =
      TextEditingController();

  // Form key for validation
  final _formKey = GlobalKey<FormState>();
  // Variables to hold user preferences
  String? _selectedLanguage;
  bool _isAgreed = false;
  bool _isLoading = false;
  String? _errorMessage;

  // Firebase authentication instance
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  void initState() {
    super.initState();
    _loadPreferredLanguage();
    _checkAuthStatus(); // Ensure the user is still authenticated
  }

  // Check if user is still authenticated
  Future<void> _checkAuthStatus() async {
    if (_auth.currentUser == null) {
      // Not authenticated, redirect to login
      if (mounted) {
        Navigator.pushReplacementNamed(context, '/login');
      }
    }
  }

  // Load the user's preferred language from shared preferences
  Future<void> _loadPreferredLanguage() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final language = prefs.getString('language');
      if (language != null && mounted) {
        setState(() {
          _selectedLanguage = language;
        });
      } else {
        setState(() {
          _selectedLanguage = 'English'; // Default language
        });
      }
    } catch (e) {
      debugPrint("Error loading language preference: $e");
      setState(() {
        _selectedLanguage = 'English'; // Default language on error
      });
    }
  }

  // Method to finalize signup and save preferences
  Future<void> _finalizeSignup() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      // Verify user is still authenticated
      final currentUser = _auth.currentUser;
      if (currentUser == null) {
        throw Exception("User is no longer authenticated");
      }

      // Save preferences
      final prefs = await SharedPreferences.getInstance();
      if (_selectedLanguage != null) {
        await prefs.setString('language', _selectedLanguage!);
      }

      await prefs.setBool('notificationsEnabled', _isAgreed);

      // Save additional info if provided
      final additionalInfo = _additionalInfoController.text.trim();
      if (additionalInfo.isNotEmpty) {
        await prefs.setString('additionalInfo', additionalInfo);
      }

      // Flag that user has completed onboarding
      await prefs.setBool('showWelcome', false);

      // Navigate to the success page
      if (mounted) {
        Navigator.pushReplacementNamed(context, "/signup-success");
      }
    } on FirebaseAuthException catch (e) {
      setState(() {
        _errorMessage = e.message ?? "Firebase authentication error";
      });
      debugPrint("Firebase Auth Error: ${e.code} - ${e.message}");
    } catch (e) {
      setState(() {
        _errorMessage = "An error occurred. Please try again.";
      });
      debugPrint("Error during completion: $e");
    } finally {
      // Stop loading spinner
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        // Prevent back navigation to keep user on this screen
        return false;
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: const Text("Complete Your Profile"),
          backgroundColor: Colors.black,
          foregroundColor: Colors.white,
          automaticallyImplyLeading: false, // Remove back button
        ),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 20),

                  // Header Text
                  const Center(
                    child: Text(
                      "Almost there!",
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ),

                  const SizedBox(height: 5),

                  // Subtitle
                  const Center(
                    child: Text(
                      "Just a few more details to set up your account.",
                      style: TextStyle(fontSize: 14, color: Colors.black54),
                      textAlign: TextAlign.center,
                    ),
                  ),

                  const SizedBox(height: 40),

                  // Error message
                  if (_errorMessage != null)
                    Container(
                      padding: const EdgeInsets.all(10),
                      margin: const EdgeInsets.only(bottom: 15),
                      decoration: BoxDecoration(
                        color: Colors.red.shade100,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      width: double.infinity,
                      child: Row(
                        children: [
                          Icon(Icons.error_outline, color: Colors.red.shade800),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              _errorMessage!,
                              style: TextStyle(color: Colors.red.shade800),
                            ),
                          ),
                        ],
                      ),
                    ),

                  // Additional Information Field
                  TextFormField(
                    controller: _additionalInfoController,
                    decoration: InputDecoration(
                      labelText: "Additional Information (Optional)",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      prefixIcon: const Icon(Icons.info_outline),
                    ),
                    maxLines: 2,
                  ),

                  const SizedBox(height: 15),

                  // Language Selection Dropdown
                  DropdownButtonFormField<String>(
                    decoration: InputDecoration(
                      labelText: "Preferred Language",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      prefixIcon: const Icon(Icons.language),
                    ),
                    value: _selectedLanguage,
                    items: ["English", "Spanish", "French", "German"]
                        .map(
                          (lang) => DropdownMenuItem(
                            value: lang,
                            child: Text(lang),
                          ),
                        )
                        .toList(),
                    onChanged: (value) {
                      setState(() {
                        _selectedLanguage = value;
                      });
                    },
                  ),

                  const SizedBox(height: 20),

                  // Notifications Checkbox
                  Row(
                    children: [
                      Checkbox(
                        activeColor: Colors.black,
                        value: _isAgreed,
                        onChanged: (value) {
                          setState(() {
                            _isAgreed = value!;
                          });
                        },
                      ),
                      const Expanded(
                        child: Text(
                          "I agree to receive updates about news and promotions",
                          style: TextStyle(color: Colors.black),
                        ),
                      ),
                    ],
                  ),

                  const Spacer(),

                  // Show either a loading spinner or the "Continue" button based on `_isLoading` state
                  // If `_isLoading` is true, show a circular progress indicator to indicate the process is ongoing
                  _isLoading
                      ? const Center(child: CircularProgressIndicator())
                      : SizedBox(
                          width: double.infinity,
                          height: 50,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.greenAccent,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30),
                              ),
                            ),
                            onPressed: _finalizeSignup,
                            child: const Text(
                              "Continue",
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),

                  const SizedBox(
                      height: 30), // Add some vertical spacing at the bottom
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

// Called when the widget is permanently removed from the widget tree
  @override
  // Disposes the TextEditingController to free up resources
  // This is important to prevent memory leaks when the widget is destroyed
  void dispose() {
    _additionalInfoController.dispose();
    super.dispose();
  }
}
