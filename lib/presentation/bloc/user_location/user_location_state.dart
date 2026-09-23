import 'package:equatable/equatable.dart';
import '../../../domain/entities/user_location_entity.dart';

abstract class UserLocationState extends Equatable {
  const UserLocationState();

  @override
  List<Object?> get props => [];
}

class UserLocationInitial extends UserLocationState {
  const UserLocationInitial();
}

class UserLocationLoading extends UserLocationState {
  const UserLocationLoading();
}

class UserLocationLoaded extends UserLocationState {
  final UserLocationEntity userLocation;

  const UserLocationLoaded(this.userLocation);

  @override
  List<Object?> get props => [userLocation];
}

class UserLocationError extends UserLocationState {
  final String message;

  const UserLocationError(this.message);

  @override
  List<Object?> get props => [message];
}
