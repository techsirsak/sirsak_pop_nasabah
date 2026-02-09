import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:sirsak_pop_nasabah/core/theme/app_fonts.dart';
import 'package:sirsak_pop_nasabah/l10n/extension.dart';
import 'package:sirsak_pop_nasabah/models/user/transaction_item_model.dart';
import 'package:sirsak_pop_nasabah/shared/helpers/string_extensions.dart';

class TransactionItemsTable extends StatelessWidget {
  const TransactionItemsTable({
    required this.items,
    super.key,
  });

  final List<TransactionItemModel> items;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final l10n = context.l10n;

    return Container(
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
          // Table header
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: colorScheme.primary.withValues(alpha: 0.1),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(12),
                topRight: Radius.circular(12),
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  flex: 3,
                  child: Text(
                    l10n.transactionDetailBarang,
                    style: textTheme.bodySmall?.copyWith(
                      fontVariations: AppFonts.semiBold,
                      color: colorScheme.primary,
                    ),
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Text(
                    l10n.transactionDetailJumlah,
                    style: textTheme.bodySmall?.copyWith(
                      fontVariations: AppFonts.semiBold,
                      color: colorScheme.primary,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Text(
                    l10n.transactionDetailHarga,
                    style: textTheme.bodySmall?.copyWith(
                      fontVariations: AppFonts.semiBold,
                      color: colorScheme.primary,
                    ),
                    textAlign: TextAlign.right,
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Text(
                    l10n.transactionDetailTotal,
                    style: textTheme.bodySmall?.copyWith(
                      fontVariations: AppFonts.semiBold,
                      color: colorScheme.primary,
                    ),
                    textAlign: TextAlign.right,
                  ),
                ),
              ],
            ),
          ),
          // Table rows
          ...items.asMap().entries.map((entry) {
            final index = entry.key;
            final item = entry.value;
            final isLast = index == items.length - 1;

            return _TableRow(
              item: item,
              isLast: isLast,
            );
          }),
        ],
      ),
    );
  }
}

class _TableRow extends StatelessWidget {
  const _TableRow({
    required this.item,
    required this.isLast,
  });

  final TransactionItemModel item;
  final bool isLast;

  String _formatQuantity() {
    // Format quantity: remove decimal if whole number
    final quantityStr = item.quantity == item.quantity.truncate()
        ? item.quantity.truncate().toString()
        : item.quantity.toStringAsFixed(1);
    return '$quantityStr ${item.unitOfMeasurement}';
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        border: isLast
            ? null
            : Border(
                bottom: BorderSide(
                  color: colorScheme.outlineVariant.withValues(alpha: 0.5),
                ),
              ),
      ),
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: Text(
              item.materialName,
              style: textTheme.bodySmall?.copyWith(
                fontVariations: AppFonts.medium,
                color: colorScheme.onSurface,
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              _formatQuantity(),
              style: textTheme.bodySmall?.copyWith(
                fontVariations: AppFonts.regular,
                color: colorScheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              item.unitPrice.truncate().toString().formatRupiah,
              style: textTheme.bodySmall?.copyWith(
                fontVariations: AppFonts.regular,
                color: colorScheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.right,
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              item.totalPrice.truncate().toString().formatRupiah,
              style: textTheme.bodySmall?.copyWith(
                fontVariations: AppFonts.semiBold,
                color: colorScheme.onSurface,
              ),
              textAlign: TextAlign.right,
            ),
          ),
        ],
      ),
    );
  }
}
