/// geo_match_flutter — A realtime location matching engine for Flutter.
///
/// Finds and assigns the nearest available user (agent) to a target,
/// suitable for ride-hailing, delivery, or emergency dispatch apps.
///
/// ## Quick Start
/// ```dart
/// import 'package:geo_match_flutter/geo_match_flutter.dart';
///
/// final matcher = GeoMatcher(debugMode: true);
/// final target = GeoUser(id: 'req_1', latitude: 40.7128, longitude: -74.0060);
/// final agents = [
///   GeoUser(id: 'agent_1', latitude: 40.7138, longitude: -74.0050),
///   GeoUser(id: 'agent_2', latitude: 40.7200, longitude: -74.0100),
/// ];
///
/// final nearest = matcher.findNearest(target, agents);
/// print(nearest); // GeoUser(id: agent_1, ...)
/// ```
library geo_match_flutter;

export 'src/models/geo_user.dart';
export 'src/core/geo_utils.dart';
export 'src/core/geo_matcher.dart';
export 'src/core/geo_assigner.dart';
export 'src/exceptions/geo_exception.dart';
