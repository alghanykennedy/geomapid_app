import 'package:geolocator/geolocator.dart';
import '../../domain/entities/user_location_entity.dart';

class UserLocationModel extends UserLocationEntity {
  const UserLocationModel({
    required super.latitude,
    required super.longitude,
    super.accuracy,
    super.altitude,
  });

  factory UserLocationModel.fromPosition(Position position) {
    return UserLocationModel(
      latitude: position.latitude,
      longitude: position.longitude,
      accuracy: position.accuracy,
      altitude: position.altitude,
    );
  }
}
