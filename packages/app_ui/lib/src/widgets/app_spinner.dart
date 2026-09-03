import 'dart:async';
import 'dart:math' as math;

import 'package:app_ui/src/colors/colors.dart';
import 'package:flutter/widgets.dart';

class AppSpinner extends StatefulWidget {
  const AppSpinner({
    super.key,
    this.size = 22,
    this.strokeWidth = 2.4,
    this.color,
    this.trackColor,
  });

  final double size;
  final double strokeWidth;
  final Color? color;
  final Color? trackColor;

  @override
  State<AppSpinner> createState() => _AppSpinnerState();
}

class _AppSpinnerState extends State<AppSpinner>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 800),
  );

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final animate = !MediaQuery.disableAnimationsOf(context) &&
        !MediaQuery.accessibleNavigationOf(context) &&
        TickerMode.valuesOf(context).enabled;
    if (animate && !_controller.isAnimating) {
      unawaited(_controller.repeat());
    } else if (!animate) {
      _controller.stop();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final color = widget.color ?? colors.accent;
    return SizedBox.square(
      dimension: widget.size,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, _) => CustomPaint(
          painter: _AppSpinnerPainter(
            turns: _controller.value,
            color: color,
            trackColor: widget.trackColor ?? color.withValues(alpha: .18),
            strokeWidth: widget.strokeWidth,
          ),
        ),
      ),
    );
  }
}

class _AppSpinnerPainter extends CustomPainter {
  const _AppSpinnerPainter({
    required this.turns,
    required this.color,
    required this.trackColor,
    required this.strokeWidth,
  });

  final double turns;
  final Color color;
  final Color trackColor;
  final double strokeWidth;

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;
    final arc = rect.deflate(strokeWidth / 2);
    final track = Paint()
      ..color = trackColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth;
    final head = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;
    canvas
      ..drawOval(arc, track)
      ..drawArc(
        arc,
        -math.pi / 2 + turns * 2 * math.pi,
        math.pi / 2,
        false,
        head,
      );
  }

  @override
  bool shouldRepaint(_AppSpinnerPainter oldDelegate) =>
      oldDelegate.turns != turns ||
      oldDelegate.color != color ||
      oldDelegate.trackColor != trackColor ||
      oldDelegate.strokeWidth != strokeWidth;
}
