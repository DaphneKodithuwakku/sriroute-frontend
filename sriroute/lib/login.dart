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


  
  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}
