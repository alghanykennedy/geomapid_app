import 'package:dio/dio.dart';
import '../constants/api_constants.dart';
import '../constants/app_constants.dart';
import '../utils/logger.dart';

class DioClient {
  late final Dio _dio;

  DioClient() {
    _dio = Dio(
      BaseOptions(
        baseUrl: ApiConstants.baseUrl,
        connectTimeout: const Duration(milliseconds: AppConstants.connectTimeout),
        receiveTimeout: const Duration(milliseconds: AppConstants.receiveTimeout),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    );

    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          AppLogger.i('HTTP Request [${options.method}] => ${options.uri}');
          return handler.next(options);
        },
        onResponse: (response, handler) {
          AppLogger.i('HTTP Response [${response.statusCode}] <= ${response.requestOptions.uri}');
          return handler.next(response);
        },
        onError: (DioException e, handler) {
          AppLogger.e('HTTP Error [${e.response?.statusCode}] <= ${e.message}', e);
          return handler.next(e);
        },
      ),
    );
  }

  Dio get dio => _dio;
}
