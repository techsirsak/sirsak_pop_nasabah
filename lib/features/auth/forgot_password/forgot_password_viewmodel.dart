import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:sirsak_pop_nasabah/core/constants/route_path.dart';
import 'package:sirsak_pop_nasabah/core/router/app_router.dart';
import 'package:sirsak_pop_nasabah/features/auth/forgot_password/forgot_password_state.dart';
import 'package:sirsak_pop_nasabah/services/api/api_exception.dart';
import 'package:sirsak_pop_nasabah/services/auth_service.dart';
import 'package:sirsak_pop_nasabah/services/logger_service.dart';
import 'package:sirsak_pop_nasabah/services/toast_service.dart';
import 'package:sirsak_pop_nasabah/services/url_launcher_service.dart';
import 'package:sirsak_pop_nasabah/shared/helpers/validation_helper.dart';

part 'forgot_password_viewmodel.g.dart';

@riverpod
class ForgotPasswordViewModel extends _$ForgotPasswordViewModel {
  @override
  ForgotPasswordState build() {
    return const ForgotPasswordState();
  }

  void setEmail(String email) {
    state = state.copyWith(email: email, emailError: null);
  }

  bool _validateEmail() {
    final error = ValidationHelper.validateEmail(state.email);
    if (error != null) {
      state = state.copyWith(emailError: error);
      return false;
    }
    return true;
  }

  Future<void> requestPasswordReset() async {
    // Clear previous errors
    state = state.copyWith(emailError: null, errorMessage: null);

    // Validate email
    if (!_validateEmail()) {
      return;
    }

    // Show loading
    state = state.copyWith(isLoading: true);

    try {
      final authService = ref.read(authServiceProvider);
      await authService.requestPasswordReset(email: state.email.trim());

      // Success - show success screen
      state = state.copyWith(isLoading: false, isSuccess: true);
    } on ApiException catch (e) {
      ref
          .read(loggerServiceProvider)
          .warning('[ForgotPasswordViewModel] Request failed: $e');

      state = state.copyWith(
        isLoading: false,
        errorMessage: e.when(
          network: (_, _) => 'errorNetworkConnection',
          server: (_, _) => 'errorServerError',
          client: (_, _, _) => 'errorRequestFailed',
          unknown: (_, _) => 'errorRequestFailed',
        ),
      );
      ref.read(toastServiceProvider).error(title: state.errorMessage ?? '');
    } catch (e, stackTrace) {
      ref
          .read(loggerServiceProvider)
          .error('[ForgotPasswordViewModel] Unexpected error', e, stackTrace);

      state = state.copyWith(
        isLoading: false,
        errorMessage: 'errorRequestFailed',
      );
      ref.read(toastServiceProvider).error(title: state.errorMessage ?? '');
    }
  }

  /// Open the device's email app
  Future<void> openEmailApp() async {
    final urlLauncher = ref.read(urlLauncherServiceProvider);
    await urlLauncher.openEmailApp();
  }

  /// Navigate to login page
  void navigateToLogin() {
    ref.read(routerProvider).go(SAppRoutePath.login);
  }
}
