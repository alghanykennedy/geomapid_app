import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:geomapid_app/core/error/failures.dart';
import 'package:geomapid_app/domain/entities/user_location_entity.dart';
import 'package:geomapid_app/domain/repositories/location_repository.dart';
import 'package:geomapid_app/domain/usecases/get_current_location.dart';
import 'package:mocktail/mocktail.dart';

class MockLocationRepository extends Mock implements LocationRepository {}

void main() {
  late GetCurrentLocation usecase;
  late MockLocationRepository mockRepository;

  setUp(() {
    mockRepository = MockLocationRepository();
    usecase = GetCurrentLocation(mockRepository);
  });

  const tUserLocation = UserLocationEntity(
    latitude: -7.7956,
    longitude: 110.3695,
  );

  test('should get current user location from repository', () async {
    // arrange
    when(() => mockRepository.getCurrentLocation())
        .thenAnswer((_) async => const Right(tUserLocation));

    // act
    final result = await usecase();

    // assert
    expect(result, equals(const Right(tUserLocation)));
    verify(() => mockRepository.getCurrentLocation()).called(1);
    verifyNoMoreInteractions(mockRepository);
  });

  test('should return LocationFailure when location fetch fails', () async {
    // arrange
    when(() => mockRepository.getCurrentLocation())
        .thenAnswer((_) async => const Left(LocationFailure('GPS error')));

    // act
    final result = await usecase();

    // assert
    expect(result, equals(const Left(LocationFailure('GPS error'))));
    verify(() => mockRepository.getCurrentLocation()).called(1);
  });
}
