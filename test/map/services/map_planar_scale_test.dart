import 'dart:math' as math;

import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rtu_mirea_app/map/services/map_planar_scale.dart';

void main() {
  test('zoomed-out floor ignores unchanged Z axis', () {
    final matrix = Matrix4.identity()..scaleByDouble(.16, .16, 1, 1);
    expect(mapPlanarScale(matrix), closeTo(.16, 1e-12));
  });

  test('rotation and pan preserve annotation screen scale', () {
    final matrix = Matrix4.identity()
      ..translateByDouble(120, -90, 0, 1)
      ..rotateZ(math.pi / 3)
      ..scaleByDouble(2.5, 2.5, 1, 1);
    expect(mapPlanarScale(matrix), closeTo(2.5, 1e-12));
  });

  test('geographic affine plan uses the larger projected axis', () {
    final matrix = Matrix4.identity()
      ..setEntry(0, 0, .3)
      ..setEntry(1, 0, .4)
      ..setEntry(1, 1, .2);
    expect(mapPlanarScale(matrix), closeTo(.5, 1e-12));
  });
}
