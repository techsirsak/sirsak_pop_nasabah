import 'dart:async';

import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:sirsak_pop_nasabah/core/constants/route_path.dart';
import 'package:sirsak_pop_nasabah/core/router/app_router.dart';
import 'package:sirsak_pop_nasabah/features/home/home_state.dart';
import 'package:sirsak_pop_nasabah/services/current_user_provider.dart';

part 'home_viewmodel.g.dart';

@riverpod
class HomeViewModel extends _$HomeViewModel {
  @override
  HomeState build() {
    final currentUserState = ref.watch(currentUserProvider);
    final user = currentUserState.user;
    final firstName = (user?.namaLengkap ?? '').split(' ').first;

    return HomeState(
      userName: firstName,
      points: 1400,
      impactMetrics: [
        ImpactMetric(
          label: 'Sampah Terkumpulkan',
          value: '12 ton',
          icon: PhosphorIcons.trash(),
        ),
        ImpactMetric(
          label: 'Sampah Terdaur Ulang',
          value: '10 ton',
          icon: PhosphorIcons.recycle(),
        ),
        ImpactMetric(
          label: 'Emisi Karbon Terhindari',
          value: '5 ton CO2eq',
          icon: PhosphorIcons.globeHemisphereEast(),
        ),
      ],
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

  void navigateToHistory() {
    unawaited(ref.read(routerProvider).push(SAppRoutePath.pointsHistory));
  }

  void navigateToWithdraw() {
    unawaited(ref.read(routerProvider).push(SAppRoutePath.withdraw));
  }

  void navigateToRewards() {
    unawaited(ref.read(routerProvider).push(SAppRoutePath.rewards));
  }

  void navigateToSetorSampah() {
    unawaited(ref.read(routerProvider).push(SAppRoutePath.setorSampah));
  }

  void navigateToChallenges() {
    unawaited(ref.read(routerProvider).push(SAppRoutePath.challenges));
  }

  void registerForEvent(Event event) {
    // TODO(devin): Implement event registration logic
  }
}
