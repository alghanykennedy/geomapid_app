import 'package:dartz/dartz.dart';
import '../../core/error/exceptions.dart';
import '../../core/error/failures.dart';
import '../../domain/entities/layer_feature_entity.dart';
import '../../domain/repositories/map_layer_repository.dart';
import '../datasources/map_layer_remote_data_source.dart';

class MapLayerRepositoryImpl implements MapLayerRepository {
  final MapLayerRemoteDataSource remoteDataSource;

  MapLayerRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, MapLayerEntity>> getMapLayer() async {
    try {
      final mapLayerModel = await remoteDataSource.getMapLayer();
      return Right(mapLayerModel);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure('Unexpected error: ${e.toString()}'));
    }
  }
}
