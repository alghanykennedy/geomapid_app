import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/usecases/get_current_location.dart';
import 'user_location_event.dart';
import 'user_location_state.dart';

class UserLocationBloc extends Bloc<UserLocationEvent, UserLocationState> {
  final GetCurrentLocation getCurrentLocation;

  UserLocationBloc({required this.getCurrentLocation})
      : super(const UserLocationInitial()) {
    on<FetchUserLocationEvent>(_onFetchUserLocation);
  }

  Future<void> _onFetchUserLocation(
    FetchUserLocationEvent event,
    Emitter<UserLocationState> emit,
  ) async {
    emit(const UserLocationLoading());
    final result = await getCurrentLocation();
    result.fold(
      (failure) => emit(UserLocationError(failure.message)),
      (location) => emit(UserLocationLoaded(location)),
    );
  }
}
