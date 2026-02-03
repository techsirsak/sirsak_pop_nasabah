import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:sirsak_pop_nasabah/core/router/app_router.dart';
import 'package:sirsak_pop_nasabah/features/profile/edit_profile/edit_profile_state.dart';
import 'package:sirsak_pop_nasabah/services/api/api_exception.dart';
import 'package:sirsak_pop_nasabah/services/current_user_provider.dart';
import 'package:sirsak_pop_nasabah/services/logger_service.dart';
import 'package:sirsak_pop_nasabah/services/toast_service.dart';
import 'package:sirsak_pop_nasabah/services/user_service.dart';
import 'package:sirsak_pop_nasabah/shared/helpers/validation_helper.dart';

part 'edit_profile_viewmodel.g.dart';

@riverpod
class EditProfileViewModel extends _$EditProfileViewModel {
  @override
  EditProfileState build() {
    final currentUserState = ref.read(currentUserProvider);
    final user = currentUserState.user;

    return EditProfileState(
      fullName: user?.namaLengkap ?? '',
      email: user?.email ?? '',
      phoneNumber: user?.noHp ?? '',
    );
  }

  void setFullName(String value) {
    state = state.copyWith(fullName: value, fullNameError: null);
  }

  void setEmail(String value) {
    state = state.copyWith(email: value, emailError: null);
  }

  void setPhoneNumber(String value) {
    state = state.copyWith(phoneNumber: value, phoneNumberError: null);
  }

  bool _validateFullName() {
    final fullName = state.fullName.trim();
    if (fullName.isEmpty) {
      state = state.copyWith(fullNameError: 'fullNameRequired');
      return false;
    }
    if (fullName.length < 2) {
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
    final phoneNumber = state.phoneNumber.trim();
    if (phoneNumber.isEmpty) {
      return true;
    }

    final phoneRegex = RegExp(r'^(\+62|62|0)8[1-9][0-9]{6,10}$');
    if (!phoneRegex.hasMatch(phoneNumber)) {
      state = state.copyWith(phoneNumberError: 'phoneNumberInvalid');
      return false;
    }
    return true;
  }

  bool _validateForm() {
    final fullNameValid = _validateFullName();
    final emailValid = _validateEmail();
    final phoneValid = _validatePhoneNumber();
    return fullNameValid && emailValid && phoneValid;
  }

  Future<void> saveProfile() async {
    state = state.copyWith(
      errorMessage: null,
      fullNameError: null,
      emailError: null,
      phoneNumberError: null,
    );

    if (!_validateForm()) {
      return;
    }

    state = state.copyWith(isLoading: true);

    try {
      await ref
          .read(userServiceProvider)
          .updateUserProfile(
            fullName: state.fullName.trim(),
            email: state.email.trim(),
            phoneNumber: state.phoneNumber.trim().isEmpty
                ? null
                : state.phoneNumber.trim(),
          );

      await ref.read(currentUserProvider.notifier).fetchCurrentUser();

      ref
          .read(toastServiceProvider)
          .success(title: 'Profile updated successfully');
      ref.read(routerProvider).pop();
    } on ApiException catch (e) {
      ref
          .read(loggerServiceProvider)
          .warning('[EditProfileViewModel] Save profile failed: $e');

      state = state.copyWith(
        isLoading: false,
        errorMessage: e.when(
          network: (message, _) => message,
          server: (message, _) => 'Server error. Please try again later.',
          client: (message, _, _) =>
              message.isNotEmpty ? message : 'Failed to update profile.',
          unknown: (message, _) =>
              'Failed to update profile. Please try again.',
        ),
      );
    } catch (e, stackTrace) {
      ref
          .read(loggerServiceProvider)
          .error('[EditProfileViewModel] Unexpected error', e, stackTrace);

      state = state.copyWith(
        isLoading: false,
        errorMessage: 'Failed to update profile. Please try again.',
      );
    }
  }
}
