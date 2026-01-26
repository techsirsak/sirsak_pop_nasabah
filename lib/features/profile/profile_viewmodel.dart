import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:sirsak_pop_nasabah/core/constants/route_path.dart';
import 'package:sirsak_pop_nasabah/core/router/app_router.dart';
import 'package:sirsak_pop_nasabah/features/profile/profile_state.dart';
import 'package:sirsak_pop_nasabah/services/current_user_provider.dart';
import 'package:sirsak_pop_nasabah/services/local_storage.dart';

part 'profile_viewmodel.g.dart';

@riverpod
class ProfileViewModel extends _$ProfileViewModel {
  @override
  ProfileState build() {
    final currentUserState = ref.watch(currentUserProvider);
    final user = currentUserState.user;

    return ProfileState(
      userName: user?.namaLengkap ?? '',
      email: user?.email ?? '',
      phoneNumber: user?.noHp ?? '',
      memberSince: user?.createdAt.year.toString() ?? '',
      isLoading: currentUserState.isLoading,
    );
  }

  void navigateToEditProfile() {}

  void navigateToFaq() {}

  void openWhatsApp() {}

  void openEmail() {}

  void openInstagram() {}

  void navigateToChangePassword() {}

  void navigateToDeleteAccount() {}

  Future<void> logout() async {
    state = state.copyWith(isLoggingOut: true, errorMessage: null);
    try {
      await ref.read(localStorageServiceProvider).clearAllTokens();
      ref.read(currentUserProvider.notifier).clearUser();
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
