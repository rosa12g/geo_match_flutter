/// Base exception for all geo_match_flutter errors.
class GeoException implements Exception {
  final String message;
  const GeoException(this.message);

  @override
  String toString() => 'GeoException: $message';
}

/// Thrown when no available agents are found.
class NoAgentsAvailableException extends GeoException {
  const NoAgentsAvailableException()
      : super('No available agents found in the provided list.');
}

/// Thrown when an invalid coordinate is provided.
class InvalidCoordinateException extends GeoException {
  const InvalidCoordinateException(super.message);
}
