import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:sirsak_pop_nasabah/features/home/widgets/section_header.dart';
import 'package:sirsak_pop_nasabah/l10n/extension.dart';
import 'package:sirsak_pop_nasabah/models/user/impact_model.dart';
import 'package:sirsak_pop_nasabah/shared/widgets/impacts_stat_row.dart';

class ImpactSection extends StatelessWidget {
  const ImpactSection({
    required this.impacts,
    super.key,
  });

  final ImpactModel impacts;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colorScheme = Theme.of(context).colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionHeader(
          icon: PhosphorIcons.chartBar(),
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
            child: ImpactsStatRow(
              impact: impacts,
              foregroundColor: colorScheme.primary,
            ),
          ),
        ),
      ],
    );
  }
}
