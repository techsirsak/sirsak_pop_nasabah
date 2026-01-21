import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:sirsak_pop_nasabah/core/theme/app_fonts.dart';
import 'package:sirsak_pop_nasabah/features/profile/profile_state.dart';
import 'package:sirsak_pop_nasabah/l10n/extension.dart';

class ProfileStatsRow extends StatelessWidget {
  const ProfileStatsRow({
    required this.stats,
    super.key,
  });

  final ProfileStats stats;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return Row(
      children: [
        Expanded(
          child: _StatItem(
            icon: PhosphorIcons.trash(),
            value: '${stats.wasteCollected.toInt()} tons',
            label: l10n.profileWasteCollected,
          ),
        ),
        Expanded(
          child: _StatItem(
            icon: PhosphorIcons.recycle(),
            value: '${stats.wasteRecycled.toInt()} tons',
            label: l10n.profileWasteRecycled,
          ),
        ),
        Expanded(
          child: _StatItem(
            icon: PhosphorIcons.leaf(),
            value: '${stats.carbonAvoided.toInt()} ton CO\u2082eq',
            label: l10n.profileCarbonAvoided,
          ),
        ),
      ],
    );
  }
}

class _StatItem extends StatelessWidget {
  const _StatItem({
    required this.icon,
    required this.value,
    required this.label,
  });

  final IconData icon;
  final String value;
  final String label;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Column(
      children: [
        Icon(
          icon,
          color: Colors.white,
          size: 24,
        ),
        const Gap(6),
        Text(
          value,
          style: textTheme.bodyMedium?.copyWith(
            color: Colors.white,
            fontVariations: AppFonts.bold,
          ),
          textAlign: TextAlign.center,
        ),
        const Gap(2),
        Text(
          label,
          style: textTheme.labelSmall?.copyWith(
            color: Colors.white.withValues(alpha: 0.8),
            fontVariations: AppFonts.regular,
            height: 1.2,
          ),
          textAlign: TextAlign.center,
          maxLines: 2,
        ),
      ],
    );
  }
}
