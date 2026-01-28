import 'dart:async';

import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:sirsak_pop_nasabah/core/constants/route_path.dart';
import 'package:sirsak_pop_nasabah/core/router/app_router.dart';
import 'package:sirsak_pop_nasabah/features/home/home_state.dart';
import 'package:sirsak_pop_nasabah/models/user/impact_model.dart';
import 'package:sirsak_pop_nasabah/services/current_user_provider.dart';
import 'package:sirsak_pop_nasabah/shared/navigation/bottom_nav_provider.dart';

part 'home_viewmodel.g.dart';

@riverpod
class HomeViewModel extends _$HomeViewModel {
  @override
  HomeState build() {
    final currentUserState = ref.watch(currentUserProvider);
    final user = currentUserState.user;
    final impact = currentUserState.impact;
    final firstName = (user?.namaLengkap ?? '').split(' ').first;

    return HomeState(
      userName: firstName,
      points: 1400,
      balance: user?.balance ?? 0,
      impacts: impact ?? const ImpactModel(),
      challenge: const Challenge(
        title: 'Bottle Hero Badge',
        current: 4,
        total: 5,
        itemType: 'sampah PET',
      ),
      events: [
        const Event(
          title: 'Event Name',
          date: '3 Dec 2025',
          description: 'Join our event and learn more about waste management',
        ),
        const Event(
          title: 'Event Name',
          date: '3 Dec 2025',
          description: 'Join our event and learn more about waste management',
        ),
        const Event(
          title: 'Event Name',
          date: '3 Dec 2025',
          description: 'Join our event and learn more about waste management',
        ),
      ],
    );
  }

  void navigateToWithdraw() {
    unawaited(ref.read(routerProvider).push(SAppRoutePath.withdraw));
  }

  void navigateToRewards() {
    unawaited(ref.read(routerProvider).push(SAppRoutePath.rewards));
  }

  void navigateToChallenges() {
    unawaited(ref.read(routerProvider).push(SAppRoutePath.challenges));
  }

  void registerForEvent(Event event) {
    // TODO(devin): Implement event registration logic
  }

  void navigateToTab(int index) {
    ref.read(bottomNavProvider.notifier).setTab(index);
  }

  void navigateToHomeTab() => navigateToTab(0);

  void navigateToDropPointTab() => navigateToTab(1);

  void navigateToWalletTab() => navigateToTab(3);

  void navigateToProfileTab() => navigateToTab(4);
}
