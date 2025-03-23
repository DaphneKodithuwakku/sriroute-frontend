void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Sri Route", // Consistent naming
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
