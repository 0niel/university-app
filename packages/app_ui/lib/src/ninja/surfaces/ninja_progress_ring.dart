import 'dart:math' as math;

import 'package:app_ui/src/ninja/ninja_colors.dart';
import 'package:app_ui/src/ninja/ninja_text.dart';
import 'package:flutter/widgets.dart';

class NinjaProgressRing extends StatelessWidget {
  const NinjaProgressRing({
    required this.value,
    super.key,
    this.size = 56,
    this.holeSize = 42,
    this.label,
  });
  final double value;
  final double size;
  final double holeSize;
  final String? label;

  @override
  Widget build(BuildContext context) {
    final colors = context.ninja;
    final progress = value.clamp(0.0, 1.0);
    return SizedBox(
      width: size,
      height: size,
      child: CustomPaint(
        painter: _NinjaRingPainter(
          value: progress,
          track: colors.surface,
          fill: colors.ink,
          hole: colors.canvas,
          holeSize: holeSize,
        ),
        child: Center(
          child: Text(
            label ?? '${(progress * 100).round()}%',
            style: NinjaText.tabular(
              TextStyle(
                fontFamily: NinjaText.family,
                fontSize: 12,
                fontWeight: FontWeight.w800,
                color: colors.ink,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _NinjaRingPainter extends CustomPainter {
  const _NinjaRingPainter({
    required this.value,
    required this.track,
    required this.fill,
    required this.hole,
    required this.holeSize,
  });

  final double value;
  final Color track;
  final Color fill;
  final Color hole;
  final double holeSize;

  @override
  void paint(Canvas canvas, Size size) {
    final center = size.center(Offset.zero);
    final radius = size.shortestSide / 2;
    final rect = Rect.fromCircle(center: center, radius: radius);
    canvas
      ..drawCircle(center, radius, Paint()..color = track)
      ..drawArc(
        rect,
        -math.pi / 2,
        2 * math.pi * value,
        true,
        Paint()..color = fill,
      )
      ..drawCircle(center, holeSize / 2, Paint()..color = hole);
  }

  @override
  bool shouldRepaint(_NinjaRingPainter oldDelegate) =>
      oldDelegate.value != value ||
      oldDelegate.track != track ||
      oldDelegate.fill != fill ||
      oldDelegate.hole != hole ||
      oldDelegate.holeSize != holeSize;
}
