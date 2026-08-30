import 'dart:math' as math;

import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';

class AppProgressRing extends StatelessWidget {
  const AppProgressRing({
    required this.value,
    super.key,
    this.size = 56,
    this.strokeWidth = 5,
    this.color,
    this.trackColor,
    this.label,
    this.sublabel,
  });

  final double value;
  final double size;
  final double strokeWidth;
  final Color? color;
  final Color? trackColor;
  final String? label;
  final String? sublabel;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colors;
    final arc = colors.primary;
    final track = colors.surfaceHigh;

    return Semantics(
      label: sublabel,
      value: label ?? '${(value.clamp(0, 1) * 100).round()}%',
      child: ExcludeSemantics(
        child: SizedBox(
          width: size,
          height: size,
          child: Stack(
            alignment: Alignment.center,
            children: [
              CustomPaint(
                size: Size.square(size),
                painter: _RingPainter(
                  value: value.clamp(0.0, 1.0),
                  arcColor: color ?? arc,
                  trackColor: trackColor ?? track,
                  strokeWidth: strokeWidth,
                ),
              ),
              if (label != null || sublabel != null)
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (label != null)
                      Text(
                        label!,
                        style: AppText.tabular(
                          TextStyle(
                            fontSize: size * 0.24,
                            fontWeight: FontWeight.w700,
                            color: colors.active,
                            height: 1,
                          ),
                        ),
                      ),
                    if (sublabel != null)
                      Text(
                        sublabel!,
                        style: AppText.overline.copyWith(
                          color: colors.deactive,
                          fontSize: 8,
                        ),
                      ),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _RingPainter extends CustomPainter {
  const _RingPainter({
    required this.value,
    required this.arcColor,
    required this.trackColor,
    required this.strokeWidth,
  });

  final double value;
  final Color arcColor;
  final Color trackColor;
  final double strokeWidth;

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.width - strokeWidth) / 2;
    final rect = Rect.fromCircle(center: center, radius: radius);

    canvas
      ..drawCircle(
        center,
        radius,
        Paint()
          ..color = trackColor
          ..strokeWidth = strokeWidth
          ..style = PaintingStyle.stroke
          ..strokeCap = StrokeCap.round,
      )
      ..drawArc(
        rect,
        -math.pi / 2,
        2 * math.pi * value,
        false,
        Paint()
          ..color = arcColor
          ..strokeWidth = strokeWidth
          ..style = PaintingStyle.stroke
          ..strokeCap = StrokeCap.round,
      );
  }

  @override
  bool shouldRepaint(_RingPainter old) =>
      old.value != value ||
      old.arcColor != arcColor ||
      old.trackColor != trackColor ||
      old.strokeWidth != strokeWidth;
}
