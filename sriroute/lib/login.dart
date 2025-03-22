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
    if (_emailController.text.trim().isEmpty || _passwordController.text.isEmpty) {
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
      if (credential.user?.displayName != null && credential.user!.displayName!.isNotEmpty) {
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
          message = 'Too many unsuccessful login attempts. Please try again later.';
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
  
  // Google Sign In
  Future<void> _signInWithGoogle() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });
    
    try {
      // Begin Google sign in process
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      
      if (googleUser == null) {
        // User cancelled the sign-in flow
        setState(() {
          _isLoading = false;
        });
        return;
      }
      
      // Get authentication details from Google
      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      
      // Create credential for Firebase
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      
      // Sign in to Firebase with the Google credential
      final userCredential = await _auth.signInWithCredential(credential);
      
      debugPrint("User signed in with Google: ${userCredential.user?.uid}");
      
      // Save the username
      String username = "User";
      if (userCredential.user?.displayName != null && userCredential.user!.displayName!.isNotEmpty) {
        username = userCredential.user!.displayName!;
      }
      
      // Save username to shared preferences
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
      setState(() {
        _errorMessage = e.message ?? 'Firebase authentication error';
      });
      debugPrint("Firebase Auth Error: ${e.code} - ${e.message}");
    } catch (e) {
      String errorMessage;
      if (e.toString().contains("ApiException: 10:")) {
        errorMessage = 'Google Sign-In configuration error. Please check Firebase Console settings.';
      } else if (e.toString().contains("network_error")) {
        errorMessage = 'Network error. Please check your internet connection.';
      } else {
        errorMessage = 'Google sign in failed. Please try again.';
      }
      
      setState(() {
        _errorMessage = errorMessage;
      });
      debugPrint("Error during Google sign in: $e");
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _showResetPasswordDialog() {
    final TextEditingController resetEmailController = TextEditingController();
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Reset Password"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              "Enter your email address to receive a password reset link.",
              style: TextStyle(fontSize: 14),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: resetEmailController,
              keyboardType: TextInputType.emailAddress,
              decoration: const InputDecoration(
                hintText: "Email",
                border: OutlineInputBorder(),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () async {
              if (resetEmailController.text.trim().isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text("Please enter your email address"),
                    backgroundColor: Colors.red,
                  ),
                );
                return;
              }
              
              try {
                await _auth.sendPasswordResetEmail(
                  email: resetEmailController.text.trim(),
                );
                
                if (mounted) {
                  Navigator.pop(context);
                  
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("Password reset email sent. Please check your inbox."),
                      backgroundColor: Colors.green,
                    ),
                  );
                }
              } on FirebaseAuthException catch (e) {
                String message;
                switch (e.code) {
                  case 'user-not-found':
                    message = 'No user found with this email address.';
                    break;
                  case 'invalid-email':
                    message = 'The email address is not valid.';
                    break;
                  default:
                    message = e.message ?? 'Failed to send reset email.';
                }
                
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(message),
                    backgroundColor: Colors.red,
                  ),
                );
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text("Error: ${e.toString()}"),
                    backgroundColor: Colors.red,
                  ),
                );
              }
            },
            child: const Text("Send Link"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(), // Dismiss keyboard
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 60), // Space at top
                
                // Welcome Text
                const Text(
                  "Hey! Welcome to Sri Route!",
                  style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                ),
                const Text(
                  "Let's get started.",
                  style: TextStyle(fontSize: 16, color: Colors.grey),
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

                // Email Field
                TextField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.email, color: Colors.black),
                    hintText: "Email",
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                ),
                const SizedBox(height: 15),

                // Password Field
                TextField(
                  controller: _passwordController,
                  obscureText: _obscurePassword,
                  decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.lock, color: Colors.black),
                    hintText: "Password",
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscurePassword ? Icons.visibility : Icons.visibility_off,
                        color: Colors.grey,
                      ),
                      onPressed: () {
                        setState(() {
                          _obscurePassword = !_obscurePassword;
                        });
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 10),

                // Forgot Password Button
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: _showResetPasswordDialog,
                    child: const Text(
                      "Forgot Password?",
                      style: TextStyle(color: Colors.grey),
                    ),
                  ),
                ),

                // Login Button
                _isLoading 
                  ? const CircularProgressIndicator()
                  : ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black,
                      foregroundColor: Colors.white,
                      minimumSize: const Size(double.infinity, 50),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    onPressed: _signInWithEmailAndPassword,
                    child: const Text(
                      "Log In",
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ),

                const SizedBox(height: 20),
                const Row(
                  children: [
                    Expanded(child: Divider(color: Colors.grey)),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16.0),
                      child: Text(
                        "Or Continue With",
                        style: TextStyle(color: Colors.grey, fontSize: 14),
                      ),
                    ),
                    Expanded(child: Divider(color: Colors.grey)),
                  ],
                ),
                const SizedBox(height: 20),

  }
}
