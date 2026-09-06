import 'dart:math' as math;

class FloorPoint {
  const FloorPoint(this.x, this.y);

  final double x;
  final double y;
}

class GeographicCoordinate {
  const GeographicCoordinate(this.latitude, this.longitude);

  final double latitude;
  final double longitude;
}

class FloorGeoAnchor {
  const FloorGeoAnchor({
    required this.x,
    required this.y,
    required this.latitude,
    required this.longitude,
  });

  factory FloorGeoAnchor.fromJson(Map<String, dynamic> json) => FloorGeoAnchor(
    x: _finiteNumber(json, 'x'),
    y: _finiteNumber(json, 'y'),
    latitude: _finiteNumber(json, 'latitude'),
    longitude: _finiteNumber(json, 'longitude'),
  );

  final double x;
  final double y;
  final double latitude;
  final double longitude;
}

class FloorGeoreference {
  factory FloorGeoreference(List<FloorGeoAnchor> anchors) {
    if (anchors.length != 3) {
      throw const FormatException('A floor georeference needs three anchors');
    }
    for (final anchor in anchors) {
      if (!anchor.x.isFinite || !anchor.y.isFinite) {
        throw const FormatException('Anchor floor coordinates must be finite');
      }
      _validateGeographic(anchor.latitude, anchor.longitude);
    }
    final longitudes = anchors.map((anchor) => anchor.longitude);
    if (longitudes.reduce(math.max) - longitudes.reduce(math.min) > 180) {
      throw const FormatException('Floor anchors must not cross the date line');
    }
    final first = anchors[0];
    final p1 = FloorPoint(anchors[1].x - first.x, anchors[1].y - first.y);
    final p2 = FloorPoint(anchors[2].x - first.x, anchors[2].y - first.y);
    final pixelDeterminant = _determinant(p1, p2);
    _validateBasis(p1, p2, pixelDeterminant);
    final origin = _project(first.latitude, first.longitude);
    final projected1 = _project(anchors[1].latitude, anchors[1].longitude);
    final projected2 = _project(anchors[2].latitude, anchors[2].longitude);
    final q1 = FloorPoint(projected1.x - origin.x, projected1.y - origin.y);
    final q2 = FloorPoint(projected2.x - origin.x, projected2.y - origin.y);
    _validateBasis(q1, q2, _determinant(q1, q2));
    final a = (q1.x * p2.y - q2.x * p1.y) / pixelDeterminant;
    final b = (q2.x * p1.x - q1.x * p2.x) / pixelDeterminant;
    final c = (q1.y * p2.y - q2.y * p1.y) / pixelDeterminant;
    final d = (q2.y * p1.x - q1.y * p2.x) / pixelDeterminant;
    if (![a, b, c, d].every((value) => value.isFinite)) {
      throw const FormatException('The floor georeference is not finite');
    }
    _validateBasis(FloorPoint(a, c), FloorPoint(b, d), a * d - b * c);
    return FloorGeoreference._(
      FloorPoint(first.x, first.y),
      origin,
      a,
      b,
      c,
      d,
    );
  }

  factory FloorGeoreference.fromJson(Map<String, dynamic> json) {
    final anchors = json['anchors'];
    if (anchors is! List) {
      throw const FormatException('Expected a floor anchors array');
    }
    return FloorGeoreference(
      anchors.map((item) {
        if (item is! Map<String, dynamic>) {
          throw const FormatException('Expected floor anchor objects');
        }
        return FloorGeoAnchor.fromJson(item);
      }).toList(),
    );
  }

  const FloorGeoreference._(
    this._originPixel,
    this._originProjected,
    this._a,
    this._b,
    this._c,
    this._d,
  );

  static const _earthRadius = 6378137.0;
  static const _maximumLatitude = 85.0511287798066;
  static const double _radians = math.pi / 180;

  final FloorPoint _originPixel;
  final FloorPoint _originProjected;
  final double _a;
  final double _b;
  final double _c;
  final double _d;

  GeographicCoordinate pixelToGeographic(double x, double y) {
    if (!x.isFinite || !y.isFinite) {
      throw const FormatException('Floor coordinates must be finite');
    }
    final dx = x - _originPixel.x;
    final dy = y - _originPixel.y;
    final projectedX = _originProjected.x + _a * dx + _b * dy;
    final projectedY = _originProjected.y + _c * dx + _d * dy;
    final longitude = projectedX / _earthRadius / _radians;
    final latitude =
        (2 * math.atan(math.exp(projectedY / _earthRadius)) - math.pi / 2) /
        _radians;
    _validateGeographic(latitude, longitude);
    return GeographicCoordinate(latitude, longitude);
  }

  FloorPoint geographicToPixel(double latitude, double longitude) {
    _validateGeographic(latitude, longitude);
    final projected = _project(latitude, longitude);
    final dx = projected.x - _originProjected.x;
    final dy = projected.y - _originProjected.y;
    final determinant = _a * _d - _b * _c;
    final x = _originPixel.x + (_d * dx - _b * dy) / determinant;
    final y = _originPixel.y + (_a * dy - _c * dx) / determinant;
    if (!x.isFinite || !y.isFinite) {
      throw const FormatException('The inverse floor position is not finite');
    }
    return FloorPoint(x, y);
  }

  static FloorPoint _project(double latitude, double longitude) => FloorPoint(
    _earthRadius * longitude * _radians,
    _earthRadius * math.log(math.tan(math.pi / 4 + latitude * _radians / 2)),
  );

  static void _validateGeographic(double latitude, double longitude) {
    if (!latitude.isFinite ||
        !longitude.isFinite ||
        latitude.abs() > _maximumLatitude ||
        longitude.abs() > 180) {
      throw const FormatException('Coordinates are outside Web Mercator');
    }
  }

  static double _determinant(FloorPoint first, FloorPoint second) =>
      first.x * second.y - second.x * first.y;

  static void _validateBasis(
    FloorPoint first,
    FloorPoint second,
    double determinant,
  ) {
    final scale =
        math.sqrt(first.x * first.x + first.y * first.y) *
        math.sqrt(second.x * second.x + second.y * second.y);
    if (!scale.isFinite ||
        scale == 0 ||
        !determinant.isFinite ||
        determinant.abs() <= scale * 1e-10) {
      throw const FormatException('Floor anchors are collinear or degenerate');
    }
  }
}

double _finiteNumber(Map<String, dynamic> json, String key) {
  final value = json[key];
  if (value is! num || !value.isFinite) {
    throw FormatException('Expected a finite number for $key');
  }
  return value.toDouble();
}
