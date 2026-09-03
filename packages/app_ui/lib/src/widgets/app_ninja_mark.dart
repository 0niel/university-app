import 'package:app_ui/src/colors/colors.dart';
import 'package:flutter/material.dart';

class AppNinjaMark extends StatelessWidget {
  const AppNinjaMark({
    super.key,
    this.size = 24,
    this.color,
    this.spin = false,
    this.cutout = true,
  });

  final double size;

  /// Shuriken fill. Defaults to the design accent blue.
  final Color? color;

  /// When true the mark slowly rotates, matching the design's
  /// `mn-shuriken-spin` decoration (used behind accent hero cards).
  final bool spin;

  /// Punches the central circular hole (the negative-space "N"). Set to false
  /// for solid decorative fills, e.g. the faint background mark on hero cards.
  final bool cutout;

  @override
  Widget build(BuildContext context) {
    final mark = SizedBox(
      width: size,
      height: size,
      child: CustomPaint(
        painter: _NinjaMarkPainter(
          color: color ?? AppColors.light.accent,
          cutout: cutout,
        ),
      ),
    );
    if (!spin) return mark;
    return _SpinningMark(child: mark);
  }
}

/// Wraps [child] in a slow, continuous rotation echoing the design's
/// `mn-shuriken-spin` keyframe.
class _SpinningMark extends StatefulWidget {
  const _SpinningMark({required this.child});

  final Widget child;

  @override
  State<_SpinningMark> createState() => _SpinningMarkState();
}

class _SpinningMarkState extends State<_SpinningMark>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(seconds: 12),
  )..repeat();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return RotationTransition(turns: _controller, child: widget.child);
  }
}

class _NinjaMarkPainter extends CustomPainter {
  const _NinjaMarkPainter({required this.color, required this.cutout});

  final Color color;
  final bool cutout;

  /// Design path points in the 32×32 viewBox.
  static const _points = [
    Offset(16, 2),
    Offset(19, 13),
    Offset(30, 16),
    Offset(19, 19),
    Offset(16, 30),
    Offset(13, 19),
    Offset(2, 16),
    Offset(13, 13),
  ];

  @override
  void paint(Canvas canvas, Size size) {
    final scale = size.width / 32;

    final path = Path();
    for (final (i, point) in _points.indexed) {
      final scaled = Offset(point.dx * scale, point.dy * scale);
      if (i == 0) {
        path.moveTo(scaled.dx, scaled.dy);
      } else {
        path.lineTo(scaled.dx, scaled.dy);
      }
    }
    path.close();

    if (!cutout) {
      canvas.drawPath(path, Paint()..color = color);
      return;
    }

    // saveLayer so BlendMode.clear punches through the shuriken only,
    // not whatever is painted beneath this widget.
    final bounds = Offset.zero & size;
    canvas
      ..saveLayer(bounds, Paint())
      ..drawPath(path, Paint()..color = color)
      ..drawCircle(
        Offset(size.width / 2, size.height / 2),
        size.width * (3.4 / 32),
        Paint()..blendMode = BlendMode.clear,
      )
      ..restore();
  }

  @override
  bool shouldRepaint(_NinjaMarkPainter old) =>
      old.color != color || old.cutout != cutout;
}
