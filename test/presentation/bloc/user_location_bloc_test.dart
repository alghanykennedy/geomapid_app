import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:geomapid_app/core/error/failures.dart';
import 'package:geomapid_app/domain/entities/user_location_entity.dart';
import 'package:geomapid_app/domain/usecases/get_current_location.dart';
import 'package:geomapid_app/presentation/bloc/user_location/user_location_bloc.dart';
import 'package:geomapid_app/presentation/bloc/user_location/user_location_event.dart';
import 'package:geomapid_app/presentation/bloc/user_location/user_location_state.dart';
import 'package:mocktail/mocktail.dart';

class MockGetCurrentLocation extends Mock implements GetCurrentLocation {}

void main() {
  late UserLocationBloc bloc;
  late MockGetCurrentLocation mockGetCurrentLocation;

  setUp(() {
    mockGetCurrentLocation = MockGetCurrentLocation();
    bloc = UserLocationBloc(getCurrentLocation: mockGetCurrentLocation);
  });

  const tUserLocation = UserLocationEntity(
    latitude: -7.7956,
    longitude: 110.3695,
  );

  test('initial state should be UserLocationInitial', () {
    expect(bloc.state, equals(const UserLocationInitial()));
  });

  blocTest<UserLocationBloc, UserLocationState>(
    'should emit [UserLocationLoading, UserLocationLoaded] when FetchUserLocationEvent succeeds',
    build: () {
      when(() => mockGetCurrentLocation())
          .thenAnswer((_) async => const Right(tUserLocation));
      return bloc;
    },
    act: (b) => b.add(const FetchUserLocationEvent()),
    expect: () => [
      const UserLocationLoading(),
      const UserLocationLoaded(tUserLocation),
    ],
  );

  blocTest<UserLocationBloc, UserLocationState>(
    'should emit [UserLocationLoading, UserLocationError] when FetchUserLocationEvent fails',
    build: () {
      when(() => mockGetCurrentLocation()).thenAnswer(
          (_) async => const Left(LocationFailure('Permission denied')));
      return bloc;
    },
    act: (b) => b.add(const FetchUserLocationEvent()),
    expect: () => [
      const UserLocationLoading(),
      const UserLocationError('Permission denied'),
    ],
  );
}
