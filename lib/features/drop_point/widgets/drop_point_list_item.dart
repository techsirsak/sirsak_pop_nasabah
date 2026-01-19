import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:sirsak_pop_nasabah/core/theme/app_fonts.dart';
import 'package:sirsak_pop_nasabah/l10n/extension.dart';
import 'package:sirsak_pop_nasabah/models/drop_point_model.dart';

class DropPointListItem extends StatelessWidget {
  const DropPointListItem({
    required this.dropPoint,
    required this.distance,
    required this.onTap,
    this.isSelected = false,
    super.key,
  });

  final DropPointModel dropPoint;
  final String distance;
  final VoidCallback onTap;
  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: colorScheme.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color:
                isSelected ? colorScheme.primary : colorScheme.outlineVariant,
            width: isSelected ? 2 : 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: .05),
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Name
            Text(
              dropPoint.name,
              style: textTheme.titleMedium?.copyWith(
                fontVariations: AppFonts.bold,
                color: colorScheme.primary,
              ),
            ),
            const Gap(8),
            // Address
            Row(
              children: [
                Icon(
                  PhosphorIcons.mapPin(),
                  size: 16,
                  color: colorScheme.onSurfaceVariant,
                ),
                const Gap(6),
                Expanded(
                  child: Text(
                    dropPoint.address,
                    style: textTheme.bodyMedium?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            const Gap(6),
            // Distance
            Row(
              children: [
                Icon(
                  PhosphorIcons.personSimpleWalk(),
                  size: 16,
                  color: colorScheme.onSurfaceVariant,
                ),
                const Gap(6),
                Text(
                  context.l10n.dropPointDistance(distance),
                  style: textTheme.bodyMedium?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
            const Gap(6),
            // Rating
            Row(
              children: [
                ...List.generate(5, (index) {
                  final filled = index < dropPoint.rating.floor();
                  final halfFilled = index == dropPoint.rating.floor() &&
                      dropPoint.rating % 1 >= 0.5;
                  return Icon(
                    filled || halfFilled
                        ? PhosphorIcons.star(PhosphorIconsStyle.fill)
                        : PhosphorIcons.star(),
                    size: 16,
                    color: colorScheme.secondary,
                  );
                }),
                const Gap(6),
                Text(
                  '(${dropPoint.rating})',
                  style: textTheme.bodyMedium?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
            const Gap(6),
            // Open hours
            Row(
              children: [
                Icon(
                  PhosphorIcons.clock(),
                  size: 16,
                  color: colorScheme.tertiary,
                ),
                const Gap(6),
                Text(
                  context.l10n.dropPointOpenUntil(dropPoint.closingTime),
                  style: textTheme.bodyMedium?.copyWith(
                    color: colorScheme.tertiary,
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
