/// Represents a user or agent with a geographic location.
class GeoUser {
  /// Unique identifier for this user.
  final String id;

  /// Latitude in decimal degrees.
  final double latitude;

  /// Longitude in decimal degrees.
  final double longitude;

  /// Whether this user is currently available for assignment.
  final bool available;

  /// Optional metadata (e.g., rating, vehicle type, name).
  final Map<String, dynamic>? metadata;

  const GeoUser({
    required this.id,
    required this.latitude,
    required this.longitude,
    this.available = true,
    this.metadata,
  });

  /// Returns a copy of this [GeoUser] with the given fields replaced.
  GeoUser copyWith({
    String? id,
    double? latitude,
    double? longitude,
    bool? available,
    Map<String, dynamic>? metadata,
  }) {
    return GeoUser(
      id: id ?? this.id,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      available: available ?? this.available,
      metadata: metadata ?? this.metadata,
    );
  }

  @override
  String toString() =>
      'GeoUser(id: $id, lat: $latitude, lon: $longitude, available: $available)';

  @override
  bool operator ==(Object other) =>
      identical(this, other) || (other is GeoUser && other.id == id);

  @override
  int get hashCode => id.hashCode;
}
