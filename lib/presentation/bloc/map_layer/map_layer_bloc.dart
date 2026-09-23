import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/usecases/get_map_layer.dart';
import 'map_layer_event.dart';
import 'map_layer_state.dart';

class MapLayerBloc extends Bloc<MapLayerEvent, MapLayerState> {
  final GetMapLayer getMapLayer;

  MapLayerBloc({required this.getMapLayer}) : super(const MapLayerInitial()) {
    on<FetchMapLayerEvent>(_onFetchMapLayer);
    on<SelectFeatureEvent>(_onSelectFeature);
    on<ClearSelectedFeatureEvent>(_onClearSelectedFeature);
  }

  Future<void> _onFetchMapLayer(
    FetchMapLayerEvent event,
    Emitter<MapLayerState> emit,
  ) async {
    emit(const MapLayerLoading());
    final result = await getMapLayer();
    result.fold(
      (failure) => emit(MapLayerError(failure.message)),
      (mapLayer) => emit(MapLayerLoaded(mapLayer: mapLayer)),
    );
  }

  void _onSelectFeature(
    SelectFeatureEvent event,
    Emitter<MapLayerState> emit,
  ) {
    if (state is MapLayerLoaded) {
      final currentState = state as MapLayerLoaded;
      emit(currentState.copyWith(
        selectedFeatureProperties: event.properties,
      ));
    }
  }

  void _onClearSelectedFeature(
    ClearSelectedFeatureEvent event,
    Emitter<MapLayerState> emit,
  ) {
    if (state is MapLayerLoaded) {
      final currentState = state as MapLayerLoaded;
      emit(currentState.copyWith(clearSelected: true));
    }
  }
}
