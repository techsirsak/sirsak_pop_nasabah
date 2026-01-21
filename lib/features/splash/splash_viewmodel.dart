import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:sirsak_pop_nasabah/core/constants/route_path.dart';
import 'package:sirsak_pop_nasabah/core/router/app_router.dart';
import 'package:sirsak_pop_nasabah/services/auth_service.dart';
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
    state = true; // Set loading state

    // Simulate initialization delay (2 seconds)
    await Future<void>.delayed(const Duration(seconds: 2));

    final localStorageService = ref.read(localStorageServiceProvider);
    final accessToken = await localStorageService.getAccessToken();

    if (accessToken == null) {
      // No token, go to landing page
      ref.read(routerProvider).go(SAppRoutePath.landingPage);
      return;
    }

    // Try to refresh token to validate session
    final refreshToken = await localStorageService.getRefreshToken();

    if (refreshToken == null) {
      // No refresh token, clear and go to landing page
      await localStorageService.clearAllTokens();
      ref.read(routerProvider).go(SAppRoutePath.landingPage);
      return;
    }

    // Attempt to refresh the token
    final isValid = await _refreshAccessToken(refreshToken);

    if (isValid) {
      ref.read(routerProvider).go(SAppRoutePath.home);
    } else {
      // Token refresh failed, clear tokens and go to landing page
      await localStorageService.clearAllTokens();
      ref.read(routerProvider).go(SAppRoutePath.landingPage);
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
