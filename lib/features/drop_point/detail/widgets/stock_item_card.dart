import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:sirsak_pop_nasabah/core/theme/app_fonts.dart';
import 'package:sirsak_pop_nasabah/models/collection_point/collection_point_stock_model.dart';

class StockItemCard extends StatelessWidget {
  const StockItemCard({
    required this.stockItem,
    super.key,
  });

  final CollectionPointStockModel stockItem;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Container(
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
            child: AspectRatio(
              aspectRatio: 1.2,
              child: stockItem.imageUrl != null
                  ? Image.network(
                      stockItem.imageUrl!,
                      fit: BoxFit.cover,
                      loadingBuilder: (context, child, loadingProgress) {
                        if (loadingProgress == null) return child;
                        return ColoredBox(
                          color: colorScheme.surfaceContainerHighest,
                          child: Center(
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: colorScheme.primary,
                              value: loadingProgress.expectedTotalBytes != null
                                  ? loadingProgress.cumulativeBytesLoaded /
                                        loadingProgress.expectedTotalBytes!
                                  : null,
                            ),
                          ),
                        );
                      },
                      errorBuilder: (context, error, stackTrace) => ColoredBox(
                        color: colorScheme.surfaceContainerHighest,
                        child: Center(
                          child: Icon(
                            Icons.image_not_supported_outlined,
                            color: colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ),
                    )
                  : ColoredBox(
                      color: colorScheme.surfaceContainerHighest,
                      child: Center(
                        child: Icon(
                          Icons.recycling,
                          size: 40,
                          color: colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ),
            ),
          ),

          // Content
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Material name
                  Text(
                    stockItem.materialName,
                    style: textTheme.titleSmall?.copyWith(
                      fontVariations: AppFonts.bold,
                      color: colorScheme.onSurface,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),

                  const Gap(4),

                  // Category/description
                  Expanded(
                    child: Text(
                      _getDescription(),
                      style: textTheme.bodySmall?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Generate a description based on category
  String _getDescription() {
    switch (stockItem.category.toLowerCase()) {
      case 'plastik':
        return 'Kemasan terbuat dari plastik.';
      case 'kertas':
        return 'Kemasan terbuat dari kertas.';
      case 'logam':
        return 'Bahan daur ulang dari logam.';
      case 'kaca':
        return 'Bahan daur ulang dari kaca.';
      default:
        return 'Bahan daur ulang anorganik termasuk plastik.';
    }
  }
}
