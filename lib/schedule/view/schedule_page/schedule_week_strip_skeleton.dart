import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:rtu_mirea_app/l10n/l10n.dart';

part 'week_strip_day_skeleton.dart';

class ScheduleWeekStripSkeleton extends StatelessWidget {
  const ScheduleWeekStripSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = context.ninja;
    final l10n = context.l10n;
    final scale = MediaQuery.textScalerOf(context).scale(1).clamp(1.0, 1.3);
    final height = 58 + (scale - 1) * 40;
    final now = DateUtils.dateOnly(DateTime.now());
    final start = now.subtract(Duration(days: now.weekday - 1));
    final labels = [
      l10n.weekdayShortMon,
      l10n.weekdayShortTue,
      l10n.weekdayShortWed,
      l10n.weekdayShortThu,
      l10n.weekdayShortFri,
      l10n.weekdayShortSat,
      l10n.weekdayShortSun,
    ];

    return SizedBox(
      height: height,
      child: MediaQuery.withClampedTextScaling(
        maxScaleFactor: 1.3,
        child: Row(
          crossAxisAlignment: .stretch,
          children: [
            for (final (index, label) in labels.indexed)
              Expanded(
                child: Padding(
                  padding: const .symmetric(horizontal: 2, vertical: 3),
                  child: _WeekStripDaySkeleton(
                    label: label,
                    day: start.add(Duration(days: index)),
                    today: DateUtils.isSameDay(
                      start.add(Duration(days: index)),
                      now,
                    ),
                    colors: colors,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
