import 'dart:async';

import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:sirsak_pop_nasabah/features/drop_point/widgets/drop_point_list_item.dart';
import 'package:sirsak_pop_nasabah/l10n/extension.dart';
import 'package:sirsak_pop_nasabah/models/collection_point/collection_point_model.dart';

class DropPointList extends StatefulWidget {
  const DropPointList({
    required this.dropPoints,
    required this.onSelect,
    required this.getDistance,
    this.selectedDropPoint,
    this.scrollToIndex,
    this.onScrollComplete,
    super.key,
  });

  final List<CollectionPointModel> dropPoints;
  final CollectionPointModel? selectedDropPoint;
  final ValueChanged<CollectionPointModel> onSelect;
  final String Function(CollectionPointModel) getDistance;
  final int? scrollToIndex;
  final VoidCallback? onScrollComplete;

  @override
  State<DropPointList> createState() => _DropPointListState();
}

class _DropPointListState extends State<DropPointList> {
  final ScrollController _scrollController = ScrollController();

  // Estimated item height (padding + content + margin)
  // Container: padding 32, margin vertical 16, content ~78 = ~126
  static const double _estimatedItemHeight = 126;

  @override
  void didUpdateWidget(DropPointList oldWidget) {
    super.didUpdateWidget(oldWidget);

    // Scroll to index when it changes and is not null
    if (widget.scrollToIndex != null &&
        widget.scrollToIndex != oldWidget.scrollToIndex) {
      _scrollToIndex(widget.scrollToIndex!);
    }
  }

  void _scrollToIndex(int index) {
    if (!_scrollController.hasClients) return;

    final targetOffset = index * _estimatedItemHeight;
    final maxScroll = _scrollController.position.maxScrollExtent;
    final clampedOffset = targetOffset.clamp(0.0, maxScroll);

    unawaited(
      _scrollController
          .animateTo(
            clampedOffset,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
          )
          .then((_) => widget.onScrollComplete?.call()),
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.dropPoints.isEmpty) {
      return _EmptyState();
    }

    return ListView.builder(
      controller: _scrollController,
      padding: const EdgeInsets.only(bottom: 16),
      itemCount: widget.dropPoints.length,
      itemBuilder: (context, index) {
        final dropPoint = widget.dropPoints[index];
        return DropPointListItem(
          dropPoint: dropPoint,
          distance: widget.getDistance(dropPoint),
          isSelected: widget.selectedDropPoint?.id == dropPoint.id,
          onTap: () => widget.onSelect(dropPoint),
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
