// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth_notifier.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
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

@ProviderFor(AuthNotifier)
final authProvider = AuthNotifierProvider._();

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
final class AuthNotifierProvider
    extends $AsyncNotifierProvider<AuthNotifier, User?> {
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
  AuthNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'authProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$authNotifierHash();

  @$internal
  @override
  AuthNotifier create() => AuthNotifier();
}

String _$authNotifierHash() => r'586d8ad257bcbefbc1ea70b2d101ac0303a279bd';

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

abstract class _$AuthNotifier extends $AsyncNotifier<User?> {
  FutureOr<User?> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<AsyncValue<User?>, User?>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<User?>, User?>,
              AsyncValue<User?>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}

/// Convenience provider for checking if user is authenticated.
///
/// Usage: `ref.watch(isAuthenticatedProvider)`

@ProviderFor(isAuthenticated)
final isAuthenticatedProvider = IsAuthenticatedProvider._();

/// Convenience provider for checking if user is authenticated.
///
/// Usage: `ref.watch(isAuthenticatedProvider)`

final class IsAuthenticatedProvider
    extends $FunctionalProvider<bool, bool, bool>
    with $Provider<bool> {
  /// Convenience provider for checking if user is authenticated.
  ///
  /// Usage: `ref.watch(isAuthenticatedProvider)`
  IsAuthenticatedProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'isAuthenticatedProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$isAuthenticatedHash();

  @$internal
  @override
  $ProviderElement<bool> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  bool create(Ref ref) {
    return isAuthenticated(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(bool value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<bool>(value),
    );
  }
}

String _$isAuthenticatedHash() => r'2f79849868c9490023e95e53a9fa4ea33690f61a';

/// Convenience provider for getting the current user.
///
/// Returns null if not authenticated or loading.
/// Usage: `ref.watch(currentUserProvider)`

@ProviderFor(currentUser)
final currentUserProvider = CurrentUserProvider._();

/// Convenience provider for getting the current user.
///
/// Returns null if not authenticated or loading.
/// Usage: `ref.watch(currentUserProvider)`

final class CurrentUserProvider extends $FunctionalProvider<User?, User?, User?>
    with $Provider<User?> {
  /// Convenience provider for getting the current user.
  ///
  /// Returns null if not authenticated or loading.
  /// Usage: `ref.watch(currentUserProvider)`
  CurrentUserProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'currentUserProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$currentUserHash();

  @$internal
  @override
  $ProviderElement<User?> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  User? create(Ref ref) {
    return currentUser(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(User? value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<User?>(value),
    );
  }
}

String _$currentUserHash() => r'36cbdf15f2eb87c2f99c368fa205f40a7b392b65';
