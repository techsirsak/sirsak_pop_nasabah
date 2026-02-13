import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:sirsak_pop_nasabah/core/theme/app_fonts.dart';
import 'package:sirsak_pop_nasabah/features/home/home_state.dart';
import 'package:sirsak_pop_nasabah/features/home/home_viewmodel.dart';
import 'package:sirsak_pop_nasabah/features/home/widgets/section_header.dart';
import 'package:sirsak_pop_nasabah/gen/assets.gen.dart';
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
          icon: PhosphorIcons.fire(),
          title: l10n.homeTakeAction,
        ),
        const Gap(16),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            children: [
              _SetorSampahCard(onTap: viewModel.navigateToDropPointTab),

              // TODO(devin): implement challenge
              // const Gap(12),
              // if (challenge != null)
              //   _ChallengeCard(
              //     challenge: challenge!,
              //     onTap: viewModel.navigateToChallenges,
              //   ),
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

    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: Material(
        color: colorScheme.primaryContainer,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(
                  Assets.images.mlp.path,
                ),
                fit: .cover,
                opacity: .7,
              ),
            ),
            child: Row(
              children: [
                Icon(
                  PhosphorIcons.mapPin(),
                  color: colorScheme.surface,
                  size: 70,
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
                        ),
                      ),
                      Text(
                        l10n.homeSetorSampahDesc,
                        style: textTheme.bodyMedium?.copyWith(
                          color: Colors.white.withValues(alpha: 0.9),
                          fontVariations: AppFonts.semiBold,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ignore: unused_element
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

    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: Material(
        color: colorScheme.primaryContainer,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(
                  Assets.images.setorSampah.path,
                ),
                fit: .cover,
                opacity: .4,
              ),
            ),
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
                        ),
                      ),
                      Text(
                        l10n.homeChallengesDesc,
                        style: textTheme.bodyMedium?.copyWith(
                          color: Colors.white.withValues(alpha: 0.9),
                          fontVariations: AppFonts.semiBold,
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
                      PhosphorIcons.medal(),
                      color: colorScheme.surface,
                      size: 70,
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
      ),
    );
  }
}
