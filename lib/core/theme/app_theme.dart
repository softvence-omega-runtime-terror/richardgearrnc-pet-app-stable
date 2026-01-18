import 'package:flutter/material.dart';
import 'package:petzy_app/core/theme/app_colors.dart';
import 'package:petzy_app/core/theme/app_typography.dart';

/// App theme configuration.
///
/// Provides light and dark themes with shared component styles.
/// Uses Material 3 design system with a custom color scheme
/// tailored for the Petzy brand.
///
/// Usage:
/// ```dart
/// MaterialApp(
///   theme: AppTheme.light,
///   darkTheme: AppTheme.dark,
///   themeMode: ThemeMode.system,
/// )
/// ```
abstract class AppTheme {
  // ─────────────────────────────────────────────────────────────────────────────
  // SHARED CONSTANTS
  // ─────────────────────────────────────────────────────────────────────────────

  /// Standard border radius for buttons.
  static const double _buttonRadius = 12;

  /// Standard border radius for cards.
  static const double _cardRadius = 16;

  /// Standard border radius for inputs.
  static const double _inputRadius = 12;

  /// Standard border radius for snackbars.
  static const double _snackBarRadius = 8;

  /// Minimum button size (width x height).
  static const Size _buttonMinSize = Size(double.infinity, 48);

  /// Standard input padding.
  static const EdgeInsets _inputPadding = EdgeInsets.symmetric(
    horizontal: 16,
    vertical: 16,
  );

  // ─────────────────────────────────────────────────────────────────────────────
  // SHARED COMPONENT THEMES
  // ─────────────────────────────────────────────────────────────────────────────

  /// Common app bar theme for both light and dark modes.
  static const AppBarTheme _appBarTheme = AppBarTheme(
    centerTitle: true,
    elevation: 0,
    scrolledUnderElevation: 1,
  );

  /// Common filled button style.
  static final FilledButtonThemeData _filledButtonTheme = FilledButtonThemeData(
    style: FilledButton.styleFrom(
      minimumSize: _buttonMinSize,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(_buttonRadius),
      ),
    ),
  );

  /// Common outlined button style.
  static final OutlinedButtonThemeData _outlinedButtonTheme =
      OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          minimumSize: _buttonMinSize,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(_buttonRadius),
          ),
        ),
      );

  /// Common text button style.
  static final TextButtonThemeData _textButtonTheme = TextButtonThemeData(
    style: TextButton.styleFrom(
      minimumSize: _buttonMinSize,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(_buttonRadius),
      ),
    ),
  );

  /// Common input decoration theme.
  static final InputDecorationTheme _inputDecorationTheme =
      InputDecorationTheme(
        filled: true,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(_inputRadius),
        ),
        contentPadding: _inputPadding,
      );

  /// Common card theme.
  static final CardThemeData _cardTheme = CardThemeData(
    elevation: 0,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(_cardRadius),
    ),
  );

  /// Common snackbar theme.
  static final SnackBarThemeData _snackBarTheme = SnackBarThemeData(
    behavior: SnackBarBehavior.floating,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(_snackBarRadius),
    ),
  );

  // ─────────────────────────────────────────────────────────────────────────────
  // PUBLIC THEMES
  // ─────────────────────────────────────────────────────────────────────────────

  /// Light theme.
  static ThemeData get light {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      colorScheme: _lightColorScheme,
      scaffoldBackgroundColor: AppColors.background,
      textTheme: AppTypography.textTheme,
      appBarTheme: _appBarTheme,
      filledButtonTheme: _filledButtonTheme,
      outlinedButtonTheme: _outlinedButtonTheme,
      textButtonTheme: _textButtonTheme,
      inputDecorationTheme: _inputDecorationTheme,
      cardTheme: _cardTheme,
      snackBarTheme: _snackBarTheme,
    );
  }

  /// Dark theme.
  static ThemeData get dark {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: _darkColorScheme,
      scaffoldBackgroundColor: _darkColorScheme.surface,
      textTheme: AppTypography.textTheme,
      appBarTheme: _appBarTheme,
      filledButtonTheme: _filledButtonTheme,
      outlinedButtonTheme: _outlinedButtonTheme,
      textButtonTheme: _textButtonTheme,
      inputDecorationTheme: _inputDecorationTheme,
      cardTheme: _cardTheme,
      snackBarTheme: _snackBarTheme,
    );
  }

  // ─────────────────────────────────────────────────────────────────────────────
  // COLOR SCHEMES
  // ─────────────────────────────────────────────────────────────────────────────

  /// Light mode color scheme.
  static const ColorScheme _lightColorScheme = ColorScheme(
    brightness: Brightness.light,

    primary: AppColors.primary,
    onPrimary: AppColors.onPrimary,
    primaryContainer: AppColors.primaryContainer,
    onPrimaryContainer: AppColors.onPrimaryContainer,

    secondary: AppColors.secondary,
    onSecondary: AppColors.onSecondary,
    secondaryContainer: AppColors.secondaryContainer,
    onSecondaryContainer: AppColors.onSecondaryContainer,

    error: AppColors.error,
    onError: AppColors.onError,

    surface: AppColors.surface,
    onSurface: AppColors.onSurface,
    surfaceContainerHighest: AppColors.surfaceVariant,
    onSurfaceVariant: AppColors.onSurfaceVariant,

    outline: AppColors.outline,
    outlineVariant: AppColors.outlineVariant,

    shadow: AppColors.shadow,
    scrim: Colors.black54,

    inverseSurface: AppColors.onSurface,
    onInverseSurface: AppColors.surface,
    inversePrimary: AppColors.primaryStrong,
  );

  /// Dark mode color scheme.
  ///
  /// Designed manually to preserve brand warmth
  /// while ensuring proper contrast and readability.
  static const ColorScheme _darkColorScheme = ColorScheme(
    brightness: Brightness.dark,

    primary: AppColors.primary,
    onPrimary: AppColors.onPrimary,
    primaryContainer: AppColors.primaryStrong,
    onPrimaryContainer: AppColors.onPrimary,

    secondary: AppColors.secondary,
    onSecondary: AppColors.onSecondary,
    secondaryContainer: AppColors.secondary,
    onSecondaryContainer: AppColors.onSecondary,

    error: AppColors.error,
    onError: AppColors.onError,

    surface: Color(0xFF1A1A1A),
    onSurface: Colors.white,
    surfaceContainerHighest: Color(0xFF262626),
    onSurfaceVariant: Color(0xFFBDBDBD),

    outline: Color(0xFF3A3A3A),
    outlineVariant: Color(0xFF2A2A2A),

    shadow: Colors.black,
    scrim: Colors.black54,

    inverseSurface: Colors.white,
    onInverseSurface: Color(0xFF121212),
    inversePrimary: AppColors.primary,
  );
}
