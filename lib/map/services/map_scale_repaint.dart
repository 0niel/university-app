import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:rtu_mirea_app/map/services/map_planar_scale.dart';

class MapScaleRepaint extends ValueNotifier<double> {
  MapScaleRepaint(ValueListenable<Matrix4>? transform)
    : _transform = transform,
      super(_scaleOf(transform)) {
    _transform?.addListener(_changed);
  }

  ValueListenable<Matrix4>? _transform;

  void updateTransform(ValueListenable<Matrix4>? transform) {
    if (identical(transform, _transform)) return;
    _transform?.removeListener(_changed);
    _transform = transform;
    _transform?.addListener(_changed);
    _changed();
  }

  void _changed() {
    final next = _scaleOf(_transform);
    if ((next - value).abs() > value * 1e-9) value = next;
  }

  static double _scaleOf(ValueListenable<Matrix4>? transform) {
    final scale = transform == null ? 1.0 : mapPlanarScale(transform.value);
    return scale.isFinite && scale > 0 ? scale : 1.0;
  }

  @override
  void dispose() {
    _transform?.removeListener(_changed);
    super.dispose();
  }
}
