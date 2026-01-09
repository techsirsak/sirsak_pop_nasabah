import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:sirsak_pop_nasabah/core/constants/route_path.dart';
import 'package:sirsak_pop_nasabah/features/auth/login/login_view.dart';
import 'package:sirsak_pop_nasabah/features/home/home_view.dart';
import 'package:sirsak_pop_nasabah/features/splash/splash_view.dart';

final routerProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: '/',
    routes: [
      GoRoute(
        path: '/',
        name: 'splash',
        pageBuilder: (context, state) => MaterialPage(
          key: state.pageKey,
          child: const SplashView(),
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
    ],
    errorBuilder: (context, state) => Scaffold(
      body: Center(
        child: Text('Page not found: ${state.matchedLocation}'),
      ),
    ),
  );
});
