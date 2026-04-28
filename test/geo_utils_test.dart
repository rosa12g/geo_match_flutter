import 'package:flutter_test/flutter_test.dart';
import 'package:geo_match_flutter/geo_match_flutter.dart';

void main() {
  group('GeoUtils.calculateDistance', () {
    test('returns ~0 for same coordinates', () {
      final dist = GeoUtils.calculateDistance(40.7128, -74.0060, 40.7128, -74.0060);
      expect(dist, closeTo(0.0, 0.001));
    });

    test('calculates known distance between NYC and LA (~3940 km)', () {
      final dist = GeoUtils.calculateDistance(40.7128, -74.0060, 34.0522, -118.2437);
      expect(dist, closeTo(3940, 50));
    });

    test('throws InvalidCoordinateException for bad latitude', () {
      expect(
        () => GeoUtils.calculateDistance(91.0, 0.0, 0.0, 0.0),
        throwsA(isA<InvalidCoordinateException>()),
      );
    });

    test('throws InvalidCoordinateException for bad longitude', () {
      expect(
        () => GeoUtils.calculateDistance(0.0, 181.0, 0.0, 0.0),
        throwsA(isA<InvalidCoordinateException>()),
      );
    });
  });
}
