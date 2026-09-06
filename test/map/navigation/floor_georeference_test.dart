import 'package:flutter_test/flutter_test.dart';
import 'package:rtu_mirea_app/map/navigation/navigation.dart';

void main() {
  const anchors = [
    FloorGeoAnchor(x: 20, y: 30, latitude: 55.669, longitude: 37.480),
    FloorGeoAnchor(x: 520, y: 50, latitude: 55.6693, longitude: 37.482),
    FloorGeoAnchor(x: 50, y: 330, latitude: 55.668, longitude: 37.4804),
  ];

  test('maps all three control points exactly through Web Mercator', () {
    final transform = FloorGeoreference(anchors);
    for (final anchor in anchors) {
      final geo = transform.pixelToGeographic(anchor.x, anchor.y);
      final pixel = transform.geographicToPixel(
        anchor.latitude,
        anchor.longitude,
      );
      expect(geo.latitude, closeTo(anchor.latitude, 1e-10));
      expect(geo.longitude, closeTo(anchor.longitude, 1e-10));
      expect(pixel.x, closeTo(anchor.x, 1e-6));
      expect(pixel.y, closeTo(anchor.y, 1e-6));
    }
  });

  test(
    'round trips rotated and sheared floor points with subpixel precision',
    () {
      final transform = FloorGeoreference(anchors);
      for (var x = -250; x <= 1000; x += 50) {
        for (var y = -100; y <= 1000; y += 50) {
          final geo = transform.pixelToGeographic(x.toDouble(), y.toDouble());
          final pixel = transform.geographicToPixel(
            geo.latitude,
            geo.longitude,
          );
          expect(pixel.x, closeTo(x, 1e-6));
          expect(pixel.y, closeTo(y, 1e-6));
        }
      }
    },
  );

  test('parses the floor anchors backend contract', () {
    final transform = FloorGeoreference.fromJson({
      'anchors': anchors
          .map(
            (anchor) => {
              'x': anchor.x,
              'y': anchor.y,
              'latitude': anchor.latitude,
              'longitude': anchor.longitude,
            },
          )
          .toList(),
    });
    final point = transform.pixelToGeographic(20, 30);
    expect(point.latitude, closeTo(55.669, 1e-10));
    expect(point.longitude, closeTo(37.480, 1e-10));
  });

  test('rejects too few or too many anchors', () {
    expect(
      () => FloorGeoreference(anchors.take(2).toList()),
      throwsFormatException,
    );
    expect(
      () => FloorGeoreference([...anchors, anchors.first]),
      throwsFormatException,
    );
  });

  test('rejects collinear pixel anchors and repeated geographic points', () {
    expect(
      () => FloorGeoreference(const [
        FloorGeoAnchor(x: 0, y: 0, latitude: 55, longitude: 37),
        FloorGeoAnchor(x: 1, y: 1, latitude: 55.1, longitude: 37),
        FloorGeoAnchor(x: 2, y: 2, latitude: 55, longitude: 37.1),
      ]),
      throwsFormatException,
    );
    expect(
      () => FloorGeoreference(const [
        FloorGeoAnchor(x: 0, y: 0, latitude: 55, longitude: 37),
        FloorGeoAnchor(x: 1, y: 0, latitude: 55, longitude: 37),
        FloorGeoAnchor(x: 0, y: 1, latitude: 55, longitude: 37.1),
      ]),
      throwsFormatException,
    );
  });

  test('rejects nonfinite input and locations outside Mercator coverage', () {
    for (final latitude in [double.nan, double.infinity, 86.0, -90.0]) {
      expect(
        () => FloorGeoreference([
          FloorGeoAnchor(x: 0, y: 0, latitude: latitude, longitude: 37),
          anchors[1],
          anchors[2],
        ]),
        throwsFormatException,
      );
    }
    final transform = FloorGeoreference(anchors);
    expect(
      () => transform.pixelToGeographic(double.nan, 0),
      throwsFormatException,
    );
    expect(
      () => transform.geographicToPixel(90, 37),
      throwsFormatException,
    );
    expect(
      () => transform.geographicToPixel(55, 181),
      throwsFormatException,
    );
  });

  test('rejects date-line crossing instead of stretching a floor globally', () {
    expect(
      () => FloorGeoreference(const [
        FloorGeoAnchor(x: 0, y: 0, latitude: 55, longitude: 179.99),
        FloorGeoAnchor(x: 1, y: 0, latitude: 55, longitude: -179.99),
        FloorGeoAnchor(x: 0, y: 1, latitude: 55.001, longitude: 179.99),
      ]),
      throwsFormatException,
    );
  });
}
