import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:sirsak_pop_nasabah/core/constants/route_path.dart';
import 'package:sirsak_pop_nasabah/features/auth/forgot_password/forgot_password_view.dart';
import 'package:sirsak_pop_nasabah/features/auth/login/login_view.dart';
import 'package:sirsak_pop_nasabah/features/auth/signup/signup_view.dart';
import 'package:sirsak_pop_nasabah/features/auth/verify_email/verify_email_view.dart';
import 'package:sirsak_pop_nasabah/features/drop_point/detail/drop_point_detail_view.dart';
import 'package:sirsak_pop_nasabah/features/home/home_view.dart';
import 'package:sirsak_pop_nasabah/features/landing_page/landing_page_view.dart';
import 'package:sirsak_pop_nasabah/features/profile/change_password/change_password_view.dart';
import 'package:sirsak_pop_nasabah/features/splash/splash_view.dart';
import 'package:sirsak_pop_nasabah/features/tutorial/tutorial_view.dart';
import 'package:sirsak_pop_nasabah/features/widget_showcase/widget_showcase_view.dart';
import 'package:sirsak_pop_nasabah/models/collection_point/collection_point_model.dart';

part 'app_router.g.dart';

@riverpod
GoRouter router(Ref ref) {
  return GoRouter(
    initialLocation: '/',
    routes: [
      GoRoute(
        path: SAppRoutePath.widgetShowcase,
        pageBuilder: (context, state) => MaterialPage(
          key: state.pageKey,
          child: const WidgetShowcaseView(),
        ),
      ),
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
      GoRoute(
        path: SAppRoutePath.tutorial,
        pageBuilder: (context, state) => MaterialPage(
          key: state.pageKey,
          child: const TutorialView(),
        ),
      ),
      GoRoute(
        path: SAppRoutePath.verifyEmail,
        pageBuilder: (context, state) => MaterialPage(
          key: state.pageKey,
          child: const VerifyEmailView(),
        ),
      ),
      GoRoute(
        path: SAppRoutePath.dropPointDetail,
        pageBuilder: (context, state) {
          final collectionPoint = state.extra! as CollectionPointModel;
          return MaterialPage(
            key: state.pageKey,
            child: DropPointDetailView(collectionPoint: collectionPoint),
          );
        },
      ),
      GoRoute(
        path: SAppRoutePath.changePassword,
        pageBuilder: (context, state) => MaterialPage(
          key: state.pageKey,
          child: const ChangePasswordView(),
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
