import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:latlong2/latlong.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:sirsak_pop_nasabah/core/constants/app_constants.dart';
import 'package:sirsak_pop_nasabah/core/theme/app_fonts.dart';
import 'package:sirsak_pop_nasabah/features/drop_point/detail/drop_point_detail_viewmodel.dart';
import 'package:sirsak_pop_nasabah/features/drop_point/detail/widgets/stock_item_card.dart';
import 'package:sirsak_pop_nasabah/l10n/extension.dart';
import 'package:sirsak_pop_nasabah/models/collection_point/collection_point_model.dart';

class DropPointDetailView extends ConsumerWidget {
  const DropPointDetailView({
    required this.collectionPoint,
    super.key,
  });

  final CollectionPointModel collectionPoint;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Family provider - pass collectionPoint as parameter
    final state = ref.watch(
      dropPointDetailViewModelProvider(collectionPoint),
    );
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        title: // Name
        Text(
          collectionPoint.name,
          style: textTheme.titleLarge?.copyWith(
            fontVariations: AppFonts.bold,
            color: colorScheme.primary,
          ),
        ),
      ),
      backgroundColor: colorScheme.surface,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _BSUDetail(collectionPoint: collectionPoint),
              const Gap(16),
              // Stock section header
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: [
                    Icon(
                      Icons.delete_outline,
                      color: colorScheme.primary,
                      size: 24,
                    ),
                    const Gap(8),
                    Expanded(
                      child: Text(
                        context.l10n.dropPointDetailAcceptedWaste,
                        style: textTheme.titleMedium?.copyWith(
                          fontVariations: AppFonts.semiBold,
                          color: colorScheme.primary,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const Gap(16),

              // Stock items grid
              if (state.isLoadingStock)
                const Center(
                  child: Padding(
                    padding: EdgeInsets.all(32),
                    child: CircularProgressIndicator(),
                  ),
                )
              else if (state.stockItems.isEmpty)
                Padding(
                  padding: const EdgeInsets.all(32),
                  child: Center(
                    child: Text(
                      'No stock items available',
                      style: textTheme.bodyMedium?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ),
                )
              else
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 12,
                          mainAxisSpacing: 12,
                          childAspectRatio: 0.75,
                        ),
                    itemCount: state.stockItems.length,
                    itemBuilder: (context, index) {
                      return StockItemCard(stockItem: state.stockItems[index]);
                    },
                  ),
                ),

              const Gap(24),
            ],
          ),
        ),
      ),
    );
  }
}

class _BSUDetail extends StatelessWidget {
  const _BSUDetail({required this.collectionPoint});

  final CollectionPointModel collectionPoint;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Column(
      children: [
        SizedBox(
          height: 200,
          width: double.infinity,
          child: IgnorePointer(
            child: FlutterMap(
              options: MapOptions(
                initialCenter: LatLng(
                  collectionPoint.lat,
                  collectionPoint.long,
                ),
                initialZoom: 15,
              ),
              children: [
                TileLayer(
                  urlTemplate: openMapUrlTemplate,
                  userAgentPackageName: appBundleID,
                ),
                MarkerLayer(
                  markers: [
                    Marker(
                      point: LatLng(
                        collectionPoint.lat,
                        collectionPoint.long,
                      ),
                      width: 40,
                      height: 40,
                      child: Container(
                        decoration: BoxDecoration(
                          color: colorScheme.primary,
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: Colors.white,
                            width: 3,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.3),
                              blurRadius: 4,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: const Icon(
                          Icons.location_on,
                          color: Colors.white,
                          size: 24,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),

        // Info card
        _InfoCard(collectionPoint: collectionPoint),
      ],
    );
  }
}

class _InfoCard extends ConsumerWidget {
  const _InfoCard({required this.collectionPoint});

  final CollectionPointModel collectionPoint;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;
    final state = ref.watch(dropPointDetailViewModelProvider(collectionPoint));
    final distance = state.distance;

    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Phone number
          if (collectionPoint.noHp?.isNotEmpty ?? false) ...[
            const Gap(12),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(
                  PhosphorIcons.phone(),
                  size: 20,
                ),
                const Gap(8),
                Expanded(
                  child: Text(
                    collectionPoint.noHp!,
                    style: textTheme.bodyMedium?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                ),
              ],
            ),
          ],

          // Address
          if (collectionPoint.alamatLengkap?.isNotEmpty ?? false) ...[
            const Gap(12),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(
                  PhosphorIcons.mapPin(),
                  size: 20,
                ),
                const Gap(8),
                Expanded(
                  child: Text(
                    collectionPoint.alamatLengkap!,
                    style: textTheme.bodyMedium?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                ),
              ],
            ),
          ],

          // Distance
          if (distance != null && distance.isNotEmpty) ...[
            const Gap(8),
            Row(
              children: [
                Icon(
                  PhosphorIcons.personSimpleWalk(),
                  size: 20,
                ),
                const Gap(8),
                Text(
                  context.l10n.dropPointDistance(distance),
                  style: textTheme.bodyMedium?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),

            const Gap(12),

            // Get Directions button
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton.icon(
                  onPressed: () => ref
                      .read(
                        dropPointDetailViewModelProvider(
                          collectionPoint,
                        ).notifier,
                      )
                      .getDirections(),
                  icon: Icon(
                    PhosphorIcons.navigationArrow(),
                    color: colorScheme.primary,
                  ),
                  label: Text(
                    context.l10n.dropPointDetailGetDirections,
                    style: textTheme.labelLarge?.copyWith(
                      fontVariations: AppFonts.semiBold,
                      color: colorScheme.primary,
                    ),
                  ),
                ),
              ],
            ),
          ],
          const Gap(8),
        ],
      ),
    );
  }
}
