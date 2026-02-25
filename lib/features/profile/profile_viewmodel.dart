import 'dart:async';

import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:sirsak_pop_nasabah/core/constants/route_path.dart';
import 'package:sirsak_pop_nasabah/core/router/app_router.dart';
import 'package:sirsak_pop_nasabah/features/profile/profile_state.dart';
import 'package:sirsak_pop_nasabah/features/profile/widgets/delete_account_confirmation_dialog.dart';
import 'package:sirsak_pop_nasabah/models/user/impact_model.dart';
import 'package:sirsak_pop_nasabah/services/api/api_exception.dart';
import 'package:sirsak_pop_nasabah/services/current_user_provider.dart';
import 'package:sirsak_pop_nasabah/services/dialog_service.dart';
import 'package:sirsak_pop_nasabah/services/local_storage.dart';
import 'package:sirsak_pop_nasabah/services/logger_service.dart';
import 'package:sirsak_pop_nasabah/services/toast_service.dart';
import 'package:sirsak_pop_nasabah/services/url_launcher_service.dart';
import 'package:sirsak_pop_nasabah/services/user_service.dart';

part 'profile_viewmodel.g.dart';

@riverpod
class ProfileViewModel extends _$ProfileViewModel {
  @override
  ProfileState build() {
    final currentUserState = ref.watch(currentUserProvider);
    final user = currentUserState.user;
    final impact = currentUserState.impact;

    return ProfileState(
      userName: user?.namaLengkap ?? '',
      email: user?.email ?? '',
      phoneNumber: user?.noHp ?? '',
      memberSince: user?.createdAt.year.toString() ?? '',
      isLoading: currentUserState.isLoading,
      impacts: impact ?? const ImpactModel(),
    );
  }

  void navigateToEditProfile() {
    unawaited(ref.read(routerProvider).push(SAppRoutePath.editProfile));
  }

  void navigateToFaq() {
    ref.read(urlLauncherServiceProvider).launchSirsakFAQ();
  }

  void openWhatsApp() {
    ref.read(urlLauncherServiceProvider).contactSirsakWA();
  }

  void openEmail() {
    ref.read(urlLauncherServiceProvider).openEmailSirsak();
  }

  void openInstagram() {
    ref.read(urlLauncherServiceProvider).openSirsakInstagram();
  }

  void navigateToChangePassword() {
    unawaited(ref.read(routerProvider).push(SAppRoutePath.changePassword));
  }

  Future<void> navigateToDeleteAccount() async {
    final confirmed = await ref
        .read(dialogServiceProvider)
        .showCustomDialog<bool>(
          child: const DeleteAccountConfirmationDialog(),
          barrierDismissible: false,
        );

    if (confirmed ?? false) {
      await deleteAccount();
    }
  }

  Future<void> deleteAccount() async {
    state = state.copyWith(isDeletingAccount: true, errorMessage: null);

    try {
      await ref.read(userServiceProvider).requestDeleteUser();
      ref
          .read(toastServiceProvider)
          .success(title: 'Account deletion requested');

      // Reuse logout cleanup logic
      await ref.read(localStorageServiceProvider).clearAllTokens();
      ref.read(currentUserProvider.notifier).clearUser();
      ref.read(routerProvider).go(SAppRoutePath.landingPage);
    } on ApiException catch (e) {
      state = state.copyWith(
        isDeletingAccount: false,
        errorMessage: e.when(
          network: (message, _) => message,
          server: (message, _) => 'Server error. Please try again.',
          client: (message, _, _) => message,
          unknown: (message, _) => 'Something went wrong. Please try again.',
        ),
      );
      ref.read(toastServiceProvider).error(title: state.errorMessage ?? '');
    } catch (e, stackTrace) {
      ref
          .read(loggerServiceProvider)
          .error('[ProfileViewModel] Delete account error', e, stackTrace);
      state = state.copyWith(
        isDeletingAccount: false,
        errorMessage: 'Something went wrong. Please try again.',
      );
      ref.read(toastServiceProvider).error(title: state.errorMessage ?? '');
    }
  }

  Future<void> logout() async {
    state = state.copyWith(isLoggingOut: true, errorMessage: null);
    try {
      await ref.read(localStorageServiceProvider).clearAllTokens();
      ref.read(currentUserProvider.notifier).clearUser();
      // Users can continue using public features without being logged in
      ref.read(routerProvider).go(SAppRoutePath.landingPage);
    } catch (e) {
      state = state.copyWith(
        isLoggingOut: false,
        errorMessage: e.toString(),
      );
    }
  }

  Future<void> loadProfileData() async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    try {
      await Future<void>.delayed(const Duration(milliseconds: 500));
      state = state.copyWith(isLoading: false);
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: e.toString(),
      );
    }
  }
}
