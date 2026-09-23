import 'package:equatable/equatable.dart';

abstract class MapLayerEvent extends Equatable {
  const MapLayerEvent();

  @override
  List<Object?> get props => [];
}

class FetchMapLayerEvent extends MapLayerEvent {
  const FetchMapLayerEvent();
}

class SelectFeatureEvent extends MapLayerEvent {
  final Map<String, dynamic>? properties;

  const SelectFeatureEvent(this.properties);

  @override
  List<Object?> get props => [properties];
}

class ClearSelectedFeatureEvent extends MapLayerEvent {
  const ClearSelectedFeatureEvent();
}
