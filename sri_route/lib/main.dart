import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_app_check/firebase_app_check.dart';
import 'firebase_options.dart';
import 'screens/welcome/welcomepage1.dart';
import 'screens/auth/login.dart';
import 'screens/auth/signup_page.dart';
import 'screens/auth/completion_page.dart';
import 'screens/auth/signup_success_page.dart';
import 'screens/main_screen.dart';
import 'utils/image_loader.dart';
import 'services/user_service.dart';
import 'screens/360_screen/detail_screen.dart';
import 'screens/360_screen/panorama_screen.dart';
import 'utils/firebase_auth_helper.dart';
import 'services/app_check_service.dart';
import 'screens/notifications/notifications_screen.dart';
import 'services/notification_service.dart';
import 'package:geolocator/geolocator.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize geolocator plugin explicitly
  try {
    await GeolocatorPlatform.instance.isLocationServiceEnabled();
    debugPrint("Geolocator plugin initialized successfully");
  } catch (e) {
    debugPrint("Error initializing Geolocator plugin: $e");
    // This will ensure the plugin is registered properly even if the above fails
  }

  // Firebase initialization
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );

    // Initialize App Check with enhanced error handling
    debugPrint("Initializing Firebase App Check...");
    await AppCheckService.initializeAppCheck().then((_) {
      debugPrint("App Check initialization completed");
    }).catchError((error) {
      debugPrint("App Check initialization error: $error");
      // App can continue without App Check if needed
    });

    // Initialize notifications with error handling
    try {
      await NotificationService.initializeNotifications();
      debugPrint("Notifications initialized successfully");
    } catch (e) {
      debugPrint("Error initializing notifications: $e");
      // App can continue without notifications if needed
    }

    // Check if Firebase Auth is properly initialized
    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      if (user != null) {
        debugPrint("Firebase Auth is working, user: ${user.uid}");
      } else {
        debugPrint("Firebase Auth is working, no user signed in");
      }
    });

    // Print debug certificate info to help with Error 10
    await FirebaseAuthHelper.checkConfiguration();
    await FirebaseAuthHelper.printDebugCertificateInfo();
  } catch (e) {
    debugPrint("Error initializing Firebase: $e");
    // Show dialog or snackbar to user that app functionality might be limited
  }

  // Pre-load user data
  try {
    await UserService.loadUserData();
  } catch (e) {
    debugPrint("Error pre-loading user data: $e");
  }

  // Initialize image loader without memory management
  await ImagePreloader.init();

  // Set preferred orientations
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.landscapeLeft,
    DeviceOrientation.landscapeRight,
  ]);

  // Check if first launch to decide showing welcome screens or not
  final prefs = await SharedPreferences.getInstance();
  final showWelcome = prefs.getBool('showWelcome') ?? true;

  runApp(MyApp(showWelcome: showWelcome));
}

class MyApp extends StatelessWidget {
  final bool showWelcome;
  const MyApp({super.key, required this.showWelcome});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Sri Route',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        useMaterial3: true,
      ),
      debugShowCheckedModeBanner: false,
      home: _handleStartupNavigation(),
      routes: {
        '/welcome': (context) => const WelcomePage1(),
        '/login': (context) => const LoginPage(),
        '/signup': (context) => const SignUpPage(),
        '/completion': (context) => const SignupCompletionPage(),
        '/signup-success': (context) => const SignupSuccessPage(),
        '/home': (context) => const MainScreen(),
        '/notifications': (context) => const NotificationsScreen(),
      },
      onGenerateRoute: (settings) {
        if (settings.name == '/details') {
          return MaterialPageRoute(
            builder: (context) =>
                TempleDetailScreen.fromArguments(settings.arguments),
          );
        }
        if (settings.name == '/panorama') {
          return MaterialPageRoute(
            builder: (context) =>
                PanoramaScreen(storagePath: settings.arguments as String?),
          );
        }
        return null;
      },
      navigatorObservers: [NavigationObserver()],
    );
  }

  Widget _handleStartupNavigation() {
    // Check if user has seen welcome screens
    if (showWelcome) {
      return const WelcomePage1();
    }

    // Check if user is already logged in
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        if (snapshot.hasData) {
          // User is logged in - debug print to verify
          debugPrint("User is logged in: ${snapshot.data?.uid}");
          return const MainScreen();
        }

        // User is not logged in - debug print to verify
        debugPrint("No user logged in, redirecting to login");
        return const LoginPage();
      },
    );
  }
}

// Custom NavigatorObserver to track and debug route navigation events
// Handles cases where route names might be null, and prints navigation activity to console
class NavigationObserver extends NavigatorObserver {
  // Called when a new route is pushed onto the navigator stack
  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    final routeName = route.settings.name ?? 'unnamed-route';
    final previousRouteName = previousRoute?.settings.name ?? 'unknown';
    debugPrint('Navigating to: $routeName (from: $previousRouteName)');
  }

// Called when a route is popped (i.e., user navigates back)
  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) {
    final routeName = route.settings.name ?? 'unnamed-route';
    final previousRouteName = previousRoute?.settings.name ?? 'unknown';
    debugPrint('Navigating back from: $routeName (to: $previousRouteName)');
  }

// Called when a route is removed from the stack without navigating (e.g., programmatic removal)
  @override
  void didRemove(Route<dynamic> route, Route<dynamic>? previousRoute) {
    final routeName = route.settings.name ?? 'unnamed-route';
    debugPrint('Removed route: $routeName');
  }

// Called when a route is replaced with another (e.g., using pushReplacement)
  @override
  void didReplace({Route<dynamic>? newRoute, Route<dynamic>? oldRoute}) {
    final newRouteName = newRoute?.settings.name ?? 'unnamed-route';
    final oldRouteName = oldRoute?.settings.name ?? 'unknown';
    debugPrint('Replaced $oldRouteName with $newRouteName');
  }
}
