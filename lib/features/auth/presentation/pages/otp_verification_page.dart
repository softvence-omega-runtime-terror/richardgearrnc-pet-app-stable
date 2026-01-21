import 'dart:async';

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:petzy_app/app/router/app_router.dart';
import 'package:petzy_app/core/core.dart';
import 'package:petzy_app/features/auth/presentation/providers/auth_notifier.dart';
import 'package:petzy_app/l10n/generated/app_localizations.dart';

/// OTP verification page with animated image and code input.
class OTPVerificationPage extends HookConsumerWidget {
  /// Creates an [OTPVerificationPage] instance.
  ///
  /// [phoneNumber] is the phone number to which the OTP was sent.
  const OTPVerificationPage({
    required this.phoneNumber,
    super.key,
  });

  /// Phone number that was used for OTP request.
  final String phoneNumber;

  // Animation configuration constants
  static const _imageAnimationDuration = AppConstants.counterAnimation;
  static const _bottomSheetAnimationDuration = AppConstants.bounceAnimation;
  static const _bottomSheetDelay = AppConstants.flipAnimation;
  static const _bottomSheetBorderRadius = AppConstants.borderRadiusXXL;
  static const int _otpLength = 6;
  static const int _resendTimeoutSeconds = 60;

  @override
  Widget build(final BuildContext context, final WidgetRef ref) {
    useOnMount(() {
      ref
          .read(analyticsServiceProvider)
          .logScreenView(screenName: 'otp_verification');
    });

    return Scaffold(
      backgroundColor: context.colorScheme.primaryContainer,
      // appBar: AppBar(
      //   backgroundColor: Colors.transparent,
      //   elevation: 0,
      //   leading: IconButton(
      //     icon: const Icon(Icons.arrow_back),
      //     onPressed: () => Navigator.of(context).pop(),
      //   ),
      // ),
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Background image
          Positioned.fill(
            child: Image.asset(
              Assets.otpBackground,
              fit: BoxFit.cover,
            ),
          ),
          // Content
          Stack(
            fit: StackFit.expand,
            children: [
              _OTPHeroSection(phoneNumber: phoneNumber),
              _OTPBottomSection(phoneNumber: phoneNumber),
            ],
          ),
        ],
      ),
    );
  }
}

/// Hero section with animated image (bottom to top).
class _OTPHeroSection extends HookConsumerWidget {
  const _OTPHeroSection({required this.phoneNumber});

  final String phoneNumber;

  @override
  Widget build(final BuildContext context, final WidgetRef ref) {
    final animationController = useAnimationController(
      duration: OTPVerificationPage._imageAnimationDuration,
    );

    useOnMount(animationController.forward);

    return Positioned(
      top: 0,
      left: 0,
      right: 0,
      height: context.screenHeight * 0.45,
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
            Assets.otpImage,
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}

/// Bottom section with OTP input and verification.
class _OTPBottomSection extends HookConsumerWidget {
  const _OTPBottomSection({required this.phoneNumber});

  final String phoneNumber;

  @override
  Widget build(final BuildContext context, final WidgetRef ref) {
    final animationController = useAnimationController(
      duration: OTPVerificationPage._bottomSheetAnimationDuration,
    );

    // Use useEffect with Timer for proper cleanup on unmount
    useEffect(() {
      final timer = Timer(OTPVerificationPage._bottomSheetDelay, () {
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
        child: _OTPCard(phoneNumber: phoneNumber),
      ),
    );
  }
}

/// Card containing OTP input and verification button.
class _OTPCard extends HookConsumerWidget {
  const _OTPCard({required this.phoneNumber});

  final String phoneNumber;

  @override
  Widget build(final BuildContext context, final WidgetRef ref) {
    final otpCode = useState('');
    final authState = ref.watch(authProvider);
    final isLoading = authState.isLoading;
    final l10n = AppLocalizations.of(context);

    ref.listen(authProvider, (final _, final next) {
      next.whenOrNull(
        error: (final error, final _) =>
            context.showErrorSnackBar(error.toString()),
        data: (final user) {
          if (user != null) context.goRoute(AppRoute.home);
        },
      );
    });

    Future<void> handleVerifyCode() async {
      if (otpCode.value.length != OTPVerificationPage._otpLength) {
        context.showErrorSnackBar(l10n.otpCodeInvalid);
        return;
      }

      await ref
          .read(authProvider.notifier)
          .verifyOtp(phoneNumber, otpCode.value);
    }

    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: context.colorScheme.surface,
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(OTPVerificationPage._bottomSheetBorderRadius),
        ),
      ),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _OTPHeader(l10n: l10n),
            const VerticalSpace.lg(),
            _OTPInput(
              isEnabled: !isLoading,
              onCodeChanged: (final code) => otpCode.value = code,
            ),
            const VerticalSpace.lg(),
            AppButton(
              variant: .primary,
              size: AppButtonSize.large,
              isExpanded: true,
              isLoading: isLoading,
              onPressed:
                  isLoading ||
                      otpCode.value.length < OTPVerificationPage._otpLength
                  ? null
                  : handleVerifyCode,
              label: l10n.verifyCode,
            ),
            const VerticalSpace.lg(),
            _ResendCodeSection(phoneNumber: phoneNumber, isLoading: isLoading),
          ],
        ),
      ),
    );
  }
}

/// Header with title and phone number display.
class _OTPHeader extends StatelessWidget {
  const _OTPHeader({required this.l10n});

  final AppLocalizations l10n;

  @override
  Widget build(final BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.enterVerificationCode,
          style: context.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        const VerticalSpace.sm(),
        Text(
          l10n.enterCodeSentToPhoneNumber,
          style: context.textTheme.bodyMedium?.copyWith(
            color: context.colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }
}

/// OTP input field with 6 digit boxes.
class _OTPInput extends HookWidget {
  const _OTPInput({
    required this.isEnabled,
    required this.onCodeChanged,
  });

  final bool isEnabled;
  final ValueChanged<String> onCodeChanged;

  @override
  Widget build(final BuildContext context) {
    final focusNodes = useState(
      List.generate(OTPVerificationPage._otpLength, (_) => FocusNode()),
    );
    final otpControllers = useState(
      List.generate(
        OTPVerificationPage._otpLength,
        (_) => TextEditingController(),
      ),
    );

    useEffect(() {
      return () {
        for (final node in focusNodes.value) {
          node.dispose();
        }
        for (final controller in otpControllers.value) {
          controller.dispose();
        }
      };
    }, const []);

    void handleOtpChange(final int index, final String value) {
      if (value.isNotEmpty) {
        if (index < OTPVerificationPage._otpLength - 1) {
          FocusScope.of(context).requestFocus(focusNodes.value[index + 1]);
        } else {
          FocusScope.of(context).unfocus();
        }
      }

      final code = otpControllers.value.map((final c) => c.text).join();
      onCodeChanged(code);
    }

    void handleOtpBackspace(final int index, final String value) {
      if (value.isEmpty && index > 0) {
        FocusScope.of(context).requestFocus(focusNodes.value[index - 1]);
      }
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: List.generate(
        OTPVerificationPage._otpLength,
        (final index) => _OTPBox(
          controller: otpControllers.value[index],
          focusNode: focusNodes.value[index],
          isEnabled: isEnabled,
          onChanged: (final value) => handleOtpChange(index, value),
          onBackspace: (final value) => handleOtpBackspace(index, value),
        ),
      ),
    );
  }
}

/// Single OTP input box.
class _OTPBox extends StatelessWidget {
  const _OTPBox({
    required this.controller,
    required this.focusNode,
    required this.isEnabled,
    required this.onChanged,
    required this.onBackspace,
  });

  final TextEditingController controller;
  final FocusNode focusNode;
  final bool isEnabled;
  final ValueChanged<String> onChanged;
  final ValueChanged<String> onBackspace;

  @override
  Widget build(final BuildContext context) {
    return SizedBox(
      width: 56,
      height: 64,
      child: TextField(
        controller: controller,
        focusNode: focusNode,
        enabled: isEnabled,
        textAlign: TextAlign.center,
        keyboardType: TextInputType.number,
        maxLength: 1,
        onChanged: onChanged,
        onEditingComplete: () {
          if (controller.text.isEmpty) {
            onBackspace('');
          }
        },
        decoration: InputDecoration(
          counterText: '',
          contentPadding: const EdgeInsets.symmetric(vertical: 12),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(AppConstants.borderRadiusSM),
            borderSide: BorderSide(
              color: context.colorScheme.outline,
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(AppConstants.borderRadiusSM),
            borderSide: BorderSide(
              color: context.colorScheme.outline,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(AppConstants.borderRadiusSM),
            borderSide: BorderSide(
              color: context.colorScheme.primary,
              width: 2,
            ),
          ),
          disabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(AppConstants.borderRadiusSM),
            borderSide: BorderSide(
              color: context.colorScheme.surfaceContainerHighest,
            ),
          ),
        ),
        style: context.textTheme.titleLarge?.copyWith(
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

/// Resend code section with countdown timer.
///
/// Manages OTP resend functionality with a 60-second countdown timer.
/// The timer automatically stops when it reaches 0 to prevent unnecessary
/// rebuilds (zombie timer bug fix).
class _ResendCodeSection extends HookConsumerWidget {
  const _ResendCodeSection({
    required this.phoneNumber,
    required this.isLoading,
  });

  final String phoneNumber;
  final bool isLoading;

  @override
  Widget build(final BuildContext context, final WidgetRef ref) {
    final remainingSeconds = useState(
      OTPVerificationPage._resendTimeoutSeconds,
    );
    final canResend = useState(false);
    final timerRef = useRef<Timer?>(null);
    final l10n = AppLocalizations.of(context);

    /// Start the countdown timer for OTP resend.
    /// Cancels any existing timer before starting a new one.
    void startTimer() {
      canResend.value = false;
      remainingSeconds.value = OTPVerificationPage._resendTimeoutSeconds;

      // Cancel any existing timer
      timerRef.value?.cancel();

      timerRef.value = Timer.periodic(const Duration(seconds: 1), (
        final timer,
      ) {
        if (remainingSeconds.value > 0) {
          remainingSeconds.value--;
        } else {
          // CRITICAL: Stop the timer when countdown reaches 0
          // This prevents the zombie timer bug (infinite rebuilds)
          canResend.value = true;
          timer.cancel();
        }
      });
    }

    // Start timer on initial mount
    useEffect(() {
      startTimer();
      return () => timerRef.value?.cancel();
    }, const []);

    Future<void> handleResendCode() async {
      if (!canResend.value) return;

      // Restart the timer
      startTimer();

      // Call resendOtp from AuthNotifier
      await ref.read(authProvider.notifier).resendOtp(phoneNumber);

      if (context.mounted) {
        ref.read(analyticsServiceProvider).logEvent(AnalyticsEvents.otpResent);
        context.showSnackBar(l10n.codeSentSuccessfully);
      }
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          l10n.didNotReceiveCode,
          style: context.textTheme.bodyMedium?.copyWith(
            color: context.colorScheme.onSurfaceVariant,
          ),
          textAlign: TextAlign.center,
        ),
        const VerticalSpace.sm(),
        if (!canResend.value)
          Text(
            '${l10n.resendCode} (${remainingSeconds.value}s)',
            style: context.textTheme.labelLarge?.copyWith(
              color: context.colorScheme.onSurfaceVariant,
            ),
          )
        else
          GestureDetector(
            onTap: isLoading ? null : handleResendCode,
            child: Text(
              l10n.resendCode,
              style: context.textTheme.labelLarge?.copyWith(
                color: context.colorScheme.primary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
      ],
    );
  }
}
