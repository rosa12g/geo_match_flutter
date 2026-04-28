# Changelog

All notable changes to this project will be documented in this file.

The format is based on Keep a Changelog (https://keepachangelog.com/).

---

## [1.0.0] - 2026-04-28

### Added
- 📍 GeoUser model with `copyWith()` support and optional metadata
- 📏 Haversine distance calculation via `GeoUtils.calculateDistance()`
- 🎯 GeoMatcher core engine:
  - Find nearest available agent
  - Find top-N nearest agents
  - Radius-based filtering
  - Custom scoring (distance + metadata support)
  - Realtime stream matching support
- 📦 GeoAssigner system:
  - Assign nearest agent automatically
  - Manual assignment support
  - Assignment lookup by request ID
  - Unassign and clear all functionality
- ⚠️ Custom exceptions:
  - GeoException (base exception)
  - NoAgentsAvailableException
  - InvalidCoordinateException
- 🐛 Debug mode with console logging for matching decisions
- 🧪 19 unit tests covering:
  - nearest matching
  - radius filtering
  - stream matching
  - assignment system
  - edge cases and validation

---

## [Unreleased]
- Future improvements and optimizations