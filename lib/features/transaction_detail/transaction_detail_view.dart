import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:sirsak_pop_nasabah/core/theme/app_fonts.dart';
import 'package:sirsak_pop_nasabah/features/transaction_detail/transaction_detail_viewmodel.dart';
import 'package:sirsak_pop_nasabah/features/transaction_detail/widgets/transaction_items_table.dart';
import 'package:sirsak_pop_nasabah/l10n/extension.dart';
import 'package:sirsak_pop_nasabah/models/user/transaction_history_model.dart';
import 'package:sirsak_pop_nasabah/shared/helpers/date_format_extensions.dart';
import 'package:sirsak_pop_nasabah/shared/helpers/string_extensions.dart';

class TransactionDetailView extends ConsumerWidget {
  const TransactionDetailView({
    required this.transaction,
    super.key,
  });

  final TransactionHistoryModel transaction;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(transactionDetailViewModelProvider(transaction));
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final l10n = context.l10n;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: AppBar(
        backgroundColor: colorScheme.surface,
        elevation: 0,
        leading: IconButton(
          onPressed: () => context.pop(),
          icon: Icon(
            Icons.chevron_left,
            color: colorScheme.onSurface,
            size: 28,
          ),
        ),
        title: Text(
          l10n.transactionDetailTitle,
          style: textTheme.titleLarge?.copyWith(
            fontVariations: AppFonts.semiBold,
            color: colorScheme.onSurface,
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Summary card
                _SummaryCard(transaction: transaction),
                const Gap(24),

                // Items section header
                Row(
                  children: [
                    Icon(
                      PhosphorIcons.package(),
                      color: colorScheme.primary,
                      size: 24,
                    ),
                    const Gap(8),
                    Text(
                      l10n.transactionDetailItems,
                      style: textTheme.titleMedium?.copyWith(
                        fontVariations: AppFonts.semiBold,
                        color: colorScheme.primary,
                      ),
                    ),
                  ],
                ),
                const Gap(16),

                // Items table
                if (state.isLoading)
                  const Center(
                    child: Padding(
                      padding: EdgeInsets.all(32),
                      child: CircularProgressIndicator(),
                    ),
                  )
                else if (state.errorMessage != null)
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.all(32),
                      child: Text(
                        state.errorMessage!,
                        style: textTheme.bodyMedium?.copyWith(
                          color: colorScheme.error,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  )
                else if (state.items.isEmpty)
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.all(32),
                      child: Text(
                        'No items',
                        style: textTheme.bodyMedium?.copyWith(
                          color: colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ),
                  )
                else
                  TransactionItemsTable(items: state.items),

                const Gap(24),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _SummaryCard extends StatelessWidget {
  const _SummaryCard({required this.transaction});

  final TransactionHistoryModel transaction;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    final isDebit = transaction.type == TransactionType.debit;
    final amountColor = isDebit ? colorScheme.primary : Colors.red;
    final amountPrefix = isDebit ? '+ ' : '- ';

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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: colorScheme.onPrimaryContainer.withValues(alpha: 0.3),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  isDebit ? PhosphorIcons.coins() : PhosphorIcons.arrowUp(),
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
                      transaction.description,
                      style: textTheme.titleMedium?.copyWith(
                        fontVariations: AppFonts.semiBold,
                      ),
                    ),
                    const Gap(4),
                    Text(
                      transaction.createdAt.toDayRelative(context.l10n),
                      style: textTheme.bodySmall?.copyWith(
                        color: colorScheme.onSurfaceVariant.withValues(
                          alpha: 0.7,
                        ),
                        fontVariations: AppFonts.regular,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          if (transaction.transactionCode != null) ...[
            const Gap(12),
            Row(
              children: [
                Icon(
                  PhosphorIcons.barcode(),
                  size: 16,
                  color: colorScheme.onSurfaceVariant,
                ),
                const Gap(8),
                Text(
                  transaction.transactionCode!,
                  style: textTheme.bodySmall?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                    fontVariations: AppFonts.regular,
                  ),
                ),
              ],
            ),
          ],
          const Gap(16),
          const Divider(height: 1),
          const Gap(16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                context.l10n.transactionDetailTotal,
                style: textTheme.bodyMedium?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                  fontVariations: AppFonts.medium,
                ),
              ),
              Text(
                '$amountPrefix${transaction.amount.toString().formatRupiah}',
                style: textTheme.titleLarge?.copyWith(
                  color: amountColor,
                  fontVariations: AppFonts.bold,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
