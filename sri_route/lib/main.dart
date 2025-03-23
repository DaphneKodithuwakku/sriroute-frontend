import 'package:flutter/material.dart';

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
    await AppCheckService.initializeAppCheck()
        .then((_) {
          debugPrint("App Check initialization completed");
        })
        .catchError((error) {
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
