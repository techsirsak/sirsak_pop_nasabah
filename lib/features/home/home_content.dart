import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:sirsak_pop_nasabah/features/home/home_viewmodel.dart';
import 'package:sirsak_pop_nasabah/features/home/widgets/action_section.dart';
import 'package:sirsak_pop_nasabah/features/home/widgets/impact_section.dart';
import 'package:sirsak_pop_nasabah/features/home/widgets/points_card.dart';
import 'package:sirsak_pop_nasabah/services/auth_state_provider.dart';
import 'package:sirsak_pop_nasabah/shared/widgets/guest_card.dart';

class HomeContent extends ConsumerWidget {
  const HomeContent({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isAuthenticated = ref.watch(isAuthenticatedProvider);
    final state = ref.watch(homeViewModelProvider);
    final viewModel = ref.read(homeViewModelProvider.notifier);

    return SingleChildScrollView(
      child: Column(
        children: [
          const Gap(16),
          if (isAuthenticated)
            PointsCard(state: state, viewModel: viewModel)
          else
            const GuestCard(),
          const Gap(34),
          if (isAuthenticated) ...[
            ImpactSection(impacts: state.impacts),
            const Gap(34),
          ],
          ActionSection(challenge: state.challenge, viewModel: viewModel),
          const Gap(34),
          // TODO(devin): implement Event
          // EventsSection(events: state.events, viewModel: viewModel),
          // const Gap(34),
        ],
      ),
    );
  }
}
