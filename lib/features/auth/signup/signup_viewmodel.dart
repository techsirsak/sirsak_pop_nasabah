import 'dart:async';

import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:sirsak_pop_nasabah/core/constants/route_path.dart';
import 'package:sirsak_pop_nasabah/core/router/app_router.dart';
import 'package:sirsak_pop_nasabah/features/auth/signup/signup_state.dart';
import 'package:sirsak_pop_nasabah/services/api/api_exception.dart';
import 'package:sirsak_pop_nasabah/services/auth_service.dart';
import 'package:sirsak_pop_nasabah/services/local_storage.dart';
import 'package:sirsak_pop_nasabah/services/logger_service.dart';
import 'package:sirsak_pop_nasabah/shared/helpers/validation_helper.dart';

part 'signup_viewmodel.g.dart';

@riverpod
class SignupViewModel extends _$SignupViewModel {
  @override
  SignupState build() {
    return const SignupState();
  }

  // ============================================
  // Field Setters (clear errors on input change)
  // ============================================

  void setFullName(String value) {
    state = state.copyWith(fullName: value, fullNameError: null);
  }

  void setEmail(String value) {
    state = state.copyWith(email: value, emailError: null);
  }

  void setPhoneNumber(String value) {
    state = state.copyWith(phoneNumber: value, phoneNumberError: null);
  }

  void setPassword(String value) {
    state = state.copyWith(
      password: value,
      passwordError: null,
      // Also clear confirm password error if passwords now match
      confirmPasswordError: null,
    );
  }

  void setConfirmPassword(String value) {
    state = state.copyWith(
      confirmPassword: value,
      confirmPasswordError: null,
    );
  }

  void setAcceptedTerms({required bool value}) {
    state = state.copyWith(acceptedTerms: value, termsError: null);
  }

  // ============================================
  // Validation Methods (return bool, set error keys)
  // ============================================

  bool _validateFullName() {
    final name = state.fullName.trim();

    if (name.isEmpty) {
      state = state.copyWith(fullNameError: 'fullNameRequired');
      return false;
    }

    if (name.length < 2) {
      state = state.copyWith(fullNameError: 'fullNameTooShort');
      return false;
    }

    return true;
  }

  bool _validateEmail() {
    final error = ValidationHelper.validateEmail(state.email);
    if (error != null) {
      state = state.copyWith(emailError: error);
      return false;
    }
    return true;
  }

  bool _validatePhoneNumber() {
    final phone = state.phoneNumber.trim();

    // Phone is optional - only validate if provided
    if (phone.isEmpty) {
      return true;
    }

    // Indonesian phone number format
    final phoneRegex = RegExp(r'^(\+62|62|0)8[1-9][0-9]{6,10}$');

    if (!phoneRegex.hasMatch(phone)) {
      state = state.copyWith(phoneNumberError: 'phoneNumberInvalid');
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

  bool _validateTerms() {
    // if (!state.acceptedTerms) {
    //   state = state.copyWith(termsError: 'termsRequired');
    //   return false;
    // }
    return true;
  }

  bool _validateForm() {
    // Run all validations (don't short-circuit to show all errors)
    final nameValid = _validateFullName();
    final emailValid = _validateEmail();
    final phoneValid = _validatePhoneNumber();
    final passwordValid = _validatePassword();
    final confirmValid = _validateConfirmPassword();
    final termsValid = _validateTerms();

    return nameValid &&
        emailValid &&
        phoneValid &&
        passwordValid &&
        confirmValid &&
        termsValid;
  }

  // ============================================
  // Main Actions
  // ============================================

  Future<void> signUp() async {
    // Clear previous errors
    state = state.copyWith(
      errorMessage: null,
      fullNameError: null,
      emailError: null,
      phoneNumberError: null,
      passwordError: null,
      confirmPasswordError: null,
      termsError: null,
    );

    // Validate form
    if (!_validateForm()) {
      return;
    }

    // Show loading
    state = state.copyWith(isLoading: true);

    try {
      // Call Auth API for registration
      final authService = ref.read(authServiceProvider);
      await authService.register(
        name: state.fullName.trim(),
        email: state.email.trim(),
        password: state.password,
      );

      // After successful registration, check if tutorial needed
      final localStorageService = ref.read(localStorageServiceProvider);
      final hasSeenTutorial = await localStorageService.hasSeenTutorial();

      if (hasSeenTutorial) {
        ref.read(routerProvider).go(SAppRoutePath.home);
      } else {
        ref.read(routerProvider).go(SAppRoutePath.tutorial);
      }
    } on ApiException catch (e) {
      ref
          .read(loggerServiceProvider)
          .warning('[SignupViewModel] Registration failed: $e');

      state = state.copyWith(
        isLoading: false,
        errorMessage: e.when(
          network: (message, _) => message,
          server: (message, _) => 'Server error. Please try again later.',
          client: (message, statusCode, errors) {
            _handleServerValidationErrors(errors);
            return message.isNotEmpty ? message : 'Registration failed.';
          },
          unknown: (message, _) => 'Registration failed. Please try again.',
        ),
      );
    } catch (e, stackTrace) {
      ref
          .read(loggerServiceProvider)
          .error('[SignupViewModel] Unexpected error', e, stackTrace);

      state = state.copyWith(
        isLoading: false,
        errorMessage: 'Registration failed. Please try again.',
      );
    }
  }

  /// Handle server-side validation errors
  void _handleServerValidationErrors(Map<String, dynamic>? errors) {
    if (errors == null) return;

    if (errors.containsKey('email')) {
      state = state.copyWith(emailError: 'emailAlreadyExists');
    }
    if (errors.containsKey('name')) {
      state = state.copyWith(fullNameError: 'fullNameInvalid');
    }
  }

  void clearError() {
    state = state.copyWith(errorMessage: null);
  }

  // ============================================
  // Navigation
  // ============================================

  void navigateToLogin() {
    unawaited(ref.read(routerProvider).push(SAppRoutePath.login));
  }

  void navigateToTermsAndConditions() {
    // TODO(devin): Navigate to Terms & Conditions page
    // unawaited(
    //   ref.read(routerProvider).push(SAppRoutePath.termsAndConditions),
    // );
  }
}
