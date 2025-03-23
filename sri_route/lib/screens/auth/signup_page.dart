import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../services/user_service.dart';
import '../../utils/google_signin_helper.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  
  String? selectedLanguage = 'English'; // Default language
  bool agreeToTerms = false;
  bool _isLoading = false;
  String? _errorMessage;
  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;

  final List<String> languages = ["English", "Spanish", "French", "German"];

  // Validate email format
  bool _isValidEmail(String email) {
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    return emailRegex.hasMatch(email);
  }

  // Convert Firebase auth errors to user-friendly messages
  String _getMessageFromErrorCode(FirebaseAuthException e) {
    switch (e.code) {
      case 'email-already-in-use':
        return 'An account already exists for that email. Please log in instead.';
      case 'invalid-email':
        return 'The email address is not valid.';
      case 'operation-not-allowed':
        return 'Email/password accounts are not enabled. Please contact support.';
      case 'weak-password':
        return 'The password provided is too weak. Please create a stronger password.';
      case 'network-request-failed':
        return 'Network error. Please check your connection and try again.';
      default:
        return e.message ?? 'An error occurred. Please try again.';
    }
  }

  // Email/password signup - Updated with better null handling
  Future<void> _signUp() async {
    if (_formKey.currentState!.validate() && agreeToTerms) {
      setState(() {
        _isLoading = true;
        _errorMessage = null;
      });

      try {
        // Use the helper to create the user account
        final UserCredential? userCredential = await FirebaseAuthHelper.signUpWithEmailPassword(
          email: _emailController.text.trim(),
          password: _passwordController.text,
          username: _usernameController.text.trim(),
          language: selectedLanguage,
        );
        
        // Check if current user exists despite possible null userCredential
        // This handles the case when our error recovery flow was used
        final currentUser = FirebaseAuth.instance.currentUser;
        
        if (userCredential == null && currentUser == null) {
          setState(() {
            _isLoading = false;
            _errorMessage = "Signup failed. Please try again.";
          });
          return;
        }
        
        // User was created successfully - either through userCredential or recovery flow
        // Save user details locally
        await UserService.saveUsername(_usernameController.text.trim());
        
        // Save language preference
        final prefs = await SharedPreferences.getInstance();
        if (selectedLanguage != null) {
          await prefs.setString('language', selectedLanguage!);
        }
        
        // Set onboarding as completed 
        await prefs.setBool('showWelcome', false);
        
        // Force data refresh
        await UserService.loadUserData();
        
        if (mounted) {
          // Navigate to success page
          Navigator.pushReplacementNamed(context, "/signup-success");
        }
      } on FirebaseAuthException catch (e) {
        setState(() {
          _errorMessage = _getMessageFromErrorCode(e);
        });
        debugPrint("Firebase Auth Error: ${e.code} - ${e.message}");
      } catch (e) {
        String message = "An error occurred. Please try again.";
        
        // Check for the specific type casting error
        if (e.toString().contains("type 'List<Object?>") && 
            e.toString().contains("is not a subtype of type 'PigeonUserDetails?'")) {
          message = "There's a compatibility issue with our authentication system. Please try again or contact support.";
        }
        
        setState(() {
          _errorMessage = message;
        });
        debugPrint("Error during signup: $e");
      } finally {
        if (mounted) {
          setState(() {
            _isLoading = false;
          });
        }
      }
    } else {
      // Show error for terms if everything else is valid
      if (_formKey.currentState!.validate() && !agreeToTerms) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Please agree to the Terms & Conditions"),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("Sign-up"),
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
      ),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                const Center(
                  child: Column(
                    children: [
                      Text(
                        "Create Account",
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 5),
                      Text(
                        "Fill in your details to create an account",
                        style: TextStyle(fontSize: 14, color: Colors.grey),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 30),
                
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
