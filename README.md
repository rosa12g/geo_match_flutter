# geo_match_flutter

A realtime location matching engine for Flutter. Finds and assigns the nearest available agent to a target — built for ride-hailing, delivery, and dispatch apps.

[![pub version](https://img.shields.io/pub/v/geo_match_flutter.svg)](https://pub.dev/packages/geo_match_flutter)
[![license](https://img.shields.io/badge/license-MIT-blue.svg)](LICENSE)

---

## Install

```yaml
dependencies:
  geo_match_flutter: ^1.0.0
```

---

## Quick Start

```dart
import 'package:geo_match_flutter/geo_match_flutter.dart';

final matcher = GeoMatcher();

final rider = GeoUser(id: 'rider_1', latitude: 40.7128, longitude: -74.0060);
final agents = [
  GeoUser(id: 'driver_1', latitude: 40.7138, longitude: -74.0050),
  GeoUser(id: 'driver_2', latitude: 40.7300, longitude: -74.0200),
];

final nearest = matcher.findNearest(rider, agents);
print(nearest?.id); // driver_1
```

---

## Features

**Matching**

```dart
// Nearest available agent
matcher.findNearest(target, agents);

// Top N sorted by distance
matcher.findTopNearest(target, agents, 3);

// All agents within a radius (km)
matcher.findWithinRadius(target, agents, 5.0);

// Ranked by distance + rating metadata
matcher.findByCustomScore(target, agents, ratingWeight: 0.5);
```

**Realtime**

```dart
// Emits nearest agent whenever the agents list updates
matcher.matchStream(agentsStream, target).listen((agent) {
  print('Nearest: ${agent?.id}');
});
```

**Assignment**

```dart
final assigner = GeoAssigner();

assigner.assignNearest('req_001', target, agents); // auto-find + assign
assigner.assign('req_002', specificAgent);         // manual assign

assigner.getAssignment('req_001'); // → 'driver_1'
assigner.unassign('req_001');
```

**Distance**

```dart
final km = GeoUtils.calculateDistance(40.7128, -74.0060, 34.0522, -118.2437);
// → ~3940.0
```

---

## GeoUser

```dart
GeoUser(
  id: 'driver_1',
  latitude: 40.7128,
  longitude: -74.0060,
  available: true,
  metadata: {'rating': 4.9, 'vehicle': 'sedan'},
);

// Immutable update
driver.copyWith(available: false);
```

---

## Debug Mode

```dart
final matcher = GeoMatcher(debugMode: true);
// Prints distances and selected agent to console
```

---

## Tests

```bash
flutter test
```

---

## License

MIT
