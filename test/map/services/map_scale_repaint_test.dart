import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rtu_mirea_app/map/services/map_scale_repaint.dart';

class _Transform extends ValueNotifier<Matrix4> {
  _Transform() : super(Matrix4.identity());

  bool get listening => hasListeners;
}

void main() {
  test('pan and planar rotation do not invalidate scale-dependent paint', () {
    final transform = _Transform();
    final scale = MapScaleRepaint(transform);
    addTearDown(transform.dispose);
    addTearDown(scale.dispose);
    var invalidations = 0;
    scale.addListener(() => invalidations++);
    for (var frame = 0; frame < 60; frame++) {
      transform.value = Matrix4.identity()
        ..translateByDouble(frame.toDouble(), -frame.toDouble(), 0, 1)
        ..rotateZ(frame / 60);
    }
    expect(invalidations, 0);
    transform.value = Matrix4.identity()..scaleByDouble(.01, .01, 1, 1);
    expect(invalidations, 1);
    expect(scale.value, .01);
    transform.value = Matrix4.identity()..scaleByDouble(2, 3, 100, 1);
    expect(invalidations, 2);
    expect(scale.value, 3);
  });

  test('controller replacement and disposal release old listeners', () {
    final first = _Transform();
    final second = _Transform();
    addTearDown(first.dispose);
    addTearDown(second.dispose);
    final scale = MapScaleRepaint(first);
    expect(first.listening, isTrue);
    scale.updateTransform(second);
    expect(first.listening, isFalse);
    expect(second.listening, isTrue);
    first.value = Matrix4.identity()..scaleByDouble(20, 20, 1, 1);
    expect(scale.value, 1);
    second.value = Matrix4.identity()..scaleByDouble(2, 2, 1, 1);
    expect(scale.value, 2);
    scale.updateTransform(null);
    expect(second.listening, isFalse);
    expect(scale.value, 1);
    scale.updateTransform(first);
    expect(scale.value, 20);
    scale.dispose();
    expect(first.listening, isFalse);
    first.value = Matrix4.identity();
  });

  test('invalid transforms fall back to a finite paint scale', () {
    final transform = _Transform();
    final scale = MapScaleRepaint(transform);
    addTearDown(transform.dispose);
    addTearDown(scale.dispose);
    transform.value = Matrix4.zero();
    expect(scale.value, 1);
    transform.value = Matrix4.identity()..setEntry(0, 0, double.nan);
    expect(scale.value, 1);
  });
}
