import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:petzy_app/app/router/app_router.dart';
import 'package:petzy_app/core/core.dart';
import 'package:petzy_app/features/auth/domain/entities/user.dart';
import 'package:petzy_app/features/auth/presentation/providers/auth_notifier.dart';
import 'package:petzy_app/features/home/presentation/widgets/feature_showcase.dart';
import 'package:petzy_app/features/home/presentation/widgets/welcome_card.dart';
import 'package:petzy_app/l10n/generated/app_localizations.dart';

/// Home page shown after successful authentication.
class HomePage extends HookConsumerWidget {
  /// Creates a [HomePage] instance.
  const HomePage({super.key});

  @override
  Widget build(final BuildContext context, final WidgetRef ref) {
    final authState = ref.watch(authProvider);
    final theme = context.theme;
    final l10n = AppLocalizations.of(context);

    // Track screen view once on mount
    useOnMount(() {
      ref.read(analyticsServiceProvider).logScreenView(screenName: 'home');
    });

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.home),
        actions: [
          const ConnectivityIndicator(),
          AppIconButton(
            icon: Icons.settings_outlined,
            onPressed: () => context.pushRoute(AppRoute.settings),
          ),
        ],
      ),
      body: AsyncValueWidget<User?>(
        value: authState,
        data: (final user) {
          return _HomeContent(user: user, theme: theme);
        },
      ),
    );
  }
}

class _HomeContent extends ConsumerWidget {
  const _HomeContent({required this.user, required this.theme});

  final User? user;
  final ThemeData theme;

  @override
  Widget build(final BuildContext context, final WidgetRef ref) {
    return ResponsivePadding(
      child: SingleChildScrollView(
        child: Column(
          children: [
            // Show user info if authenticated, otherwise show sign-in prompt
            if (user != null) ...[
              // User avatar
              CircleAvatar(
                radius: 50,
                backgroundColor: theme.colorScheme.primaryContainer,
                child: Text(
                  user!.email.substring(0, 1).toUpperCase(),
                  style: theme.textTheme.headlineLarge?.copyWith(
                    color: theme.colorScheme.primary,
                  ),
                ),
              ),
              const VerticalSpace.md(),

              // User info
              Text(
                user!.name ?? 'User',
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const VerticalSpace.sm(),
              Text(
                user!.email,
                style: theme.textTheme.bodyLarge?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
              const VerticalSpace.md(),
            ] else ...[
              // Sign-in prompt for unauthenticated users
              CircleAvatar(
                radius: 50,
                backgroundColor: theme.colorScheme.surfaceContainer,
                child: Icon(
                  Icons.person_outline,
                  size: AppConstants.iconSizeLG,
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
              const VerticalSpace.md(),
              Text(
                AppLocalizations.of(context).login,
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const VerticalSpace.sm(),
              Text(
                AppLocalizations.of(context).signInToUnlock,
                style: theme.textTheme.bodyLarge?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
              const VerticalSpace.md(),
              AppButton(
                variant: AppButtonVariant.primary,
                size: AppButtonSize.large,
                isExpanded: true,
                onPressed: () => context.pushRoute(AppRoute.login),
                icon: Icons.login,
                label: AppLocalizations.of(context).login,
              ),
              const VerticalSpace.md(),
            ],

            // Welcome message (shown to all users)
            WelcomeCard(theme: theme),
            const VerticalSpace.md(),

            // Feature showcase demonstrating boilerplate capabilities
            const FeatureShowcase(),
            const VerticalSpace.md(),

            // Logout button (only shown to authenticated users)
            if (user != null)
              AppButton(
                variant: AppButtonVariant.secondary,
                size: AppButtonSize.large,
                isExpanded: true,
                onPressed: () => _handleLogout(context, ref),
                icon: Icons.logout,
                label: AppLocalizations.of(context).logout,
              ),
            const VerticalSpace.md(),

            AppButton(
              onPressed: () {
                throw Exception('Test Crash');
              },
              label: 'Crash!',
            ),
            const VerticalSpace.lg(),
          ],
        ),
      ),
    );
  }

  Future<void> _handleLogout(
    final BuildContext context,
    final WidgetRef ref,
  ) async {
    final l10n = AppLocalizations.of(context);
    final confirmed = await AppDialogs.confirm(
      context,
      title: l10n.logout,
      message: l10n.confirmLogout,
      confirmText: l10n.logout,
      cancelText: l10n.cancel,
    );

    if (confirmed ?? false) {
      try {
        final authNotifier = ref.read(authProvider.notifier);
        await authNotifier.logout();
        // Router will automatically redirect to login when authState becomes null
      } catch (e) {
        if (context.mounted) {
          ref
              .read(feedbackServiceProvider)
              .showError(
                l10n.logoutFailed,
              );
        }
      }
    }
  }
}
