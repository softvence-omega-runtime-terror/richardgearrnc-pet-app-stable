import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:petzy_app/core/constants/storage_keys.dart';
import 'package:petzy_app/core/constants/app_constants.dart';
import 'package:petzy_app/core/result/result.dart';
import 'package:petzy_app/features/auth/domain/entities/user.dart';
import 'package:petzy_app/features/auth/domain/repositories/auth_repository.dart';

/// Mock implementation of [AuthRepository].
///
/// This implementation simulates API calls with artificial delays.
/// Use this for development and testing.
///
/// Features:
/// - Simulates network latency (200ms default)
/// - Returns mock user data
/// - Stores mock tokens in secure storage
/// - Can simulate errors by using special email addresses
///
/// Special email addresses for testing:
/// - "error@test.com" - Simulates a login error
/// - "slow@test.com" - Simulates a slow network (500ms delay)
/// - Any other email - Successful login
class AuthRepositoryMock implements AuthRepository {
  /// Creates a [AuthRepositoryMock] instance.
  AuthRepositoryMock({required this.secureStorage});

  /// Secure storage for storing mock tokens.
  final FlutterSecureStorage secureStorage;

  @override
  Future<Result<User>> login(final String email, final String password) async {
    // Simulate slow network for testing
    final delay = email == 'slow@test.com'
        ? AppConstants.mockSlowNetworkDelay
        : AppConstants.mockNetworkDelay;
    await Future<void>.delayed(delay);

    // Simulate error for testing
    if (email == 'error@test.com') {
      return const Failure(AuthException(message: 'Invalid credentials'));
    }

    // Simulate empty password validation
    if (password.isEmpty) {
      return const Failure(AuthException(message: 'Password is required'));
    }

    // Generate mock token
    final token = 'mock_token_${DateTime.now().millisecondsSinceEpoch}';
    await secureStorage.write(key: StorageKeys.accessToken, value: token);

    // Return mock user
    final user = User(
      id: 'mock_user_${email.hashCode}',
      email: email,
      name: _extractNameFromEmail(email),
    );

    await secureStorage.write(key: StorageKeys.userId, value: user.id);

    return Success(user);
  }

  @override
  Future<Result<void>> loginWithPhone(final String phoneNumber) async {
    await Future<void>.delayed(AppConstants.mockNetworkDelay);

    // Simulate error for testing
    if (phoneNumber.contains('000')) {
      return const Failure(AuthException(message: 'Invalid phone number'));
    }

    // OTP sent successfully - do NOT store any tokens or user data
    // User will be authenticated only after OTP verification with verifyOtp()
    return const Success(null);
  }

  @override
  Future<Result<User>> verifyOtp(
    final String phoneNumber,
    final String code,
  ) async {
    await Future<void>.delayed(AppConstants.mockNetworkDelay);

    // Simulate error for testing
    if (code == '000000') {
      return const Failure(AuthException(message: 'Invalid OTP code'));
    }

    // Generate mock token
    final token = 'mock_token_${DateTime.now().millisecondsSinceEpoch}';
    await secureStorage.write(key: StorageKeys.accessToken, value: token);

    // Return mock user
    final user = User(
      id: 'mock_user_${phoneNumber.hashCode}',
      email: '$phoneNumber@phone.local',
      name: 'Phone User',
    );

    await secureStorage.write(key: StorageKeys.userId, value: user.id);

    return Success(user);
  }

  @override
  Future<Result<void>> resendOtp(final String phoneNumber) async {
    await Future<void>.delayed(AppConstants.mockNetworkDelay);

    // Simulate error for testing
    if (phoneNumber.contains('000')) {
      return const Failure(AuthException(message: 'Invalid phone number'));
    }

    // In a real app, this would trigger an OTP to be sent
    // For mock, we just return success after a delay
    return const Success(null);
  }

  @override
  Future<Result<User>> restoreSession() async {
    await Future<void>.delayed(AppConstants.mockNetworkDelay);

    final token = await secureStorage.read(key: StorageKeys.accessToken);
    final userId = await secureStorage.read(key: StorageKeys.userId);

    if (token == null || userId == null) {
      return Failure(AuthException.noSession());
    }

    // In a real app, you would validate the token here
    // For mock, we just return a user if token exists
    return Success(
      User(id: userId, email: 'restored@test.com', name: 'Restored User'),
    );
  }

  @override
  Future<Result<void>> logout() async {
    await Future<void>.delayed(AppConstants.mockQuickDelay);

    try {
      await secureStorage.delete(key: StorageKeys.accessToken);
      await secureStorage.delete(key: StorageKeys.refreshToken);
      await secureStorage.delete(key: StorageKeys.userId);
      return const Success(null);
    } catch (e, stackTrace) {
      return Failure(
        CacheException(
          message: 'Failed to clear session',
          stackTrace: stackTrace,
        ),
      );
    }
  }

  @override
  Future<bool> isAuthenticated() async {
    final token = await secureStorage.read(key: StorageKeys.accessToken);
    return token != null;
  }

  /// Extract a display name from email address
  String _extractNameFromEmail(final String email) {
    final localPart = email.split('@').first;
    return localPart
        .replaceAll(RegExp('[._-]'), ' ')
        .split(' ')
        .map(
          (final word) => word.isNotEmpty
              ? '${word[0].toUpperCase()}${word.substring(1)}'
              : '',
        )
        .join(' ');
  }
}
