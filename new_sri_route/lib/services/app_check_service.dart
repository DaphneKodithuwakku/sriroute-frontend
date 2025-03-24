import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:flutter/foundation.dart';
import 'dart:math' as math;

class AppCheckService {
  static bool _isInitialized = false;
  static int _retryAttempts = 0;
  static const int _maxRetryAttempts = 3;
  static String? _debugToken;

  /// Initialize Firebase App Check with appropriate retry logic
  static Future<void> initializeAppCheck() async {
    if (_isInitialized) return;

    try {
      // IMPORTANT: Get and log debug token *before* activating App Check
      _debugToken = await _extractDebugToken();
      if (_debugToken != null) {
        debugPrint(
            '⚠️ IMPORTANT: Add this debug token to Firebase Console: $_debugToken');
        debugPrint(
            'Go to: Firebase Console > Project Settings > App Check > Debug verification');
      }

      // For development, ALWAYS use debug provider only
      await FirebaseAppCheck.instance.activate(
        androidProvider: AndroidProvider.debug,
        appleProvider: AppleProvider.debug,
        // Important: Don't mix debug/production providers during development
      );

      _isInitialized = true;
      _retryAttempts = 0; // Reset retry counter on success
      debugPrint('Firebase App Check initialized successfully in debug mode');
    } catch (e) {
      debugPrint('Error initializing Firebase App Check: $e');

      if (_retryAttempts < _maxRetryAttempts) {
        _retryAttempts++;
        // Exponential backoff: 2^retry * 200ms + random jitter
        final backoff =
            math.pow(2, _retryAttempts) * 200 + (math.Random().nextInt(100));
        debugPrint(
            'Retrying App Check initialization in ${backoff}ms (attempt $_retryAttempts)');

        await Future.delayed(Duration(milliseconds: backoff.toInt()));
        await initializeAppCheck(); // Recursive retry with backoff
      } else {
        debugPrint(
            '⚠️ Failed to initialize App Check after $_retryAttempts attempts');
        debugPrint(
            '⚠️ Warning: App will continue without App Check verification');
        // Mark as initialized to prevent further retries and let app continue
        _isInitialized = true;
      }
    }
  }

  /// Get debug token without initializing App Check first
  static Future<String?> _extractDebugToken() async {
    try {
      // Try to extract debug token from logs programmatically
      // This is an unofficial approach but works in many cases

      // For Android, the token is generated during app startup
      // Check logs for a line containing: "Enter this debug secret into the allow list"

      // Return null here as we can't directly extract the token programmatically
      // Let the developer copy it from the logs instead
      return null;
    } catch (e) {
      debugPrint('Error extracting debug token: $e');
      return null;
    }
  }

  /// Get App Check token with retry mechanism
  static Future<String?> getToken() async {
    if (!_isInitialized) {
      await initializeAppCheck();
    }

    try {
      final token = await FirebaseAppCheck.instance.getToken();
      return token;
    } catch (e) {
      debugPrint('Error getting App Check token: $e');
      // Show important debug information
      debugPrint('⚠️ If you see App Check errors, verify that:');
      debugPrint('1. You\'ve added your debug token to Firebase Console');
      if (_debugToken != null) {
        debugPrint('   Debug token: $_debugToken');
      } else {
        debugPrint('   Check logs above for your debug token');
      }
      debugPrint('2. Your Firebase project is properly configured');
      return null;
    }
  }
}
