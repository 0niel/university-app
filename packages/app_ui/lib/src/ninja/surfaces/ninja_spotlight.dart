import 'dart:math' as math;

import 'package:app_ui/src/animations/ninja_motion.dart';
import 'package:app_ui/src/ninja/ninja_colors.dart';
import 'package:app_ui/src/ninja/ninja_text.dart';
import 'package:app_ui/src/ninja/widgets/ninja_button.dart';
import 'package:flutter/widgets.dart';

enum NinjaSpotlightShape { rounded, circle }

enum NinjaCoachArrow { none, up, down }

class NinjaSpotlight extends StatelessWidget {
  const NinjaSpotlight({
    required this.hole,
    required this.pulse,
    this.shape = NinjaSpotlightShape.rounded,
    this.radius = 22,
    this.animateHole = true,
    super.key,
  });

  final Rect? hole;
  final NinjaSpotlightShape shape;
  final double radius;
  final bool animateHole;

  final Animation<double> pulse;

  @override
  Widget build(BuildContext context) {
    final colors = context.ninja;
    final media = MediaQuery.maybeOf(context);
    final reduceMotion = (media?.disableAnimations ?? false) ||
        (media?.accessibleNavigation ?? false);
    final scrim = colors.isDark
        ? colors.canvas.withValues(alpha: 0.84)
        : colors.ink.withValues(alpha: 0.66);

    Widget paint(Rect? rect) => AnimatedBuilder(
          animation: pulse,
          builder: (context, _) => CustomPaint(
            size: Size.infinite,
            painter: _NinjaSpotlightPainter(
              hole: rect,
              shape: shape,
              radius: radius,
              scrim: scrim,
              ring: colors.brand,
              pulse: reduceMotion ? 0 : pulse.value,
            ),
          ),
        );

    if (hole == null) return IgnorePointer(child: paint(null));

    return IgnorePointer(
      child: TweenAnimationBuilder<Rect?>(
        tween: RectTween(end: hole),
        duration: animateHole ? NinjaMotion.of(context) : Duration.zero,
        curve: NinjaMotion.emphasized,
        builder: (context, rect, _) => paint(rect),
      ),
    );
  }
}

class _NinjaSpotlightPainter extends CustomPainter {
  const _NinjaSpotlightPainter({
    required this.hole,
    required this.shape,
    required this.radius,
    required this.scrim,
    required this.ring,
    required this.pulse,
  });

  final Rect? hole;
  final NinjaSpotlightShape shape;
  final double radius;
  final Color scrim;
  final Color ring;
  final double pulse;

  static const double _ringWidth = 2;
  static const double _pulseSpread = 12;

  @override
  void paint(Canvas canvas, Size size) {
    final screen = Path()..addRect(Offset.zero & size);
    final hole = this.hole;
    if (hole == null || hole.isEmpty) {
      canvas.drawPath(screen, Paint()..color = scrim);
      return;
    }

    final cutout = _path(hole);
    canvas
      ..drawPath(
        Path.combine(PathOperation.difference, screen, cutout),
        Paint()..color = scrim,
      )
      ..drawPath(
        cutout,
        Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = _ringWidth
          ..color = ring,
      );

    final fade = (1 - pulse) * 0.5;
    if (pulse <= 0 || fade <= 0.01) return;
    canvas.drawPath(
      _path(hole.inflate(_pulseSpread * pulse)),
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = _ringWidth
        ..color = ring.withValues(alpha: fade),
    );
  }

  Path _path(Rect rect) {
    if (shape == NinjaSpotlightShape.circle) {
      return Path()
        ..addOval(
          Rect.fromCircle(center: rect.center, radius: rect.longestSide / 2),
        );
    }
    return Path()
      ..addRRect(
        RRect.fromRectAndRadius(
          rect,
          Radius.circular(math.min(radius, rect.shortestSide / 2)),
        ),
      );
  }

  @override
  bool shouldRepaint(_NinjaSpotlightPainter oldDelegate) =>
      oldDelegate.hole != hole ||
      oldDelegate.shape != shape ||
      oldDelegate.radius != radius ||
      oldDelegate.scrim != scrim ||
      oldDelegate.ring != ring ||
      oldDelegate.pulse != pulse;
}

class NinjaCoachCard extends StatelessWidget {
  const NinjaCoachCard({
    required this.title,
    required this.body,
    required this.nextLabel,
    required this.onNext,
    this.progress,
    this.backLabel,
    this.onBack,
    this.skipLabel,
    this.onSkip,
    this.arrow = NinjaCoachArrow.none,
    this.arrowOffset = 0,
    super.key,
  });

  final String title;
  final String body;
  final String nextLabel;
  final VoidCallback onNext;
  final String? progress;
  final String? backLabel;
  final VoidCallback? onBack;
  final String? skipLabel;
  final VoidCallback? onSkip;
  final NinjaCoachArrow arrow;

  final double arrowOffset;

  static const double _arrowWidth = 20;
  static const double _arrowHeight = 9;

  @override
  Widget build(BuildContext context) {
    final colors = context.ninja;
    final progress = this.progress;
    final skipLabel = this.skipLabel;
    final backLabel = this.backLabel;

    final card = DecoratedBox(
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(NinjaRadius.card),
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 18, 20, 18),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (progress != null || (skipLabel != null && onSkip != null))
              Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Row(
                  children: [
                    if (progress != null)
                      Text(
                        progress,
                        style: NinjaText.microLabel.copyWith(
                          color: colors.brandInk,
                        ),
                      ),
                    const Spacer(),
                    if (skipLabel != null && onSkip != null)
                      NinjaButton.text(
                        label: skipLabel,
                        size: NinjaButtonSize.small,
                        onPressed: onSkip,
                      ),
                  ],
                ),
              ),
            Text(
              title,
              style: NinjaText.headline.copyWith(color: colors.ink),
            ),
            const SizedBox(height: 6),
            Text(
              body,
              style: NinjaText.body.copyWith(color: colors.mutedDark),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                if (backLabel != null && onBack != null) ...[
                  NinjaButton.outline(
                    label: backLabel,
                    size: NinjaButtonSize.small,
                    onPressed: onBack,
                  ),
                  const SizedBox(width: 10),
                ],
                Expanded(
                  child: NinjaButton.primary(
                    label: nextLabel,
                    size: NinjaButtonSize.small,
                    expanded: true,
                    onPressed: onNext,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );

    if (arrow == NinjaCoachArrow.none) return card;

    final tail = Padding(
      padding: EdgeInsets.only(
        left: math.max(0, arrowOffset - _arrowWidth / 2),
      ),
      child: CustomPaint(
        size: const Size(_arrowWidth, _arrowHeight),
        painter: _NinjaCoachArrowPainter(
          color: colors.surface,
          pointsUp: arrow == NinjaCoachArrow.up,
        ),
      ),
    );

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: arrow == NinjaCoachArrow.up ? [tail, card] : [card, tail],
    );
  }
}

class _NinjaCoachArrowPainter extends CustomPainter {
  const _NinjaCoachArrowPainter({required this.color, required this.pointsUp});

  final Color color;
  final bool pointsUp;

  @override
  void paint(Canvas canvas, Size size) {
    final path = Path();
    if (pointsUp) {
      path
        ..moveTo(size.width / 2, 0)
        ..lineTo(size.width, size.height)
        ..lineTo(0, size.height);
    } else {
      path
        ..moveTo(0, 0)
        ..lineTo(size.width, 0)
        ..lineTo(size.width / 2, size.height);
    }
    canvas.drawPath(path..close(), Paint()..color = color);
  }

  @override
  bool shouldRepaint(_NinjaCoachArrowPainter oldDelegate) =>
      oldDelegate.color != color || oldDelegate.pointsUp != pointsUp;
}
