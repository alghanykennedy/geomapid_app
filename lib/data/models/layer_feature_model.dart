import '../../domain/entities/layer_feature_entity.dart';

class LayerFeatureModel extends LayerFeatureEntity {
  const LayerFeatureModel({
    required super.id,
    required super.type,
    required super.latitude,
    required super.longitude,
    required super.properties,
  });

  factory LayerFeatureModel.fromJson(Map<String, dynamic> json) {
    final geometry = json['geometry'] as Map<String, dynamic>? ?? {};
    final coordinates = (geometry['coordinates'] as List<dynamic>?) ?? [0.0, 0.0];

    final double lng = (coordinates.isNotEmpty) ? (coordinates[0] as num).toDouble() : 0.0;
    final double lat = (coordinates.length > 1) ? (coordinates[1] as num).toDouble() : 0.0;

    return LayerFeatureModel(
      id: json['id']?.toString() ?? '',
      type: json['type']?.toString() ?? 'Feature',
      latitude: lat,
      longitude: lng,
      properties: (json['properties'] as Map<String, dynamic>?) ?? {},
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'type': type,
      'geometry': {
        'type': 'Point',
        'coordinates': [longitude, latitude],
      },
      'properties': properties,
    };
  }
}

class MapLayerModel extends MapLayerEntity {
  const MapLayerModel({
    required super.layerId,
    required super.layerName,
    required super.features,
    required super.rawGeoJson,
  });

  factory MapLayerModel.fromJson(Map<String, dynamic> json) {
    final featuresJson = (json['features'] as List<dynamic>?) ?? [];
    final features = featuresJson
        .map((f) => LayerFeatureModel.fromJson(f as Map<String, dynamic>))
        .toList();

    return MapLayerModel(
      layerId: json['layer_id']?.toString() ?? '',
      layerName: json['layer_name']?.toString() ?? 'GEO MAPID Layer',
      features: features,
      rawGeoJson: json,
    );
  }
}
