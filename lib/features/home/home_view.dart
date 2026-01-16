import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:sirsak_pop_nasabah/features/home/home_viewmodel.dart';
import 'package:sirsak_pop_nasabah/features/home/widgets/action_section.dart';
import 'package:sirsak_pop_nasabah/features/home/widgets/events_section.dart';
import 'package:sirsak_pop_nasabah/features/home/widgets/impact_section.dart';
import 'package:sirsak_pop_nasabah/features/home/widgets/notification_bell.dart';
import 'package:sirsak_pop_nasabah/features/home/widgets/points_card.dart';
import 'package:sirsak_pop_nasabah/gen/assets.gen.dart';
import 'package:sirsak_pop_nasabah/shared/navigation/bottom_nav_widget.dart';

class HomeView extends ConsumerWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(homeViewModelProvider);
    final viewModel = ref.read(homeViewModelProvider.notifier);
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: AppBar(
        backgroundColor: colorScheme.surface,
        elevation: 0,
        centerTitle: false,
        title: Image.asset(
          Assets.images.sirsakLogoWhite.path,
          color: colorScheme.primary,
          fit: .contain,
          height: 130,
        ),
        actions: const [
          NotificationBell(),
          Gap(8),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const Gap(16),
            PointsCard(state: state, viewModel: viewModel),
            const Gap(34),
            ImpactSection(metrics: state.impactMetrics),
            const Gap(34),
            ActionSection(challenge: state.challenge, viewModel: viewModel),
            const Gap(34),
            EventsSection(events: state.events, viewModel: viewModel),
            const Gap(34),
          ],
        ),
      ),
      bottomNavigationBar: const AppBottomNavBar(),
    );
  }
}
