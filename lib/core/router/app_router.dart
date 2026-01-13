import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:sirsak_pop_nasabah/core/constants/route_path.dart';
import 'package:sirsak_pop_nasabah/features/auth/forgot_password/forgot_password_view.dart';
import 'package:sirsak_pop_nasabah/features/auth/login/login_view.dart';
import 'package:sirsak_pop_nasabah/features/auth/signup/signup_view.dart';
import 'package:sirsak_pop_nasabah/features/home/home_view.dart';
import 'package:sirsak_pop_nasabah/features/landing_page/landing_page_view.dart';
import 'package:sirsak_pop_nasabah/features/splash/splash_view.dart';

part 'app_router.g.dart';

@riverpod
GoRouter router(Ref ref) {
  return GoRouter(
    initialLocation: '/',
    routes: [
      GoRoute(
        path: '/',
        pageBuilder: (context, state) => MaterialPage(
          key: state.pageKey,
          child: const SplashView(),
        ),
      ),
      GoRoute(
        path: SAppRoutePath.landingPage,
        pageBuilder: (context, state) => MaterialPage(
          key: state.pageKey,
          child: const LandingPageView(),
        ),
      ),
      GoRoute(
        path: SAppRoutePath.login,
        pageBuilder: (context, state) => MaterialPage(
          key: state.pageKey,
          child: const LoginView(),
        ),
      ),
      GoRoute(
        path: SAppRoutePath.home,
        pageBuilder: (context, state) => MaterialPage(
          key: state.pageKey,
          child: const HomeView(),
        ),
      ),
      GoRoute(
        path: SAppRoutePath.forgotPassword,
        pageBuilder: (context, state) => MaterialPage(
          key: state.pageKey,
          child: const ForgotPasswordView(),
        ),
      ),
      GoRoute(
        path: SAppRoutePath.signUp,
        pageBuilder: (context, state) => MaterialPage(
          key: state.pageKey,
          child: const SignUpView(),
        ),
      ),
    ],
    errorBuilder: (context, state) => Scaffold(
      body: Center(
        child: Text('Page not found: ${state.matchedLocation}'),
      ),
    ),
  );
}
