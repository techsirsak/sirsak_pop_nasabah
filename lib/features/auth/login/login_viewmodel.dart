import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:sirsak_pop_nasabah/core/router/app_router.dart';
import 'package:sirsak_pop_nasabah/features/auth/login/login_state.dart';

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
    final email = state.email.trim();
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');

    if (email.isEmpty) {
      state = state.copyWith(emailError: 'emailRequired');
      return false;
    }

    if (!emailRegex.hasMatch(email)) {
      state = state.copyWith(emailError: 'emailInvalid');
      return false;
    }

    return true;
  }

  bool _validatePassword() {
    final password = state.password;

    if (password.isEmpty) {
      state = state.copyWith(passwordError: 'passwordRequired');
      return false;
    }

    if (password.length < 6) {
      state = state.copyWith(passwordError: 'passwordMinLength');
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
      // Simulate API call delay
      await Future<void>.delayed(const Duration(seconds: 1));

      // Mock successful login - navigate to home
      ref.read(routerProvider).go('/home');
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'Login failed. Please try again.',
      );
    }
  }

  void clearError() {
    state = state.copyWith(errorMessage: null);
  }
}
