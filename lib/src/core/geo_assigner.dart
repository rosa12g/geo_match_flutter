import '../models/geo_user.dart';
import '../exceptions/geo_exception.dart';
import 'geo_matcher.dart';

/// Manages assignment of agents to requests.
///
/// Stores assignments in memory as a [Map] of requestId → agentId.
class GeoAssigner {
  final GeoMatcher _matcher;
  final Map<String, String> _assignments = {};

  GeoAssigner({GeoMatcher? matcher})
      : _matcher = matcher ?? const GeoMatcher();

  /// All current assignments (requestId → agentId).
  Map<String, String> get assignments => Map.unmodifiable(_assignments);

  /// Assigns [agent] to [requestId].
  ///
  /// Throws [GeoException] if the agent is not available.
  void assign(String requestId, GeoUser agent) {
    if (!agent.available) {
      throw GeoException(
          'Agent ${agent.id} is not available for assignment.');
    }
    _assignments[requestId] = agent.id;
  }

  /// Finds the nearest available agent from [agents] and assigns them to [requestId].
  ///
  /// Returns the assigned [GeoUser], or null if no agents are available.
  GeoUser? assignNearest(
    String requestId,
    GeoUser target,
    List<GeoUser> agents,
  ) {
    final nearest = _matcher.findNearest(target, agents);
    if (nearest != null) {
      _assignments[requestId] = nearest.id;
    }
    return nearest;
  }

  /// Returns the agent ID assigned to [requestId], or null if unassigned.
  String? getAssignment(String requestId) => _assignments[requestId];

  /// Removes the assignment for [requestId].
  void unassign(String requestId) => _assignments.remove(requestId);

  /// Clears all assignments.
  void clearAll() => _assignments.clear();
}
