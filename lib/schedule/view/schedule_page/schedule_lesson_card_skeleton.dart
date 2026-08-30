import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';

class ScheduleLessonCardSkeleton extends StatelessWidget {
  const ScheduleLessonCardSkeleton({super.key, this.titleLines = 1});

  final int titleLines;

  @override
  Widget build(BuildContext context) {
    final colors = context.ninja;
    final scale = MediaQuery.textScalerOf(context).scale(1);
    final timeWidth = 54.0 + ((scale - 1).clamp(0, 1) * 24).toDouble();

    return Padding(
      padding: const .fromLTRB(
        NinjaMetrics.screenPadding,
        0,
        NinjaMetrics.screenPadding,
        5,
      ),
      child: Container(
        padding: const .fromLTRB(12, 11, 12, 12),
        decoration: BoxDecoration(
          color: colors.surface,
          borderRadius: .circular(NinjaRadius.card),
        ),
        child: Row(
          crossAxisAlignment: .start,
          children: [
            SizedBox(
              width: timeWidth,
              child: const Column(
                crossAxisAlignment: .start,
                children: [
                  NinjaSkeleton(width: 42, height: 14, radius: 6),
                  SizedBox(height: 6),
                  NinjaSkeleton(width: 34, height: 10, radius: 5),
                ],
              ),
            ),
            const NinjaSkeleton(width: 34, height: 34, radius: 11),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: .start,
                children: [
                  const NinjaSkeleton(height: 15, widthFactor: .82, radius: 7),
                  if (titleLines > 1) ...[
                    const SizedBox(height: 6),
                    const NinjaSkeleton(
                      height: 15,
                      widthFactor: .52,
                      radius: 7,
                    ),
                  ],
                  const SizedBox(height: 8),
                  const NinjaSkeleton(height: 11, widthFactor: .66, radius: 5),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
