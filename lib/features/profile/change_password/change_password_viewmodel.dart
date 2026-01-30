import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:sirsak_pop_nasabah/core/router/app_router.dart';
import 'package:sirsak_pop_nasabah/features/profile/change_password/change_password_state.dart';
import 'package:sirsak_pop_nasabah/services/api/api_exception.dart';
import 'package:sirsak_pop_nasabah/services/auth_service.dart';
import 'package:sirsak_pop_nasabah/services/current_user_provider.dart';
import 'package:sirsak_pop_nasabah/services/logger_service.dart';
import 'package:sirsak_pop_nasabah/services/toast_service.dart';
import 'package:sirsak_pop_nasabah/shared/helpers/validation_helper.dart';

part 'change_password_viewmodel.g.dart';

@riverpod
class ChangePasswordViewModel extends _$ChangePasswordViewModel {
  @override
  ChangePasswordState build() {
    return const ChangePasswordState();
  }

  void setPassword(String value) {
    state = state.copyWith(password: value, passwordError: null);
  }

  void setConfirmPassword(String value) {
    state = state.copyWith(confirmPassword: value, confirmPasswordError: null);
  }

  bool _validatePassword() {
    final error = ValidationHelper.validatePassword(state.password);
    if (error != null) {
      state = state.copyWith(passwordError: error);
      return false;
    }
    return true;
  }

  bool _validateConfirmPassword() {
    final confirmPassword = state.confirmPassword;
    final password = state.password;

    if (confirmPassword.isEmpty) {
      state = state.copyWith(confirmPasswordError: 'confirmPasswordRequired');
      return false;
    }

    if (confirmPassword != password) {
      state = state.copyWith(confirmPasswordError: 'passwordsDoNotMatch');
      return false;
    }

    return true;
  }

  bool _validateForm() {
    final passwordValid = _validatePassword();
    final confirmValid = _validateConfirmPassword();
    return passwordValid && confirmValid;
  }

  Future<void> changePassword() async {
    state = state.copyWith(
      errorMessage: null,
      passwordError: null,
      confirmPasswordError: null,
    );

    if (!_validateForm()) {
      return;
    }

    state = state.copyWith(isLoading: true);

    try {
      final currentUser = ref.read(currentUserProvider);
      final email = currentUser.user?.email;

      if (email == null) {
        state = state.copyWith(
          isLoading: false,
          errorMessage: 'User email not found',
        );
        return;
      }

      await ref.read(authServiceProvider).updatePassword(
            email: email,
            password: state.password,
          );

      ref.read(toastServiceProvider).success(
            title: 'Password changed successfully',
          );
      ref.read(routerProvider).pop();
    } on ApiException catch (e) {
      ref
          .read(loggerServiceProvider)
          .warning('[ChangePasswordViewModel] Change password failed: $e');

      state = state.copyWith(
        isLoading: false,
        errorMessage: e.when(
          network: (message, _) => message,
          server: (message, _) => 'Server error. Please try again later.',
          client: (message, statusCode, errors) =>
              message.isNotEmpty ? message : 'Failed to change password.',
          unknown: (message, _) =>
              'Failed to change password. Please try again.',
        ),
      );
    } catch (e, stackTrace) {
      ref
          .read(loggerServiceProvider)
          .error('[ChangePasswordViewModel] Unexpected error', e, stackTrace);

      state = state.copyWith(
        isLoading: false,
        errorMessage: 'Failed to change password. Please try again.',
      );
    }
  }

  void clearError() {
    state = state.copyWith(errorMessage: null);
  }
}
