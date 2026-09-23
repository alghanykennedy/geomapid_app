class ServerException implements Exception {
  final String message;
  const ServerException([this.message = 'Server Exception']);
}

class NetworkException implements Exception {
  final String message;
  const NetworkException([this.message = 'Network Exception']);
}

class LocationException implements Exception {
  final String message;
  const LocationException([this.message = 'Location Exception']);
}
