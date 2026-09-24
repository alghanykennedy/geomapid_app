import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:maplibre_gl/maplibre_gl.dart';
import '../../core/constants/app_constants.dart';
import '../../core/theme/app_colors.dart';
import '../../core/widgets/app_error_view.dart';
import '../../core/widgets/app_loading_indicator.dart';
import '../../core/widgets/feature_popup_card.dart';
import '../../services/map_service.dart';
import '../bloc/map_layer/map_layer_bloc.dart';
import '../bloc/map_layer/map_layer_event.dart';
import '../bloc/map_layer/map_layer_state.dart';
import '../bloc/user_location/user_location_bloc.dart';
import '../bloc/user_location/user_location_event.dart';
import '../bloc/user_location/user_location_state.dart';
import '../widgets/map_view.dart';
import '../widgets/user_location_marker.dart';

class MapPage extends StatefulWidget {
  final MapService mapService;

  const MapPage({super.key, required this.mapService});

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  bool _isMapStyleLoaded = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.map_rounded, size: 24),
            SizedBox(width: 8),
            Text(AppConstants.appName),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            tooltip: 'Reload Layer Data',
            onPressed: () {
              context.read<MapLayerBloc>().add(const FetchMapLayerEvent());
            },
          ),
        ],
      ),
      body: MultiBlocListener(
        listeners: [
          BlocListener<MapLayerBloc, MapLayerState>(
            listenWhen: (previous, current) {
              if (current is MapLayerLoaded) {
                if (previous is! MapLayerLoaded) return true;
                return previous.mapLayer != current.mapLayer;
              }
              return true;
            },
            listener: (context, state) {
              if (state is MapLayerLoaded && _isMapStyleLoaded) {
                widget.mapService.loadGeoJsonLayer(state.mapLayer.rawGeoJson);
              } else if (state is MapLayerError) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(state.message),
                    backgroundColor: AppColors.error,
                  ),
                );
              }
            },
          ),
          BlocListener<UserLocationBloc, UserLocationState>(
            listener: (context, state) {
              if (state is UserLocationLoaded) {
                final userLatLng = LatLng(
                  state.userLocation.latitude,
                  state.userLocation.longitude,
                );
                widget.mapService.animateToLocation(userLatLng, zoom: 15.0);
                widget.mapService.updateUserLocationMarker(userLatLng);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Location acquired!'),
                    backgroundColor: AppColors.success,
                    duration: Duration(seconds: 2),
                  ),
                );
              } else if (state is UserLocationError) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(state.message),
                    backgroundColor: AppColors.error,
                  ),
                );
              }
            },
          ),
        ],
        child: Stack(
          children: [
            // Map Canvas View
            MapViewWidget(
              mapService: widget.mapService,
              onStyleLoaded: () {
                setState(() {
                  _isMapStyleLoaded = true;
                });
                final currentState = context.read<MapLayerBloc>().state;
                if (currentState is MapLayerLoaded) {
                  widget.mapService
                      .loadGeoJsonLayer(currentState.mapLayer.rawGeoJson);
                } else {
                  context.read<MapLayerBloc>().add(const FetchMapLayerEvent());
                }
              },
              onMapTap: (latLng, point) async {
                if (context.mounted) {
                  context
                      .read<MapLayerBloc>()
                      .add(const ClearSelectedFeatureEvent());
                }
              },
              onSymbolTapped: (symbol) {
                final properties = symbol.data;
                if (properties is Map && context.mounted) {
                  context.read<MapLayerBloc>().add(
                        SelectFeatureEvent({
                          ...Map<String, dynamic>.from(properties),
                          'Latitude': symbol.options.geometry?.latitude,
                          'Longitude': symbol.options.geometry?.longitude,
                        }),
                      );
                }
              },
            ),

            // Loading state view
            BlocBuilder<MapLayerBloc, MapLayerState>(
              builder: (context, state) {
                if (state is MapLayerLoading) {
                  return const AppLoadingIndicator(
                    message: 'Loading GEO MAPID layer...',
                  );
                }
                return const SizedBox.shrink();
              },
            ),

            // Error retry view if initial load fails
            BlocBuilder<MapLayerBloc, MapLayerState>(
              builder: (context, state) {
                if (state is MapLayerError) {
                  return AppErrorView(
                    message: state.message,
                    onRetry: () {
                      context
                          .read<MapLayerBloc>()
                          .add(const FetchMapLayerEvent());
                    },
                  );
                }
                return const SizedBox.shrink();
              },
            ),

            // Feature Popup Card at bottom when tapped
            BlocBuilder<MapLayerBloc, MapLayerState>(
              builder: (context, state) {
                if (state is MapLayerLoaded &&
                    state.selectedFeatureProperties != null) {
                  return Positioned(
                    left: 0,
                    right: 0,
                    bottom: 20,
                    child: FeaturePopupCard(
                      properties: state.selectedFeatureProperties!,
                      onClose: () {
                        context
                            .read<MapLayerBloc>()
                            .add(const ClearSelectedFeatureEvent());
                      },
                    ),
                  );
                }
                return const SizedBox.shrink();
              },
            ),

            // Floating Controls (User location button)
            Positioned(
              right: 16,
              bottom: 110,
              child: BlocBuilder<UserLocationBloc, UserLocationState>(
                builder: (context, state) {
                  final isLoading = state is UserLocationLoading;
                  return UserLocationControlWidget(
                    isLoading: isLoading,
                    onLocateUser: () {
                      context
                          .read<UserLocationBloc>()
                          .add(const FetchUserLocationEvent());
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
