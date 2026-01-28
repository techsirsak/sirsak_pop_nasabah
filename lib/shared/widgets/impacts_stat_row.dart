import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:sirsak_pop_nasabah/core/theme/app_fonts.dart';
import 'package:sirsak_pop_nasabah/l10n/extension.dart';
import 'package:sirsak_pop_nasabah/models/user/impact_model.dart';

class ImpactsStatRow extends StatelessWidget {
  const ImpactsStatRow({
    required this.impact,
    this.foregroundColor,
    super.key,
  });

  final ImpactModel impact;
  final Color? foregroundColor;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return Row(
      children: [
        Expanded(
          child: _StatItem(
            icon: PhosphorIcons.trash(),
            value: '${impact.collected.toInt()} tons',
            label: l10n.profileWasteCollected,
            foregroundColor: foregroundColor,
          ),
        ),
        Expanded(
          child: _StatItem(
            icon: PhosphorIcons.recycle(),
            value: '${impact.recycled.toInt()} tons',
            label: l10n.profileWasteRecycled,
            foregroundColor: foregroundColor,
          ),
        ),
        Expanded(
          child: _StatItem(
            icon: PhosphorIcons.globeHemisphereEast(),
            value: '${impact.carbonFootprintReduced.toInt()} ton CO\u2082eq',
            label: l10n.profileCarbonAvoided,
            foregroundColor: foregroundColor,
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
    this.foregroundColor,
  });
  final IconData icon;
  final String value;
  final String label;
  final Color? foregroundColor;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return Column(
      children: [
        Icon(
          icon,
          color: foregroundColor ?? colorScheme.surface,
          size: 40,
        ),
        const Gap(6),
        Text(
          value,
          style: textTheme.bodyMedium?.copyWith(
            color: foregroundColor ?? colorScheme.surface,
            fontVariations: AppFonts.bold,
          ),
          textAlign: TextAlign.center,
        ),
        const Gap(2),
        Text(
          label,
          style: textTheme.labelMedium?.copyWith(
            color:
                foregroundColor ?? colorScheme.surface.withValues(alpha: 0.8),
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
