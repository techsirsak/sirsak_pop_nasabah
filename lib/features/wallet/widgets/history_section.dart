import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:intl/intl.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:sirsak_pop_nasabah/core/theme/app_fonts.dart';
import 'package:sirsak_pop_nasabah/features/home/widgets/section_header.dart';
import 'package:sirsak_pop_nasabah/features/wallet/wallet_state.dart';
import 'package:sirsak_pop_nasabah/features/wallet/wallet_viewmodel.dart';
import 'package:sirsak_pop_nasabah/l10n/extension.dart';

class HistorySection extends StatelessWidget {
  const HistorySection({
    required this.state,
    required this.viewModel,
    super.key,
  });

  final WalletState state;
  final WalletViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    final isPointsTab = state.selectedHistoryTab == HistoryTabType.sirsalPoints;
    final currentHistory = isPointsTab
        ? state.pointsHistory
        : state.bankSampahHistory;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionHeader(
          icon: PhosphorIcons.listBullets(),
          title: l10n.walletHistory,
        ),
        const Gap(16),
        // Tab chips
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            children: [
              _TabChip(
                label: l10n.walletSirsakPoints,
                isSelected: isPointsTab,
                onTap: () => viewModel.selectHistoryTab(
                  HistoryTabType.sirsalPoints,
                ),
              ),
              const Gap(8),
              _TabChip(
                label: l10n.walletBankSampahBalance,
                isSelected: !isPointsTab,
                onTap: () => viewModel.selectHistoryTab(
                  HistoryTabType.bankSampah,
                ),
              ),
            ],
          ),
        ),
        const Gap(16),
        // Transaction list
        if (currentHistory.isEmpty)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: _EmptyHistoryCard(),
          )
        else
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              children: currentHistory.map((transaction) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: _HistoryListItem(
                    transaction: transaction,
                    isPoints: isPointsTab,
                  ),
                );
              }).toList(),
            ),
          ),
      ],
    );
  }
}

class _TabChip extends StatelessWidget {
  const _TabChip({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? colorScheme.primaryContainer : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
          border: isSelected ? null : Border.all(color: colorScheme.outline),
        ),
        child: Text(
          label,
          style: textTheme.bodyMedium?.copyWith(
            color: isSelected ? Colors.white : colorScheme.onSurface,
            fontVariations: AppFonts.medium,
          ),
        ),
      ),
    );
  }
}

class _HistoryListItem extends StatelessWidget {
  const _HistoryListItem({
    required this.transaction,
    required this.isPoints,
  });

  final TransactionHistory transaction;
  final bool isPoints;

  String _formatAmount(double amount, TransactionType type) {
    final prefix = type == TransactionType.credit ? '+ ' : '- ';
    if (isPoints) {
      return '$prefix${amount.toInt().toString().replaceAllMapped(
        RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
        (Match m) => '${m[1]},',
      )}';
    } else {
      return '${prefix}Rp ${amount.toInt().toString().replaceAllMapped(
        RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
        (Match m) => '${m[1]},',
      )}';
    }
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final transactionDate = DateTime(date.year, date.month, date.day);

    if (transactionDate == today) {
      return 'Today, ${DateFormat('h:mm a').format(date)}';
    } else if (transactionDate == today.subtract(const Duration(days: 1))) {
      return 'Yesterday, ${DateFormat('h:mm a').format(date)}';
    } else {
      return DateFormat('d MMM yyyy, h:mm a').format(date);
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    final isCredit = transaction.type == TransactionType.credit;
    final amountColor = isCredit ? colorScheme.primary : Colors.red;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: colorScheme.onPrimaryContainer.withValues(alpha: 0.3),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              isCredit ? PhosphorIcons.coins() : PhosphorIcons.arrowUp(),
              size: 24,
              color: colorScheme.primary,
            ),
          ),
          const Gap(12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  transaction.title,
                  style: textTheme.titleSmall?.copyWith(
                    fontVariations: AppFonts.semiBold,
                  ),
                ),
                const Gap(2),
                Text(
                  transaction.description,
                  style: textTheme.bodySmall?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                    fontVariations: AppFonts.regular,
                  ),
                ),
                const Gap(2),
                Text(
                  _formatDate(transaction.date),
                  style: textTheme.bodySmall?.copyWith(
                    color: colorScheme.onSurfaceVariant.withValues(alpha: 0.7),
                    fontVariations: AppFonts.regular,
                  ),
                ),
              ],
            ),
          ),
          Text(
            _formatAmount(transaction.amount, transaction.type),
            style: textTheme.titleMedium?.copyWith(
              color: amountColor,
              fontVariations: AppFonts.semiBold,
            ),
          ),
        ],
      ),
    );
  }
}

class _EmptyHistoryCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Icon(
            PhosphorIcons.clipboardText(),
            size: 48,
            color: colorScheme.onSurfaceVariant.withValues(alpha: 0.5),
          ),
          const Gap(12),
          Text(
            'No transactions yet',
            style: textTheme.bodyMedium?.copyWith(
              color: colorScheme.onSurfaceVariant,
              fontVariations: AppFonts.medium,
            ),
          ),
        ],
      ),
    );
  }
}
