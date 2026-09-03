import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:rtu_mirea_app/l10n/l10n.dart';
import 'package:rtu_mirea_app/search/widgets/search_coach_callout.dart';

class SearchCoachOverlay extends StatefulWidget {
  const SearchCoachOverlay({
    required this.anchorKey,
    required this.onDismiss,
    super.key,
  });

  final GlobalKey anchorKey;

  final VoidCallback onDismiss;

  @override
  State<SearchCoachOverlay> createState() => _SearchCoachOverlayState();
}

class _SearchCoachOverlayState extends State<SearchCoachOverlay> {
  Rect? _anchor;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _resolveAnchor());
  }

  void _resolveAnchor() {
    if (!mounted) return;
    final box =
        widget.anchorKey.currentContext?.findRenderObject() as RenderBox?;
    if (box == null || !box.attached) return;
    final topLeft = box.localToGlobal(.zero);
    setState(() => _anchor = topLeft & box.size);
  }

  @override
  Widget build(BuildContext context) {
    final anchor = _anchor;
    if (anchor == null) return const SizedBox.shrink();

    final colors = context.colors;
    final l10n = context.l10n;
    final center = anchor.center;
    final radius = anchor.longestSide / 2 + 6;

    return GestureDetector(
      onTap: widget.onDismiss,
      behavior: .opaque,
      child: Stack(
        children: [
          Positioned.fill(
            child: CustomPaint(
              painter: _SpotlightPainter(
                center: center,
                radius: radius,
                scrim: colors.isDark
                    ? colors.canvas.withValues(alpha: 0.7)
                    : colors.ink.withValues(alpha: 0.62),
                ring: colors.accent,
              ),
            ),
          ),
          Positioned(
            top: anchor.bottom + 16,
            right: 16,
            width: 268,
            child: SearchCoachCallout(
              title: l10n.searchCoachTitle,
              body: l10n.searchCoachBody,
              gesture: l10n.searchCoachGesture,
            ),
          ),
        ],
      ),
    );
  }
}

class _SpotlightPainter extends CustomPainter {
  const _SpotlightPainter({
    required this.center,
    required this.radius,
    required this.scrim,
    required this.ring,
  });

  final Offset center;
  final double radius;
  final Color scrim;
  final Color ring;

  @override
  void paint(Canvas canvas, Size size) {
    final scrimPath = Path.combine(
      .difference,
      Path()..addRect(Offset.zero & size),
      Path()..addOval(Rect.fromCircle(center: center, radius: radius)),
    );
    canvas
      ..drawPath(scrimPath, Paint()..color = scrim)
      ..drawCircle(
        center,
        radius,
        Paint()
          ..style = .stroke
          ..strokeWidth = 2
          ..color = ring,
      );
  }

  @override
  bool shouldRepaint(_SpotlightPainter oldDelegate) =>
      oldDelegate.center != center ||
      oldDelegate.radius != radius ||
      oldDelegate.ring != ring;
}
