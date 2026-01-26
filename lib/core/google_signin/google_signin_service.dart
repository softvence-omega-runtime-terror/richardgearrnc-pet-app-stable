import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:google_sign_in/google_sign_in.dart';
import 'package:petzy_app/config/google_signin_config.dart';
import 'package:petzy_app/core/utils/logger.dart';

/// Service responsible for authenticating users via Google Sign-In
/// and linking the Google account with Firebase Authentication.
///
/// Compatible with:
/// - google_sign_in ^7.2.0
/// - firebase_auth ^6.1.4
///
/// 2026 Platform Integration:
/// - **iOS**: Initializes with clientId from GoogleService-Info.plist
/// - **Android**: Initializes with serverClientId for Credential Manager (v7.0+)
/// - Returns Firebase ID token (safe for backend API calls)
///
/// This service is UI-agnostic and safe to use with Riverpod.
class GoogleSignInService {
  /// Creates a [GoogleSignInService].
  ///
  /// Dependencies can be injected for testing.
  GoogleSignInService({
    final firebase_auth.FirebaseAuth? firebaseAuth,
  }) : _firebaseAuth = firebaseAuth ?? firebase_auth.FirebaseAuth.instance;

  final firebase_auth.FirebaseAuth _firebaseAuth;
  bool _isInitialized = false;

  /// Returns the singleton GoogleSignIn instance (v7.x API).
  GoogleSignIn get _googleSignIn => GoogleSignIn.instance;

  /// Initializes GoogleSignIn with platform-specific client IDs.
  /// - iOS: Uses clientId from GoogleService-Info.plist
  /// - Android: Uses serverClientId for Credential Manager
  /// This is a one-time operation that must be called before authenticate().
  Future<void> _ensureInitialized() async {
    if (_isInitialized) return;

    try {
      // Initialize with platform-specific IDs for google_sign_in v7.x
      await _googleSignIn.initialize(
        // iOS requires clientId from GoogleService-Info.plist
        clientId: Platform.isIOS ? GoogleSignInConfig.iosClientId : null,
        // Android requires serverClientId for Credential Manager integration
        serverClientId: Platform.isAndroid
            ? GoogleSignInConfig.androidServerClientId
            : null,
      );
      _isInitialized = true;
    } catch (e, stack) {
      AppLogger.instance.w(
        'GoogleSignIn initialization (may already be initialized)',
        error: e,
        stackTrace: stack,
      );
      // It's OK if this fails - likely already initialized
      _isInitialized = true;
    }
  }

  /// Triggers interactive Google Sign-In and authenticates with Firebase.
  ///
  /// Flow:
  /// 1. Ensures initialization with platform-specific client IDs
  /// 2. Calls [GoogleSignIn.instance.authenticate()] which:
  ///    - On iOS: Uses native ASWebAuthenticationSession (KeyChain integration)
  ///    - On Android 7.0+: Uses Credential Manager (with serverClientId)
  ///    - Throws on cancellation (doesn't return null)
  /// 3. Gets authentication token with ID token
  /// 4. Extracts ID token (required for Firebase)
  /// 5. Creates Firebase credential
  /// 6. Authenticates with Firebase
  /// 7. Returns Firebase ID token (safe for APIs)
  ///
  /// Returns the Firebase ID token for use in backend API calls.
  ///
  /// Throws [GoogleSignInException] on any error including user cancellation.
  Future<String> signIn() async {
    try {
      // 1️⃣ Ensure GoogleSignIn is initialized with serverClientId
      await _ensureInitialized();

      // 2️⃣ Trigger interactive Google Sign-In
      // On Android: Uses Credential Manager when serverClientId is provided
      // In v7.x, authenticate() throws on cancellation (doesn't return null)
      final googleAccount = await _googleSignIn.authenticate();

      // 3️⃣ Get authentication token with ID token
      final googleAuth = await googleAccount.authentication;

      // 4️⃣ Extract ID token (required for Firebase)
      final idToken = googleAuth.idToken;
      if (idToken == null) {
        throw const GoogleSignInException(
          message:
              'Missing Google ID token. Check serverClientId configuration.',
        );
      }

      // 5️⃣ Create Firebase credential with ID token
      final credential = firebase_auth.GoogleAuthProvider.credential(
        idToken: idToken,
      );

      // 6️⃣ Authenticate with Firebase
      final userCredential = await _firebaseAuth.signInWithCredential(
        credential,
      );

      final user = userCredential.user;
      if (user == null) {
        throw const GoogleSignInException(
          message: 'Firebase user creation failed',
        );
      }

      // 7️⃣ Get Firebase ID token for API calls
      final firebaseIdToken = await user.getIdToken();
      if (firebaseIdToken == null) {
        throw const GoogleSignInException(
          message: 'Failed to retrieve Firebase ID token',
        );
      }

      return firebaseIdToken;
    } on firebase_auth.FirebaseAuthException catch (e, stack) {
      AppLogger.instance.e(
        'FirebaseAuthException during Google sign-in',
        error: e,
        stackTrace: stack,
      );
      throw GoogleSignInException(
        message: e.message ?? 'Firebase authentication failed',
      );
    } on GoogleSignInException {
      rethrow;
    } catch (e, stack) {
      AppLogger.instance.e(
        'Unexpected error during Google sign-in',
        error: e,
        stackTrace: stack,
      );

      // Handle user cancellation errors from platform
      if (e.toString().contains('PlatformException') ||
          e.toString().contains('cancelled') ||
          e.toString().contains('user_cancelled')) {
        throw const GoogleSignInException.cancelled();
      }

      throw GoogleSignInException(
        message: 'Sign in failed: ${e.toString()}',
      );
    }
  }

  /// Signs out from both Google and Firebase.
  ///
  /// Call this on app logout.
  Future<void> signOut() async {
    try {
      await Future.wait<void>([
        _googleSignIn.signOut(),
        _firebaseAuth.signOut(),
      ]);
    } catch (e, stack) {
      AppLogger.instance.w(
        'Error during Google sign-out',
        error: e,
        stackTrace: stack,
      );
    }
  }

  /// Fully disconnects the Google account from the app.
  ///
  /// This revokes Google consent and requires re-authentication.
  Future<void> disconnect() async {
    try {
      await Future.wait<void>([
        _googleSignIn.disconnect(),
        _firebaseAuth.signOut(),
      ]);
    } catch (e, stack) {
      AppLogger.instance.w(
        'Error disconnecting Google account',
        error: e,
        stackTrace: stack,
      );
    }
  }
}

/// Exception thrown for Google Sign-In related failures.
class GoogleSignInException implements Exception {
  /// Creates a [GoogleSignInException].
  const GoogleSignInException({
    required this.message,
    this.isCancelled = false,
  });

  /// Factory for cancellation cases (not an error).
  const GoogleSignInException.cancelled()
    : message = 'User cancelled Google sign-in',
      isCancelled = true;

  /// Description of the failure.
  final String message;

  /// Whether the flow was cancelled by the user.
  final bool isCancelled;

  @override
  String toString() => 'GoogleSignInException: $message';
}
