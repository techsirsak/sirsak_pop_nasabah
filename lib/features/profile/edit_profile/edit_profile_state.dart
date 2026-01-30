import 'package:freezed_annotation/freezed_annotation.dart';

part 'edit_profile_state.freezed.dart';

@freezed
abstract class EditProfileState with _$EditProfileState {
  const factory EditProfileState({
    @Default('') String fullName,
    @Default('') String email,
    @Default('') String phoneNumber,
    @Default(false) bool isLoading,
    String? fullNameError,
    String? emailError,
    String? phoneNumberError,
    String? errorMessage,
  }) = _EditProfileState;
}
