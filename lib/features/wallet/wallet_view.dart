import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:sirsak_pop_nasabah/features/wallet/wallet_viewmodel.dart';
import 'package:sirsak_pop_nasabah/features/wallet/widgets/history_section.dart';
import 'package:sirsak_pop_nasabah/features/wallet/widgets/wallet_balance_card.dart';

class WalletView extends ConsumerWidget {
  const WalletView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
