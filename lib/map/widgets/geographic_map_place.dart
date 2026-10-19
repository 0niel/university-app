import 'package:flutter/foundation.dart';
import 'package:latlong2/latlong.dart';

class GeographicMapPlace {
  const GeographicMapPlace({
    required this.label,
    required this.position,
    required this.onTap,
  });

  final String label;
  final LatLng position;
  final VoidCallback onTap;
}
