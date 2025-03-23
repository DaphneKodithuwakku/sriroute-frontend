void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Sri Route",  // Consistent naming
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
  

  
  bool _isLoading = false;
  String? _errorMessage;
  bool _obscurePassword = true;
  
  // Email & Password Sign In - Updated to use helper
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
      // Use helper method to handle sign in with error recovery
      final UserCredential? userCredential = await FirebaseAuthHelper.signInWithEmailPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text,
      );
      
      // Check if the user is authenticated despite possible errors
      if (userCredential == null && !FirebaseAuthHelper.isUserAuthenticated()) {
        setState(() {
          _isLoading = false;
          _errorMessage = "Login failed. Please try again.";
        });
        return;
      }
      
      // Get the current user - either from userCredential or directly from FirebaseAuth
      final user = userCredential?.user ?? FirebaseAuth.instance.currentUser;
      if (user == null) {
        setState(() {
          _isLoading = false;
          _errorMessage = "Failed to authenticate user";
        });
        return;
      }
      
      debugPrint("User signed in: ${user.uid}");
      
      // Get username from Firebase or set default
      String username = "User";
      if (user.displayName != null && user.displayName!.isNotEmpty) {
        username = user.displayName!;
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
      String errorMessage = 'Sign in failed. Please try again.';
      
      // Add special handling for the type casting error
      if (e.toString().contains("type 'List<Object?>") && 
          e.toString().contains("is not a subtype of type 'PigeonUserDetails?'")) {
        errorMessage = "There's a technical issue. Please try again.";
      }
      
      setState(() {
        _errorMessage = errorMessage;
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