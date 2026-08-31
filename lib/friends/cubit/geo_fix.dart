class GeoFix {
  const GeoFix({
    required this.latitude,
    required this.longitude,
    required this.accuracyM,
    required this.timestamp,
    this.speedMps,
  });

  final double latitude;
  final double longitude;
  final double accuracyM;
  final DateTime timestamp;
  final double? speedMps;
}
