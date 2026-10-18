import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';

class MapLoadingPlan extends StatelessWidget {
  const MapLoadingPlan({super.key});

  @override
  Widget build(BuildContext context) => ExcludeSemantics(
    child: CustomPaint(
      painter: _LoadingPlanPainter(
        room: context.colors.surface,
        wall: context.colors.line,
        corridor: context.colors.surface2.withValues(alpha: .45),
      ),
    ),
  );
}

class _LoadingPlanPainter extends CustomPainter {
  const _LoadingPlanPainter({
    required this.room,
    required this.wall,
    required this.corridor,
  });

  final Color room;
  final Color wall;
  final Color corridor;

  @override
  void paint(Canvas canvas, Size size) {
    final scale = (size.width / 100).clamp(0.0, size.height / 74);
    canvas
      ..translate(
        (size.width - 100 * scale) / 2,
        (size.height - 74 * scale) / 2,
      )
      ..scale(scale);
    final fill = Paint()..color = room;
    final outline = Paint()
      ..color = wall
      ..style = PaintingStyle.stroke
      ..strokeWidth = .6;
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        const Rect.fromLTWH(1, 1, 98, 72),
        const Radius.circular(4),
      ),
      Paint()..color = corridor,
    );
    for (var row = 0; row < 2; row++) {
      for (var column = 0; column < 6; column++) {
        final rect = RRect.fromRectAndRadius(
          Rect.fromLTWH(4 + column * 15.5, row == 0 ? 4 : 44, 14, 25),
          const Radius.circular(1.6),
        );
        canvas
          ..drawRRect(rect, fill)
          ..drawRRect(rect, outline);
      }
    }
    final core = RRect.fromRectAndRadius(
      const Rect.fromLTWH(37, 31, 26, 11),
      const Radius.circular(1.5),
    );
    canvas
      ..drawRRect(core, fill)
      ..drawRRect(core, outline);
    for (var step = 0; step < 5; step++) {
      canvas.drawLine(
        Offset(41 + step * 4, 34),
        Offset(41 + step * 4, 39),
        outline,
      );
    }
  }

  @override
  bool shouldRepaint(covariant _LoadingPlanPainter oldDelegate) =>
      room != oldDelegate.room ||
      wall != oldDelegate.wall ||
      corridor != oldDelegate.corridor;
}
