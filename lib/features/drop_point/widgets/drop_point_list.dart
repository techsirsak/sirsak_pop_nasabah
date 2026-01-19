import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:sirsak_pop_nasabah/features/drop_point/widgets/drop_point_list_item.dart';
import 'package:sirsak_pop_nasabah/l10n/extension.dart';
import 'package:sirsak_pop_nasabah/models/drop_point_model.dart';

class DropPointList extends StatelessWidget {
  const DropPointList({
    required this.dropPoints,
    required this.onSelect,
    required this.getDistance,
    this.selectedDropPoint,
    super.key,
  });

  final List<DropPointModel> dropPoints;
  final DropPointModel? selectedDropPoint;
  final ValueChanged<DropPointModel> onSelect;
  final String Function(DropPointModel) getDistance;

  @override
  Widget build(BuildContext context) {
    if (dropPoints.isEmpty) {
      return _EmptyState();
    }

    return ListView.builder(
      padding: const EdgeInsets.only(bottom: 16),
      itemCount: dropPoints.length,
      itemBuilder: (context, index) {
        final dropPoint = dropPoints[index];
        return DropPointListItem(
          dropPoint: dropPoint,
          distance: getDistance(dropPoint),
          isSelected: selectedDropPoint?.id == dropPoint.id,
          onTap: () => onSelect(dropPoint),
        );
      },
    );
  }
}

class _EmptyState extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            PhosphorIcons.mapPinLine(),
            size: 64,
            color: colorScheme.onSurfaceVariant,
          ),
          const Gap(16),
          Text(
            context.l10n.dropPointNoResults,
            style: textTheme.titleMedium?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
          ),
          const Gap(8),
          Text(
            context.l10n.dropPointNoResultsHint,
            style: textTheme.bodyMedium?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}
