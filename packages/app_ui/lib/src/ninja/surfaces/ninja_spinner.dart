import 'dart:async';
import 'dart:math' as math;

import 'package:app_ui/src/colors/colors.dart';
import 'package:flutter/widgets.dart';

class NinjaSpinner extends StatefulWidget {
  const NinjaSpinner({
    super.key,
    this.size = 28,
    this.strokeWidth = 3,
    this.color,
    this.trackColor,
  });

  final double size;
  final double strokeWidth;
  final Color? color;
  final Color? trackColor;

  @override
  State<NinjaSpinner> createState() => _NinjaSpinnerState();
}

class _NinjaSpinnerState extends State<NinjaSpinner>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 800),
  );

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final reduceMotion = MediaQuery.maybeDisableAnimationsOf(context) ?? false;
    if (reduceMotion) {
      _controller.stop();
    } else if (!_controller.isAnimating) {
      unawaited(_controller.repeat());
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
    return SizedBox(
      width: widget.size,
      height: widget.size,
      child: RotationTransition(
        turns: _controller,
        child: CustomPaint(
          painter: _NinjaSpinnerPainter(
            track: widget.trackColor ?? colors.surface2,
            head: widget.color ?? colors.accent,
            strokeWidth: widget.strokeWidth,
          ),
        ),
      ),
    );
  }
}

class _NinjaSpinnerPainter extends CustomPainter {
  const _NinjaSpinnerPainter({
    required this.track,
    required this.head,
    required this.strokeWidth,
  });

  final Color track;
  final Color head;
  final double strokeWidth;

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Rect.fromCircle(
      center: size.center(Offset.zero),
      radius: (size.shortestSide - strokeWidth) / 2,
    );
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..color = track;
    canvas
      ..drawArc(rect, 0, 2 * math.pi, false, paint)
      ..drawArc(rect, -math.pi / 2, math.pi / 2, false, paint..color = head);
  }

  @override
  bool shouldRepaint(_NinjaSpinnerPainter oldDelegate) =>
      oldDelegate.track != track ||
      oldDelegate.head != head ||
      oldDelegate.strokeWidth != strokeWidth;
}

typedef AppSpinner = NinjaSpinner;
