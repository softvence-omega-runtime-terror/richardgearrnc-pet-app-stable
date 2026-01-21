import 'package:petzy_app/core/result/result.dart';
import 'package:petzy_app/features/auth/domain/entities/user.dart';

/// Contract for authentication operations.
/// Implemented by [AuthRepositoryImpl] in the data layer.
abstract interface class AuthRepository {
  /// Attempt to login with email and password.
  Future<Result<User>> login(final String email, final String password);

  /// Attempt to login with phone number.
  /// This sends an OTP code to the phone number.
  /// Returns void on success (only OTP sent, user not authenticated yet).
  /// User will be authenticated after calling verifyOtp().
  Future<Result<void>> loginWithPhone(final String phoneNumber);

  /// Verify OTP code for phone number authentication.
  Future<Result<User>> verifyOtp(
    final String phoneNumber,
    final String code,
  );

  /// Resend OTP code to the provided phone number.
  Future<Result<void>> resendOtp(final String phoneNumber);

  /// Restore session from stored credentials.
  Future<Result<User>> restoreSession();

  /// Clear the current session and logout.
  Future<Result<void>> logout();

  /// Check if user is currently authenticated.
  Future<bool> isAuthenticated();
}
