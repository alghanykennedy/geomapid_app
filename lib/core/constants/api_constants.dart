import 'package:flutter_dotenv/flutter_dotenv.dart';

class ApiConstants {
  static String get baseUrl =>
      dotenv.get('MAPID_BASE_URL', fallback: 'https://geoserver.mapid.io');

  static String get apiKey => dotenv.get('MAPID_API_KEY', fallback: '');

  static String get layerId => dotenv.get('MAPID_LAYER_ID', fallback: '');

  static String get projectId => dotenv.get('MAPID_PROJECT_ID', fallback: '');

  static String get mapBasemapUrl => dotenv.get(
        'MAP_BASEMAP_URL',
        fallback: 'https://tiles.openfreemap.org/styles/liberty',
      );

  static String get getLayerPath => '/layers_new/get_layer';
}
