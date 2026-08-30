import 'dart:math' as math;

import 'package:rtu_mirea_app/friends/cubit/geo_fix.dart';

class GeoFusionFilter {
  GeoFusionFilter({
    this.processNoiseMps = 3,
    this.teleportSpeedMps = 70,
    this.teleportResetStreak = 3,
  });

  final double processNoiseMps;
  final double teleportSpeedMps;
  final int teleportResetStreak;

  double? _latitude;
  double? _longitude;
  double _varianceM2 = 0;
  DateTime? _timestamp;
  int _teleportStreak = 0;

  GeoFix? get estimate {
    final latitude = _latitude;
    final longitude = _longitude;
    final timestamp = _timestamp;
    if (latitude == null || longitude == null || timestamp == null) {
      return null;
    }
    return GeoFix(
      latitude: latitude,
      longitude: longitude,
      accuracyM: math.max(3, math.sqrt(_varianceM2)),
      timestamp: timestamp,
    );
  }

  GeoFix? add(GeoFix fix) {
    if (!fix.latitude.isFinite || !fix.longitude.isFinite) return null;
    final accuracy = (fix.accuracyM.isFinite && fix.accuracyM > 0)
        ? math.max(fix.accuracyM, 3).toDouble()
        : 100.0;
    final latitude = _latitude;
    final longitude = _longitude;
    final timestamp = _timestamp;
    if (latitude == null || longitude == null || timestamp == null) {
      _seed(fix, accuracy);
      return estimate;
    }
    final deltaMs = fix.timestamp.difference(timestamp).inMilliseconds;
    if (deltaMs < 0) return null;
    final deltaSeconds = math.max(deltaMs / 1000, 0.05);
    final distance = distanceMeters(
      latitude,
      longitude,
      fix.latitude,
      fix.longitude,
    );
    if (_isTeleport(distance, deltaSeconds, accuracy)) {
      _teleportStreak++;
      if (_teleportStreak < teleportResetStreak) return null;
      _seed(fix, accuracy);
      return estimate;
    }
    _teleportStreak = 0;
    final processNoise = math.max(processNoiseMps, fix.speedMps ?? 0);
    final predictedVariance =
        _varianceM2 + deltaSeconds * processNoise * processNoise;
    final gain = predictedVariance / (predictedVariance + accuracy * accuracy);
    _latitude = latitude + gain * (fix.latitude - latitude);
    _longitude = longitude + gain * (fix.longitude - longitude);
    _varianceM2 = predictedVariance * (1 - gain);
    _timestamp = fix.timestamp;
    return estimate;
  }

  bool _isTeleport(double distance, double deltaSeconds, double accuracy) {
    final gateRadius = 3 * (math.sqrt(_varianceM2) + accuracy);
    return distance / deltaSeconds > teleportSpeedMps && distance > gateRadius;
  }

  void _seed(GeoFix fix, double accuracy) {
    _latitude = fix.latitude;
    _longitude = fix.longitude;
    _varianceM2 = accuracy * accuracy;
    _timestamp = fix.timestamp;
    _teleportStreak = 0;
  }

  static double distanceMeters(
    double latitudeFirst,
    double longitudeFirst,
    double latitudeSecond,
    double longitudeSecond,
  ) {
    const earthRadiusM = 6371000.0;
    final latitudeDelta = _radians(latitudeSecond - latitudeFirst);
    final longitudeDelta = _radians(longitudeSecond - longitudeFirst);
    final a =
        math.pow(math.sin(latitudeDelta / 2), 2) +
        math.cos(_radians(latitudeFirst)) *
            math.cos(_radians(latitudeSecond)) *
            math.pow(math.sin(longitudeDelta / 2), 2);
    return 2 * earthRadiusM * math.asin(math.min(1, math.sqrt(a)));
  }

  static double _radians(double degrees) => degrees * math.pi / 180;
}
