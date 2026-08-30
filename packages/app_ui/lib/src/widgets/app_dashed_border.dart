import 'dart:math' as math;

import 'package:flutter/material.dart';

/// {@template app_dashed_border}
/// Paints a dashed rounded-rectangle border around [child].
///
/// Used for "dropzone"-style affordances (file pickers, both-free slots) where
/// the dashed outline signals an empty / actionable area, per the design.
/// {@endtemplate}
class AppDashedBorder extends StatelessWidget {
  /// {@macro app_dashed_border}
  const AppDashedBorder({
    required this.color,
    required this.radius,
    required this.child,
    this.strokeWidth = 2,
    super.key,
  });

  /// Colour of the dashes.
  final Color color;

  /// Corner radius of the border (and the clip applied to [child]).
  final double radius;

  /// Thickness of the dashes.
  final double strokeWidth;

  /// Content drawn inside the border.
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      foregroundPainter: _DashedRRectPainter(
        color: color,
        radius: radius,
        strokeWidth: strokeWidth,
      ),
      child: child,
    );
  }
}

class _DashedRRectPainter extends CustomPainter {
  const _DashedRRectPainter({
    required this.color,
    required this.radius,
    required this.strokeWidth,
  });

  final Color color;
  final double radius;
  final double strokeWidth;

  static const double _dash = 5;
  static const double _gap = 4;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth;

    final rrect = RRect.fromRectAndRadius(
      Offset.zero & size,
      Radius.circular(radius),
    );
    final path = Path()..addRRect(rrect);

    for (final metric in path.computeMetrics()) {
      var distance = 0.0;
      while (distance < metric.length) {
        final next = math.min(distance + _dash, metric.length);
        canvas.drawPath(metric.extractPath(distance, next), paint);
        distance = next + _gap;
      }
    }
  }

  @override
  bool shouldRepaint(_DashedRRectPainter oldDelegate) {
    return oldDelegate.color != color ||
        oldDelegate.radius != radius ||
        oldDelegate.strokeWidth != strokeWidth;
  }
}
