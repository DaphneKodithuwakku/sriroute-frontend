import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../services/user_service.dart';
import 'signup_page.dart'; // Import Signup Page
import 'completion_page.dart'; // Import Completion Page
import 'signup_success_page.dart'; // Import Signup Success Page

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Sri Route",
      theme: ThemeData(primarySwatch: Colors.green),
      home: const LoginPage(),
      routes: {
        "/signup": (context) => const SignUpPage(), // Route for SignUp Page
        "/completion":
            (context) =>
                const SignupCompletionPage(), // Route for Completion Page
        "/signup-success":
            (context) => const SignupSuccessPage(), // ✅ Route for Success Page
      },
    );
  }
}

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  bool _isLoading = false;
  String? _errorMessage;
  bool _obscurePassword = true;

  // Email & Password Sign In
  Future<void> _signInWithEmailAndPassword() async {
    if (_emailController.text.trim().isEmpty ||
        _passwordController.text.isEmpty) {
      setState(() {
        _errorMessage = "Please enter both email and password";
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final credential = await _auth.signInWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text,
      );

      debugPrint("User signed in: ${credential.user?.uid}");

      // Get username from Firebase or set default
      String username = "User";
      if (credential.user?.displayName != null &&
          credential.user!.displayName!.isNotEmpty) {
        username = credential.user!.displayName!;
      }

      // Save the username
      await UserService.saveUsername(username);

      // Mark welcome screens as completed
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('showWelcome', false);

      // Force refresh user service data
      await UserService.loadUserData();

      if (mounted) {
        Navigator.pushReplacementNamed(context, '/home');
      }
    } on FirebaseAuthException catch (e) {
      String message;
      switch (e.code) {
        case 'user-not-found':
          message = 'No user found with this email.';
          break;
        case 'wrong-password':
          message = 'Wrong password provided.';
          break;
        case 'invalid-email':
          message = 'The email address is invalid.';
          break;
        case 'user-disabled':
          message = 'This user account has been disabled.';
          break;
        case 'too-many-requests':
          message =
              'Too many unsuccessful login attempts. Please try again later.';
          break;
        default:
          message = e.message ?? 'An error occurred during sign in.';
      }

      setState(() {
        _errorMessage = message;
      });
      debugPrint("Firebase Auth Error: ${e.code} - ${e.message}");
    } catch (e) {
      setState(() {
        _errorMessage = 'Sign in failed. Please try again.';
      });
      debugPrint("Error during sign in: $e");
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}
