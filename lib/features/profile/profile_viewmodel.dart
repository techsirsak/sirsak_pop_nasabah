import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:sirsak_pop_nasabah/features/profile/profile_state.dart';

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
        wasteCollected: 12.0,
        wasteRecycled: 10.0,
        carbonAvoided: 5.0,
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

  void navigateToEditProfile() {
    // TODO: Navigate to edit profile screen
  }

  void navigateToFaq() {
    // TODO: Navigate to FAQ page or open external link
  }

  void openWhatsApp() {
    // TODO: Open WhatsApp with phone number
  }

  void openEmail() {
    // TODO: Open email client
  }

  void openInstagram() {
    // TODO: Open Instagram profile
  }

  void navigateToChangePassword() {
    // TODO: Navigate to change password screen
  }

  void navigateToDeleteAccount() {
    // TODO: Navigate to delete account confirmation
  }

  Future<void> logout() async {
    state = state.copyWith(isLoggingOut: true, errorMessage: null);
    try {
      // TODO: Call auth service to logout
      await Future<void>.delayed(const Duration(milliseconds: 500));
      // TODO: Navigate to login/landing page
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
      // TODO: Fetch from API
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
