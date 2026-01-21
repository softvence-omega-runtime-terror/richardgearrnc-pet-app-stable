import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_bn.dart';
import 'app_localizations_en.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'generated/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('bn'),
  ];

  /// The title of the application
  ///
  /// In en, this message translates to:
  /// **'Flutter Boilerplate'**
  String get appTitle;

  /// Welcome message shown on the home screen
  ///
  /// In en, this message translates to:
  /// **'Welcome to the app!'**
  String get welcomeMessage;

  /// Login button text
  ///
  /// In en, this message translates to:
  /// **'Login'**
  String get login;

  /// Logout button text
  ///
  /// In en, this message translates to:
  /// **'Logout'**
  String get logout;

  /// Email input label
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get email;

  /// Password input label
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get password;

  /// Forgot password link text
  ///
  /// In en, this message translates to:
  /// **'Forgot Password?'**
  String get forgotPassword;

  /// Sign up button text
  ///
  /// In en, this message translates to:
  /// **'Sign Up'**
  String get signUp;

  /// Settings screen title
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// Profile screen title
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get profile;

  /// Home navigation label
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get home;

  /// Dark mode toggle label
  ///
  /// In en, this message translates to:
  /// **'Dark Mode'**
  String get darkMode;

  /// Language settings label
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// Notifications settings label
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get notifications;

  /// Biometric auth toggle label
  ///
  /// In en, this message translates to:
  /// **'Biometric Authentication'**
  String get biometricAuthentication;

  /// Title shown in biometric prompt
  ///
  /// In en, this message translates to:
  /// **'Authenticate'**
  String get biometricPromptTitle;

  /// Subtitle shown in biometric prompt
  ///
  /// In en, this message translates to:
  /// **'Verify your identity to continue'**
  String get biometricPromptSubtitle;

  /// Cancel button in biometric prompt
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get biometricPromptCancel;

  /// Generic error message
  ///
  /// In en, this message translates to:
  /// **'Something went wrong. Please try again.'**
  String get errorGeneric;

  /// Network error message
  ///
  /// In en, this message translates to:
  /// **'Network error. Please check your connection.'**
  String get errorNetwork;

  /// Timeout error message
  ///
  /// In en, this message translates to:
  /// **'Request timed out. Please try again.'**
  String get errorTimeout;

  /// Unauthorized error message
  ///
  /// In en, this message translates to:
  /// **'Session expired. Please login again.'**
  String get errorUnauthorized;

  /// Retry button text
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get retry;

  /// Cancel button text
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// Confirm button text
  ///
  /// In en, this message translates to:
  /// **'Confirm'**
  String get confirm;

  /// Save button text
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// Delete button text
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// Edit button text
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get edit;

  /// Loading indicator text
  ///
  /// In en, this message translates to:
  /// **'Loading...'**
  String get loading;

  /// Empty state message
  ///
  /// In en, this message translates to:
  /// **'No data available'**
  String get noData;

  /// Search input hint text
  ///
  /// In en, this message translates to:
  /// **'Search...'**
  String get searchHint;

  /// App version display text
  ///
  /// In en, this message translates to:
  /// **'Version {version}'**
  String version(String version);

  /// Item count with pluralization
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =0{No items} =1{1 item} other{{count} items}}'**
  String itemCount(int count);

  /// Last updated timestamp
  ///
  /// In en, this message translates to:
  /// **'Last updated: {date}'**
  String lastUpdated(DateTime date);

  /// First onboarding screen title
  ///
  /// In en, this message translates to:
  /// **'Welcome'**
  String get onboardingTitle1;

  /// First onboarding screen description
  ///
  /// In en, this message translates to:
  /// **'Discover amazing features and get started with our app.'**
  String get onboardingDescription1;

  /// Second onboarding screen title
  ///
  /// In en, this message translates to:
  /// **'Explore'**
  String get onboardingTitle2;

  /// Second onboarding screen description
  ///
  /// In en, this message translates to:
  /// **'Browse through a wide variety of content tailored for you.'**
  String get onboardingDescription2;

  /// Third onboarding screen title
  ///
  /// In en, this message translates to:
  /// **'Get Started'**
  String get onboardingTitle3;

  /// Third onboarding screen description
  ///
  /// In en, this message translates to:
  /// **'Create your account and start your journey.'**
  String get onboardingDescription3;

  /// Skip button text
  ///
  /// In en, this message translates to:
  /// **'Skip'**
  String get skip;

  /// Next button text
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get next;

  /// Get started button text
  ///
  /// In en, this message translates to:
  /// **'Get Started'**
  String get getStarted;

  /// Message shown when offline mode is active
  ///
  /// In en, this message translates to:
  /// **'Offline mode enabled'**
  String get offlineModeEnabled;

  /// Message shown when connection is restored
  ///
  /// In en, this message translates to:
  /// **'You\'re back online'**
  String get backOnline;

  /// Badge count settings label
  ///
  /// In en, this message translates to:
  /// **'Badge Count'**
  String get badgeCount;

  /// Notification count label with pluralization
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =0{No notifications} =1{1 notification} other{{count} notifications}}'**
  String notificationCountLabel(int count);

  /// Add 1 notification button text
  ///
  /// In en, this message translates to:
  /// **'Add 1'**
  String get addOne;

  /// Add 5 notifications button text
  ///
  /// In en, this message translates to:
  /// **'Add 5'**
  String get addFive;

  /// Clear badge button text
  ///
  /// In en, this message translates to:
  /// **'Clear'**
  String get clear;

  /// Badge count feature description
  ///
  /// In en, this message translates to:
  /// **'Tap the menu to manage badge count. This demonstrates how to track notification count across app restarts.'**
  String get badgeCountDescription;

  /// Success message when badge is incremented
  ///
  /// In en, this message translates to:
  /// **'Badge incremented'**
  String get badgeIncremented;

  /// Success message when badge is cleared
  ///
  /// In en, this message translates to:
  /// **'Badge cleared'**
  String get badgeCleared;

  /// Success message when notifications are added
  ///
  /// In en, this message translates to:
  /// **'Added {count} notifications'**
  String notificationsAddedFormat(int count);

  /// Error message format
  ///
  /// In en, this message translates to:
  /// **'Failed: {error}'**
  String failedFormat(String error);

  /// Theme settings label
  ///
  /// In en, this message translates to:
  /// **'Theme'**
  String get theme;

  /// App package name label
  ///
  /// In en, this message translates to:
  /// **'Package Name'**
  String get packageName;

  /// Terms of Service link text
  ///
  /// In en, this message translates to:
  /// **'Terms of Service'**
  String get termsOfService;

  /// Privacy Policy link text
  ///
  /// In en, this message translates to:
  /// **'Privacy Policy'**
  String get privacyPolicy;

  /// Open source licenses link text
  ///
  /// In en, this message translates to:
  /// **'Open Source Licenses'**
  String get openSourceLicenses;

  /// Theme selection dialog title
  ///
  /// In en, this message translates to:
  /// **'Choose Theme'**
  String get chooseTheme;

  /// Light theme option
  ///
  /// In en, this message translates to:
  /// **'Light'**
  String get lightMode;

  /// Dark theme option
  ///
  /// In en, this message translates to:
  /// **'Dark'**
  String get darkModeOption;

  /// System default theme option
  ///
  /// In en, this message translates to:
  /// **'System default'**
  String get systemDefault;

  /// Login page welcome message
  ///
  /// In en, this message translates to:
  /// **'Welcome Back'**
  String get welcomeBack;

  /// Login page subtitle
  ///
  /// In en, this message translates to:
  /// **'Sign in to continue'**
  String get signInToContinue;

  /// Notification demo section title
  ///
  /// In en, this message translates to:
  /// **'Notifications & Deep Linking'**
  String get notificationsDeepLinking;

  /// Notification demo instruction text
  ///
  /// In en, this message translates to:
  /// **'Send a notification that routes to Settings when tapped.'**
  String get sendNotificationInstruction;

  /// Error message when badge count cannot be loaded
  ///
  /// In en, this message translates to:
  /// **'Badge count unavailable'**
  String get badgeCountUnavailable;

  /// Badge count display label
  ///
  /// In en, this message translates to:
  /// **'Badge Count: {count}'**
  String badgeCountLabel(int count);

  /// Appearance settings section
  ///
  /// In en, this message translates to:
  /// **'Appearance'**
  String get appearance;

  /// About app section
  ///
  /// In en, this message translates to:
  /// **'About'**
  String get about;

  /// Legal section in settings
  ///
  /// In en, this message translates to:
  /// **'Legal'**
  String get legal;

  /// Version label in settings (without version number)
  ///
  /// In en, this message translates to:
  /// **'Version'**
  String get versionLabel;

  /// Language selection dialog title
  ///
  /// In en, this message translates to:
  /// **'Choose Language'**
  String get chooseLanguage;

  /// English language option
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get english;

  /// Bengali language option
  ///
  /// In en, this message translates to:
  /// **'Bengali (বাংলা)'**
  String get bengali;

  /// Feature showcase widget title
  ///
  /// In en, this message translates to:
  /// **'Feature Showcase'**
  String get featureShowcase;

  /// Feature showcase description
  ///
  /// In en, this message translates to:
  /// **'Explore the boilerplate\'s built-in utilities and components.'**
  String get featureShowcaseDescription;

  /// Feedback service demo title
  ///
  /// In en, this message translates to:
  /// **'Feedback Service'**
  String get feedbackDemo;

  /// Feedback demo description
  ///
  /// In en, this message translates to:
  /// **'Show different types of snackbar messages.'**
  String get feedbackDemoDescription;

  /// Success button label
  ///
  /// In en, this message translates to:
  /// **'Success'**
  String get success;

  /// Error button label
  ///
  /// In en, this message translates to:
  /// **'Error'**
  String get error;

  /// Info button label
  ///
  /// In en, this message translates to:
  /// **'Info'**
  String get info;

  /// Dialog demo title
  ///
  /// In en, this message translates to:
  /// **'Dialogs'**
  String get dialogDemo;

  /// Dialog demo description
  ///
  /// In en, this message translates to:
  /// **'Show confirmation dialogs using AppDialogs.'**
  String get dialogDemoDescription;

  /// Show dialog button label
  ///
  /// In en, this message translates to:
  /// **'Show Dialog'**
  String get showDialog;

  /// Navigation demo title
  ///
  /// In en, this message translates to:
  /// **'Type-Safe Navigation'**
  String get navigationDemo;

  /// Navigation demo description
  ///
  /// In en, this message translates to:
  /// **'Navigate using AppRoute enum for compile-time safety.'**
  String get navigationDemoDescription;

  /// Navigate to settings button label
  ///
  /// In en, this message translates to:
  /// **'Go to Settings'**
  String get goToSettings;

  /// Feedback message when notifications are enabled
  ///
  /// In en, this message translates to:
  /// **'Notifications enabled'**
  String get notificationsEnabled;

  /// Notifications settings description
  ///
  /// In en, this message translates to:
  /// **'Enable or disable push notifications for this app.'**
  String get notificationsEnabledDescription;

  /// Notification demo title
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get notificationDemo;

  /// Notification demo description
  ///
  /// In en, this message translates to:
  /// **'Send local notifications with scheduling support.'**
  String get notificationDemoDescription;

  /// Send basic notification button label
  ///
  /// In en, this message translates to:
  /// **'Send Notification'**
  String get basicNotification;

  /// Logout confirmation message
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to sign out?'**
  String get confirmLogout;

  /// Error message when logout fails
  ///
  /// In en, this message translates to:
  /// **'Failed to sign out. Please try again.'**
  String get logoutFailed;

  /// Welcome message on home page
  ///
  /// In en, this message translates to:
  /// **'You\'re all set!'**
  String get youAreAllSet;

  /// Welcome card description
  ///
  /// In en, this message translates to:
  /// **'Start building your amazing app.'**
  String get startBuilding;

  /// Title for the basic notification demo
  ///
  /// In en, this message translates to:
  /// **'Hello!'**
  String get notificationTitle;

  /// Body text for the basic notification demo
  ///
  /// In en, this message translates to:
  /// **'This is a basic notification from the boilerplate.'**
  String get notificationBody;

  /// Title for the dialog confirmation demo
  ///
  /// In en, this message translates to:
  /// **'Confirm Action'**
  String get dialogConfirmTitle;

  /// Message text for the dialog confirmation demo
  ///
  /// In en, this message translates to:
  /// **'This demonstrates the AppDialogs.confirm() helper.'**
  String get dialogConfirmMessage;

  /// Confirm button text in the dialog demo
  ///
  /// In en, this message translates to:
  /// **'Got it'**
  String get dialogConfirmButton;

  /// Snackbar message when dialog is confirmed
  ///
  /// In en, this message translates to:
  /// **'Dialog confirmed!'**
  String get dialogConfirmed;

  /// Validation error message for empty email field
  ///
  /// In en, this message translates to:
  /// **'Email is required'**
  String get emailRequired;

  /// Validation error message for invalid email format
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid email'**
  String get emailInvalid;

  /// Validation error message for empty password field
  ///
  /// In en, this message translates to:
  /// **'Password is required'**
  String get passwordRequired;

  /// Validation error message for weak password
  ///
  /// In en, this message translates to:
  /// **'Password must be 8+ chars with uppercase, lowercase, number & special char'**
  String get passwordWeak;

  /// Title for first onboarding page
  ///
  /// In en, this message translates to:
  /// **'Welcome'**
  String get onboardingWelcomeTitle;

  /// Description for first onboarding page
  ///
  /// In en, this message translates to:
  /// **'Welcome to Flutter Boilerplate. A production-ready template for your next app.'**
  String get onboardingWelcomeDescription;

  /// Title for second onboarding page
  ///
  /// In en, this message translates to:
  /// **'Modern Architecture'**
  String get onboardingArchitectureTitle;

  /// Description for second onboarding page
  ///
  /// In en, this message translates to:
  /// **'Built with Riverpod, GoRouter, and clean architecture principles.'**
  String get onboardingArchitectureDescription;

  /// Title for third onboarding page
  ///
  /// In en, this message translates to:
  /// **'Ready to Ship'**
  String get onboardingReadyTitle;

  /// Description for third onboarding page
  ///
  /// In en, this message translates to:
  /// **'Everything you need to build and ship your app faster.'**
  String get onboardingReadyDescription;

  /// Skip button text in onboarding
  ///
  /// In en, this message translates to:
  /// **'Skip'**
  String get onboardingSkip;

  /// Back button text in onboarding
  ///
  /// In en, this message translates to:
  /// **'Back'**
  String get onboardingBack;

  /// Next button text in onboarding
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get onboardingNext;

  /// Get started button text (final onboarding page)
  ///
  /// In en, this message translates to:
  /// **'Get Started'**
  String get onboardingGetStarted;

  /// Feedback message when notifications are disabled
  ///
  /// In en, this message translates to:
  /// **'Notifications disabled'**
  String get notificationsDisabled;

  /// Sign-in prompt message on home screen for unauthenticated users
  ///
  /// In en, this message translates to:
  /// **'Sign in to unlock exclusive features'**
  String get signInToUnlock;

  /// Login page hero title
  ///
  /// In en, this message translates to:
  /// **'Login To Explore'**
  String get loginToExplore;

  /// Phone number input label
  ///
  /// In en, this message translates to:
  /// **'Phone Number'**
  String get phoneNumber;

  /// Validation error when phone number is empty
  ///
  /// In en, this message translates to:
  /// **'Phone number is required'**
  String get phoneNumberRequired;

  /// Validation error when phone number is invalid
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid phone number'**
  String get phoneNumberInvalid;

  /// Separator text between login options
  ///
  /// In en, this message translates to:
  /// **'Or'**
  String get or;

  /// Google sign-in button text
  ///
  /// In en, this message translates to:
  /// **'Google'**
  String get google;

  /// Phone number input hint text
  ///
  /// In en, this message translates to:
  /// **'(000) 000-0000'**
  String get phoneInputHint;

  /// Placeholder message for Google Sign-In feature
  ///
  /// In en, this message translates to:
  /// **'Google Sign-In coming soon'**
  String get googleSignInComingSoon;

  /// OTP page title
  ///
  /// In en, this message translates to:
  /// **'Enter verification code'**
  String get enterVerificationCode;

  /// OTP page subtitle instruction
  ///
  /// In en, this message translates to:
  /// **'Enter the code sent to your phone number'**
  String get enterCodeSentToPhoneNumber;

  /// OTP verification button text
  ///
  /// In en, this message translates to:
  /// **'Verify Code'**
  String get verifyCode;

  /// Error message for invalid OTP code
  ///
  /// In en, this message translates to:
  /// **'Invalid verification code. Please try again.'**
  String get otpCodeInvalid;

  /// Text shown when user didn't receive OTP code
  ///
  /// In en, this message translates to:
  /// **'Didn\'t receive the code?'**
  String get didNotReceiveCode;

  /// Button text to resend OTP code
  ///
  /// In en, this message translates to:
  /// **'Resend Code'**
  String get resendCode;

  /// Text showing countdown timer for resend button
  ///
  /// In en, this message translates to:
  /// **'Resend code in {seconds}s'**
  String resendCodeIn(int seconds);

  /// Success message when OTP code is resent
  ///
  /// In en, this message translates to:
  /// **'Code sent successfully!'**
  String get codeSentSuccessfully;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['bn', 'en'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'bn':
      return AppLocalizationsBn();
    case 'en':
      return AppLocalizationsEn();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
