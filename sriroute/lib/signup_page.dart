import 'package:flutter/material.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  bool agreeToTerms = false;
  String? selectedLanguage;
  final List<String> languages = ["English", "Spanish", "French", "German"];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Sign-up"),
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Center(
              child: Column(
                children: [
                  Text(
                    "Nice to see you!",
                    style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 5),
                  Text(
                    "Create your account",
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30),

            // Username Input
            TextField(
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.person, color: Colors.white),
                hintText: "Username",
                filled: true,
                fillColor: Colors.black,
                hintStyle: const TextStyle(color: Colors.white),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide.none,
                ),
              ),
              style: const TextStyle(color: Colors.white),
            ),
            const SizedBox(height: 15),

            // Email Input
            TextField(
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.email, color: Colors.white),
                hintText: "Email address",
                filled: true,
                fillColor: Colors.black,
                hintStyle: const TextStyle(color: Colors.white),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide.none,
                ),
              ),
              style: const TextStyle(color: Colors.white),
            ),
            const SizedBox(height: 15),

            // Password Input
            TextField(
              obscureText: true,
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.lock, color: Colors.white),
                hintText: "Password",
                filled: true,
                fillColor: Colors.black,
                hintStyle: const TextStyle(color: Colors.white),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide.none,
                ),
              ),
              style: const TextStyle(color: Colors.white),
            ),
            const SizedBox(height: 15),

            // Language Selection Dropdown
            DropdownButtonFormField<String>(
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.language, color: Colors.white),
                filled: true,
                fillColor: Colors.black,
                hintText: "Language",
                hintStyle: const TextStyle(color: Colors.white),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide.none,
                ),
              ),
              dropdownColor: Colors.black,
              style: const TextStyle(color: Colors.white),
              value: selectedLanguage,
              items:
                  languages.map((String language) {
                    return DropdownMenuItem<String>(
                      value: language,
                      child: Text(
                        language,
                        style: const TextStyle(color: Colors.white),
                      ),
                    );
                  }).toList(),
              onChanged: (String? value) {
                setState(() {
                  selectedLanguage = value;
                });
              },
            ),
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
                const Text(
                  "I agree with Terms & Conditions",
                  style: TextStyle(color: Colors.grey),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Continue Button
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                foregroundColor: Colors.white,
                minimumSize: const Size(double.infinity, 50),
              ),
              onPressed: () {
                if (agreeToTerms) {
                  // Handle sign-up logic here
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text(
                        "You must agree to the Terms & Conditions.",
                      ),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              },
              child: const Text("Continue"),
            ),
          ],
        ),
      ),
      backgroundColor: Colors.white,
    );
  }
}
