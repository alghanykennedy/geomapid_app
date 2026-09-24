import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:geomapid_app/core/error/failures.dart';
import 'package:geomapid_app/domain/entities/layer_feature_entity.dart';
import 'package:geomapid_app/domain/repositories/map_layer_repository.dart';
import 'package:geomapid_app/domain/usecases/get_map_layer.dart';
import 'package:mocktail/mocktail.dart';

class MockMapLayerRepository extends Mock implements MapLayerRepository {}

void main() {
  late GetMapLayer usecase;
  late MockMapLayerRepository mockRepository;

  setUp(() {
    mockRepository = MockMapLayerRepository();
    usecase = GetMapLayer(mockRepository);
  });

  const tMapLayerEntity = MapLayerEntity(
    layerId: '6aaa479abf51a2f0185a601b',
    layerName: 'Test Layer',
    features: [
      LayerFeatureEntity(
        id: '1',
        type: 'Feature',
        latitude: -7.799,
        longitude: 110.368,
        properties: {'NAMA': 'Test Place'},
      ),
    ],
    rawGeoJson: {'type': 'FeatureCollection'},
  );

  test('should get map layer entity from repository', () async {
    // arrange
    when(() => mockRepository.getMapLayer())
        .thenAnswer((_) async => const Right(tMapLayerEntity));

    // act
    final result = await usecase();

    // assert
    expect(result, equals(const Right(tMapLayerEntity)));
    verify(() => mockRepository.getMapLayer()).called(1);
    verifyNoMoreInteractions(mockRepository);
  });

  test('should return ServerFailure when repository fails', () async {
    // arrange
    when(() => mockRepository.getMapLayer())
        .thenAnswer((_) async => const Left(ServerFailure('Server Error')));

    // act
    final result = await usecase();

    // assert
    expect(result, equals(const Left(ServerFailure('Server Error'))));
    verify(() => mockRepository.getMapLayer()).called(1);
  });
}
