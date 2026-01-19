import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:sirsak_pop_nasabah/features/drop_point/drop_point_viewmodel.dart';
import 'package:sirsak_pop_nasabah/features/drop_point/widgets/drop_point_filter_row.dart';
import 'package:sirsak_pop_nasabah/features/drop_point/widgets/drop_point_list.dart';
import 'package:sirsak_pop_nasabah/features/drop_point/widgets/drop_point_map.dart';
import 'package:sirsak_pop_nasabah/features/drop_point/widgets/drop_point_search_bar.dart';
import 'package:sirsak_pop_nasabah/features/home/widgets/notification_bell.dart';
import 'package:sirsak_pop_nasabah/gen/assets.gen.dart';

class DropPointView extends ConsumerStatefulWidget {
  const DropPointView({super.key});

  @override
  ConsumerState<DropPointView> createState() => _DropPointViewState();
}

class _DropPointViewState extends ConsumerState<DropPointView> {
  @override
  void initState() {
    super.initState();
    // Initialize location when view is first opened
    WidgetsBinding.instance.addPostFrameCallback((_) {
      unawaited(ref.read(dropPointViewModelProvider.notifier).initLocation());
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(dropPointViewModelProvider);
    final viewModel = ref.read(dropPointViewModelProvider.notifier);
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: AppBar(
        backgroundColor: colorScheme.surface,
        elevation: 0,
        centerTitle: false,
        title: Image.asset(
          Assets.images.sirsakLogoWhite.path,
          color: colorScheme.primary,
          fit: BoxFit.contain,
          height: 130,
        ),
        actions: const [
          NotificationBell(),
          Gap(8),
        ],
      ),
      body: Column(
        children: [
          const Gap(16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: DropPointSearchBar(
              value: state.searchQuery,
              onChanged: viewModel.setSearchQuery,
              onClear: viewModel.clearSearch,
            ),
          ),
          const Gap(16),
          SizedBox(
            height: 250,
            child: DropPointMap(
              state: state,
              viewModel: viewModel,
            ),
          ),
          const Gap(16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: DropPointFilterRow(
              activeFilters: state.activeFilters,
              onFilterToggle: viewModel.toggleFilter,
            ),
          ),
          const Gap(16),
          Expanded(
            child: DropPointList(
              dropPoints: state.filteredDropPoints,
              selectedDropPoint: state.selectedDropPoint,
              onSelect: viewModel.selectDropPoint,
              getDistance: viewModel.getDistanceString,
            ),
          ),
        ],
      ),
    );
  }
}
