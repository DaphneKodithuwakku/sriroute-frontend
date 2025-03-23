import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

// Rename class to FirebaseAuthHelper since it now handles all auth methods
class FirebaseAuthHelper {
  static Future<void> checkConfiguration() async {
    try {
      debugPrint("Checking Google Sign-In configuration...");
      
      // Initialize GoogleSignIn with basic scopes
      final GoogleSignIn googleSignIn = GoogleSignIn(
        scopes: ['email', 'profile'],
      );
      
      // Don't actually sign in, just check initialization
      final bool isAvailable = await googleSignIn.canAccessScopes(['email']);
      
      debugPrint("Google Sign-In available: $isAvailable");
      
      // Get the client ID for debug purposes (redacted for security)
      final String? clientId = await _getClientId(googleSignIn);
      if (clientId != null && clientId.isNotEmpty) {
        final String redactedClientId = "${clientId.substring(0, 6)}...${clientId.substring(clientId.length - 6)}";
        debugPrint("Google client ID detected: $redactedClientId");
      } else {
        debugPrint("Warning: No Google client ID detected");
      }
      
    } catch (e) {
      debugPrint("Error checking Google Sign-In configuration: $e");
    }
  }
  
  // Helper method to extract client ID (using internal API, might not work for all versions)
  static Future<String?> _getClientId(GoogleSignIn googleSignIn) async {
    try {
      // This is a crude way to get client ID and might break with future GoogleSignIn versions
      final dynamic signIn = googleSignIn;
      final dynamic result = await signIn.clientId;
      return result?.toString();
    } catch (e) {
      debugPrint("Unable to retrieve client ID: $e");
      return null;
    }
  }
  
  static String explainErrorCode(String errorMessage) {
    if (errorMessage.contains("10:")) {
      return """
Error 10: SHA-1 certificate fingerprint not registered.

FIX: Add your app's SHA-1 fingerprint to Firebase console:
1. Get your SHA-1 with:
   keytool -list -v -keystore ~/.android/debug.keystore -alias androiddebugkey -storepass android -keypass android
2. Go to Firebase Console → Project Settings → Your Android app
3. Add the SHA-1 fingerprint
4. Download new google-services.json and replace in your project
""";
    } else if (errorMessage.contains("12501")) {
      return "Error 12501: User cancelled the sign-in flow.";
    } else if (errorMessage.contains("12502")) {
      return "Error 12502: Google Sign-In could not establish a connection.";
    } else if (errorMessage.contains("network_error")) {
      return "Network error: Please check your internet connection.";
    } else if (errorMessage.contains("google-signin-cast-error")) {
      return "There's a compatibility issue with Google Sign-In. Please try email login or update the app.";
    } else if (errorMessage.contains("type 'List<Object?>") && 
               errorMessage.contains("is not a subtype of type 'PigeonUserDetails?'")) {
      return "There's a compatibility issue with Google Sign-In. Please try email login or update the app.";
    } else if (errorMessage.contains("signup-cast-error")) {
      return "There was an issue with account creation. Please try again.";
    } else {
      return errorMessage;
    }
  }

  // Method to print SHA-1 certificate info for debugging
  static Future<void> printDebugCertificateInfo() async {
    try {
      debugPrint("--------- Google Sign-In Debug Info ---------");
      debugPrint("To fix Error 10, add your SHA-1 fingerprint to Firebase Console:");
      debugPrint("1. Run this command to get your SHA-1:");
      debugPrint("   keytool -list -v -keystore ~/.android/debug.keystore -alias androiddebugkey -storepass android -keypass android");
      debugPrint("2. The SHA-1 fingerprint will look like: AA:BB:CC:DD:...");
      debugPrint("3. Add this to Firebase Console under Project Settings → Your Android app → Add fingerprint");
      debugPrint("-------------------------------------------");
    } catch (e) {
      debugPrint("Error retrieving certificate info: $e");
    }
  }

  // Enhanced method to check if a user is authenticated regardless of errors
  static bool isUserAuthenticated() {
    return FirebaseAuth.instance.currentUser != null;
  }
  
  // Enhanced Google sign-in with better error recovery
  static Future<UserCredential?> signInWithGoogle() async {
    try {
      debugPrint("Starting Google Sign-In process...");
      
      // Initialize GoogleSignIn with basic scopes
      final GoogleSignIn googleSignIn = GoogleSignIn(
        scopes: ['email', 'profile'],
      );
      
      // Begin sign-in flow - this can throw the type casting error
      try {
        final GoogleSignInAccount? googleUser = await googleSignIn.signIn();
        
        if (googleUser == null) {
          debugPrint("Google Sign-In cancelled by user");
          return null;
        }
        
        // Get authentication details
        final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
        
        // Create Firebase credential
        final credential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken,
        );