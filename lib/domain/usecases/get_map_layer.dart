import 'package:dartz/dartz.dart';
import '../../core/error/failures.dart';
import '../entities/layer_feature_entity.dart';
import '../repositories/map_layer_repository.dart';

class GetMapLayer {
  final MapLayerRepository repository;

  GetMapLayer(this.repository);

  Future<Either<Failure, MapLayerEntity>> call() async {
    return await repository.getMapLayer();
  }
}
