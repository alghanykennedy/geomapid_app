import 'package:permission_handler/permission_handler.dart';
import 'logger.dart';

class LocationPermissionHelper {
  static Future<bool> requestLocationPermission() async {
    final status = await Permission.locationWhenInUse.status;
    if (status.isGranted) {
      return true;
    }

    if (status.isDenied) {
      final result = await Permission.locationWhenInUse.request();
      return result.isGranted;
    }

    if (status.isPermanentlyDenied) {
      AppLogger.w('Location permission is permanently denied');
      await openAppSettings();
      return false;
    }

    return false;
  }
}
