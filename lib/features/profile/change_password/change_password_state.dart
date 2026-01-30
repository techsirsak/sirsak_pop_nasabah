import 'package:freezed_annotation/freezed_annotation.dart';

part 'change_password_state.freezed.dart';

@freezed
abstract class ChangePasswordState with _$ChangePasswordState {
  const factory ChangePasswordState({
    @Default('') String password,
    @Default('') String confirmPassword,
    @Default(false) bool isLoading,
    String? passwordError,
    String? confirmPasswordError,
    String? errorMessage,
  }) = _ChangePasswordState;
}
