import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mocktail/mocktail.dart';
import 'package:petzy_app/core/analytics/analytics_service.dart';
import 'package:petzy_app/core/google_signin/google_signin_provider.dart';
import 'package:petzy_app/core/result/result.dart';
import 'package:petzy_app/features/auth/data/repositories/auth_repository_provider.dart';
import 'package:petzy_app/features/auth/domain/entities/user.dart';
import 'package:petzy_app/features/auth/domain/repositories/auth_repository.dart';
import 'package:petzy_app/features/auth/presentation/providers/auth_notifier.dart';

import '../../helpers/mocks.dart';

// Mocks
class MockAuthRepository extends Mock implements AuthRepository {}

void main() {
  group('AuthNotifier', () {
    late ProviderContainer container;
    late MockAuthRepository mockRepository;
    late MockGoogleSignInService mockGoogleSignInService;
    late MockAnalyticsService mockAnalyticsService;

    setUp(() {
      mockRepository = MockAuthRepository();
      mockGoogleSignInService = MockGoogleSignInService();
      mockAnalyticsService = MockAnalyticsService();

      // Register fallback values for mocktail
      registerFallbackValue(mockGoogleSignInService);
      registerFallbackValue('');
      registerFallbackValue('');

      // Setup analytics mock to return futures for all methods
      when(() => mockAnalyticsService.logEvent(any())).thenAnswer((_) async {});
      when(
        () => mockAnalyticsService.logEvent(
          any(),
          parameters: any(named: 'parameters'),
        ),
      ).thenAnswer((_) async {});
      when(
        () => mockAnalyticsService.logScreenView(
          screenName: any(named: 'screenName'),
        ),
      ).thenAnswer((_) async {});

      container = ProviderContainer(
        overrides: [
          authRepositoryProvider.overrideWithValue(mockRepository),
          googleSignInServiceProvider.overrideWithValue(
            mockGoogleSignInService,
          ),
          analyticsServiceProvider.overrideWithValue(mockAnalyticsService),
        ],
      );

      // Setup default mock behavior
      when(
        () => mockRepository.restoreSession(),
      ).thenAnswer((_) async => Failure(AuthException.noSession()));
    });

    group('build', () {
      test('returns null when session restoration fails', () async {
        // Act
        final state = await container.read(authProvider.future);

        // Assert
        expect(state, isNull);
      });

      test('returns user when session restoration succeeds', () async {
        // Arrange
        const testUser = User(
          id: 'user_123',
          email: 'test@example.com',
          name: 'Test User',
        );
        when(
          () => mockRepository.restoreSession(),
        ).thenAnswer((_) async => const Success(testUser));

        // Need to create new container with updated override
        container = ProviderContainer(
          overrides: [
            authRepositoryProvider.overrideWithValue(mockRepository),
            googleSignInServiceProvider.overrideWithValue(
              mockGoogleSignInService,
            ),
            analyticsServiceProvider.overrideWithValue(mockAnalyticsService),
          ],
        );

        // Act
        final state = await container.read(authProvider.future);

        // Assert
        expect(state, testUser);
      });
    });

    group('login', () {
      test('sets state to AsyncLoading then AsyncData on success', () async {
        // Arrange
        const testUser = User(
          id: 'user_123',
          email: 'test@example.com',
          name: 'Test User',
        );
        when(
          () => mockRepository.login(any(), any()),
        ).thenAnswer((_) async => const Success(testUser));

        // Act
        await container
            .read(authProvider.notifier)
            .login(
              'test@example.com',
              'password123',
            );

        // Assert
        final state = container.read(authProvider);
        expect(state.value, testUser);
      });

      test('sets state to AsyncError on failure', () async {
        // Arrange
        when(
          () => mockRepository.login(any(), any()),
        ).thenAnswer((_) async => Failure(AuthException.invalidCredentials()));

        // Act
        await container
            .read(authProvider.notifier)
            .login(
              'test@example.com',
              'wrong_password',
            );

        // Assert
        final state = container.read(authProvider);
        expect(state, isA<AsyncError<User?>>());
        if (state is AsyncError<User?>) {
          expect(state.error, isA<AppException>());
        }
      });
    });

    group('loginWithGoogle', () {
      test('returns AsyncData(null) on cancellation without error', () async {
        // Arrange
        when(
          () => mockRepository.loginWithGoogle(
            googleSignInService: any(named: 'googleSignInService'),
          ),
        ).thenAnswer(
          (_) async => Failure(
            AuthException.googleAuth(
              message: 'User cancelled',
              isCancelled: true,
            ),
          ),
        );

        // Act
        await container.read(authProvider.notifier).loginWithGoogle();

        // Assert
        final state = container.read(authProvider);
        expect(state.value, isNull);
        expect(state, isA<AsyncData<User?>>());
      });

      test('returns AsyncData(user) on successful authentication', () async {
        // Arrange
        const testUser = User(
          id: 'google_user_123',
          email: 'google@example.com',
          name: 'Google User',
        );
        when(
          () => mockRepository.loginWithGoogle(
            googleSignInService: any(named: 'googleSignInService'),
          ),
        ).thenAnswer((_) async => const Success(testUser));

        // Act
        await container.read(authProvider.notifier).loginWithGoogle();

        // Assert
        final state = container.read(authProvider);
        expect(state.value, testUser);
      });

      test('returns AsyncError on real authentication failure', () async {
        // Arrange
        when(
          () => mockRepository.loginWithGoogle(
            googleSignInService: any(named: 'googleSignInService'),
          ),
        ).thenAnswer(
          (_) async => Failure(AuthException(message: 'Invalid token')),
        );

        // Act
        await container.read(authProvider.notifier).loginWithGoogle();

        // Assert
        final state = container.read(authProvider);
        expect(state, isA<AsyncError<User?>>());
        if (state is AsyncError<User?>) {
          expect(state.error, isA<AppException>());
        }
      });

      test('distinguishes between cancellation and real errors', () async {
        // Arrange - First try with cancellation
        when(
          () => mockRepository.loginWithGoogle(
            googleSignInService: any(named: 'googleSignInService'),
          ),
        ).thenAnswer(
          (_) async => Failure(
            AuthException.googleAuth(
              message: 'User cancelled',
              isCancelled: true,
            ),
          ),
        );

        // Act - Cancellation should not be an error
        await container.read(authProvider.notifier).loginWithGoogle();
        final cancelState = container.read(authProvider);

        // Assert - Cancellation is AsyncData(null), not AsyncError
        expect(cancelState.value, isNull);
        expect(cancelState, isA<AsyncData<User?>>());

        // Arrange - Now try with real error
        when(
          () => mockRepository.loginWithGoogle(
            googleSignInService: any(named: 'googleSignInService'),
          ),
        ).thenAnswer(
          (_) async => Failure(AuthException(message: 'Network error')),
        );

        // Act - Real error should be an error
        await container.read(authProvider.notifier).loginWithGoogle();
        final errorState = container.read(authProvider);

        // Assert - Real error is AsyncError
        expect(errorState, isA<AsyncError<User?>>());
        if (errorState is AsyncError<User?>) {
          expect(errorState.error, isA<AppException>());
        }
      });
    });

    group('logout', () {
      test('clears user state on successful logout', () async {
        // Arrange
        when(
          () => mockRepository.logout(),
        ).thenAnswer((_) async => const Success(null));

        // Act
        await container.read(authProvider.notifier).logout();

        // Assert
        final state = container.read(authProvider);
        expect(state.value, isNull);
      });

      test('clears user state even on logout API failure', () async {
        // Arrange
        when(() => mockRepository.logout()).thenAnswer(
          (_) async => Failure(
            NetworkException(message: 'Network error'),
          ),
        );

        // Act
        await container.read(authProvider.notifier).logout();

        // Assert
        final state = container.read(authProvider);
        expect(state.value, isNull);
      });
    });

    group('isAuthenticated getter', () {
      test('returns true when user is logged in', () async {
        // Arrange
        const testUser = User(
          id: 'user_123',
          email: 'test@example.com',
          name: 'Test User',
        );
        when(
          () => mockRepository.login(any(), any()),
        ).thenAnswer((_) async => const Success(testUser));

        await container
            .read(authProvider.notifier)
            .login(
              'test@example.com',
              'password123',
            );

        // Act & Assert
        expect(
          container.read(authProvider.notifier).isAuthenticated,
          true,
        );
      });

      test('returns false when user is not logged in', () async {
        // Act & Assert
        expect(
          container.read(authProvider.notifier).isAuthenticated,
          false,
        );
      });
    });

    group('currentUser getter', () {
      test('returns user when authenticated', () async {
        // Arrange
        const testUser = User(
          id: 'user_123',
          email: 'test@example.com',
          name: 'Test User',
        );
        when(
          () => mockRepository.login(any(), any()),
        ).thenAnswer((_) async => const Success(testUser));

        await container
            .read(authProvider.notifier)
            .login(
              'test@example.com',
              'password123',
            );

        // Act & Assert
        expect(
          container.read(authProvider.notifier).currentUser,
          testUser,
        );
      });

      test('returns null when not authenticated', () async {
        // Act & Assert
        expect(
          container.read(authProvider.notifier).currentUser,
          isNull,
        );
      });
    });
  });
}
