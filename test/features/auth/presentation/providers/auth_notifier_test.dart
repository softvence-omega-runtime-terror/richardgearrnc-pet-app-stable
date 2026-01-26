import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mocktail/mocktail.dart';
import 'package:petzy_app/core/analytics/analytics_service.dart';
import 'package:petzy_app/core/google_signin/google_signin_provider.dart';
import 'package:petzy_app/core/google_signin/google_signin_service.dart';
import 'package:petzy_app/core/result/result.dart';
import 'package:petzy_app/features/auth/data/repositories/auth_repository_provider.dart';
import 'package:petzy_app/features/auth/domain/entities/user.dart';
import 'package:petzy_app/features/auth/domain/repositories/auth_repository.dart';
import 'package:petzy_app/features/auth/presentation/providers/auth_notifier.dart';

// ─────────────────────────────────────────────────────────────────────────────
// MOCKS
// ─────────────────────────────────────────────────────────────────────────────

class MockAuthRepository extends Mock implements AuthRepository {}

class MockAnalyticsService extends Mock implements AnalyticsService {}

class MockGoogleSignInService extends Mock implements GoogleSignInService {}

// ─────────────────────────────────────────────────────────────────────────────
// TEST DATA
// ─────────────────────────────────────────────────────────────────────────────

final testUser = User(
  id: '123',
  email: 'test@example.com',
  name: 'Test User',
);

// ─────────────────────────────────────────────────────────────────────────────
// TESTS
// ─────────────────────────────────────────────────────────────────────────────

void main() {
  group('AuthNotifier', () {
    late MockAuthRepository mockAuthRepository;
    late MockAnalyticsService mockAnalyticsService;
    late ProviderContainer container;

    setUp(() {
      mockAuthRepository = MockAuthRepository();
      mockAnalyticsService = MockAnalyticsService();

      // Setup default mocks for async methods - will be overridden in individual tests
      when(
        () => mockAuthRepository.restoreSession(),
      ).thenAnswer(
        (_) async => Failure(UnexpectedException(message: 'Failed')),
      );

      // Configure MockAnalyticsService to return Future<void> by default
      when(
        () => mockAnalyticsService.logEvent(any()),
      ).thenAnswer((_) async {});
      when(
        () => mockAnalyticsService.logScreenView(
          screenName: any(named: 'screenName'),
        ),
      ).thenAnswer((_) async {});
    });

    /// Create a ProviderContainer with mocked dependencies
    ProviderContainer createContainer({
      final AuthRepository? authRepo,
      final AnalyticsService? analyticsService,
    }) {
      return ProviderContainer(
        overrides: [
          authRepositoryProvider.overrideWithValue(
            authRepo ?? mockAuthRepository,
          ),
          analyticsServiceProvider.overrideWithValue(
            analyticsService ?? mockAnalyticsService,
          ),
        ],
      );
    }

    // ─────────────────────────────────────────────────────────────────────────
    // BUILD & INITIALIZATION TESTS
    // ─────────────────────────────────────────────────────────────────────────

    test('initializes with null when restoreSession fails', () async {
      // Arrange
      when(
        () => mockAuthRepository.restoreSession(),
      ).thenAnswer(
        (_) async => Failure(UnexpectedException(message: 'Failed')),
      );
      container = createContainer();

      // Act
      final state = await container.read(authProvider.future);

      // Assert
      expect(state, isNull);
    });

    test('initializes with user when session is restored', () async {
      // Arrange
      when(
        () => mockAuthRepository.restoreSession(),
      ).thenAnswer((_) async => Success(testUser));
      container = createContainer();

      // Act
      final state = await container.read(authProvider.future);

      // Assert
      expect(state, equals(testUser));
      expect(state?.id, equals('123'));
      expect(state?.email, equals('test@example.com'));
    });

    // ─────────────────────────────────────────────────────────────────────────
    // LOGIN TESTS
    // ─────────────────────────────────────────────────────────────────────────

    test('login with email succeeds with valid credentials', () async {
      // Arrange
      when(
        () => mockAuthRepository.login('test@example.com', 'password'),
      ).thenAnswer((_) async => Success(testUser));
      container = createContainer();

      // Act
      await container
          .read(authProvider.notifier)
          .login('test@example.com', 'password');

      // Assert
      final state = container.read(authProvider);
      expect(state.value, equals(testUser));
      verify(() => mockAnalyticsService.logEvent('login')).called(1);
    });

    test('login with phone succeeds with valid phone number', () async {
      // Arrange
      when(
        () => mockAuthRepository.loginWithPhone('+821234567890'),
      ).thenAnswer((_) async => Success(testUser));
      container = createContainer();

      // Act
      await container
          .read(authProvider.notifier)
          .loginWithPhone('+821234567890');

      // Assert
      final state = container.read(authProvider);
      // loginWithPhone doesn't log in the user yet - it just sends OTP
      // User is only logged in after OTP verification
      expect(state.value, isNull);
      // Analytics should NOT be called since this is just an OTP request
      verifyNever(() => mockAnalyticsService.logEvent('login'));
    });

    test('login with email returns error on failure', () async {
      // Arrange
      final error = UnexpectedException(message: 'Invalid credentials');
      when(
        () => mockAuthRepository.login('test@example.com', 'wrong'),
      ).thenAnswer((_) async => Failure(error));
      container = createContainer();

      // Act
      await container
          .read(authProvider.notifier)
          .login('test@example.com', 'wrong');

      // Assert
      final state = container.read(authProvider);
      expect(state.hasError, true);
      expect(state.error, isA<UnexpectedException>());
      // Analytics should not be called on error
      verifyNever(() => mockAnalyticsService.logEvent('login'));
    });

    test('login with phone returns error on failure', () async {
      // Arrange
      final error = UnexpectedException(message: 'Invalid phone number');
      when(
        () => mockAuthRepository.loginWithPhone('+00000000000'),
      ).thenAnswer((_) async => Failure(error));
      container = createContainer();

      // Act & Assert
      expect(
        () => container
            .read(authProvider.notifier)
            .loginWithPhone('+00000000000'),
        throwsA(isA<UnexpectedException>()),
      );
    });

    test('login sets AsyncLoading state during request', () async {
      // Arrange
      when(() => mockAuthRepository.loginWithPhone('+821234567890')).thenAnswer(
        (_) => Future.delayed(
          const Duration(milliseconds: 100),
          () => Success(testUser),
        ),
      );
      container = createContainer();
      final notifier = container.read(authProvider.notifier);

      // Act
      final future = notifier.loginWithPhone('+821234567890');

      // Assert - Should be loading immediately
      expect(container.read(authProvider), isA<AsyncLoading<User?>>());

      await future;
    });

    // ─────────────────────────────────────────────────────────────────────────
    // LOGOUT TESTS
    // ─────────────────────────────────────────────────────────────────────────

    test('logout clears user state on success', () async {
      // Arrange
      container = createContainer();
      // First login
      when(
        () => mockAuthRepository.loginWithPhone('+821234567890'),
      ).thenAnswer((_) async => Success(testUser));
      await container
          .read(authProvider.notifier)
          .loginWithPhone('+821234567890');

      // Setup logout mock
      when(
        () => mockAuthRepository.logout(),
      ).thenAnswer((_) async => const Success(null));

      // Act
      await container.read(authProvider.notifier).logout();

      // Assert
      final state = container.read(authProvider);
      expect(state.value, isNull);
      expect(state.isLoading, false);
      verify(() => mockAnalyticsService.logEvent('logout')).called(1);
    });

    test('logout clears state even if server fails', () async {
      // Arrange
      container = createContainer();
      // First login
      when(
        () => mockAuthRepository.loginWithPhone('+821234567890'),
      ).thenAnswer((_) async => Success(testUser));
      await container
          .read(authProvider.notifier)
          .loginWithPhone('+821234567890');

      // Setup logout mock to fail
      when(
        () => mockAuthRepository.logout(),
      ).thenAnswer(
        (_) async => Failure(UnexpectedException(message: 'Logout failed')),
      );

      // Act
      await container.read(authProvider.notifier).logout();

      // Assert - State should still be cleared
      final state = container.read(authProvider);
      expect(state.value, isNull);
      expect(state.isLoading, false);
      verify(() => mockAnalyticsService.logEvent('logout')).called(1);
    });

    // ─────────────────────────────────────────────────────────────────────────
    // GOOGLE SIGN-IN TESTS
    // ─────────────────────────────────────────────────────────────────────────

    test('loginWithGoogle succeeds with valid Google sign-in', () async {
      // Arrange
      final googleSignIn = MockGoogleSignInService();
      when(
        () => googleSignIn.signIn(),
      ).thenAnswer((_) async => 'firebase_id_token');

      when(
        () => mockAuthRepository.loginWithGoogle(
          googleSignInService: googleSignIn,
        ),
      ).thenAnswer((_) async => Success(testUser));

      container = ProviderContainer(
        overrides: [
          authRepositoryProvider.overrideWithValue(mockAuthRepository),
          analyticsServiceProvider.overrideWithValue(mockAnalyticsService),
          googleSignInServiceProvider.overrideWithValue(googleSignIn),
        ],
      );

      // Act
      await container.read(authProvider.notifier).loginWithGoogle();

      // Assert
      final state = container.read(authProvider);
      expect(state.value, equals(testUser));
      verify(() => mockAnalyticsService.logEvent('login')).called(1);
    });

    test('loginWithGoogle distinguishes cancellation from errors', () async {
      // Arrange
      final googleSignIn = MockGoogleSignInService();
      when(
        () => googleSignIn.signIn(),
      ).thenThrow(const GoogleSignInException.cancelled());

      when(
        () => mockAuthRepository.loginWithGoogle(
          googleSignInService: googleSignIn,
        ),
      ).thenAnswer(
        (_) async => Failure(
          AuthException.googleAuth(
            message: 'User cancelled',
            isCancelled: true,
          ),
        ),
      );

      container = ProviderContainer(
        overrides: [
          authRepositoryProvider.overrideWithValue(mockAuthRepository),
          analyticsServiceProvider.overrideWithValue(mockAnalyticsService),
          googleSignInServiceProvider.overrideWithValue(googleSignIn),
        ],
      );

      // Act
      await container.read(authProvider.notifier).loginWithGoogle();

      // Assert - Cancellation should be AsyncData(null), not error
      final state = container.read(authProvider);
      expect(state.value, isNull);
      expect(state.hasError, isFalse);
      verifyNever(() => mockAnalyticsService.logEvent('login'));
    });

    test('loginWithGoogle returns error on auth failure', () async {
      // Arrange
      final googleSignIn = MockGoogleSignInService();
      when(() => googleSignIn.signIn()).thenThrow(
        const GoogleSignInException(message: 'Authentication failed'),
      );

      when(
        () => mockAuthRepository.loginWithGoogle(
          googleSignInService: googleSignIn,
        ),
      ).thenAnswer(
        (_) async => Failure(
          AuthException.googleAuth(message: 'Authentication failed'),
        ),
      );

      container = ProviderContainer(
        overrides: [
          authRepositoryProvider.overrideWithValue(mockAuthRepository),
          analyticsServiceProvider.overrideWithValue(mockAnalyticsService),
          googleSignInServiceProvider.overrideWithValue(googleSignIn),
        ],
      );

      // Act
      await container.read(authProvider.notifier).loginWithGoogle();

      // Assert
      final state = container.read(authProvider);
      expect(state.hasError, isTrue);
      expect(state.error, isA<AuthException>());
      verifyNever(() => mockAnalyticsService.logEvent('login'));
    });

    test('loginWithGoogle sets AsyncLoading during sign-in', () async {
      // Arrange
      final googleSignIn = MockGoogleSignInService();
      when(
        () => googleSignIn.signIn(),
      ).thenAnswer((_) async => 'firebase_id_token');

      when(
        () => mockAuthRepository.loginWithGoogle(
          googleSignInService: googleSignIn,
        ),
      ).thenAnswer(
        (_) => Future.delayed(
          const Duration(milliseconds: 100),
          () => Success(testUser),
        ),
      );

      container = ProviderContainer(
        overrides: [
          authRepositoryProvider.overrideWithValue(mockAuthRepository),
          analyticsServiceProvider.overrideWithValue(mockAnalyticsService),
          googleSignInServiceProvider.overrideWithValue(googleSignIn),
        ],
      );

      final notifier = container.read(authProvider.notifier);

      // Act
      notifier.loginWithGoogle();

      // Assert - Should be loading immediately
      expect(container.read(authProvider), isA<AsyncLoading<User?>>());
    });

    // ─────────────────────────────────────────────────────────────────────────
    // CONVENIENCE PROVIDER TESTS
    // ─────────────────────────────────────────────────────────────────────────

    test('isAuthenticated returns true when user is logged in', () async {
      // Arrange
      when(
        () => mockAuthRepository.restoreSession(),
      ).thenAnswer((_) async => Success(testUser));
      container = createContainer();
      await container.read(authProvider.future);

      // Act
      final isAuth = container.read(isAuthenticatedProvider);

      // Assert
      expect(isAuth, true);
    });

    test('isAuthenticated returns false when user is null', () async {
      // Arrange
      when(
        () => mockAuthRepository.restoreSession(),
      ).thenAnswer(
        (_) async => Failure(UnexpectedException(message: 'Failed')),
      );
      container = createContainer();
      await container.read(authProvider.future);

      // Act
      final isAuth = container.read(isAuthenticatedProvider);

      // Assert
      expect(isAuth, false);
    });

    test('currentUser returns user when authenticated', () async {
      // Arrange
      when(
        () => mockAuthRepository.restoreSession(),
      ).thenAnswer((_) async => Success(testUser));
      container = createContainer();
      await container.read(authProvider.future);

      // Act
      final user = container.read(currentUserProvider);

      // Assert
      expect(user, equals(testUser));
      expect(user?.id, equals('123'));
    });

    test('currentUser returns null when not authenticated', () async {
      // Arrange
      when(
        () => mockAuthRepository.restoreSession(),
      ).thenAnswer(
        (_) async => Failure(UnexpectedException(message: 'Failed')),
      );
      container = createContainer();
      await container.read(authProvider.future);

      // Act
      final user = container.read(currentUserProvider);

      // Assert
      expect(user, isNull);
    });

    // ─────────────────────────────────────────────────────────────────────────
    // STATE TRANSITION TESTS
    // ─────────────────────────────────────────────────────────────────────────

    test(
      'transitions from authenticated to unauthenticated on logout',
      () async {
        // Arrange
        container = createContainer();
        when(
          () => mockAuthRepository.login('test@example.com', 'password'),
        ).thenAnswer((_) async => Success(testUser));
        when(
          () => mockAuthRepository.logout(),
        ).thenAnswer((_) async => const Success(null));

        // Act - Login
        await container
            .read(authProvider.notifier)
            .login('test@example.com', 'password');
        expect(container.read(isAuthenticatedProvider), true);

        // Act - Logout
        await container.read(authProvider.notifier).logout();

        // Assert
        expect(container.read(isAuthenticatedProvider), false);
      },
    );

    test('handles rapid login/logout cycles', () async {
      // Arrange
      container = createContainer();
      when(
        () => mockAuthRepository.login('test@example.com', 'password'),
      ).thenAnswer((_) async => Success(testUser));
      when(
        () => mockAuthRepository.logout(),
      ).thenAnswer((_) async => const Success(null));

      // Act & Assert - Multiple cycles
      for (int i = 0; i < 3; i++) {
        await container
            .read(authProvider.notifier)
            .login('test@example.com', 'password');
        expect(container.read(isAuthenticatedProvider), true);

        await container.read(authProvider.notifier).logout();
        expect(container.read(isAuthenticatedProvider), false);
      }
    });

    // ─────────────────────────────────────────────────────────────────────────
    // ERROR HANDLING TESTS
    // ─────────────────────────────────────────────────────────────────────────

    test('handles network exception during login', () async {
      // Arrange
      final networkError = NetworkException(message: 'No internet');
      when(
        () => mockAuthRepository.loginWithPhone('+821234567890'),
      ).thenAnswer((_) async => Failure(networkError));
      container = createContainer();

      // Act & Assert
      expect(
        () => container
            .read(authProvider.notifier)
            .loginWithPhone('+821234567890'),
        throwsA(isA<NetworkException>()),
      );
    });

    test('handles timeout exception during login', () async {
      // Arrange
      final timeoutError = UnexpectedException(message: 'Request timed out');
      when(
        () => mockAuthRepository.login('test@example.com', 'password'),
      ).thenAnswer((_) async => Failure(timeoutError));
      container = createContainer();

      // Act
      await container
          .read(authProvider.notifier)
          .login('test@example.com', 'password');

      // Assert
      final state = container.read(authProvider);
      expect(state.error, isA<UnexpectedException>());
    });
  });
}
