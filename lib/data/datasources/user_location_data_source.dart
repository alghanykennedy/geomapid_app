import 'package:geolocator/geolocator.dart';
import '../../core/error/exceptions.dart';
import '../../core/utils/location_permission_helper.dart';
import '../models/user_location_model.dart';

abstract class UserLocationDataSource {
  Future<UserLocationModel> getCurrentLocation();
}

class UserLocationDataSourceImpl implements UserLocationDataSource {
  @override
  Future<UserLocationModel> getCurrentLocation() async {
    final bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      throw const LocationException('GPS location services are disabled.');
    }

    final bool hasPermission =
        await LocationPermissionHelper.requestLocationPermission();
    if (!hasPermission) {
      throw const LocationException('Location permission denied.');
    }

    try {
      final position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
          timeLimit: Duration(seconds: 10),
        ),
      );
      return UserLocationModel.fromPosition(position);
    } catch (e) {
      throw LocationException('Failed to get location: ${e.toString()}');
    }
  }
}
