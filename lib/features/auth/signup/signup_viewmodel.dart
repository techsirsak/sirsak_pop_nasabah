import 'dart:async';
import 'dart:convert';

import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:sirsak_pop_nasabah/core/constants/route_path.dart';
import 'package:sirsak_pop_nasabah/core/router/app_router.dart';
import 'package:sirsak_pop_nasabah/features/auth/signup/signup_state.dart';
import 'package:sirsak_pop_nasabah/features/qr_scan/qr_scan_state.dart';
import 'package:sirsak_pop_nasabah/services/api/api_exception.dart';
import 'package:sirsak_pop_nasabah/services/auth_service.dart';
import 'package:sirsak_pop_nasabah/services/crypto/qr_crypto_service.dart';
import 'package:sirsak_pop_nasabah/services/logger_service.dart';
import 'package:sirsak_pop_nasabah/services/url_launcher_service.dart';
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
    if (!state.acceptedTerms) {
      state = state.copyWith(termsError: 'termsRequired');
      return false;
    }
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

      ref.read(routerProvider).go(SAppRoutePath.verifyEmail);
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
    ref.read(routerProvider).go(SAppRoutePath.login);
  }

  void launchTermsAndConditions() {
    ref.read(urlLauncherServiceProvider).launchTermsAndConditions();
  }

  void launchPrivacyPolicy() {
    ref.read(urlLauncherServiceProvider).launchPrivacyPolicy();
  }

  /// Navigate to QR scan page and handle returned data
  ///
  /// When QR is scanned, the QR scan view pops with [ParsedQrData].
  /// This method captures that data and populates the form accordingly:
  /// - [QrType.registerBsu]: Sets bsuId and bsuName for display
  /// - [QrType.registerNasabah]: Auto-fills fullName, email, phoneNumber
  Future<void> navigateToQrScan() async {
    final result = await ref
        .read(routerProvider)
        .push<ParsedQrData>(
          SAppRoutePath.qrScan,
        );

    if (result == null) {
      // User cancelled/back without scanning
      return;
    }

    _handleQrScanResult(result);
  }

  /// Process the scanned QR data and update state accordingly
  void _handleQrScanResult(ParsedQrData data) {
    switch (data.type) {
      case QrType.registerBsu:
        _handleBsuQrData(data.bsuData);
      case QrType.registerNasabah:
        _handleNasabahQrData(data.nasabahData);
      case QrType.unknown:
        // Show an error for unknown QR type
        state = state.copyWith(
          errorMessage: 'Invalid QR code type',
        );
    }
  }

  /// Handle BSU QR data - store BSU info for display and registration
  void _handleBsuQrData(QrBsuData? bsuData) {
    if (bsuData == null) {
      ref
          .read(loggerServiceProvider)
          .warning(
            '[SignupViewModel] BSU QR scanned but bsuData is null',
          );
      return;
    }

    ref
        .read(loggerServiceProvider)
        .info(
          '[SignupViewModel] BSU QR processed - '
          'id: ${bsuData.id}, name: ${bsuData.bsuName}',
        );

    state = state.copyWith(
      bsuId: bsuData.id,
      bsuName: bsuData.bsuName,
      qrType: QrType.registerBsu,
    );
  }

  /// Handle Nasabah QR data - auto-populate form fields
  void _handleNasabahQrData(QrNasabahData? nasabahData) {
    if (nasabahData == null) {
      ref
          .read(loggerServiceProvider)
          .warning(
            '[SignupViewModel] Nasabah QR scanned but nasabahData is null',
          );
      return;
    }

    ref
        .read(loggerServiceProvider)
        .info(
          '[SignupViewModel] Nasabah QR processed - id: ${nasabahData.id}, '
          'name: ${nasabahData.name}, email: ${nasabahData.email}',
        );

    state = state.copyWith(
      nasabahId: nasabahData.id,
      fullName: nasabahData.name,
      email: nasabahData.email,
      phoneNumber: nasabahData.noHp ?? '',
      qrType: QrType.registerNasabah,
      // Clear any existing field errors since we're populating from QR
      fullNameError: null,
      emailError: null,
      phoneNumberError: null,
    );
  }

  /// Clear any QR-related data from the state
  ///
  /// Useful when user wants to clear the BSU association or nasabah data
  void clearQrData() {
    state = state.copyWith(
      bsuId: null,
      bsuName: null,
      nasabahId: null,
      qrType: null,
    );
  }
}
