import 'package:dartz/dartz.dart';
import '../../core/error/exceptions.dart';
import '../../core/error/failures.dart';
import '../../domain/entities/user_location_entity.dart';
import '../../domain/repositories/location_repository.dart';
import '../datasources/user_location_data_source.dart';

class LocationRepositoryImpl implements LocationRepository {
  final UserLocationDataSource dataSource;

  LocationRepositoryImpl({required this.dataSource});

  @override
  Future<Either<Failure, UserLocationEntity>> getCurrentLocation() async {
    try {
      final userLocation = await dataSource.getCurrentLocation();
      return Right(userLocation);
    } on LocationException catch (e) {
      return Left(LocationFailure(e.message));
    } catch (e) {
      return Left(LocationFailure('Failed to acquire location: ${e.toString()}'));
    }
  }
}
