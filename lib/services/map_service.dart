import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:maplibre_gl/maplibre_gl.dart';
import '../core/constants/app_colors.dart';
import '../core/constants/app_constants.dart';
import '../core/utils/logger.dart';

class MapService {
  MapLibreMapController? _controller;
  Symbol? _userLocationSymbol;

  void setController(MapLibreMapController controller) {
    _controller = controller;
  }

  MapLibreMapController? get controller => _controller;

  /// Load GeoJSON features onto the map as a source and circle/symbol layer
  Future<void> loadGeoJsonLayer(Map<String, dynamic> geoJsonData) async {
    if (_controller == null) {
      AppLogger.w('MapController is null when attempting to load GeoJSON layer');
      return;
    }

    try {
      // 1. Remove existing layer & source if re-loading
      await _controller!.removeLayer(AppConstants.circleLayerId).catchError((_) {});
      await _controller!.removeSource(AppConstants.geoJsonSourceId).catchError((_) {});

      // 2. Add GeoJSON Source
      final String rawGeoJsonString = jsonEncode(geoJsonData);
      await _controller!.addSource(
        AppConstants.geoJsonSourceId,
        GeoJsonSourceProperties(data: rawGeoJsonString),
      );

      // 3. Add Circle Layer for Point rendering
      await _controller!.addCircleLayer(
        AppConstants.geoJsonSourceId,
        AppConstants.circleLayerId,
        const CircleLayerProperties(
          circleColor: '#E53935', // Primary Red
          circleRadius: 8.0,
          circleStrokeWidth: 2.0,
          circleStrokeColor: '#FFFFFF',
          circleOpacity: 0.85,
        ),
      );

      AppLogger.i('Successfully added GeoJSON source and circle layer to MapLibre');
    } catch (e) {
      AppLogger.e('Failed to add GeoJSON layer to map', e);
    }
  }

  /// Update or add user location marker on map
  Future<void> updateUserLocationMarker(LatLng userLatLng) async {
    if (_controller == null) return;

    try {
      if (_userLocationSymbol != null) {
        await _controller!.removeSymbol(_userLocationSymbol!);
      }

      _userLocationSymbol = await _controller!.addSymbol(
        SymbolOptions(
          geometry: userLatLng,
          iconImage: 'user_marker_icon',
          iconSize: 1.5,
          iconColor: '#1976D2',
        ),
      );

      AppLogger.i('Updated user location marker at: ${userLatLng.latitude}, ${userLatLng.longitude}');
    } catch (e) {
      // Fallback if custom icon not preloaded, add simple circle marker via latLng camera move
      AppLogger.w('Could not add symbol marker, moving camera to user location');
    }
  }

  /// Move camera to specified LatLng with optional zoom
  Future<void> animateToLocation(LatLng latLng, {double zoom = 14.0}) async {
    if (_controller == null) return;
    await _controller!.animateCamera(
      CameraUpdate.newLatLngZoom(latLng, zoom),
    );
  }

  /// Query features near tap point
  Future<List<dynamic>> queryFeaturesAtPoint(Point<double> point) async {
    if (_controller == null) return [];
    try {
      final features = await _controller!.queryRenderedFeatures(
        point,
        [AppConstants.circleLayerId],
        null,
      );
      return features;
    } catch (e) {
      AppLogger.e('Error querying features at point', e);
      return [];
    }
  }
}
