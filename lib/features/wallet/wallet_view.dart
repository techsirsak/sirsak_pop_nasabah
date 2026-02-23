import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:sirsak_pop_nasabah/features/wallet/wallet_viewmodel.dart';
import 'package:sirsak_pop_nasabah/features/wallet/widgets/history_section.dart';
import 'package:sirsak_pop_nasabah/features/wallet/widgets/wallet_balance_card.dart';
import 'package:sirsak_pop_nasabah/services/auth_state_provider.dart';
import 'package:sirsak_pop_nasabah/shared/widgets/auth_guard_placeholder.dart';
import 'package:sirsak_pop_nasabah/shared/widgets/login_required_bottom_sheet.dart';

class WalletView extends ConsumerStatefulWidget {
  const WalletView({super.key});

  @override
  ConsumerState<WalletView> createState() => _WalletViewState();
}

class _WalletViewState extends ConsumerState<WalletView> {
  bool _hasShownBottomSheet = false;

  @override
  Widget build(BuildContext context) {
    final isAuthenticated = ref.watch(isAuthenticatedProvider);

    // Show login prompt for unauthenticated users
    if (!isAuthenticated) {
      // Show bottom sheet on first build
      if (!_hasShownBottomSheet) {
        _hasShownBottomSheet = true;
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted) {
            unawaited(showLoginRequiredBottomSheet(context, ref));
          }
        });
      }

      return AuthGuardPlaceholder(
        onTap: () => showLoginRequiredBottomSheet(context, ref),
      );
    }

    // Reset flag when authenticated (for logout scenario)
    _hasShownBottomSheet = false;

    final state = ref.watch(walletViewModelProvider);
    final viewModel = ref.read(walletViewModelProvider.notifier);
    final colorScheme = Theme.of(context).colorScheme;

    return RefreshIndicator(
      onRefresh: viewModel.refresh,
      color: colorScheme.primary,
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Gap(16),
            WalletBalanceCard(state: state, viewModel: viewModel),
            const Gap(24),
            // TODO(devin): implement rewards
            // RewardsSection(viewModel: viewModel),
            // const Gap(24),
            HistorySection(state: state, viewModel: viewModel),
            const Gap(24),
          ],
        ),
      ),
    );
  }
}
