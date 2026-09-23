import 'package:equatable/equatable.dart';
import '../../../domain/entities/layer_feature_entity.dart';

abstract class MapLayerState extends Equatable {
  const MapLayerState();

  @override
  List<Object?> get props => [];
}

class MapLayerInitial extends MapLayerState {
  const MapLayerInitial();
}

class MapLayerLoading extends MapLayerState {
  const MapLayerLoading();
}

class MapLayerLoaded extends MapLayerState {
  final MapLayerEntity mapLayer;
  final Map<String, dynamic>? selectedFeatureProperties;

  const MapLayerLoaded({
    required this.mapLayer,
    this.selectedFeatureProperties,
  });

  MapLayerLoaded copyWith({
    MapLayerEntity? mapLayer,
    Map<String, dynamic>? selectedFeatureProperties,
    bool clearSelected = false,
  }) {
    return MapLayerLoaded(
      mapLayer: mapLayer ?? this.mapLayer,
      selectedFeatureProperties: clearSelected
          ? null
          : (selectedFeatureProperties ?? this.selectedFeatureProperties),
    );
  }

  @override
  List<Object?> get props => [mapLayer, selectedFeatureProperties];
}

class MapLayerError extends MapLayerState {
  final String message;

  const MapLayerError(this.message);

  @override
  List<Object?> get props => [message];
}
