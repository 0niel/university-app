import 'dart:math' as math;

import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';

/// Non-class calendar activities the student is involved in.
enum AppActivityType { event, retake, extra, personal, consult }

extension AppActivityTypeX on AppActivityType {
  String get label => switch (this) {
        AppActivityType.event => 'Событие',
        AppActivityType.retake => 'Пересдача',
        AppActivityType.extra => 'Доп. занятие',
        AppActivityType.personal => 'Личное',
        AppActivityType.consult => 'Консультация',
      };

  Color color(AppColors colors) => switch (this) {
        AppActivityType.event => colors.secondary,
        AppActivityType.retake => colors.colorful07,
        AppActivityType.extra => colors.success,
        AppActivityType.personal => colors.warning,
        AppActivityType.consult => colors.colorful01,
      };

  AppLineIcon get icon => switch (this) {
        AppActivityType.event => AppLineIcon.star,
        AppActivityType.retake => AppLineIcon.alert,
        AppActivityType.extra => AppLineIcon.plus,
        AppActivityType.personal => AppLineIcon.pin,
        AppActivityType.consult => AppLineIcon.message,
      };
}

/// Dashed-border, colour-spined card for a non-class activity (event, retake,
/// extra class, consultation, personal). Mirrors the design's `ActivityRow`.
class AppActivityRow extends StatelessWidget {
  const AppActivityRow({
    required this.type,
    required this.time,
    required this.title,
    super.key,
    this.endTime,
    this.place,
    this.subtitle,
    this.onTap,
  });

  final AppActivityType type;
  final String time;
  final String? endTime;
  final String title;
  final String? place;
  final String? subtitle;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colors;
    final color = type.color(colors);
    final meta = [
      place,
      subtitle,
    ].where((s) => s != null && s.isNotEmpty).join(' · ');

    return AppPressable(
      onTap: onTap,
      child: CustomPaint(
        foregroundPainter: _DashedRRectPainter(
          color: color.withValues(alpha: 0.4),
          radius: 18,
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(18),
          child: ColoredBox(
            color: colors.surface,
            child: IntrinsicHeight(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Container(width: 4, color: color),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(16, 13, 16, 13),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text.rich(
                                TextSpan(
                                  text: time,
                                  children: [
                                    if (endTime != null)
                                      TextSpan(
                                        text: '–$endTime',
                                        style: TextStyle(
                                          color: colors.deactiveDarker,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                  ],
                                ),
                                style: AppText.tabular(
                                  AppText.bodyStrong.copyWith(
                                    color: colors.active,
                                    fontSize: 15,
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 8),
                              _TypePill(type: type, color: color),
                            ],
                          ),
                          const SizedBox(height: 6),
                          Text(
                            title,
                            style: AppText.bodyLarge.copyWith(
                              color: colors.active,
                              fontWeight: FontWeight.w600,
                              height: 1.25,
                            ),
                          ),
                          if (meta.isNotEmpty) ...[
                            const SizedBox(height: 4),
                            Text(
                              meta,
                              style: AppText.caption.copyWith(
                                color: colors.deactiveDarker,
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _TypePill extends StatelessWidget {
  const _TypePill({required this.type, required this.color});

  final AppActivityType type;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.13),
        borderRadius: BorderRadius.circular(AppRadius.full),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          AppLineIconWidget(type.icon, size: 11, color: color),
          const SizedBox(width: 4),
          Text(
            type.label,
            style: AppText.captionSmall.copyWith(
              color: color,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

/// Paints a dashed rounded-rect outline (Flutter has no dashed border builtin).
class _DashedRRectPainter extends CustomPainter {
  const _DashedRRectPainter({required this.color, required this.radius});

  final Color color;
  final double radius;

  static const double _dash = 5;
  static const double _gap = 4;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;

    final rrect = RRect.fromRectAndRadius(
      Offset.zero & size,
      Radius.circular(radius),
    );
    final path = Path()..addRRect(rrect);

    for (final metric in path.computeMetrics()) {
      var distance = 0.0;
      while (distance < metric.length) {
        final next = math.min(distance + _dash, metric.length);
        canvas.drawPath(metric.extractPath(distance, next), paint);
        distance = next + _gap;
      }
    }
  }

  @override
  bool shouldRepaint(_DashedRRectPainter oldDelegate) {
    return oldDelegate.color != color || oldDelegate.radius != radius;
  }
}
