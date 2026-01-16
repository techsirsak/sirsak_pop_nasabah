import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:sirsak_pop_nasabah/core/theme/app_fonts.dart';
import 'package:sirsak_pop_nasabah/features/home/home_state.dart';
import 'package:sirsak_pop_nasabah/features/home/widgets/section_header.dart';
import 'package:sirsak_pop_nasabah/l10n/extension.dart';

class ImpactSection extends StatelessWidget {
  const ImpactSection({
    required this.metrics,
    super.key,
  });

  final List<ImpactMetric> metrics;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionHeader(
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
                      child: ImpactMetricWidget(metric: metric),
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

class ImpactMetricWidget extends StatelessWidget {
  const ImpactMetricWidget({
    required this.metric,
    super.key,
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
