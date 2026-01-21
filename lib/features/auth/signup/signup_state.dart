import 'package:freezed_annotation/freezed_annotation.dart';

part 'signup_state.freezed.dart';

@freezed
abstract class SignupState with _$SignupState {
  const factory SignupState({
    // Form fields
    @Default('') String fullName,
    @Default('') String email,
    @Default('') String phoneNumber,
    @Default('') String password,
    @Default('') String confirmPassword,
    @Default(false) bool acceptedTerms,

    // Loading state
    @Default(false) bool isLoading,

    // General error message
    String? errorMessage,

    // Field-specific error keys (i18n keys)
    String? fullNameError,
    String? emailError,
    String? phoneNumberError,
    String? passwordError,
    String? confirmPasswordError,
    String? termsError,
  }) = _SignupState;
}
