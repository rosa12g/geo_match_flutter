import '../models/geo_user.dart';
import 'geo_utils.dart';

/// Handles all matching logic for finding nearby available agents.
class GeoMatcher {
  /// When true, logs matching steps to the console.
  final bool debugMode;

  const GeoMatcher({this.debugMode = false});

  /// Returns the nearest available agent to [target], or null if none found.
  GeoUser? findNearest(GeoUser target, List<GeoUser> agents) {
    final available = agents.where((a) => a.available && a.id != target.id).toList();

    if (available.isEmpty) {
      _log('No available agents found.');
      return null;
    }

    GeoUser? nearest;
    double minDistance = double.infinity;

    for (final agent in available) {
      final dist = GeoUtils.calculateDistance(
        target.latitude, target.longitude,
        agent.latitude, agent.longitude,
      );
      _log('Agent ${agent.id}: ${dist.toStringAsFixed(3)} km');

      if (dist < minDistance) {
        minDistance = dist;
        nearest = agent;
      }
    }

    _log('Selected: ${nearest?.id} at ${minDistance.toStringAsFixed(3)} km');
    return nearest;
  }

  /// Returns the top [n] nearest available agents to [target], sorted by distance.
  List<GeoUser> findTopNearest(GeoUser target, List<GeoUser> agents, int n) {
    final available = agents.where((a) => a.available && a.id != target.id).toList();

    if (available.isEmpty) return [];

    final sorted = _sortByDistance(target, available);
    return sorted.take(n).toList();
  }

  /// Returns all available agents within [radiusKm] kilometers of [target].
  List<GeoUser> findWithinRadius(
    GeoUser target,
    List<GeoUser> agents,
    double radiusKm,
  ) {
    final available = agents.where((a) => a.available && a.id != target.id);

    return available.where((agent) {
      final dist = GeoUtils.calculateDistance(
        target.latitude, target.longitude,
        agent.latitude, agent.longitude,
      );
      _log('Agent ${agent.id}: ${dist.toStringAsFixed(3)} km (radius: $radiusKm km)');
      return dist <= radiusKm;
    }).toList();
  }

  /// Returns agents sorted by a custom score: weighted distance + optional rating.
  ///
  /// [ratingWeight] controls how much the metadata `rating` field influences ranking.
  /// Lower score = better match.
  List<GeoUser> findByCustomScore(
    GeoUser target,
    List<GeoUser> agents, {
    double ratingWeight = 0.3,
  }) {
    final available = agents.where((a) => a.available && a.id != target.id).toList();

    if (available.isEmpty) return [];

    return available..sort((a, b) {
      final distA = GeoUtils.calculateDistance(
        target.latitude, target.longitude, a.latitude, a.longitude);
      final distB = GeoUtils.calculateDistance(
        target.latitude, target.longitude, b.latitude, b.longitude);

      final ratingA = (a.metadata?['rating'] as num?)?.toDouble() ?? 0.0;
      final ratingB = (b.metadata?['rating'] as num?)?.toDouble() ?? 0.0;

      // Lower distance is better; higher rating is better (invert rating contribution)
      final scoreA = distA - (ratingA * ratingWeight);
      final scoreB = distB - (ratingB * ratingWeight);

      return scoreA.compareTo(scoreB);
    });
  }

  /// Emits the nearest available agent whenever [agentsStream] emits a new list.
  Stream<GeoUser?> matchStream(
    Stream<List<GeoUser>> agentsStream,
    GeoUser target,
  ) {
    return agentsStream.map((agents) => findNearest(target, agents));
  }

  List<GeoUser> _sortByDistance(GeoUser target, List<GeoUser> agents) {
    return agents..sort((a, b) {
      final distA = GeoUtils.calculateDistance(
        target.latitude, target.longitude, a.latitude, a.longitude);
      final distB = GeoUtils.calculateDistance(
        target.latitude, target.longitude, b.latitude, b.longitude);
      return distA.compareTo(distB);
    });
  }

  void _log(String message) {
    if (debugMode) print('[GeoMatcher] $message');
  }
}
