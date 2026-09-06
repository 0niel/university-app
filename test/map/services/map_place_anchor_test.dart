import 'dart:ui';

import 'package:flutter_test/flutter_test.dart';
import 'package:rtu_mirea_app/map/data/map_data_models.dart';
import 'package:rtu_mirea_app/map/services/map_place_anchor.dart';

void main() {
  final path = Path()..addRect(const Rect.fromLTWH(20, 20, 60, 60));
  MapPlaceData place(String kind, double x, double y) => MapPlaceData.fromJson({
    'id': 'point',
    'floor_id': 'one',
    'label': 'Место',
    'kind': kind,
    'x': x.isFinite ? x : x.toString(),
    'y': y.isFinite ? y : y.toString(),
  });

  test('published room anchor is used inside the unchanged polygon', () {
    final anchor = resolveMapPlaceAnchor(
      path,
      floorSize: const Size(200, 200),
      place: place('classroom', 30, 40),
    );
    expect(anchor.point, const Offset(30, 40));
    expect(anchor.detachedService, isFalse);
    expect(path.getBounds(), const Rect.fromLTWH(20, 20, 60, 60));
  });

  test('service anchor may move outside its former room', () {
    final anchor = resolveMapPlaceAnchor(
      path,
      floorSize: const Size(200, 200),
      place: place('atm', 150, 60),
    );
    expect(anchor.point, const Offset(150, 60));
    expect(anchor.detachedService, isTrue);
    expect(path.getBounds(), const Rect.fromLTWH(20, 20, 60, 60));
  });

  test('room anchor outside its polygon falls back inside', () {
    final anchor = resolveMapPlaceAnchor(
      path,
      floorSize: const Size(200, 200),
      place: place('room', 150, 60),
    );
    expect(anchor.point, const Offset(50, 50));
    expect(anchor.detachedService, isFalse);
  });

  test('room anchors cannot enter an evenodd courtyard hole', () {
    final courtyard = Path()
      ..fillType = PathFillType.evenOdd
      ..addRect(const Rect.fromLTWH(0, 0, 100, 100))
      ..addRect(const Rect.fromLTWH(30, 30, 40, 40));
    final anchor = resolveMapPlaceAnchor(
      courtyard,
      floorSize: const Size(200, 200),
      place: place('classroom', 50, 50),
    );
    expect(anchor.point, isNot(const Offset(50, 50)));
    expect(courtyard.contains(anchor.point!), isTrue);
  });

  for (final coordinates in [
    (double.nan, 60.0),
    (50.0, double.infinity),
    (-1.0, 50.0),
    (201.0, 50.0),
  ]) {
    test(
      'invalid service coordinates $coordinates fall back to source geometry',
      () {
        final anchor = resolveMapPlaceAnchor(
          path,
          floorSize: const Size(200, 200),
          place: place('atm', coordinates.$1, coordinates.$2),
        );
        expect(anchor.point, const Offset(50, 50));
        expect(anchor.detachedService, isFalse);
      },
    );
  }
}
