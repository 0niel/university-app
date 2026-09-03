import 'dart:math' as math;

import 'package:app_ui/src/colors/colors.dart';
import 'package:app_ui/src/typography/typography.dart';
import 'package:flutter/widgets.dart';

class AppProgressRing extends StatelessWidget {
  const AppProgressRing({
    required this.value,
    super.key,
    this.size = 64,
    this.strokeWidth = 6,
    this.color,
    this.trackColor,
    this.label,
    this.sublabel,
    this.labelStyle,
  });

  final double value;
  final double size;
  final double strokeWidth;
  final Color? color;
  final Color? trackColor;
  final String? label;
  final String? sublabel;
  final TextStyle? labelStyle;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final label = this.label;
    final sublabel = this.sublabel;

    return Semantics(
      label: sublabel,
      value: label ?? '${(value.clamp(0, 1) * 100).round()}%',
      child: ExcludeSemantics(
        child: SizedBox.square(
          dimension: size,
          child: Stack(
            alignment: Alignment.center,
            children: [
              CustomPaint(
                size: Size.square(size),
                painter: _RingPainter(
                  value: value.clamp(0.0, 1.0),
                  arcColor: color ?? colors.accent,
                  trackColor: trackColor ?? colors.surface2,
                  strokeWidth: strokeWidth,
                ),
              ),
              if (label != null || sublabel != null)
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (label != null)
                      Text(
                        label,
                        style: (labelStyle ??
                                AppText.sans(
                                  size * 14 / 64,
                                  FontWeight.w800,
                                  height: 1,
                                  tabular: true,
                                ))
                            .copyWith(color: colors.ink),
                      ),
                    if (sublabel != null)
                      Text(
                        sublabel,
                        style: AppText.overline.copyWith(
                          fontSize: size * .13,
                          color: colors.muted,
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
    final radius = math.max<double>(
      0,
      (size.shortestSide - strokeWidth) / 2 - size.shortestSide / 32,
    );
    final rect = Rect.fromCircle(center: center, radius: radius);

    canvas.drawCircle(
      center,
      radius,
      Paint()
        ..color = trackColor
        ..strokeWidth = strokeWidth
        ..style = PaintingStyle.stroke,
    );
    if (value <= 0) return;
    canvas.drawArc(
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
