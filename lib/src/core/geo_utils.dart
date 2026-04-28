import 'dart:math';
import '../exceptions/geo_exception.dart';

/// Utility class for geographic calculations.
class GeoUtils {
  GeoUtils._();

  static const double _earthRadiusKm = 6371.0;

  /// Calculates the distance in kilometers between two coordinates
  /// using the Haversine formula.
  ///
  /// Throws [InvalidCoordinateException] if any coordinate is out of range.
  static double calculateDistance(
    double lat1,
    double lon1,
    double lat2,
    double lon2,
  ) {
    _validateCoordinates(lat1, lon1);
    _validateCoordinates(lat2, lon2);

    final dLat = _toRadians(lat2 - lat1);
    final dLon = _toRadians(lon2 - lon1);

    final a = sin(dLat / 2) * sin(dLat / 2) +
        cos(_toRadians(lat1)) *
            cos(_toRadians(lat2)) *
            sin(dLon / 2) *
            sin(dLon / 2);

    final c = 2 * atan2(sqrt(a), sqrt(1 - a));
    return _earthRadiusKm * c;
  }

  static double _toRadians(double degrees) => degrees * pi / 180.0;

  static void _validateCoordinates(double lat, double lon) {
    if (lat < -90 || lat > 90) {
      throw InvalidCoordinateException(
          'Latitude must be between -90 and 90. Got: $lat');
    }
    if (lon < -180 || lon > 180) {
      throw InvalidCoordinateException(
          'Longitude must be between -180 and 180. Got: $lon');
    }
  }
}
