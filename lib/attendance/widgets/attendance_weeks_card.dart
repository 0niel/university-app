import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:rtu_mirea_app/attendance/models/attendance_week.dart';
import 'package:rtu_mirea_app/attendance/utils/attendance_format.dart';
import 'package:rtu_mirea_app/l10n/l10n.dart';

class AttendanceWeeksCard extends StatelessWidget {
  const AttendanceWeeksCard({
    required this.weeks,
    required this.semesterStart,
    super.key,
  });

  static const barsHeight = 56.0;
  static const emptyRatio = 0.08;

  final List<AttendanceWeek> weeks;
  final DateTime semesterStart;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final l10n = context.l10n;
    final locale = Localizations.localeOf(context).toLanguageTag();
    return AppCard(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.fieldGap,
        AppSpacing.lg,
        AppSpacing.fieldGap,
        AppSpacing.md,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                l10n.attendanceWeeksTitle,
                style: AppText.captionSmall.copyWith(color: colors.muted),
              ),
              Text(
                l10n.attendanceWeeksRange(
                  formatShortMonth(semesterStart, locale),
                ),
                style: AppText.captionSmall.copyWith(color: colors.muted),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          SizedBox(
            height: barsHeight,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                for (final (index, week) in weeks.indexed) ...[
                  if (index > 0) const SizedBox(width: AppSpacing.xs),
                  Expanded(child: AttendanceWeekBar(week: week)),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class AttendanceWeekBar extends StatelessWidget {
  const AttendanceWeekBar({required this.week, super.key});

  final AttendanceWeek week;

  static Color colorOf(AppColors colors, AttendanceWeek week) {
    final ratio = week.ratio;
    if (ratio == null) return colors.surface2;
    if (week.isCurrent) return colors.accent;
    return ratio < 0.75 ? colors.warn : colors.lecture;
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final ratio = week.ratio ?? AttendanceWeeksCard.emptyRatio;
    return Align(
      alignment: Alignment.bottomCenter,
      child: FractionallySizedBox(
        heightFactor: ratio.clamp(AttendanceWeeksCard.emptyRatio, 1),
        child: Opacity(
          opacity: 0.85,
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: colorOf(colors, week),
              borderRadius: BorderRadius.circular(AppRadius.xs),
            ),
            child: const SizedBox.expand(),
          ),
        ),
      ),
    );
  }
}
