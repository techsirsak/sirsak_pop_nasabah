import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:sirsak_pop_nasabah/core/theme/app_fonts.dart';
import 'package:sirsak_pop_nasabah/features/drop_point/drop_point_state.dart';
import 'package:sirsak_pop_nasabah/l10n/extension.dart';

class DropPointFilterRow extends StatelessWidget {
  const DropPointFilterRow({
    required this.activeFilters,
    required this.onFilterToggle,
    super.key,
  });

  final Set<DropPointFilterType> activeFilters;
  final ValueChanged<DropPointFilterType> onFilterToggle;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Row(
      children: [
        Icon(
          PhosphorIcons.funnel(),
          color: colorScheme.onSurfaceVariant,
          size: 20,
        ),
        const Gap(4),
        Text(
          context.l10n.dropPointFilter,
          style: textTheme.bodyMedium?.copyWith(
            color: colorScheme.onSurfaceVariant,
          ),
        ),
        const Gap(12),
        Icon(
          PhosphorIcons.arrowsDownUp(),
          color: colorScheme.onSurfaceVariant,
          size: 20,
        ),
        const Gap(4),
        Text(
          context.l10n.dropPointSortBy,
          style: textTheme.bodyMedium?.copyWith(
            color: colorScheme.onSurfaceVariant,
          ),
        ),
        const Spacer(),
        _FilterChip(
          label: context.l10n.dropPointBankSampah,
          isSelected: activeFilters.contains(DropPointFilterType.bankSampah),
          onTap: () => onFilterToggle(DropPointFilterType.bankSampah),
        ),
        const Gap(8),
        _FilterChip(
          label: context.l10n.dropPointRvm,
          isSelected: activeFilters.contains(DropPointFilterType.rvm),
          onTap: () => onFilterToggle(DropPointFilterType.rvm),
        ),
      ],
    );
  }
}

class _FilterChip extends StatelessWidget {
  const _FilterChip({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: isSelected ? colorScheme.primary : colorScheme.surface,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? colorScheme.primary : colorScheme.outline,
          ),
        ),
        child: Text(
          label,
          style: textTheme.labelMedium?.copyWith(
            color: isSelected ? colorScheme.onPrimary : colorScheme.onSurface,
            fontVariations: AppFonts.medium,
          ),
        ),
      ),
    );
  }
}
