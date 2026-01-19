import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:sirsak_pop_nasabah/core/theme/app_fonts.dart';
import 'package:sirsak_pop_nasabah/features/home/widgets/notification_bell.dart';
import 'package:sirsak_pop_nasabah/features/wallet/wallet_viewmodel.dart';
import 'package:sirsak_pop_nasabah/features/wallet/widgets/history_section.dart';
import 'package:sirsak_pop_nasabah/features/wallet/widgets/rewards_section.dart';
import 'package:sirsak_pop_nasabah/features/wallet/widgets/wallet_balance_card.dart';
import 'package:sirsak_pop_nasabah/l10n/extension.dart';

class WalletView extends ConsumerWidget {
  const WalletView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(walletViewModelProvider);
    final viewModel = ref.read(walletViewModelProvider.notifier);
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final l10n = context.l10n;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: AppBar(
        backgroundColor: colorScheme.surface,
        elevation: 0,
        centerTitle: false,
        title: Text(
          l10n.walletTitle,
          style: textTheme.titleLarge?.copyWith(
            fontVariations: AppFonts.bold,
          ),
        ),
        actions: const [
          NotificationBell(),
          Gap(8),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Gap(16),
            WalletBalanceCard(state: state, viewModel: viewModel),
            const Gap(24),
            RewardsSection(viewModel: viewModel),
            const Gap(24),
            HistorySection(state: state, viewModel: viewModel),
            const Gap(24),
          ],
        ),
      ),
    );
  }
}
