import 'dart:math';
import 'package:flutter/material.dart';
import 'package:maplibre_gl/maplibre_gl.dart';
import '../../core/constants/api_constants.dart';
import '../../core/constants/app_constants.dart';
import '../../services/map_service.dart';

class MapViewWidget extends StatelessWidget {
  final MapService mapService;
  final VoidCallback onStyleLoaded;
  final Function(LatLng latLng, Point<double> point) onMapTap;
  final ValueChanged<Symbol> onSymbolTapped;

  const MapViewWidget({
    super.key,
    required this.mapService,
    required this.onStyleLoaded,
    required this.onMapTap,
    required this.onSymbolTapped,
  });

  @override
  Widget build(BuildContext context) {
    return MaplibreMap(
      styleString: ApiConstants.mapBasemapUrl,
      initialCameraPosition: const CameraPosition(
        target: LatLng(AppConstants.defaultLat, AppConstants.defaultLng),
        zoom: AppConstants.defaultZoom,
      ),
      onMapCreated: (controller) {
        mapService.setController(controller);
        controller.onSymbolTapped.add(onSymbolTapped);
      },
      onStyleLoadedCallback: onStyleLoaded,
      onMapClick: (point, latLng) {
        onMapTap(latLng, point);
      },
      trackCameraPosition: true,
      myLocationEnabled: true,
      myLocationRenderMode: MyLocationRenderMode.NORMAL,
      doubleClickZoomEnabled: false,
    );
  }
}
