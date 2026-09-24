import 'package:flutter/services.dart';
import 'package:maplibre_gl/maplibre_gl.dart';
import '../core/utils/logger.dart';

class MapService {
  MaplibreMapController? _controller;
  static const _userLocationSourceId = 'user-location-source';
  static const _userLocationLayerId = 'user-location-layer';

  void setController(MaplibreMapController controller) {
    _controller = controller;
  }

  MaplibreMapController? get controller => _controller;

  /// Load GeoJSON point features as interactive symbol annotations.
  Future<void> loadGeoJsonLayer(Map<String, dynamic> geoJsonData) async {
    if (_controller == null) {
      AppLogger.w(
          'MapController is null when attempting to load GeoJSON layer');
      return;
    }

    try {
      final bytes = await rootBundle.load('assets/markers/img_marker.png');
      await _controller!.addImage('geo-mapid-pin', bytes.buffer.asUint8List());
      await _controller!.clearSymbols();

      final features = geoJsonData['features'];
      if (features is! List) {
        AppLogger.w('GeoJSON layer does not contain a features array');
        return;
      }

      final options = <SymbolOptions>[];
      final data = <Map>[];
      for (final feature in features) {
        if (feature is! Map) continue;
        final geometry = feature['geometry'];
        final coordinates = geometry is Map ? geometry['coordinates'] : null;
        if (geometry is! Map ||
            geometry['type'] != 'Point' ||
            coordinates is! List) {
          continue;
        }
        if (coordinates.length < 2 ||
            coordinates[0] is! num ||
            coordinates[1] is! num) {
          continue;
        }

        final properties = feature['properties'];
        options.add(
          SymbolOptions(
            geometry: LatLng(
              (coordinates[1] as num).toDouble(),
              (coordinates[0] as num).toDouble(),
            ),
            iconImage: 'geo-mapid-pin',
            iconSize: 0.3,
          ),
        );
        data.add(properties is Map
            ? Map<String, dynamic>.from(properties)
            : <String, dynamic>{});
      }

      if (options.isNotEmpty) {
        await _controller!.addSymbols(options, data);
      }
      AppLogger.i(
          'Successfully added ${options.length} interactive symbols to MapLibre');
    } catch (e) {
      AppLogger.e('Failed to add GeoJSON symbols to map', e);
    }
  }

  /// Update or add user location marker on map
  Future<void> updateUserLocationMarker(LatLng userLatLng) async {
    if (_controller == null) return;

    try {
      final userLocationGeoJson = {
        'type': 'FeatureCollection',
        'features': [
          {
            'type': 'Feature',
            'properties': const {},
            'geometry': {
              'type': 'Point',
              'coordinates': [userLatLng.longitude, userLatLng.latitude],
            },
          },
        ],
      };

      await _controller!.removeLayer(_userLocationLayerId).catchError((_) {});
      await _controller!.removeSource(_userLocationSourceId).catchError((_) {});
      await _controller!.addGeoJsonSource(
        _userLocationSourceId,
        userLocationGeoJson,
      );
      await _controller!.addCircleLayer(
        _userLocationSourceId,
        _userLocationLayerId,
        const CircleLayerProperties(
          circleColor: '#1976D2',
          circleRadius: 9,
          circleStrokeWidth: 3,
          circleStrokeColor: '#FFFFFF',
          circleOpacity: 1,
        ),
      );

      AppLogger.i(
          'Updated user location marker at: ${userLatLng.latitude}, ${userLatLng.longitude}');
    } catch (e) {
      AppLogger.e('Could not add user location marker', e);
    }
  }

  /// Move camera to specified LatLng with optional zoom
  Future<void> animateToLocation(LatLng latLng, {double zoom = 14.0}) async {
    if (_controller == null) return;
    await _controller!.animateCamera(
      CameraUpdate.newLatLngZoom(latLng, zoom),
    );
  }
}
