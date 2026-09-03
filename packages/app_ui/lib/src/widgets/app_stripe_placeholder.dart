import 'dart:math' as math;

import 'package:app_ui/src/colors/colors.dart';
import 'package:flutter/widgets.dart';

class AppStripePlaceholder extends StatelessWidget {
  const AppStripePlaceholder({
    super.key,
    this.child,
    this.borderRadius,
    this.shape = BoxShape.rectangle,
    this.stripeWidth = 10,
    this.base,
    this.stripe,
  });

  final Widget? child;
  final BorderRadius? borderRadius;
  final BoxShape shape;
  final double stripeWidth;
  final Color? base;
  final Color? stripe;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final painted = CustomPaint(
      painter: _StripePainter(
        base: base ?? colors.surface,
        stripe: stripe ?? colors.surface2,
        stripeWidth: stripeWidth,
      ),
      child: Center(child: child ?? const SizedBox.shrink()),
    );

    if (shape == BoxShape.circle) {
      return ClipOval(child: painted);
    }
    return ClipRRect(
      borderRadius: borderRadius ?? BorderRadius.zero,
      child: painted,
    );
  }
}

class _StripePainter extends CustomPainter {
  const _StripePainter({
    required this.base,
    required this.stripe,
    required this.stripeWidth,
  });

  final Color base;
  final Color stripe;
  final double stripeWidth;

  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawRect(Offset.zero & size, Paint()..color = base);

    if (stripeWidth <= 0 || !stripeWidth.isFinite) return;
    final paint = Paint()..color = stripe;
    final band = stripeWidth * math.sqrt2;
    final step = band * 2;
    final span = size.width + size.height;
    for (var offset = 0.0; offset < span; offset += step) {
      final path = Path()
        ..moveTo(offset, 0)
        ..lineTo(offset + band, 0)
        ..lineTo(offset + band - size.height, size.height)
        ..lineTo(offset - size.height, size.height)
        ..close();
      canvas.drawPath(path, paint);
    }
  }

  @override
  bool shouldRepaint(_StripePainter old) =>
      old.base != base ||
      old.stripe != stripe ||
      old.stripeWidth != stripeWidth;
}
