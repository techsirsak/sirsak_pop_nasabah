import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:sirsak_pop_nasabah/features/drop_point/drop_point_state.dart';
import 'package:sirsak_pop_nasabah/features/drop_point/drop_point_viewmodel.dart';
import 'package:sirsak_pop_nasabah/features/drop_point/widgets/location_found_toast.dart';
import 'package:sirsak_pop_nasabah/features/drop_point/widgets/location_permission_banner.dart';
import 'package:sirsak_pop_nasabah/features/drop_point/widgets/zoom_control.dart';
import 'package:sirsak_pop_nasabah/models/collection_point/collection_point_model.dart';

class DropPointMap extends StatelessWidget {
  const DropPointMap({
    required this.state,
    required this.viewModel,
    super.key,
  });

  final DropPointState state;
  final DropPointViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Stack(
          children: [
            FlutterMap(
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
                  urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                  userAgentPackageName: 'com.sirsak.pop_nasabah',
                ),
                // Drop point markers
                MarkerLayer(
                  markers: state.dropPoints.map((dropPoint) {
                    return _buildDropPointMarker(
                      dropPoint,
                      colorScheme,
                      state.selectedDropPoint?.id == dropPoint.id,
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
            // Zoom controls
            Positioned(
              top: 8,
              left: 8,
              bottom: 8,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  ZoomControl(
                    onZoomIn: viewModel.zoomIn,
                    onZoomOut: viewModel.zoomOut,
                  ),
                ],
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
    bool isSelected,
  ) {
    // Skip points without valid coordinates
    if (dropPoint.latitude == null || dropPoint.longitude == null) {
      print('skip _buildDropPointMarker ${dropPoint.toJson()}');
      return const Marker(
        point: LatLng(0, 0),
        width: 0,
        height: 0,
        child: SizedBox.shrink(),
      );
    }

    return Marker(
      point: LatLng(dropPoint.lat, dropPoint.long),
      width: isSelected ? 40 : 30,
      height: isSelected ? 40 : 30,
      child: GestureDetector(
        onTap: () => viewModel.selectDropPoint(dropPoint),
        child: Container(
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
