import 'package:flutter_test/flutter_test.dart';
import 'package:geo_match_flutter/geo_match_flutter.dart';

void main() {
  late GeoAssigner assigner;

  setUp(() {
    assigner = GeoAssigner();
  });

  group('GeoAssigner', () {
    test('assigns agent to request', () {
      final agent = GeoUser(id: 'agent_1', latitude: 40.7128, longitude: -74.0060);
      assigner.assign('req_1', agent);
      expect(assigner.getAssignment('req_1'), 'agent_1');
    });

    test('throws when assigning unavailable agent', () {
      final agent = GeoUser(
        id: 'agent_1',
        latitude: 40.7128,
        longitude: -74.0060,
        available: false,
      );
      expect(() => assigner.assign('req_1', agent), throwsA(isA<GeoException>()));
    });

    test('assignNearest finds and assigns nearest agent', () {
      final target = GeoUser(id: 'target', latitude: 40.7128, longitude: -74.0060);
      final agents = [
        GeoUser(id: 'agent_1', latitude: 40.7130, longitude: -74.0062),
        GeoUser(id: 'agent_2', latitude: 40.7200, longitude: -74.0100),
      ];

      final assigned = assigner.assignNearest('req_1', target, agents);
      expect(assigned?.id, 'agent_1');
      expect(assigner.getAssignment('req_1'), 'agent_1');
    });

    test('unassign removes assignment', () {
      final agent = GeoUser(id: 'agent_1', latitude: 40.7128, longitude: -74.0060);
      assigner.assign('req_1', agent);
      assigner.unassign('req_1');
      expect(assigner.getAssignment('req_1'), isNull);
    });

    test('clearAll removes all assignments', () {
      final agent = GeoUser(id: 'agent_1', latitude: 40.7128, longitude: -74.0060);
      assigner.assign('req_1', agent);
      assigner.assign('req_2', agent);
      assigner.clearAll();
      expect(assigner.assignments, isEmpty);
    });
  });
}
