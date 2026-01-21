import 'package:go_router/go_router.dart';
import 'package:petzy_app/app/router/app_router.dart';
import 'package:petzy_app/app/startup/presentation/force_update_page.dart';
import 'package:petzy_app/app/startup/presentation/maintenance_page.dart';
import 'package:petzy_app/features/auth/presentation/pages/login_page.dart';
import 'package:petzy_app/features/auth/presentation/pages/otp_verification_page.dart';

/// Routes that are accessible without authentication.
final authRoutes = [
  GoRoute(
    path: AppRoute.login.path,
    name: AppRoute.login.name,
    builder: (final context, final state) => const LoginPage(),
  ),
  GoRoute(
    path: AppRoute.otpVerification.path,
    name: AppRoute.otpVerification.name,
    builder: (final context, final state) {
      final phoneNumber = state.pathParameters['phoneNumber'] ?? '';
      return OTPVerificationPage(phoneNumber: phoneNumber);
    },
  ),
  GoRoute(
    path: AppRoute.maintenance.path,
    name: AppRoute.maintenance.name,
    builder: (final context, final state) => const MaintenancePage(),
  ),
  GoRoute(
    path: AppRoute.forceUpdate.path,
    name: AppRoute.forceUpdate.name,
    builder: (final context, final state) => const ForceUpdatePage(),
  ),
];
