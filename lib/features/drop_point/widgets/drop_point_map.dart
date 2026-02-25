import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:latlong2/latlong.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:sirsak_pop_nasabah/core/constants/app_constants.dart';
import 'package:sirsak_pop_nasabah/core/theme/app_fonts.dart';
import 'package:sirsak_pop_nasabah/features/drop_point/drop_point_state.dart';
import 'package:sirsak_pop_nasabah/features/drop_point/drop_point_viewmodel.dart';
import 'package:sirsak_pop_nasabah/features/drop_point/widgets/location_found_toast.dart';
import 'package:sirsak_pop_nasabah/features/drop_point/widgets/location_permission_banner.dart';
import 'package:sirsak_pop_nasabah/features/drop_point/widgets/zoom_control.dart';
import 'package:sirsak_pop_nasabah/models/collection_point/collection_point_model.dart';

class DropPointMap extends ConsumerStatefulWidget {
  const DropPointMap({super.key});

  @override
  ConsumerState<DropPointMap> createState() => _DropPointMapState();
}

class _DropPointMapState extends ConsumerState<DropPointMap> {
  late final MapController _mapController;

  @override
  void initState() {
    super.initState();
    _mapController = MapController();
  }

  @override
  void dispose() {
    _mapController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final state = ref.watch(dropPointViewModelProvider);
    final viewModel = ref.read(dropPointViewModelProvider.notifier);

    // Listen for zoom/center changes and update map programmatically
    ref.listen(
      dropPointViewModelProvider.select(
        (s) => (s.mapZoom, s.mapCenterLat, s.mapCenterLng),
      ),
      (prev, next) {
        if (prev != next) {
          _mapController.move(
            LatLng(next.$2, next.$3),
            next.$1,
          );
        }
      },
    );

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Stack(
          children: [
            FlutterMap(
              mapController: _mapController,
              options: MapOptions(
                initialCenter: LatLng(state.mapCenterLat, state.mapCenterLng),
                initialZoom: state.mapZoom,
                minZoom: 5,
                maxZoom: 18,
                onTap: (_, _) => viewModel.clearSelection(),
              ),
              children: [
                // OpenStreetMap tile layer
                TileLayer(
                  urlTemplate: openMapUrlTemplate,
                  userAgentPackageName: appBundleID,
                ),
                // Drop point markers
                MarkerLayer(
                  markers: state.validDropPoints.map((dropPoint) {
                    return _buildDropPointMarker(
                      dropPoint,
                      colorScheme,
                      state.selectedDropPoint?.id == dropPoint.id,
                      onTap: () => viewModel.selectDropPoint(dropPoint),
                    );
                  }).toList(),
                ),
                // User location marker
                if (state.userLocation != null)
                  MarkerLayer(
                    markers: [
                      _buildUserLocationMarker(
                        state.userLocation!.latitude,
                        state.userLocation!.longitude,
                        colorScheme,
                      ),
                    ],
                  ),
                // // required to used for free
                // const SimpleAttributionWidget(
                //   source: Text('OpenStreetMap'),
                // ),
              ],
            ),
            // Map controls (my location + zoom)
            Positioned(
              top: 8,
              left: 8,
              bottom: 8,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  const Gap(8),
                  ZoomControl(
                    onZoomIn: viewModel.zoomIn,
                    onZoomOut: viewModel.zoomOut,
                  ),
                ],
              ),
            ),
            Positioned(
              bottom: 8,
              right: 8,
              child: _MyLocationButton(
                onTap: () {
                  if (state.userLocation != null) {
                    _mapController.move(
                      LatLng(
                        state.userLocation!.latitude,
                        state.userLocation!.longitude,
                      ),
                      state.mapZoom,
                    );
                  }
                },
                isEnabled: state.userLocation != null,
              ),
            ),
            // Location found toast
            if (state.isLocationFound)
              Positioned(
                bottom: 8,
                right: 8,
                child: LocationFoundToast(
                  onDismiss: viewModel.dismissLocationFound,
                ),
              ),
            // Location permission banner
            if (state.locationPermissionStatus ==
                LocationPermissionStatus.deniedForever)
              Positioned(
                bottom: 8,
                left: 8,
                right: 8,
                child: LocationPermissionBanner(
                  onOpenSettings: viewModel.openLocationAppSettings,
                ),
              ),
          ],
        ),
      ),
    );
  }

  Marker _buildDropPointMarker(
    CollectionPointModel dropPoint,
    ColorScheme colorScheme,
    bool isSelected, {
    required VoidCallback onTap,
  }) {
    // Skip points without valid coordinates
    if (dropPoint.latitude == null || dropPoint.longitude == null) {
      return const Marker(
        point: LatLng(0, 0),
        width: 0,
        height: 0,
        child: SizedBox.shrink(),
      );
    }

    return Marker(
      point: LatLng(dropPoint.lat, dropPoint.long),
      width: 100,
      height: isSelected ? 65 : 55,
      child: GestureDetector(
        onTap: onTap,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              constraints: const BoxConstraints(maxWidth: 96),
              padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.9),
                borderRadius: BorderRadius.circular(4),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.2),
                    blurRadius: 2,
                    offset: const Offset(0, 1),
                  ),
                ],
              ),
              child: Text(
                dropPoint.name,
                style: const TextStyle(
                  fontSize: 10,
                  fontVariations: AppFonts.semiBold,
                  color: Colors.black87,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
              ),
            ),
            const Gap(2),
            Container(
              width: isSelected ? 40 : 30,
              height: isSelected ? 40 : 30,
              decoration: BoxDecoration(
                color: Colors.blue,
                shape: BoxShape.circle,
                border: Border.all(
                  color: Colors.white,
                  width: isSelected ? 3 : 2,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: .2),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Icon(
                Icons.location_on,
                color: Colors.white,
                size: isSelected ? 24 : 18,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Marker _buildUserLocationMarker(
    double latitude,
    double longitude,
    ColorScheme colorScheme,
  ) {
    return Marker(
      point: LatLng(latitude, longitude),
      width: 24,
      height: 24,
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
              color: colorScheme.primary.withValues(alpha: .3),
              blurRadius: 8,
              spreadRadius: 2,
            ),
          ],
        ),
      ),
    );
  }
}

class _MyLocationButton extends StatelessWidget {
  const _MyLocationButton({
    required this.onTap,
    required this.isEnabled,
  });

  final VoidCallback onTap;
  final bool isEnabled;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Opacity(
      opacity: isEnabled ? 1.0 : 0.5,
      child: Container(
        decoration: BoxDecoration(
          color: colorScheme.surface.withValues(alpha: .9),
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: .1),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: InkWell(
          onTap: isEnabled ? onTap : null,
          borderRadius: BorderRadius.circular(8),
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: Icon(
              PhosphorIcons.gpsFix(),
              size: 20,
              color: colorScheme.onSurface,
            ),
          ),
        ),
      ),
    );
  }
}
