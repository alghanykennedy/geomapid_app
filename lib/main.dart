import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'core/theme/app_theme.dart';
import 'injection_container.dart';
import 'presentation/bloc/map_layer/map_layer_bloc.dart';
import 'presentation/bloc/user_location/user_location_bloc.dart';
import 'presentation/pages/map_page.dart';
import 'services/map_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Load environment variables from .env
  try {
    await dotenv.load(fileName: '.env');
  } catch (e) {
    debugPrint('Could not load .env file: $e');
  }

  // Initialize GetIt dependency injection
  await initDependencies();

  runApp(const GeoMapidApp());
}

class GeoMapidApp extends StatelessWidget {
  const GeoMapidApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<MapLayerBloc>(
          create: (_) => sl<MapLayerBloc>(),
        ),
        BlocProvider<UserLocationBloc>(
          create: (_) => sl<UserLocationBloc>(),
        ),
      ],
      child: MaterialApp(
        title: 'GEO MAPID Explorer',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        home: MapPage(
          mapService: sl<MapService>(),
        ),
      ),
    );
  }
}
