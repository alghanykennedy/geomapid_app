import 'package:dartz/dartz.dart';
import '../../core/error/failures.dart';
import '../entities/layer_feature_entity.dart';

abstract class MapLayerRepository {
  Future<Either<Failure, MapLayerEntity>> getMapLayer();
}
