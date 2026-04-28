import 'package:flutter_test/flutter_test.dart';
import 'package:geo_match_flutter/geo_match_flutter.dart';

void main() {
  final matcher = GeoMatcher();

  final target = GeoUser(id: 'target', latitude: 40.7128, longitude: -74.0060);

  final agents = [
    GeoUser(id: 'agent_far', latitude: 40.7300, longitude: -74.0200, available: true),
    GeoUser(id: 'agent_near', latitude: 40.7130, longitude: -74.0062, available: true),
    GeoUser(id: 'agent_unavailable', latitude: 40.7129, longitude: -74.0061, available: false),
  ];

  group('GeoMatcher.findNearest', () {
    test('returns nearest available agent', () {
      final result = matcher.findNearest(target, agents);
      expect(result?.id, 'agent_near');
    });

    test('returns null for empty list', () {
      expect(matcher.findNearest(target, []), isNull);
    });

    test('ignores unavailable agents', () {
      final onlyUnavailable = [
        GeoUser(id: 'u1', latitude: 40.7129, longitude: -74.0061, available: false),
      ];
      expect(matcher.findNearest(target, onlyUnavailable), isNull);
    });

    test('excludes target itself from results', () {
      final result = matcher.findNearest(target, [target]);
      expect(result, isNull);
    });
  });

  group('GeoMatcher.findTopNearest', () {
    test('returns top N sorted by distance', () {
      final result = matcher.findTopNearest(target, agents, 2);
      expect(result.length, 2);
      expect(result.first.id, 'agent_near');
    });

    test('returns all available if N > available count', () {
      final result = matcher.findTopNearest(target, agents, 10);
      expect(result.length, 2); // only 2 available
    });
  });

  group('GeoMatcher.findWithinRadius', () {
    test('returns agents within radius', () {
      // agent_near is ~0.03 km away, agent_far is ~2+ km away
      final result = matcher.findWithinRadius(target, agents, 0.1);
      expect(result.map((a) => a.id), contains('agent_near'));
      expect(result.map((a) => a.id), isNot(contains('agent_far')));
    });

    test('returns empty list when no agents in radius', () {
      final result = matcher.findWithinRadius(target, agents, 0.001);
      expect(result, isEmpty);
    });
  });

  group('GeoMatcher.matchStream', () {
    test('emits nearest agent from stream', () async {
      final controller = Stream.value(agents);
      final results = await matcher.matchStream(controller, target).first;
      expect(results?.id, 'agent_near');
    });

    test('emits null when no agents available', () async {
      final stream = Stream.value(<GeoUser>[]);
      final result = await matcher.matchStream(stream, target).first;
      expect(result, isNull);
    });
  });
}
