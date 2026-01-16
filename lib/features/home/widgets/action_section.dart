import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:sirsak_pop_nasabah/core/theme/app_fonts.dart';
import 'package:sirsak_pop_nasabah/features/home/home_state.dart';
import 'package:sirsak_pop_nasabah/features/home/home_viewmodel.dart';
import 'package:sirsak_pop_nasabah/features/home/widgets/section_header.dart';
import 'package:sirsak_pop_nasabah/l10n/extension.dart';

class ActionSection extends StatelessWidget {
  const ActionSection({
    required this.challenge,
    required this.viewModel,
    super.key,
  });

  final Challenge? challenge;
  final HomeViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionHeader(
          icon: PhosphorIcons.lightning(),
          title: l10n.homeTakeAction,
        ),
        const Gap(16),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            children: [
              SetorSampahCard(onTap: viewModel.navigateToSetorSampah),
              const Gap(12),
              if (challenge != null)
                ChallengeCard(
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

class SetorSampahCard extends StatelessWidget {
  const SetorSampahCard({
    required this.onTap,
    super.key,
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

class ChallengeCard extends StatelessWidget {
  const ChallengeCard({
    required this.challenge,
    required this.onTap,
    super.key,
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
