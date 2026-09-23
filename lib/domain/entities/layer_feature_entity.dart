import 'package:equatable/equatable.dart';

class LayerFeatureEntity extends Equatable {
  final String id;
  final String type;
  final double latitude;
  final double longitude;
  final Map<String, dynamic> properties;

  const LayerFeatureEntity({
    required this.id,
    required this.type,
    required this.latitude,
    required this.longitude,
    required this.properties,
  });

  @override
  List<Object?> get props => [id, type, latitude, longitude, properties];
}

class MapLayerEntity extends Equatable {
  final String layerId;
  final String layerName;
  final List<LayerFeatureEntity> features;
  final Map<String, dynamic> rawGeoJson;

  const MapLayerEntity({
    required this.layerId,
    required this.layerName,
    required this.features,
    required this.rawGeoJson,
  });

  @override
  List<Object?> get props => [layerId, layerName, features, rawGeoJson];
}
