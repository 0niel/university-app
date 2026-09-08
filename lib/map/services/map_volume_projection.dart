import 'dart:math' as math;

import 'package:flutter/widgets.dart';
import 'package:rtu_mirea_app/map/services/map_planar_scale.dart';

class MapVolumeProjection {
  MapVolumeProjection({
    required this.viewportSize,
    required Matrix4 transform,
    double bearing = 0,
    double pitch = .85,
    Offset? pivot,
  }) : pivot = pivot ?? viewportSize.center(Offset.zero),
       bearing = bearing.isFinite ? bearing : 0,
       pitch = pitch.isFinite ? pitch.clamp(0, 1.25) : .85 {
    final safe = transform.storage.every((value) => value.isFinite);
    final camera = safe && Matrix4.tryInvert(transform) != null
        ? transform
        : Matrix4.identity();
    final planarScale = mapPlanarScale(camera);
    scale = planarScale.isFinite && planarScale > 1e-9 ? planarScale : 1;
    final rotation = Matrix4.rotationZ(this.bearing);
    groundMatrix = Matrix4.identity()
      ..translateByDouble(this.pivot.dx, this.pivot.dy, 0, 1)
      ..scaleByDouble(1, math.cos(this.pitch), 1, 1)
      ..multiply(rotation)
      ..translateByDouble(-this.pivot.dx, -this.pivot.dy, 0, 1)
      ..multiply(camera);
    inverseGroundMatrix = Matrix4.tryInvert(groundMatrix) ?? Matrix4.identity();
  }

  final Size viewportSize;
  final Offset pivot;
  final double bearing;
  final double pitch;
  late final double scale;
  late final Matrix4 groundMatrix;
  late final Matrix4 inverseGroundMatrix;

  Offset sceneToScreen(Offset point, {double height = 0}) {
    final ground = MatrixUtils.transformPoint(groundMatrix, point);
    return ground - Offset(0, height * scale * math.sin(pitch));
  }

  Offset screenToScene(Offset point) =>
      MatrixUtils.transformPoint(inverseGroundMatrix, point);

  Offset screenDeltaToScene(Offset delta) =>
      screenToScene(pivot + delta) - screenToScene(pivot);

  Rect get visibleSceneBounds {
    final bounds = Offset.zero & viewportSize;
    final points = [
      screenToScene(bounds.topLeft),
      screenToScene(bounds.topRight),
      screenToScene(bounds.bottomLeft),
      screenToScene(bounds.bottomRight),
    ];
    return Rect.fromLTRB(
      points.map((point) => point.dx).reduce(math.min),
      points.map((point) => point.dy).reduce(math.min),
      points.map((point) => point.dx).reduce(math.max),
      points.map((point) => point.dy).reduce(math.max),
    );
  }
}
