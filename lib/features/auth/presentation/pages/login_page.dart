import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:petzy_app/app/router/app_router.dart';
import 'package:petzy_app/core/core.dart';
import 'package:petzy_app/features/auth/presentation/providers/auth_notifier.dart';
import 'package:petzy_app/l10n/generated/app_localizations.dart';

/// Login page with animated hero image and phone number input.
class LoginPage extends HookConsumerWidget {
  /// Creates a [LoginPage] instance.
  const LoginPage({super.key});

  // Animation configuration constants
  static const _imageAnimationDuration = AppConstants.counterAnimation;
  static const _bottomSheetAnimationDuration = AppConstants.bounceAnimation;
  static const _bottomSheetDelay = AppConstants.flipAnimation;
  static const _bottomSheetBorderRadius = AppConstants.borderRadiusXXL;
  static const _pawIconSize = AppConstants.iconSizeSM;
  static const _pawIconOpacity = AppConstants.pageIndicatorInactiveOpacity;
  static const _googleIconSize = AppConstants.iconSizeMD;
  static const double _heroTopSpacing = 0.08;

  @override
  Widget build(final BuildContext context, final WidgetRef ref) {
    useOnMount(() {
      ref.read(analyticsServiceProvider).logScreenView(screenName: 'login');
    });

    return Scaffold(
      backgroundColor: context.colorScheme.primaryContainer,
      body: const Stack(
        fit: .expand,
        children: [
          _HeroSection(),
          _BottomSection(),
        ],
      ),
    );
  }
}

/// Hero section with animated login image.
class _HeroSection extends HookConsumerWidget {
  const _HeroSection();

  @override
  Widget build(final BuildContext context, final WidgetRef ref) {
    final animationController = useAnimationController(
      duration: LoginPage._imageAnimationDuration,
    );

    useOnMount(animationController.forward);

    final l10n = AppLocalizations.of(context);

    return Column(
      children: [
        SizedBox(height: context.screenHeight * LoginPage._heroTopSpacing),
        Text(
          l10n.loginToExplore,
          style: context.textTheme.headlineMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: context.colorScheme.onPrimaryContainer,
          ),
        ),
        Expanded(
          child: SlideTransition(
            position:
                Tween<Offset>(
                  begin: const Offset(0, 1),
                  end: Offset.zero,
                ).animate(
                  CurvedAnimation(
                    parent: animationController,
                    curve: Curves.easeOutCubic,
                  ),
                ),
            child: FadeTransition(
              opacity: Tween<double>(begin: 0, end: 1).animate(
                CurvedAnimation(
                  parent: animationController,
                  curve: Curves.easeOut,
                ),
              ),
              child: Image.asset(
                Assets.loginImage,
                fit: BoxFit.contain,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

/// Bottom section with phone input and login options.
class _BottomSection extends HookConsumerWidget {
  const _BottomSection();

  @override
  Widget build(final BuildContext context, final WidgetRef ref) {
    final animationController = useAnimationController(
      duration: LoginPage._bottomSheetAnimationDuration,
    );

    // Use useEffect with Timer for proper cleanup on unmount to prevent
    // calling forward() on a disposed controller if user navigates away early
    useEffect(() {
      final timer = Timer(LoginPage._bottomSheetDelay, () {
        try {
          animationController.forward();
        } catch (_) {
          // Silently ignore if controller is disposed
        }
      });
      return timer.cancel;
    }, const []);

    return Positioned(
      left: 0,
      right: 0,
      bottom: 0,
      child: SlideTransition(
        position:
            Tween<Offset>(
              begin: const Offset(0, 1),
              end: Offset.zero,
            ).animate(
              CurvedAnimation(
                parent: animationController,
                curve: Curves.easeOutCubic,
              ),
            ),
        child: const _LoginCard(),
      ),
    );
  }
}

/// State holder for phone input
class _PhoneState {
  _PhoneState({
    final PhoneNumber? phoneNumber,
    this.isValid = false,
  }) : phoneNumber =
           phoneNumber ?? PhoneNumber(isoCode: AppConstants.defaultCountryCode);

  final PhoneNumber phoneNumber;
  final bool isValid;

  _PhoneState copyWith({
    final PhoneNumber? phoneNumber,
    final bool? isValid,
  }) {
    return _PhoneState(
      phoneNumber: phoneNumber ?? this.phoneNumber,
      isValid: isValid ?? this.isValid,
    );
  }
}

/// Card containing phone input and login buttons.
class _LoginCard extends HookConsumerWidget {
  const _LoginCard();

  @override
  Widget build(final BuildContext context, final WidgetRef ref) {
    final phoneState = useState(_PhoneState());
    final isLoading = useState(false);
    final l10n = AppLocalizations.of(context);

    Future<void> handleLogin() async {
      if (!phoneState.value.isValid) {
        context.showErrorSnackBar(l10n.phoneNumberInvalid);
        return;
      }

      final phoneNumber = phoneState.value.phoneNumber.phoneNumber ?? '';

      if (phoneNumber.isEmpty) {
        context.showErrorSnackBar(l10n.phoneNumberInvalid);
        return;
      }

      try {
        // Request OTP
        await ref.read(authProvider.notifier).loginWithPhone(phoneNumber);

        // OTP sent successfully, navigate to verification page
        if (!context.mounted) return;
        context.goRouteWith(
          AppRoute.otpVerification,
          {'phoneNumber': phoneNumber},
        );
      } catch (e) {
        // Error during OTP request
        if (!context.mounted) return;
        final errorMessage = e.toString();
        context.showErrorSnackBar(errorMessage);
      }
    }

    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: context.colorScheme.surface,
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(LoginPage._bottomSheetBorderRadius),
        ),
      ),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _PhoneNumberHeader(l10n: l10n),
            const VerticalSpace.md(),
            _PhoneInput(
              initialValue: phoneState.value.phoneNumber,
              isEnabled: !isLoading.value,
              onInputChanged: (final value) {
                phoneState.value = phoneState.value.copyWith(
                  phoneNumber: value,
                );
              },
              onInputValidated: (final valid) {
                // Prevent unnecessary rebuilds when validity status doesn't change
                if (phoneState.value.isValid != valid) {
                  phoneState.value = phoneState.value.copyWith(isValid: valid);
                }
              },
            ),
            const VerticalSpace.lg(),
            AppButton(
              variant: .primary,
              size: AppButtonSize.large,
              isExpanded: true,
              isLoading: isLoading.value,
              onPressed: isLoading.value
                  ? null
                  : () async {
                      isLoading.value = true;
                      try {
                        await handleLogin();
                      } finally {
                        isLoading.value = false;
                      }
                    },
              label: l10n.login,
            ),
            const VerticalSpace.md(),
            Text(
              l10n.or,
              style: context.textTheme.bodyMedium?.copyWith(
                color: context.colorScheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
            const VerticalSpace.md(),
            _GoogleSignInButton(isLoading: isLoading.value),
          ],
        ),
      ),
    );
  }
}

/// Header with phone number label and decorative paw icons.
class _PhoneNumberHeader extends StatelessWidget {
  const _PhoneNumberHeader({required this.l10n});

  final AppLocalizations l10n;

  @override
  Widget build(final BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Flexible(
          child: Text(
            l10n.phoneNumber,
            style: context.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.pets,
              size: LoginPage._pawIconSize,
              color: context.colorScheme.onSurface.withValues(
                alpha: LoginPage._pawIconOpacity,
              ),
            ),
            const HorizontalSpace.xs(),
            Icon(
              Icons.pets,
              size: LoginPage._pawIconSize,
              color: context.colorScheme.onSurface.withValues(
                alpha: LoginPage._pawIconOpacity,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

/// Phone number input with country picker.
class _PhoneInput extends StatelessWidget {
  const _PhoneInput({
    required this.initialValue,
    required this.isEnabled,
    required this.onInputChanged,
    required this.onInputValidated,
  });

  final PhoneNumber initialValue;
  final bool isEnabled;
  final ValueChanged<PhoneNumber> onInputChanged;
  final ValueChanged<bool> onInputValidated;

  @override
  Widget build(final BuildContext context) {
    return Container(
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: context.colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(AppConstants.borderRadiusLG),
      ),
      child: InternationalPhoneNumberInput(
        onInputChanged: onInputChanged,
        onInputValidated: (final bool? valid) =>
            onInputValidated(valid ?? false),
        initialValue: initialValue,
        selectorConfig: const SelectorConfig(
          selectorType: PhoneInputSelectorType.DROPDOWN,
          useBottomSheetSafeArea: true,
          leadingPadding: AppSpacing.md,
        ),
        inputDecoration: InputDecoration(
          hintText: AppLocalizations.of(context).phoneInputHint,
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.md,
            vertical: AppSpacing.md,
          ),
          hintStyle: context.textTheme.bodyLarge?.copyWith(
            color: context.colorScheme.onSurfaceVariant,
          ),
        ),
        textStyle: context.textTheme.bodyLarge,
        formatInput: true,
        keyboardType: TextInputType.phone,
        autoValidateMode: AutovalidateMode.disabled,
        ignoreBlank: true,
        isEnabled: isEnabled,
      ),
    );
  }
}

/// Google sign-in button.
class _GoogleSignInButton extends ConsumerWidget {
  const _GoogleSignInButton({required this.isLoading});

  final bool isLoading;

  @override
  Widget build(final BuildContext context, final WidgetRef ref) {
    final l10n = AppLocalizations.of(context);

    return OutlinedButton(
      onPressed: isLoading ? null : () => _handleGoogleSignIn(context),
      style: OutlinedButton.styleFrom(
        minimumSize: const Size.fromHeight(AppConstants.buttonHeight),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppConstants.borderRadiusMD),
        ),
        side: BorderSide(color: context.colorScheme.outline),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          SvgPicture.asset(
            AppIcons.google,
            width: LoginPage._googleIconSize,
            height: LoginPage._googleIconSize,
          ),
          const HorizontalSpace.sm(),
          Flexible(
            child: Text(
              l10n.google,
              style: context.textTheme.labelLarge?.copyWith(
                color: context.colorScheme.onSurface,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  void _handleGoogleSignIn(final BuildContext context) {
    // TODO: Implement Google Sign-In
    final l10n = AppLocalizations.of(context);
    context.showInfoSnackBar(l10n.googleSignInComingSoon);
  }
}
