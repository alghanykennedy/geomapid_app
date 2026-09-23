import 'package:dartz/dartz.dart';
import '../../core/error/failures.dart';
import '../entities/user_location_entity.dart';
import '../repositories/location_repository.dart';

class GetCurrentLocation {
  final LocationRepository repository;

  GetCurrentLocation(this.repository);

  Future<Either<Failure, UserLocationEntity>> call() async {
    return await repository.getCurrentLocation();
  }
}
