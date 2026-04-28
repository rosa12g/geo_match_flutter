# Changelog

All notable changes to this project will be documented in this file.

## [1.0.0] - 2026-04-28

Initial release.

- `GeoUser` model with `copyWith()` and optional metadata
- Haversine distance calculation via `GeoUtils.calculateDistance()`
- `GeoMatcher` — nearest, top-N, radius, custom score, and stream matching
- `GeoAssigner` — in-memory request-to-agent assignment management
- `GeoException`, `NoAgentsAvailableException`, `InvalidCoordinateException`
- Debug mode with console logging
- 19 unit tests
