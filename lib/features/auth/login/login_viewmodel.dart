import 'dart:async';

import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:sirsak_pop_nasabah/core/constants/route_path.dart';
import 'package:sirsak_pop_nasabah/core/router/app_router.dart';
import 'package:sirsak_pop_nasabah/features/auth/login/login_state.dart';
import 'package:sirsak_pop_nasabah/services/api/api_exception.dart';
import 'package:sirsak_pop_nasabah/services/auth_service.dart';
import 'package:sirsak_pop_nasabah/services/collection_points_cache_provider.dart';
import 'package:sirsak_pop_nasabah/services/current_user_provider.dart';
import 'package:sirsak_pop_nasabah/services/local_storage.dart';
import 'package:sirsak_pop_nasabah/services/logger_service.dart';
import 'package:sirsak_pop_nasabah/services/toast_service.dart';
import 'package:sirsak_pop_nasabah/shared/helpers/validation_helper.dart';

part 'login_viewmodel.g.dart';

@riverpod
class LoginViewModel extends _$LoginViewModel {
  @override
  LoginState build() {
    return const LoginState();
  }

  void setEmail(String email) {
    state = state.copyWith(email: email, emailError: null);
  }

  void setPassword(String password) {
    state = state.copyWith(password: password, passwordError: null);
  }

  bool _validateEmail() {
    final error = ValidationHelper.validateEmail(state.email);
    if (error != null) {
      state = state.copyWith(emailError: error);
      return false;
    }
    return true;
  }

  bool _validatePassword() {
    final error = ValidationHelper.validatePassword(state.password);
    if (error != null) {
      state = state.copyWith(passwordError: error);
      return false;
    }
    return true;
  }

  bool _validateForm() {
    final emailValid = _validateEmail();
    final passwordValid = _validatePassword();
    return emailValid && passwordValid;
  }

  Future<void> login() async {
    // Clear previous errors
    state = state.copyWith(
      errorMessage: null,
      emailError: null,
      passwordError: null,
    );

    // Validate form
    if (!_validateForm()) {
      return;
    }

    // Show loading
    state = state.copyWith(isLoading: true);

    try {
      // Call Auth API for login
      final authService = ref.read(authServiceProvider);
      final response = await authService.login(
        email: state.email.trim(),
        password: state.password,
      );

      // Save tokens
      final localStorageService = ref.read(localStorageServiceProvider);
      await localStorageService.saveAccessToken(response.accessToken);
      await localStorageService.saveRefreshToken(response.refreshToken);

      // Fetch user data after successful login
      final userFetched = await ref
          .read(currentUserProvider.notifier)
          .fetchCurrentUser();

      if (!userFetched) {
        ref
            .read(loggerServiceProvider)
            .warning(
              '[LoginViewModel] Failed to fetch user data after login',
            );
        // Continue anyway - user can still use the app
      }

      // Fetch collection points in background (non-blocking)
      unawaited(
        ref
            .read(collectionPointsCacheProvider.notifier)
            .fetchAndCacheCollectionPoints(),
      );

      // Check if tutorial needed and navigate
      final hasSeenTutorial = await localStorageService.hasSeenTutorial();

      if (hasSeenTutorial) {
        ref.read(routerProvider).go(SAppRoutePath.home);
      } else {
        ref.read(routerProvider).go(SAppRoutePath.tutorial);
      }
    } on InvalidCredentialsException catch (e) {
      ref
          .read(loggerServiceProvider)
          .warning('[LoginViewModel] Invalid credentials: $e');

      state = state.copyWith(
        isLoading: false,
        errorMessage: 'errorInvalidCredentials',
      );
      ref.read(toastServiceProvider).error(title: state.errorMessage ?? '');
    } on ApiException catch (e) {
      ref
          .read(loggerServiceProvider)
          .warning('[LoginViewModel] Login failed: $e');

      state = state.copyWith(
        isLoading: false,
        errorMessage: e.when(
          network: (_, _) => 'errorNetworkConnection',
          server: (_, _) => 'errorServerError',
          client: (_, _, errors) {
            _handleServerValidationErrors(errors);
            return 'errorLoginFailed';
          },
          unknown: (_, _) => 'errorLoginFailed',
        ),
      );
      ref.read(toastServiceProvider).error(title: state.errorMessage ?? '');
    } catch (e, stackTrace) {
      ref
          .read(loggerServiceProvider)
          .error('[LoginViewModel] Unexpected error', e, stackTrace);
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'errorLoginFailed',
      );
      ref.read(toastServiceProvider).error(title: state.errorMessage ?? '');
    }
  }

  /// Handle server-side validation errors
  void _handleServerValidationErrors(Map<String, dynamic>? errors) {
    if (errors == null) return;

    if (errors.containsKey('email')) {
      state = state.copyWith(emailError: 'emailInvalid');
    }
    if (errors.containsKey('password')) {
      state = state.copyWith(passwordError: 'passwordInvalid');
    }
  }

  void clearError() {
    state = state.copyWith(errorMessage: null);
  }

  void navigateToForgotPassword() {
    unawaited(ref.read(routerProvider).push(SAppRoutePath.forgotPassword));
  }

  void navigateToSignUp() {
    unawaited(ref.read(routerProvider).push(SAppRoutePath.signUp));
  }
}
