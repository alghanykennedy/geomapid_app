class AppConstants {
  static const String appName = 'GEO MAPID Explorer';

  // Map Default Settings
  static const double defaultLat = -7.7956; // Yogyakarta default center
  static const double defaultLng = 110.3695;
  static const double defaultZoom = 12.0;

  // Timeouts
  static const int connectTimeout = 15000; // ms
  static const int receiveTimeout = 15000; // ms

  // Layer Source/Layer IDs for MapLibre
  static const String geoJsonSourceId = 'geomapid-geojson-source';
  static const String circleLayerId = 'geomapid-circle-layer';
  static const String symbolLayerId = 'geomapid-symbol-layer';
}
