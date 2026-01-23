import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:sirsak_pop_nasabah/core/constants/route_path.dart';
import 'package:sirsak_pop_nasabah/core/router/app_router.dart';
import 'package:sirsak_pop_nasabah/features/profile/profile_state.dart';
import 'package:sirsak_pop_nasabah/services/local_storage.dart';

part 'profile_viewmodel.g.dart';

@riverpod
class ProfileViewModel extends _$ProfileViewModel {
  @override
  ProfileState build() {
    return ProfileState(
      userName: 'John Smith',
      email: 'johnsmith@gmail.com',
      phoneNumber: '0812 1234 5678',
      memberSince: '2024',
      stats: const ProfileStats(
        wasteCollected: 12,
        wasteRecycled: 10,
        carbonAvoided: 5,
      ),
      badges: _getMockBadges(),
    );
  }

  List<ProfileBadge> _getMockBadges() {
    return const [
      ProfileBadge(id: '1', name: 'Bottle Hero', isEarned: true),
      ProfileBadge(id: '2', name: 'Bottle Hero', isEarned: true),
      ProfileBadge(id: '3', name: 'Bottle Hero', isEarned: true),
    ];
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
