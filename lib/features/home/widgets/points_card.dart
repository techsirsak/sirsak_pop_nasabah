import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:sirsak_pop_nasabah/core/theme/app_colors.dart';
import 'package:sirsak_pop_nasabah/core/theme/app_fonts.dart';
import 'package:sirsak_pop_nasabah/features/home/home_state.dart';
import 'package:sirsak_pop_nasabah/features/home/home_viewmodel.dart';
import 'package:sirsak_pop_nasabah/l10n/extension.dart';
import 'package:sirsak_pop_nasabah/shared/helpers/string_extensions.dart';
import 'package:sirsak_pop_nasabah/shared/widgets/buttons.dart';

class PointsCard extends StatelessWidget {
  const PointsCard({
    required this.state,
    required this.viewModel,
    super.key,
  });

  final HomeState state;
  final HomeViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final l10n = context.l10n;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(
          vertical: 12,
          horizontal: 20,
        ),
        decoration: BoxDecoration(
          gradient: colorScheme.pointsCardGradient,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          mainAxisSize: .min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Welcome text and wallet icon
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    l10n.homeGreeting(state.userName.firstWord.capitalize),
                    style: textTheme.bodyLarge?.copyWith(
                      color: Colors.white,
                      fontVariations: AppFonts.regular,
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(
                    PhosphorIcons.wallet(),
                    color: Colors.white,
                    size: 32,
                  ),
                  onPressed: () {
                    // TODO(devin): Navigate to wallet
                  },
                ),
              ],
            ),
            const Gap(12),
            // const _PointDisplay(),
            // const Gap(20),
            const _SaldoDisplay(),
            const Gap(12),
            // Action buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Flexible(
                  flex: 5,
                  child: SButton(
                    text: l10n.homeHistory,
                    onPressed: viewModel.navigateToWalletTab,
                    variant: ButtonVariant.text,
                    size: ButtonSize.small,
                    icon: PhosphorIcons.clipboardText(),
                    foregroundColor: Colors.white,
                  ),
                ),
                // TODO(devin): implement withdraw
                // Flexible(
                //   flex: 4,
                //   child: SButton(
                //     text: l10n.homeWithdraw,
                //     onPressed: viewModel.navigateToWithdraw,
                //     variant: ButtonVariant.text,
                //     size: ButtonSize.small,
                //     icon: PhosphorIcons.handWithdraw(),
                //     foregroundColor: Colors.white,
                //   ),
                // ),
                // TODO(devin): implement rewards
                // Flexible(
                //   flex: 5,
                //   child: SButton(
                //     text: l10n.homeRewards,
                //     onPressed: viewModel.navigateToRewards,
                //     size: ButtonSize.small,
                //     icon: PhosphorIcons.gift(),
                //     foregroundColor: colorScheme.primary,
                //     backgroundColor: colorScheme.surface,
                //     borderRadius: 25,
                //   ),
                // ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _PointDisplay extends ConsumerWidget {
  const _PointDisplay();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(homeViewModelProvider);
    final textTheme = Theme.of(context).textTheme;
    final l10n = context.l10n;
    return Row(
      textBaseline: TextBaseline.alphabetic,
      children: [
        Flexible(
          child: Text(
            state.points.toString().formatPoints,
            style: textTheme.displayLarge?.copyWith(
              color: Colors.white,
              fontVariations: AppFonts.bold,
              height: 1,
            ),
          ),
        ),
        const Gap(8),
        Text(
          l10n.homePoints,
          style: textTheme.titleMedium?.copyWith(
            color: Colors.white.withValues(alpha: 0.9),
            fontVariations: AppFonts.regular,
          ),
        ),
      ],
    );
  }
}

class _SaldoDisplay extends ConsumerWidget {
  const _SaldoDisplay();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(homeViewModelProvider);
    final textTheme = Theme.of(context).textTheme;
    final l10n = context.l10n;

    return Column(
      mainAxisSize: .min,
      crossAxisAlignment: .start,
      textBaseline: TextBaseline.alphabetic,
      children: [
        Text(
          l10n.walletBankSampahBalance,
          style: textTheme.titleMedium?.copyWith(
            color: Colors.white.withValues(alpha: 0.9),
            fontVariations: AppFonts.regular,
          ),
        ),
        const Gap(8),
        Flexible(
          child: FittedBox(
            child: Text(
              state.balance.toString().formatRupiah,
              style: textTheme.displayLarge?.copyWith(
                color: Colors.white,
                fontVariations: AppFonts.bold,
                height: 1,
              ),
              textAlign: .center,
            ),
          ),
        ),
      ],
    );
  }
}
