import '../../core/constants/api_constants.dart';
import '../../core/error/exceptions.dart';
import '../../core/network/dio_client.dart';
import '../models/layer_feature_model.dart';

abstract class MapLayerRemoteDataSource {
  Future<MapLayerModel> getMapLayer();
}

class MapLayerRemoteDataSourceImpl implements MapLayerRemoteDataSource {
  final DioClient dioClient;

  MapLayerRemoteDataSourceImpl({required this.dioClient});

  @override
  Future<MapLayerModel> getMapLayer() async {
    try {
      final response = await dioClient.dio.get(
        ApiConstants.getLayerPath,
        queryParameters: {
          'api_key': ApiConstants.apiKey,
          'layer_id': ApiConstants.layerId,
          'project_id': ApiConstants.projectId,
        },
      );

      if (response.statusCode == 200 && response.data != null) {
        final Map<String, dynamic> data;
        if (response.data is Map<String, dynamic>) {
          data = response.data as Map<String, dynamic>;
        } else {
          throw const ServerException('Invalid response format');
        }

        return MapLayerModel.fromJson(data);
      } else {
        throw ServerException('Failed to fetch layer data: ${response.statusCode}');
      }
    } catch (e) {
      if (e is ServerException) rethrow;
      throw ServerException('Network or parsing error: ${e.toString()}');
    }
  }
}
