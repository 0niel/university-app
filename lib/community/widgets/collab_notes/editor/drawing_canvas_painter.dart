import 'package:flutter/rendering.dart';
import 'package:rtu_mirea_app/community/widgets/collab_notes/editor/drawing_stroke.dart';

class DrawingCanvasPainter extends CustomPainter {
  const DrawingCanvasPainter({
    required this.strokes,
    required this.backgroundColor,
    this.canvasSize,
    this.offset = Offset.zero,
    this.scale = 1,
    this.paths = const {},
  });

  final List<DrawingStroke> strokes;
  final Color backgroundColor;
  final Size? canvasSize;
  final Offset offset;
  final double scale;
  final Map<DrawingStroke, Path> paths;

  static Path pathFor(DrawingStroke stroke) {
    final outline = stroke.outline();
    if (outline.isEmpty) return Path();
    return Path()..addPolygon(outline, true);
  }

  @override
  void paint(Canvas canvas, Size size) {
    canvas
      ..save()
      ..clipRect(Offset.zero & size)
      ..translate(offset.dx, offset.dy)
      ..scale(scale);
    final bounds = Offset.zero & (canvasSize ?? size);
    canvas
      ..drawRect(bounds, Paint()..color = backgroundColor)
      ..clipRect(bounds)
      ..saveLayer(bounds, Paint());
    for (final stroke in strokes) {
      canvas.drawPath(
        paths[stroke] ?? pathFor(stroke),
        Paint()
          ..color = stroke.color
          ..style = PaintingStyle.fill
          ..blendMode = stroke.isEraser ? BlendMode.clear : BlendMode.srcOver,
      );
    }
    canvas
      ..restore()
      ..restore();
  }

  @override
  bool shouldRepaint(covariant DrawingCanvasPainter oldDelegate) =>
      !identical(oldDelegate.strokes, strokes) ||
      oldDelegate.canvasSize != canvasSize ||
      oldDelegate.offset != offset ||
      oldDelegate.scale != scale ||
      oldDelegate.backgroundColor != backgroundColor;
}
