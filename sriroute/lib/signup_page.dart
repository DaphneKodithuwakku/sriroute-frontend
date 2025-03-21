import 'package:flutter/material.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  String? selectedLanguage;
  bool agreeToTerms = false;

  final List<String> languages = ["English", "Spanish", "French", "German"];

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
        onTap:
            () =>
                FocusScope.of(
                  context,
                ).unfocus(), // Hide the keyboard when tapping outside
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header part
              const Center(
                child: Column(
                  children: [
                    Text(
                      "Almost there!",
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 5),
                    Text(
                      "Just a few more details to set up your account.",
                      style: TextStyle(fontSize: 14, color: Colors.grey),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 30),

              // Username Input
              buildTextField(
                controller: _usernameController,
                hintText: "Username",
                icon: Icons.person,
              ),
              const SizedBox(height: 15),

              // Email Input
              buildTextField(
                controller: _emailController,
                hintText: "Email address",
                icon: Icons.email,
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 15),

              // Password Input
              buildTextField(
                controller: _passwordController,
                hintText: "Password",
                icon: Icons.lock,
                obscureText: true,
              ),
              const SizedBox(height: 15),

              // Language Selection Dropdown
              buildLanguageDropdown(),
              const SizedBox(height: 20),

              // Terms & Conditions Checkbox
              Row(
                children: [
                  Checkbox(
                    value: agreeToTerms,
                    activeColor: Colors.green,
                    onChanged: (bool? value) {
                      setState(() {
                        agreeToTerms = value!;
                      });
                    },
                  ),
                  const Text("I agree with Terms & Conditions"),
                ],
              ),
              const SizedBox(height: 20),

              // Continue Button will navigates to completion page**
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  foregroundColor: Colors.white,
                  minimumSize: const Size(double.infinity, 50),
                ),
                onPressed: () {
                  if (_validateInputs()) {
                    Navigator.pushNamed(context, "/completion");
                  }
                },
                child: const Text("Continue"),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Widget for Input Fields
  Widget buildTextField({
    required TextEditingController controller,
    required String hintText,
    required IconData icon,
    bool obscureText = false,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return TextField(
      controller: controller,
      obscureText: obscureText,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        prefixIcon: Icon(icon, color: Colors.black),
        hintText: hintText,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  // Widget for Language Selection Dropdown
  Widget buildLanguageDropdown() {
    return DropdownButtonFormField<String>(
      decoration: InputDecoration(
        prefixIcon: const Icon(Icons.language, color: Colors.black),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
      ),
      value: selectedLanguage,
      items:
          languages.map((lang) {
            return DropdownMenuItem(value: lang, child: Text(lang));
          }).toList(),
      onChanged: (value) {
        setState(() {
          selectedLanguage = value;
        });
      },
    );
  }

  // Validation for Inputs
  bool _validateInputs() {
    if (_usernameController.text.isEmpty ||
        _emailController.text.isEmpty ||
        _passwordController.text.isEmpty ||
        selectedLanguage == null ||
        !agreeToTerms) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            "Please fill all fields and agree to Terms & Conditions",
          ),
          backgroundColor: Colors.red,
        ),
      );
      return false;
    }
    return true;
  }
}
