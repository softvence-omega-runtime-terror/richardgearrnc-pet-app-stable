import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:petzy_app/app/bootstrap.dart';
import 'package:petzy_app/core/localization/locale_notifier.dart';
import 'package:petzy_app/core/utils/connectivity.dart';

/// Application entry point.
///
/// Uses [runGuardedApp] to wrap the app in a guarded zone for
/// comprehensive error catching in production.
void main() {
  // ignore: discarded_futures - runGuardedApp handles its own async flow
  runGuardedApp(
    appBuilder: (final sharedPreferences, final connectivity) => ProviderScope(
      overrides: [
        sharedPreferencesProvider.overrideWithValue(sharedPreferences),
        connectivityServiceProvider.overrideWithValue(connectivity),
      ],
      child: const AppBootstrap(),
    ),
  );
}
