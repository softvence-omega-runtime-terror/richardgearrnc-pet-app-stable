import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:petzy_app/app/startup/app_lifecycle_notifier.dart';
import 'package:petzy_app/app/startup/startup_route_mapper.dart';
import 'package:petzy_app/core/constants/app_constants.dart';
import 'package:petzy_app/core/constants/assets.dart';
import 'package:petzy_app/core/widgets/async_value_widget.dart';

/// Splash page shown during app initialization.
///
/// Handles app startup lifecycle:
/// - Initializes the app lifecycle notifier
/// - Resolves startup state (auth, maintenance, onboarding, etc.)
/// - Routes to appropriate page based on startup state
class SplashPage extends ConsumerStatefulWidget {
  /// Creates the [SplashPage] widget.
  const SplashPage({super.key});

  @override
  ConsumerState<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends ConsumerState<SplashPage> {
  bool _hasNavigated = false;

  @override
  void initState() {
    super.initState();
    _initializeApp();
  }

  /// Initialize app lifecycle and navigate to appropriate route.
  Future<void> _initializeApp() async {
    try {
      // Initialize the app lifecycle (resolves startup state)
      final lifecycleNotifier = ref.read(appLifecycleNotifierProvider.notifier);
      await lifecycleNotifier.initialize();

      // Minimum splash screen visibility duration
      await Future<void>.delayed(AppConstants.splashDuration);

      if (mounted) {
        _navigateToInitialRoute();
      }
    } catch (e) {
      // Handle initialization errors - log and proceed
      if (mounted) {
        _navigateToInitialRoute();
      }
    }
  }

  /// Navigate to the appropriate route based on startup state.
  void _navigateToInitialRoute() {
    if (_hasNavigated) return;
    _hasNavigated = true;

    final lifecycleState = ref.read(appLifecycleNotifierProvider);
    final route = StartupRouteMapper.map(lifecycleState.currentState);

    context.go(route);
  }

  @override
  Widget build(final BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(
            Assets.splash,
            fit: BoxFit.cover,
          ),
          Positioned(
            bottom: 80,
            left: 0,
            right: 0,
            child: Center(
              child: const _LoadingIndicator(),
            ),
          ),
        ],
      ),
    );
  }
}

/// Loading indicator shown during app initialization.
class _LoadingIndicator extends StatelessWidget {
  const _LoadingIndicator();

  @override
  Widget build(final BuildContext context) {
    // return SizedBox(
    //   width: 160,
    //   height: 160,
    //   child: Lottie.asset(
    //     Assets.loadingAnimation,
    //     repeat: true,
    //   ),
    // );
    return const LoadingWidget();
  }
}
