import 'package:get_it/get_it.dart';
import 'core/network/dio_client.dart';
import 'core/network/network_info.dart';
import 'data/datasources/map_layer_remote_data_source.dart';
import 'data/datasources/user_location_data_source.dart';
import 'data/repositories/location_repository_impl.dart';
import 'data/repositories/map_layer_repository_impl.dart';
import 'domain/repositories/location_repository.dart';
import 'domain/repositories/map_layer_repository.dart';
import 'domain/usecases/get_current_location.dart';
import 'domain/usecases/get_map_layer.dart';
import 'presentation/bloc/map_layer/map_layer_bloc.dart';
import 'presentation/bloc/user_location/user_location_bloc.dart';
import 'services/location_service.dart';
import 'services/map_service.dart';

final sl = GetIt.instance;

Future<void> initDependencies() async {
  // Services
  sl.registerLazySingleton<MapService>(() => MapService());
  sl.registerLazySingleton<LocationService>(() => LocationService());

  // Core
  sl.registerLazySingleton<DioClient>(() => DioClient());
  sl.registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl());

  // Data sources
  sl.registerLazySingleton<MapLayerRemoteDataSource>(
    () => MapLayerRemoteDataSourceImpl(dioClient: sl()),
  );
  sl.registerLazySingleton<UserLocationDataSource>(
    () => UserLocationDataSourceImpl(),
  );

  // Repositories
  sl.registerLazySingleton<MapLayerRepository>(
    () => MapLayerRepositoryImpl(remoteDataSource: sl()),
  );
  sl.registerLazySingleton<LocationRepository>(
    () => LocationRepositoryImpl(dataSource: sl()),
  );

  // Use cases
  sl.registerLazySingleton<GetMapLayer>(
    () => GetMapLayer(sl()),
  );
  sl.registerLazySingleton<GetCurrentLocation>(
    () => GetCurrentLocation(sl()),
  );

  // Blocs
  sl.registerFactory<MapLayerBloc>(
    () => MapLayerBloc(getMapLayer: sl()),
  );
  sl.registerFactory<UserLocationBloc>(
    () => UserLocationBloc(getCurrentLocation: sl()),
  );
}
