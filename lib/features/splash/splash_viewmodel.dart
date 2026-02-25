import 'dart:async';

import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:sirsak_pop_nasabah/core/constants/route_path.dart';
import 'package:sirsak_pop_nasabah/core/router/app_router.dart';
import 'package:sirsak_pop_nasabah/services/auth_service.dart';
import 'package:sirsak_pop_nasabah/services/collection_points_cache_provider.dart';
import 'package:sirsak_pop_nasabah/services/current_user_provider.dart';
import 'package:sirsak_pop_nasabah/services/local_storage.dart';
import 'package:sirsak_pop_nasabah/services/logger_service.dart';

part 'splash_viewmodel.g.dart';

@riverpod
class SplashViewModel extends _$SplashViewModel {
  @override
  bool build() {
    return false;
  }

  Future<void> initializeSplash() async {
    final logger = ref.read(loggerServiceProvider)
      ..info('[SplashViewModel] initializeSplash started');
    state = true; // Set loading state

    // Fetch collection points in background
    // (for both guest and authenticated users)
    logger.info(
      '[SplashViewModel] starting collection points fetch in background',
    );
    await ref
        .read(collectionPointsCacheProvider.notifier)
        .fetchAndCacheCollectionPoints();

    final localStorageService = ref.read(localStorageServiceProvider);
    logger.info('[SplashViewModel] getting access token...');
    final accessToken = await localStorageService.getAccessToken();
    logger.info(
      '[SplashViewModel] accessToken exist: ${accessToken != null}',
    );

    if (accessToken == null) {
      // No token, go to landing page
      logger.info(
        '[SplashViewModel] no access token, navigating to landing page',
      );
      ref.read(routerProvider).go(SAppRoutePath.landingPage);
      return;
    }

    // Try to refresh token to validate session
    logger.info('[SplashViewModel] getting refresh token...');
    final refreshToken = await localStorageService.getRefreshToken();
    logger.info(
      '[SplashViewModel] refreshToken exist: ${refreshToken != null}',
    );

    if (refreshToken == null) {
      // No refresh token, clear and go to landing page
      logger.info(
        '[SplashViewModel] no refresh token, '
        'clearing and navigating to landing page',
      );
      await localStorageService.clearAllTokens();
      ref.read(routerProvider).go(SAppRoutePath.landingPage);
      return;
    }

    // Attempt to refresh the token
    logger.info('[SplashViewModel] attempting to refresh token...');
    final isValid = await _refreshAccessToken(refreshToken);
    logger.info('[SplashViewModel] token refresh result: $isValid');

    if (isValid) {
      // Fetch user data after successful token refresh
      logger.info('[SplashViewModel] fetching current user...');
      final userFetched = await ref
          .read(currentUserProvider.notifier)
          .fetchCurrentUser();
      logger.info('[SplashViewModel] user fetched: $userFetched');

      if (!userFetched) {
        logger.warning(
          '[SplashViewModel] Failed to fetch user data on startup',
        );
        // Continue anyway - user can still use the app
      }

      logger.info('[SplashViewModel] navigating to home');
      ref.read(routerProvider).go(SAppRoutePath.home);
    } else {
      // Token refresh failed, clear tokens and go to landing page
      logger.info(
        '[SplashViewModel] token refresh failed, '
        'clearing and navigating to landing page',
      );
      await localStorageService.clearAllTokens();

      // Check if tutorial needed and navigate
      final hasSeenTutorial = await localStorageService.hasSeenTutorial();
      logger.info('[SplashViewModel] hasSeenTutorial: $hasSeenTutorial');
      if (hasSeenTutorial) {
        logger.info('[SplashViewModel] navigating to login page');
        ref.read(routerProvider).go(SAppRoutePath.login);
      } else {
        logger.info('[SplashViewModel] navigating to landing page');
        ref.read(routerProvider).go(SAppRoutePath.landingPage);
      }
    }
  }

  /// Attempts to refresh the access token using the refresh token.
  /// Returns true if successful, false otherwise.
  Future<bool> _refreshAccessToken(String refreshToken) async {
    try {
      final authService = ref.read(authServiceProvider);
      final localStorageService = ref.read(localStorageServiceProvider);

      final response = await authService.refreshToken(
        refreshToken: refreshToken,
      );

      // Save new tokens
      await localStorageService.saveAccessToken(response.accessToken);
      await localStorageService.saveRefreshToken(response.refreshToken);

      return true;
    } catch (e) {
      ref
          .read(loggerServiceProvider)
          .warning('[SplashViewModel] Token refresh failed: $e');
      return false;
    }
  }
}
