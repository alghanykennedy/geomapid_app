import 'package:equatable/equatable.dart';

class UserLocationEntity extends Equatable {
  final double latitude;
  final double longitude;
  final double? accuracy;
  final double? altitude;

  const UserLocationEntity({
    required this.latitude,
    required this.longitude,
    this.accuracy,
    this.altitude,
  });

  @override
  List<Object?> get props => [latitude, longitude, accuracy, altitude];
}
