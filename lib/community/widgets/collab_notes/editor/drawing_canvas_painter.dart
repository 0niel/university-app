import 'package:flutter/rendering.dart';
import 'package:rtu_mirea_app/community/widgets/collab_notes/editor/drawing_stroke.dart';

class DrawingCanvasPainter extends CustomPainter {
  const DrawingCanvasPainter({
    required this.strokes,
    required this.backgroundColor,
  });

  final List<DrawingStroke> strokes;
  final Color backgroundColor;

  @override
  void paint(Canvas canvas, Size size) {
    final bounds = Offset.zero & size;
    canvas
      ..drawRect(bounds, Paint()..color = backgroundColor)
      ..saveLayer(bounds, Paint());
    for (final stroke in strokes) {
      final outline = stroke.outline();
      if (outline.isEmpty) continue;
      final path = Path()..moveTo(outline.first.dx, outline.first.dy);
      for (final point in outline.skip(1)) {
        path.lineTo(point.dx, point.dy);
      }
      path.close();
      canvas.drawPath(
        path,
        Paint()
          ..color = stroke.color
          ..style = PaintingStyle.fill
          ..blendMode = stroke.isEraser ? BlendMode.clear : BlendMode.srcOver,
      );
    }
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant DrawingCanvasPainter oldDelegate) =>
      !identical(oldDelegate.strokes, strokes) ||
      oldDelegate.backgroundColor != backgroundColor;
}
