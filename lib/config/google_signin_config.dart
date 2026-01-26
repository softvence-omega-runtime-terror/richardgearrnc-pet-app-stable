/// Configuration for Google Sign-In.
///
/// Contains platform-specific client IDs for Android and iOS.
/// These are required by google_sign_in ^7.2.0 for proper platform integration.
abstract final class GoogleSignInConfig {
  /// iOS Client ID from GoogleService-Info.plist (CLIENT_ID).
  ///
  /// This is required for iOS to properly initialize Google Sign-In.
  /// Obtained from: GoogleService-Info.plist > CLIENT_ID
  static const String iosClientId =
      '389948242204-nk6421icrug37432r6pur1mtog6ffeod.apps.googleusercontent.com';

  /// Web Client ID from Firebase Console (client_type: 3 in google-services.json).
  ///
  /// This is required for Android's Credential Manager API (google_sign_in ^7.0.0+).
  /// The Web Client ID is used for server-side verification.
  /// Used as serverClientId parameter for Android platform.
  static const String androidServerClientId =
      '389948242204-80bqgg5hqodk52imrrsdvc1u7gmu5p62.apps.googleusercontent.com';
}
