import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:sirsak_pop_nasabah/features/drop_point/drop_point_viewmodel.dart';
import 'package:sirsak_pop_nasabah/features/drop_point/widgets/drop_point_list.dart';
import 'package:sirsak_pop_nasabah/features/drop_point/widgets/drop_point_map.dart';
import 'package:sirsak_pop_nasabah/features/drop_point/widgets/drop_point_search_bar.dart';

class DropPointView extends ConsumerStatefulWidget {
  const DropPointView({super.key});

  @override
  ConsumerState<DropPointView> createState() => _DropPointViewState();
}

class _DropPointViewState extends ConsumerState<DropPointView> {
  bool _isSearchFocused = false;

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
    return Column(
      children: [
        Stack(
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              height: _isSearchFocused ? 100 : 300,
              child: const DropPointMap(),
            ),
            Align(
              alignment: .topCenter,
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 6,
                ),
                child: DropPointSearchBar(
                  value: state.searchQuery,
                  onChanged: viewModel.setSearchQuery,
                  onClear: viewModel.clearSearch,
                  onFocusChanged: (focused) =>
                      setState(() => _isSearchFocused = focused),
                ),
              ),
            ),
          ],
        ),
        const Gap(6),
        // TODO(devin): Implement filter drop point
        // Padding(
        //   padding: const EdgeInsets.symmetric(horizontal: 16),
        //   child: DropPointFilterRow(
        //     activeFilters: state.activeFilters,
        //     onFilterToggle: viewModel.toggleFilter,
        //   ),
        // ),
        // const Gap(16),
        Expanded(
          child: DropPointList(
            dropPoints: state.filteredDropPoints,
            selectedDropPoint: state.selectedDropPoint,
            onSelect: viewModel.selectDropPoint,
            userLocation: state.userLocation,
            scrollToIndex: state.scrollToIndex,
            onScrollComplete: viewModel.clearScrollIndex,
          ),
        ),
      ],
    );
  }
}
