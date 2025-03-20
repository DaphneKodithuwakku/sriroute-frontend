import 'package:flutter/material.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';

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

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(), // Dismiss keyboard
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
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

              // Username Field
              buildTextField(hintText: "Username", icon: Icons.person),
              const SizedBox(height: 15),

              // Password Field
              buildTextField(
                hintText: "Password",
                icon: Icons.lock,
                obscureText: true,
              ),
              const SizedBox(height: 10),

              // Forgot Password Button
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () {},
                  child: const Text(
                    "Forgot Password?",
                    style: TextStyle(color: Colors.grey),
                  ),
                ),
              ),

              // Login Button
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  foregroundColor: Colors.white,
                  minimumSize: const Size(double.infinity, 50),
                ),
                onPressed: () {},
                child: const Text("Log In"),
              ),

              const SizedBox(height: 20),
              const Text("Or Continue With"),
              const SizedBox(height: 20),

              // Social Media Sign-in Buttons
              SignInButton(
                Buttons.Google,
                text: "Continue with Google",
                onPressed: () {},
              ),
              SignInButton(
                Buttons.Facebook,
                text: "Continue with Facebook",
                onPressed: () {},
              ),
              SignInButton(
                Buttons.Apple,
                text: "Continue with Apple",
                onPressed: () {},
              ),

              const SizedBox(height: 20),

              // Navigation to Signup Page
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Not a member? "),
                  TextButton(
                    onPressed: () {
                      Navigator.pushNamed(context, "/signup");
                    },
                    child: const Text(
                      "Register Now",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Reusable TextField Widget
  Widget buildTextField({
    required String hintText,
    required IconData icon,
    bool obscureText = false,
  }) {
    return TextField(
      obscureText: obscureText,
      decoration: InputDecoration(
        prefixIcon: Icon(icon, color: Colors.black),
        hintText: hintText,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }
}
