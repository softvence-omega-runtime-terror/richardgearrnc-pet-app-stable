import 'package:flutter/foundation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:petzy_app/core/core.dart';
import 'package:petzy_app/features/auth/data/repositories/auth_repository_provider.dart';
import 'package:petzy_app/features/auth/domain/entities/user.dart';
import 'package:petzy_app/features/auth/domain/repositories/auth_repository.dart';

part 'auth_notifier.g.dart';

/// Manages authentication state.
///
/// Use this to:
/// - Check if user is logged in
/// - Login/logout
/// - Access current user
///
/// ## Why `keepAlive: true`?
///
/// Auth state should persist for the entire app lifecycle because:
/// - Auth state is needed across all screens for route guards
/// - Prevents unnecessary session restoration on every navigation
/// - Session should survive screen transitions
///
/// **Note:** Most presentation-layer providers (ViewModels, page-specific notifiers)
/// should NOT use `keepAlive: true`. Use `autoDispose` (default) to free memory
/// when the user navigates away. Only use `keepAlive` for:
/// - Global app state (auth, theme, user preferences)
/// - Expensive services (network clients, database connections)
/// - State that must survive navigation (audio player, download manager)
@Riverpod(keepAlive: true)
class AuthNotifier extends _$AuthNotifier {
  late final AuthRepository _repo;

  @override
  Future<User?> build() async {
    _repo = ref.watch(authRepositoryProvider);

    final result = await _repo.restoreSession();
    return result.dataOrNull;
  }

  /// Attempt to login with credentials.
  Future<void> login(final String email, final String password) async {
    state = const AsyncLoading();

    final result = await _repo.login(email, password);

    state = result.fold(
      onSuccess: AsyncData.new,
      onFailure: (final error) => AsyncError(error, StackTrace.current),
    );

    // Track login event (success or failure)
    if (state.value != null) {
      ref.read(analyticsServiceProvider).logEvent(AnalyticsEvents.login);
    }
  }

  /// Attempt to login with phone number.
  /// This sends an OTP to the phone number.
  Future<void> loginWithPhone(final String phoneNumber) async {
    final result = await _repo.loginWithPhone(phoneNumber);

    result.fold(
      onSuccess: (_) {
        // OTP sent successfully - don't set user state yet
        // User will be authenticated after OTP verification
      },
      onFailure: (final error) {
        throw error;
      },
    );
  }

  /// Verify OTP code for phone number authentication.
  Future<void> verifyOtp(
    final String phoneNumber,
    final String code,
  ) async {
    state = const AsyncLoading();

    final result = await _repo.verifyOtp(phoneNumber, code);

    state = result.fold(
      onSuccess: AsyncData.new,
      onFailure: (final error) => AsyncError(error, StackTrace.current),
    );

    // Track OTP verification event
    if (state.value != null) {
      ref.read(analyticsServiceProvider).logEvent(AnalyticsEvents.otpVerified);
    }
  }

  /// Resend OTP code to the provided phone number.
  Future<void> resendOtp(final String phoneNumber) async {
    final result = await _repo.resendOtp(phoneNumber);

    result.fold(
      onSuccess: (_) {
        ref.read(analyticsServiceProvider).logEvent(AnalyticsEvents.otpResent);
      },
      onFailure: (final error) {
        if (kDebugMode) {
          debugPrint('Resend OTP error: ${error.message}');
        }
      },
    );
  }

  /// Logout the current user.
  Future<void> logout() async {
    final result = await _repo.logout();

    result.fold(
      onSuccess: (_) {
        state = const AsyncData(null);
        ref.read(analyticsServiceProvider).logEvent(AnalyticsEvents.logout);
      },
      onFailure: (final error) {
        // Still clear local state even if server logout fails
        state = const AsyncData(null);
        ref.read(analyticsServiceProvider).logEvent(AnalyticsEvents.logout);
        if (kDebugMode) {
          debugPrint('Logout error: ${error.message}');
        }
      },
    );
  }

  /// Check if user is currently authenticated.
  bool get isAuthenticated => state.value != null;

  /// Get the current user, or null if not authenticated.
  User? get currentUser => state.value;
}

/// Convenience provider for checking if user is authenticated.
///
/// Usage: `ref.watch(isAuthenticatedProvider)`
@riverpod
bool isAuthenticated(final Ref ref) {
  final authState = ref.watch(authProvider);
  return authState.value != null;
}

/// Convenience provider for getting the current user.
///
/// Returns null if not authenticated or loading.
/// Usage: `ref.watch(currentUserProvider)`
@riverpod
User? currentUser(final Ref ref) {
  return ref.watch(authProvider).value;
}
