import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:sirsak_pop_nasabah/core/theme/app_colors.dart';
import 'package:sirsak_pop_nasabah/core/theme/app_fonts.dart';
import 'package:sirsak_pop_nasabah/features/home/home_state.dart';
import 'package:sirsak_pop_nasabah/features/home/home_viewmodel.dart';
import 'package:sirsak_pop_nasabah/gen/assets.gen.dart';
import 'package:sirsak_pop_nasabah/l10n/extension.dart';
import 'package:sirsak_pop_nasabah/shared/navigation/bottom_nav_widget.dart';
import 'package:sirsak_pop_nasabah/shared/widgets/buttons.dart';

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
        title: Image.asset(
          Assets.images.sirsakLogoWhite.path,
          color: colorScheme.primary,
          height: 32,
        ),
        actions: [
          _NotificationBell(),
          const Gap(8),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const Gap(16),
            _PointsCard(state: state, viewModel: viewModel),
            const Gap(24),
            _ImpactSection(metrics: state.impactMetrics),
            const Gap(24),
            _ActionSection(challenge: state.challenge, viewModel: viewModel),
            const Gap(24),
            _EventsSection(events: state.events, viewModel: viewModel),
            const Gap(24),
          ],
        ),
      ),
      bottomNavigationBar: const AppBottomNavBar(),
    );
  }
}

// ============================================================================
// Notification Bell
// ============================================================================

class _NotificationBell extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Stack(
      children: [
        IconButton(
          icon: Icon(PhosphorIcons.bell()),
          onPressed: () {
            // Placeholder - no action for now
          },
        ),
        Positioned(
          right: 8,
          top: 8,
          child: Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: colorScheme.secondary,
              shape: BoxShape.circle,
            ),
            constraints: const BoxConstraints(
              minWidth: 16,
              minHeight: 16,
            ),
            child: const Text(
              '3',
              style: TextStyle(
                color: Colors.white,
                fontSize: 10,
                fontVariations: AppFonts.bold,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ],
    );
  }
}

// ============================================================================
// Points Card
// ============================================================================

class _PointsCard extends StatelessWidget {
  const _PointsCard({
    required this.state,
    required this.viewModel,
  });

  final HomeState state;
  final HomeViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final l10n = context.l10n;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          gradient: colorScheme.pointsCardGradient,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Welcome text and wallet icon
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    l10n.homeGreeting(state.userName),
                    style: textTheme.bodyMedium?.copyWith(
                      color: Colors.white,
                      fontVariations: AppFonts.regular,
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(
                    PhosphorIcons.wallet(),
                    color: Colors.white,
                  ),
                  onPressed: () {
                    // TODO(devin): Navigate to wallet
                  },
                ),
              ],
            ),
            const Gap(16),
            // Points display
            Row(
              crossAxisAlignment: CrossAxisAlignment.baseline,
              textBaseline: TextBaseline.alphabetic,
              children: [
                Text(
                  state.points.toString().replaceAllMapped(
                    RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
                    (Match m) => '${m[1]},',
                  ),
                  style: textTheme.displayLarge?.copyWith(
                    color: Colors.white,
                    fontVariations: AppFonts.bold,
                    height: 1,
                  ),
                ),
                const Gap(8),
                Text(
                  l10n.homePoints,
                  style: textTheme.titleMedium?.copyWith(
                    color: Colors.white.withValues(alpha: 0.9),
                    fontVariations: AppFonts.regular,
                  ),
                ),
              ],
            ),
            const Gap(20),
            // Action buttons
            Row(
              children: [
                Expanded(
                  child: SButton(
                    text: l10n.homeHistory,
                    onPressed: viewModel.navigateToHistory,
                    variant: ButtonVariant.outlined,
                    size: ButtonSize.small,
                    icon: PhosphorIcons.clockCounterClockwise(),
                  ),
                ),
                const Gap(8),
                Expanded(
                  child: SButton(
                    text: l10n.homeWithdraw,
                    onPressed: viewModel.navigateToWithdraw,
                    variant: ButtonVariant.outlined,
                    size: ButtonSize.small,
                    icon: PhosphorIcons.wallet(),
                  ),
                ),
                const Gap(8),
                Expanded(
                  child: SButton(
                    text: l10n.homeRewards,
                    onPressed: viewModel.navigateToRewards,
                    size: ButtonSize.small,
                    icon: PhosphorIcons.gift(),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// ============================================================================
// Impact Section
// ============================================================================

class _ImpactSection extends StatelessWidget {
  const _ImpactSection({
    required this.metrics,
  });

  final List<ImpactMetric> metrics;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _SectionHeader(
          icon: PhosphorIcons.chartLineUp(),
          title: l10n.homeYourImpact,
        ),
        const Gap(16),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              children: metrics
                  .map(
                    (metric) => Expanded(
                      child: _ImpactMetric(metric: metric),
                    ),
                  )
                  .toList(),
            ),
          ),
        ),
      ],
    );
  }
}

class _ImpactMetric extends StatelessWidget {
  const _ImpactMetric({
    required this.metric,
  });

  final ImpactMetric metric;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Column(
      children: [
        Icon(
          metric.icon,
          color: colorScheme.primary,
          size: 32,
        ),
        const Gap(8),
        Text(
          metric.value,
          style: textTheme.titleMedium?.copyWith(
            fontVariations: AppFonts.bold,
            color: colorScheme.onSurface,
          ),
          textAlign: TextAlign.center,
        ),
        const Gap(4),
        Text(
          metric.label,
          style: textTheme.bodySmall?.copyWith(
            fontVariations: AppFonts.regular,
            color: colorScheme.onSurfaceVariant,
          ),
          textAlign: TextAlign.center,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }
}

// ============================================================================
// Action Section
// ============================================================================

class _ActionSection extends StatelessWidget {
  const _ActionSection({
    required this.challenge,
    required this.viewModel,
  });

  final Challenge? challenge;
  final HomeViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _SectionHeader(
          icon: PhosphorIcons.lightning(),
          title: l10n.homeTakeAction,
        ),
        const Gap(16),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            children: [
              _SetorSampahCard(onTap: viewModel.navigateToSetorSampah),
              const Gap(12),
              if (challenge != null)
                _ChallengeCard(
                  challenge: challenge!,
                  onTap: viewModel.navigateToChallenges,
                ),
            ],
          ),
        ),
      ],
    );
  }
}

class _SetorSampahCard extends StatelessWidget {
  const _SetorSampahCard({
    required this.onTap,
  });

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final l10n = context.l10n;

    return Material(
      color: colorScheme.tertiary,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.2),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  PhosphorIcons.mapPin(),
                  color: Colors.white,
                  size: 32,
                ),
              ),
              const Gap(16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l10n.homeSetorSampah,
                      style: textTheme.titleMedium?.copyWith(
                        color: Colors.white,
                        fontVariations: AppFonts.semiBold,
                      ),
                    ),
                    const Gap(4),
                    Text(
                      l10n.homeSetorSampahDesc,
                      style: textTheme.bodyMedium?.copyWith(
                        color: Colors.white.withValues(alpha: 0.9),
                        fontVariations: AppFonts.regular,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ChallengeCard extends StatelessWidget {
  const _ChallengeCard({
    required this.challenge,
    required this.onTap,
  });

  final Challenge challenge;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final l10n = context.l10n;

    return Material(
      color: colorScheme.primaryContainer,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l10n.homeChallenges,
                      style: textTheme.titleMedium?.copyWith(
                        color: Colors.white,
                        fontVariations: AppFonts.semiBold,
                      ),
                    ),
                    const Gap(4),
                    Text(
                      l10n.homeChallengesDesc,
                      style: textTheme.bodyMedium?.copyWith(
                        color: Colors.white.withValues(alpha: 0.9),
                        fontVariations: AppFonts.regular,
                      ),
                    ),
                    const Gap(12),
                    Text(
                      l10n.homeChallengeProgress(
                        challenge.current,
                        challenge.total,
                        challenge.itemType,
                      ),
                      style: textTheme.bodySmall?.copyWith(
                        color: Colors.white.withValues(alpha: 0.8),
                        fontVariations: AppFonts.medium,
                      ),
                    ),
                  ],
                ),
              ),
              const Gap(16),
              Column(
                children: [
                  Icon(
                    PhosphorIcons.seal(),
                    color: colorScheme.secondary,
                    size: 48,
                  ),
                  const Gap(4),
                  Text(
                    challenge.title,
                    style: textTheme.labelSmall?.copyWith(
                      color: Colors.white,
                      fontVariations: AppFonts.medium,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ============================================================================
// Events Section
// ============================================================================

class _EventsSection extends StatelessWidget {
  const _EventsSection({
    required this.events,
    required this.viewModel,
  });

  final List<Event> events;
  final HomeViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _SectionHeader(
          icon: PhosphorIcons.calendar(),
          title: l10n.homeEvents,
        ),
        const Gap(16),
        SizedBox(
          height: 280,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: events.length,
            separatorBuilder: (context, index) => const Gap(12),
            itemBuilder: (context, index) {
              return _EventCard(
                event: events[index],
                onRegister: () => viewModel.registerForEvent(events[index]),
              );
            },
          ),
        ),
      ],
    );
  }
}

class _EventCard extends StatelessWidget {
  const _EventCard({
    required this.event,
    required this.onRegister,
  });

  final Event event;
  final VoidCallback onRegister;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final l10n = context.l10n;

    return Container(
      width: 250,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Event image placeholder
          Container(
            height: 120,
            decoration: BoxDecoration(
              color: colorScheme.secondaryContainer,
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(12),
              ),
            ),
            child: Stack(
              children: [
                Center(
                  child: Icon(
                    PhosphorIcons.image(),
                    size: 48,
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
                Positioned(
                  top: 12,
                  left: 12,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      event.date,
                      style: textTheme.labelSmall?.copyWith(
                        fontVariations: AppFonts.medium,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Event details
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    event.title,
                    style: textTheme.titleSmall?.copyWith(
                      fontVariations: AppFonts.semiBold,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const Gap(8),
                  Expanded(
                    child: Text(
                      event.description,
                      style: textTheme.bodySmall?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                        fontVariations: AppFonts.regular,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const Gap(12),
                  SButton(
                    text: l10n.homeRegisterNow,
                    onPressed: onRegister,
                    size: ButtonSize.small,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ============================================================================
// Section Header
// ============================================================================

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({
    required this.icon,
    required this.title,
  });

  final IconData icon;
  final String title;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          Icon(
            icon,
            color: colorScheme.primary,
            size: 24,
          ),
          const Gap(8),
          Text(
            title,
            style: textTheme.titleLarge?.copyWith(
              fontVariations: AppFonts.semiBold,
            ),
          ),
        ],
      ),
    );
  }
}
