import 'package:flutter/foundation.dart';
import 'package:flutter/rendering.dart';

class MapViewportPainter extends CustomPainter {
  MapViewportPainter({
    required this.painter,
    required this.sceneSize,
    required this.transform,
  }) : super(repaint: Listenable.merge([painter, ?transform]));

  final CustomPainter painter;
  final Size sceneSize;
  final ValueListenable<Matrix4>? transform;

  @override
  void paint(Canvas canvas, Size size) {
    canvas
      ..save()
      ..clipRect(Offset.zero & size);
    if (transform case final camera?) canvas.transform(camera.value.storage);
    painter.paint(canvas, sceneSize);
    canvas.restore();
  }

  @override
  bool shouldRepaint(MapViewportPainter oldDelegate) =>
      sceneSize != oldDelegate.sceneSize ||
      transform != oldDelegate.transform ||
      painter.runtimeType != oldDelegate.painter.runtimeType ||
      painter.shouldRepaint(oldDelegate.painter);
}
