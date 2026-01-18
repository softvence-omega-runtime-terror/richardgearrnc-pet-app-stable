import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lottie/lottie.dart';
import 'package:petzy_app/core/core.dart';

/// A widget that renders loading, error, or data states
/// for a Riverpod [AsyncValue].
///
/// Simplifies handling common async UI patterns.
class AsyncValueWidget<T> extends StatelessWidget {
  /// Creates an [AsyncValueWidget].
  const AsyncValueWidget({
    required this.value,
    required this.data,
    super.key,
    this.loading,
    this.error,
    this.skipLoadingOnRefresh = true,
    this.skipLoadingOnReload = false,
  });

  /// The async value to render.
  final AsyncValue<T> value;

  /// Builder for the data state.
  final Widget Function(T data) data;

  /// Optional builder for the loading state.
  final Widget Function()? loading;

  /// Optional builder for the error state.
  final Widget Function(Object error, StackTrace stackTrace)? error;

  /// Whether to skip the loading indicator during refresh.
  final bool skipLoadingOnRefresh;

  /// Whether to skip the loading indicator during reload.
  final bool skipLoadingOnReload;

  @override
  Widget build(final BuildContext context) {
    return value.when(
      data: data,
      loading: loading ?? () => const LoadingWidget(),
      error: error ?? (final e, final st) => AppErrorWidget.fromError(error: e),
      skipLoadingOnRefresh: skipLoadingOnRefresh,
      skipLoadingOnReload: skipLoadingOnReload,
    );
  }
}

/// A widget that displays a centered loading indicator.
class LoadingWidget extends StatelessWidget {
  /// Creates a [LoadingWidget].
  const LoadingWidget({
    super.key,
    // this.size = 40.0,
    this.size = 160.0,
    // this.strokeWidth = 3.0,
    this.message,
  });

  /// Size of the loading indicator.
  final double size;

  /// Stroke width of the loading indicator.
  // final double strokeWidth;

  /// Optional message displayed below the indicator.
  final String? message;

  @override
  Widget build(final BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Center(
      child: Column(
        mainAxisAlignment: .center,
        children: [
          SizedBox(
            width: size,
            height: size,
            // child: CircularProgressIndicator(strokeWidth: strokeWidth),
            child: Lottie.asset(Assets.loadingAnimation, repeat: true),
          ),
          if (message != null) ...[
            const VerticalSpace.md(),
            Text(
              message!,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

/// A widget that displays an error message with an optional retry action.
///
/// Named `AppErrorWidget` to avoid collision with Flutter's built-in `ErrorWidget`.
class AppErrorWidget extends StatelessWidget {
  /// Creates an [AppErrorWidget].
  const AppErrorWidget({
    required this.message,
    super.key,
    this.onRetry,
    this.icon = Icons.error_outline,
  });

  /// Builds an [AppErrorWidget] from an error object.
  factory AppErrorWidget.fromError({
    required final Object error,
    final VoidCallback? onRetry,
  }) {
    return AppErrorWidget(message: error.toString(), onRetry: onRetry);
  }

  /// Error message to display.
  final String message;

  /// Optional retry callback.
  final VoidCallback? onRetry;

  /// Icon displayed above the message.
  final IconData icon;

  @override
  Widget build(final BuildContext context) {
    final theme = context.theme;

    return Center(
      child: Padding(
        padding: const .all(AppSpacing.lg),
        child: Column(
          mainAxisAlignment: .center,
          children: [
            Icon(
              icon,
              size: AppConstants.onboardingIconSize,
              color: theme.colorScheme.error,
            ),
            const VerticalSpace.md(),
            Text(
              'Something went wrong',
              style: theme.textTheme.titleMedium,
            ),
            const VerticalSpace.sm(),
            Text(
              message,
              textAlign: .center,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
            if (onRetry != null) ...[
              const VerticalSpace.lg(),
              OutlinedButton.icon(
                onPressed: onRetry,
                icon: const Icon(Icons.refresh),
                label: const Text('Retry'),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

/// A widget that displays an empty or no-content state.
class EmptyWidget extends StatelessWidget {
  /// Creates an [EmptyWidget].
  const EmptyWidget({
    required this.message,
    super.key,
    this.icon = Icons.inbox_outlined,
    this.action,
    this.actionLabel,
  });

  /// Message describing the empty state.
  final String message;

  /// Icon displayed above the message.
  final IconData icon;

  /// Optional action callback.
  final VoidCallback? action;

  /// Label for the optional action button.
  final String? actionLabel;

  @override
  Widget build(final BuildContext context) {
    final theme = context.theme;

    return Center(
      child: Padding(
        padding: const .all(AppSpacing.lg),
        child: Column(
          mainAxisAlignment: .center,
          children: [
            Icon(
              icon,
              size: AppConstants.iconSizeXXL,
              color: theme.colorScheme.outline,
            ),
            const VerticalSpace.md(),
            Text(
              message,
              textAlign: .center,
              style: theme.textTheme.bodyLarge?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
            if (action != null && actionLabel != null) ...[
              const VerticalSpace.lg(),
              AppButton(
                onPressed: action,
                label: actionLabel!,
              ),
            ],
          ],
        ),
      ),
    );
  }
}
