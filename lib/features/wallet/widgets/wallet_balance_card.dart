import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:sirsak_pop_nasabah/core/theme/app_colors.dart';
import 'package:sirsak_pop_nasabah/core/theme/app_fonts.dart';
import 'package:sirsak_pop_nasabah/features/wallet/wallet_state.dart';
import 'package:sirsak_pop_nasabah/features/wallet/wallet_viewmodel.dart';
import 'package:sirsak_pop_nasabah/l10n/extension.dart';

class WalletBalanceCard extends StatelessWidget {
  const WalletBalanceCard({
    required this.state,
    required this.viewModel,
    super.key,
  });

  final WalletState state;
  final WalletViewModel viewModel;

  String _formatNumber(int number) {
    return number.toString().replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (Match m) => '${m[1]},',
    );
  }

  String _formatCurrency(double amount) {
    return 'Rp ${amount.toInt().toString().replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (Match m) => '${m[1]},',
    )}';
  }

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
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header: "Saldo Nasabah" + info icon
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  l10n.walletBalance,
                  style: textTheme.bodyMedium?.copyWith(
                    color: Colors.white,
                    fontVariations: AppFonts.medium,
                  ),
                ),
                IconButton(
                  icon: Icon(
                    PhosphorIcons.question(),
                    color: Colors.white,
                    size: 24,
                  ),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                  onPressed: viewModel.showBalanceInfo,
                ),
              ],
            ),
            const Gap(16),
            // Main balance: Points
            Row(
              children: [
                Icon(
                  PhosphorIcons.wallet(),
                  color: Colors.white,
                  size: 24,
                ),
                const Gap(8),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _formatNumber(state.sirsalPoints),
                      style: textTheme.displayLarge?.copyWith(
                        color: Colors.white,
                        fontVariations: AppFonts.bold,
                        height: 1,
                      ),
                    ),
                    Text(
                      l10n.walletSirsakPoints,
                      style: textTheme.bodySmall?.copyWith(
                        color: Colors.white.withValues(alpha: 0.9),
                        fontVariations: AppFonts.regular,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const Gap(12),
            // Secondary balance: Bank Sampah
            Row(
              children: [
                Icon(
                  PhosphorIcons.bank(),
                  color: Colors.white,
                  size: 24,
                ),
                const Gap(8),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _formatCurrency(state.bankSampahBalance),
                      style: textTheme.titleLarge?.copyWith(
                        color: Colors.white,
                        fontVariations: AppFonts.semiBold,
                      ),
                    ),
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
            Row(
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
                      '+${_formatCurrency(state.monthlyBankSampahEarned)}',
                      style: textTheme.bodyMedium?.copyWith(
                        color: Colors.white,
                        fontVariations: AppFonts.medium,
                      ),
                    ),
                    Text(
                      '+${_formatNumber(state.monthlyPointsEarned)} points',
                      style: textTheme.bodySmall?.copyWith(
                        color: Colors.white.withValues(alpha: 0.8),
                        fontVariations: AppFonts.regular,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
