import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:geomapid_app/core/error/failures.dart';
import 'package:geomapid_app/domain/entities/layer_feature_entity.dart';
import 'package:geomapid_app/domain/usecases/get_map_layer.dart';
import 'package:geomapid_app/presentation/bloc/map_layer/map_layer_bloc.dart';
import 'package:geomapid_app/presentation/bloc/map_layer/map_layer_event.dart';
import 'package:geomapid_app/presentation/bloc/map_layer/map_layer_state.dart';
import 'package:mocktail/mocktail.dart';

class MockGetMapLayer extends Mock implements GetMapLayer {}

void main() {
  late MapLayerBloc bloc;
  late MockGetMapLayer mockGetMapLayer;

  setUp(() {
    mockGetMapLayer = MockGetMapLayer();
    bloc = MapLayerBloc(getMapLayer: mockGetMapLayer);
  });

  const tMapLayerEntity = MapLayerEntity(
    layerId: '6aaa479abf51a2f0185a601b',
    layerName: 'Pariwisata Jogja',
    features: [],
    rawGeoJson: {'type': 'FeatureCollection'},
  );

  test('initial state should be MapLayerInitial', () {
    expect(bloc.state, equals(const MapLayerInitial()));
  });

  blocTest<MapLayerBloc, MapLayerState>(
    'should emit [MapLayerLoading, MapLayerLoaded] when FetchMapLayerEvent succeeds',
    build: () {
      when(() => mockGetMapLayer())
          .thenAnswer((_) async => const Right(tMapLayerEntity));
      return bloc;
    },
    act: (b) => b.add(const FetchMapLayerEvent()),
    expect: () => [
      const MapLayerLoading(),
      const MapLayerLoaded(mapLayer: tMapLayerEntity),
    ],
  );

  blocTest<MapLayerBloc, MapLayerState>(
    'should emit [MapLayerLoading, MapLayerError] when FetchMapLayerEvent fails',
    build: () {
      when(() => mockGetMapLayer())
          .thenAnswer((_) async => const Left(ServerFailure('API error')));
      return bloc;
    },
    act: (b) => b.add(const FetchMapLayerEvent()),
    expect: () => [
      const MapLayerLoading(),
      const MapLayerError('API error'),
    ],
  );

  blocTest<MapLayerBloc, MapLayerState>(
    'should update selectedFeatureProperties when SelectFeatureEvent is added',
    build: () => bloc,
    seed: () => const MapLayerLoaded(mapLayer: tMapLayerEntity),
    act: (b) => b.add(const SelectFeatureEvent({'NAMA': 'Test Point'})),
    expect: () => [
      const MapLayerLoaded(
        mapLayer: tMapLayerEntity,
        selectedFeatureProperties: {'NAMA': 'Test Point'},
      ),
    ],
  );

  blocTest<MapLayerBloc, MapLayerState>(
    'should clear selectedFeatureProperties when ClearSelectedFeatureEvent is added',
    build: () => bloc,
    seed: () => const MapLayerLoaded(
      mapLayer: tMapLayerEntity,
      selectedFeatureProperties: {'NAMA': 'Test Point'},
    ),
    act: (b) => b.add(const ClearSelectedFeatureEvent()),
    expect: () => [
      const MapLayerLoaded(
        mapLayer: tMapLayerEntity,
        selectedFeatureProperties: null,
      ),
    ],
  );
}
