import 'package:flutter/material.dart';

class SignupCompletionPage extends StatefulWidget {
  const SignupCompletionPage({super.key});

  @override
  _SignupCompletionPageState createState() => _SignupCompletionPageState();
}

class _SignupCompletionPageState extends State<SignupCompletionPage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  String? _selectedLanguage;
  bool _isAgreed = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
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

              // Username Input Field
              buildTextField(
                controller: _usernameController,
                hintText: "Username",
                icon: Icons.person,
              ),

              const SizedBox(height: 15),

              // Password Input Field
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
                    activeColor: Colors.black,
                    value: _isAgreed,
                    onChanged: (value) {
                      setState(() {
                        _isAgreed = value!;
                      });
                    },
                  ),
                  const Text(
                    "I agree with Terms & Conditions",
                    style: TextStyle(color: Colors.black),
                  ),
                ],
              ),

              const Spacer(),

              // Continue Button
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.greenAccent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  onPressed: () {
                    if (_isAgreed) {
                      // Handle continue action
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                            "Please agree to the Terms & Conditions",
                          ),
                          backgroundColor: Colors.red,
                        ),
                      );
                    }
                  },
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

              const SizedBox(height: 30),
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
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.black54,
        borderRadius: BorderRadius.circular(10),
      ),
      child: TextField(
        controller: controller,
        obscureText: obscureText,
        style: const TextStyle(color: Colors.white),
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.symmetric(
            vertical: 15,
            horizontal: 20,
          ),
          border: InputBorder.none,
          hintText: hintText,
          hintStyle: const TextStyle(color: Colors.white70),
          prefixIcon: Icon(icon, color: Colors.white),
        ),
      ),
    );
  }

  // Widget for Language Selection Dropdown
  Widget buildLanguageDropdown() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      decoration: BoxDecoration(
        color: Colors.black54,
        borderRadius: BorderRadius.circular(10),
      ),
      child: DropdownButton<String>(
        isExpanded: true,
        underline: const SizedBox(),
        icon: const Icon(
          Icons.arrow_forward_ios,
          color: Colors.white,
          size: 16,
        ),
        hint: const Text("Language", style: TextStyle(color: Colors.white)),
        dropdownColor: Colors.black,
        style: const TextStyle(color: Colors.white),
        value: _selectedLanguage,
        items:
            ["English", "Spanish", "French", "German"]
                .map((lang) => DropdownMenuItem(value: lang, child: Text(lang)))
                .toList(),
        onChanged: (value) {
          setState(() {
            _selectedLanguage = value;
          });
        },
      ),
    );
  }
}
