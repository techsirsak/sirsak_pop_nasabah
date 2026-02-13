import 'dart:async';

import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:sirsak_pop_nasabah/core/constants/route_path.dart';
import 'package:sirsak_pop_nasabah/core/theme/app_fonts.dart';
import 'package:sirsak_pop_nasabah/l10n/extension.dart';
import 'package:sirsak_pop_nasabah/models/collection_point/collection_point_model.dart';
import 'package:sirsak_pop_nasabah/shared/helpers/date_format_extensions.dart';

class DropPointListItem extends StatelessWidget {
  const DropPointListItem({
    required this.dropPoint,
    required this.distance,
    required this.onTap,
    this.isSelected = false,
    super.key,
  });

  final CollectionPointModel dropPoint;
  final String distance;
  final VoidCallback onTap;
  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return GestureDetector(
      onTap: () {
        onTap();
        unawaited(
          context.push(SAppRoutePath.dropPointDetail, extra: dropPoint),
        );
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: colorScheme.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected
                ? colorScheme.primary
                : colorScheme.outlineVariant,
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
                fontSize: 18,
                color: colorScheme.primary,
              ),
            ),
            // Phone
            if (dropPoint.noHp?.isNotEmpty ?? false) ...[
              const Gap(8),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    PhosphorIcons.phone(),
                    size: 16,
                    color: colorScheme.onSurfaceVariant,
                  ),
                  const Gap(8),
                  Expanded(
                    child: Text(
                      dropPoint.noHp!,
                      style: textTheme.bodyMedium,
                    ),
                  ),
                ],
              ),
            ],
            // Address
            if (dropPoint.alamatLengkap?.isNotEmpty ?? false) ...[
              const Gap(6),
              Row(
                children: [
                  Icon(
                    PhosphorIcons.mapPin(),
                    size: 16,
                  ),
                  const Gap(6),
                  Expanded(
                    child: Text(
                      dropPoint.alamatLengkap!,
                      style: textTheme.bodyMedium,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ],

            // Next schedule
            if (dropPoint.nextScheduledWeighing != null &&
                dropPoint.nextScheduledWeighing!.isAfter(DateTime.now())) ...[
              const Gap(6),
              Row(
                children: [
                  Icon(
                    PhosphorIcons.calendarStar(),
                    size: 16,
                  ),
                  const Gap(6),
                  Text(
                    context.l10n.dropPointNextWeighing(
                      dropPoint.nextScheduledWeighing!.toScheduleRelative,
                    ),
                    style: textTheme.bodyMedium,
                  ),
                ],
              ),
            ],

            // Distance
            if (distance.isNotEmpty) ...[
              const Gap(6),
              Row(
                children: [
                  Icon(
                    PhosphorIcons.personSimpleWalk(),
                    size: 16,
                  ),
                  const Gap(6),
                  Text(
                    context.l10n.dropPointDistance(distance),
                    style: textTheme.bodyMedium,
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
}
