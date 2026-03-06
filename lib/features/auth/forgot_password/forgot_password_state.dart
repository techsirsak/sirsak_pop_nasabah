import 'package:freezed_annotation/freezed_annotation.dart';

part 'forgot_password_state.freezed.dart';

@freezed
abstract class ForgotPasswordState with _$ForgotPasswordState {
  const factory ForgotPasswordState({
    @Default('') String email,
    @Default(false) bool isLoading,
    @Default(false) bool isSuccess,
    String? emailError,
    String? errorMessage,
  }) = _ForgotPasswordState;
}
