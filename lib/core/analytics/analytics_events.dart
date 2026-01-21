/// Analytics event constants.
///
/// Use these constants to ensure consistency across your analytics.
/// Firebase Analytics has naming requirements:
/// - Max 40 characters
/// - Only alphanumeric characters and underscores
/// - Must start with a letter
///
/// ## Usage:
///
/// ```dart
/// await analyticsService.logEvent(
///   AnalyticsEvents.itemPurchased,
///   parameters: {'item_id': '123'},
/// );
/// ```
abstract final class AnalyticsEvents {
  // ─────────────────────────────────────────────────────────────────────────────
  // PREDEFINED FIREBASE EVENTS (use these when possible)
  // ─────────────────────────────────────────────────────────────────────────────

  /// User logged in.
  static const login = 'login';

  /// User signed up.
  static const signUp = 'sign_up';

  /// User performed a search.
  static const search = 'search';

  /// User shared content.
  static const share = 'share';

  /// User started the tutorial/onboarding.
  static const tutorialBegin = 'tutorial_begin';

  /// User completed the tutorial/onboarding.
  static const tutorialComplete = 'tutorial_complete';

  /// User selected content.
  static const selectContent = 'select_content';

  /// User viewed an item.
  static const viewItem = 'view_item';

  /// User added item to cart.
  static const addToCart = 'add_to_cart';

  /// User began checkout.
  static const beginCheckout = 'begin_checkout';

  /// User completed purchase.
  static const purchase = 'purchase';

  // ─────────────────────────────────────────────────────────────────────────────
  // CUSTOM APP EVENTS
  // ─────────────────────────────────────────────────────────────────────────────

  // Authentication
  /// User logged out.
  static const logout = 'logout';

  /// User verified OTP code.
  static const otpVerified = 'otp_verified';

  /// User resent OTP code.
  static const otpResent = 'otp_resent';

  /// User reset password.
  static const passwordReset = 'password_reset';

  /// User updated profile.
  static const profileUpdated = 'profile_updated';

  /// User deleted account.
  static const accountDeleted = 'account_deleted';

  // Engagement
  /// User clicked a button.
  static const buttonClick = 'button_click';

  /// User viewed a screen.
  static const screenView = 'screen_view';

  /// User pulled to refresh.
  static const pullToRefresh = 'pull_to_refresh';

  /// User enabled notifications.
  static const notificationsEnabled = 'notifications_enabled';

  /// User disabled notifications.
  static const notificationsDisabled = 'notifications_disabled';

  /// User tapped notification.
  static const notificationTapped = 'notification_tapped';

  // Settings
  /// User changed theme.
  static const themeChanged = 'theme_changed';

  /// User changed language.
  static const languageChanged = 'language_changed';

  /// User enabled biometric auth.
  static const biometricEnabled = 'biometric_enabled';

  // Feedback
  /// User submitted feedback.
  static const feedbackSubmitted = 'feedback_submitted';

  /// User rated the app.
  static const appRated = 'app_rated';

  /// User reported an issue.
  static const issueReported = 'issue_reported';

  // Errors
  /// App encountered an error.
  static const errorOccurred = 'error_occurred';

  /// API call failed.
  static const apiError = 'api_error';

  // Features
  /// User used feature.
  static const featureUsed = 'feature_used';

  /// User discovered feature.
  static const featureDiscovered = 'feature_discovered';

  // Subscription
  /// User started trial.
  static const trialStarted = 'trial_started';

  /// User subscribed.
  static const subscriptionStarted = 'subscription_started';

  /// User cancelled subscription.
  static const subscriptionCancelled = 'subscription_cancelled';

  /// User upgraded subscription.
  static const subscriptionUpgraded = 'subscription_upgraded';

  // Deep Links
  /// User opened app via deep link.
  static const deepLinkOpened = 'deep_link_opened';

  // Performance
  /// App launch time (cold start).
  static const appLaunchCold = 'app_launch_cold';

  /// App launch time (warm start).
  static const appLaunchWarm = 'app_launch_warm';
}

/// Analytics user properties constants.
///
/// User properties help segment your users for analysis.
///
/// ## Usage:
///
/// ```dart
/// await analyticsService.setUserProperty(
///   AnalyticsUserProperties.subscriptionTier,
///   'premium',
/// );
/// ```
abstract final class AnalyticsUserProperties {
  /// User's subscription tier (free, basic, premium).
  static const subscriptionTier = 'subscription_tier';

  /// User's preferred language.
  static const preferredLanguage = 'preferred_language';

  /// User's preferred theme (light, dark, system).
  static const preferredTheme = 'preferred_theme';

  /// Whether user has enabled notifications.
  static const notificationsEnabled = 'notifications_enabled';

  /// Whether user has enabled biometric auth.
  static const biometricEnabled = 'biometric_enabled';

  /// User's account type.
  static const accountType = 'account_type';

  /// User's signup method (email, google, apple).
  static const signupMethod = 'signup_method';

  /// User's onboarding status.
  static const onboardingCompleted = 'onboarding_completed';

  /// App version user is on.
  static const appVersion = 'app_version';

  /// Platform (iOS, Android).
  static const platform = 'platform';
}
