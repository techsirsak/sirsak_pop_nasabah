import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:sirsak_pop_nasabah/core/theme/app_colors.dart';
import 'package:sirsak_pop_nasabah/core/theme/app_fonts.dart';
import 'package:sirsak_pop_nasabah/features/wallet/wallet_state.dart';
import 'package:sirsak_pop_nasabah/features/wallet/wallet_viewmodel.dart';
import 'package:sirsak_pop_nasabah/l10n/extension.dart';
import 'package:sirsak_pop_nasabah/shared/helpers/string_extensions.dart';

class WalletBalanceCard extends StatelessWidget {
  const WalletBalanceCard({
    required this.state,
    required this.viewModel,
    super.key,
  });

  final WalletState state;
  final WalletViewModel viewModel;

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
          horizontal: 16,
        ),
        decoration: BoxDecoration(
          gradient: colorScheme.pointsCardGradient,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header: "Saldo Nasabah" + info icon
            Stack(
              alignment: .center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      l10n.walletBalance,
                      style: textTheme.bodyLarge?.copyWith(
                        color: Colors.white,
                        fontVariations: AppFonts.medium,
                      ),
                    ),
                  ],
                ),
                Align(
                  alignment: .topRight,
                  child: IconButton(
                    icon: Icon(
                      PhosphorIcons.question(),
                      color: Colors.white,
                      size: 28,
                    ),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                    onPressed: viewModel.showBalanceInfo,
                  ),
                ),
              ],
            ),
            const Gap(14),
            // Main balance: Points
            // Column(
            //   children: [
            //     Text(
            //       state.sirsalPoints.toString().formatPoints,
            //       style: textTheme.displayLarge?.copyWith(
            //         color: Colors.white,
            //         fontVariations: AppFonts.bold,
            //         height: 1,
            //       ),
            //     ),
            //     Row(
            //       mainAxisAlignment: .center,
            //       children: [
            //         Icon(
            //           PhosphorIcons.wallet(),
            //           color: Colors.white,
            //           size: 16,
            //         ),
            //         const Gap(8),
            //         Text(
            //           l10n.walletSirsakPoints,
            //           style: textTheme.bodySmall?.copyWith(
            //             color: Colors.white.withValues(alpha: 0.9),
            //             fontVariations: AppFonts.regular,
            //           ),
            //         ),
            //       ],
            //     ),
            //   ],
            // ),
            // const Gap(14),
            // Secondary balance: Bank Sampah
            Column(
              children: [
                Text(
                  state.bankSampahBalance.toString().formatRupiah,
                  style: textTheme.titleLarge?.copyWith(
                    color: Colors.white,
                    fontVariations: AppFonts.semiBold,
                  ),
                ),
                Row(
                  mainAxisAlignment: .center,
                  children: [
                    Icon(
                      PhosphorIcons.bank(),
                      color: Colors.white,
                      size: 16,
                    ),
                    const Gap(8),
                    Text(
                      l10n.walletBankSampahBalance,
                      style: textTheme.bodySmall?.copyWith(
                        color: Colors.white.withValues(alpha: 0.8),
                        fontVariations: AppFonts.regular,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const Gap(20),
            // Footer: Expiry date + Monthly stats
            _FooterInfo(state: state),
            const Gap(6),
          ],
        ),
      ),
    );
  }
}

class _FooterInfo extends StatelessWidget {
  const _FooterInfo({
    required this.state,
  });

  final WalletState state;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final l10n = context.l10n;

    return Row(
      crossAxisAlignment: .start,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // Left: Expiry date
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.walletExpiry,
              style: textTheme.bodySmall?.copyWith(
                color: Colors.white.withValues(alpha: 0.7),
                fontVariations: AppFonts.regular,
              ),
            ),
            Text(
              state.expiryDate ?? '-',
              style: textTheme.bodyMedium?.copyWith(
                color: Colors.white,
                fontVariations: AppFonts.semiBold,
              ),
            ),
          ],
        ),
        // Right: Monthly stats
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              l10n.walletMonthly,
              style: textTheme.bodySmall?.copyWith(
                color: Colors.white.withValues(alpha: 0.7),
                fontVariations: AppFonts.regular,
              ),
            ),
            Text(
              '+'
              '${state.monthlyBankSampahEarned.toString().formatRupiah}',
              style: textTheme.bodyMedium?.copyWith(
                color: Colors.white,
                fontVariations: AppFonts.medium,
              ),
            ),
            // Text(
            //   '+${state.monthlyPointsEarned.toString().formatPoints}'
            //   ' points',
            //   style: textTheme.bodySmall?.copyWith(
            //     color: Colors.white.withValues(alpha: 0.8),
            //     fontVariations: AppFonts.regular,
            //   ),
            // ),
          ],
        ),
      ],
    );
  }
}
