import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:rtu_mirea_app/l10n/l10n.dart';
import 'package:rtu_mirea_app/teacher_account/domain/teacher_workload.dart';
import 'package:rtu_mirea_app/teacher_account/widgets/dashboard/teacher_lesson_tile.dart';
import 'package:rtu_mirea_app/teacher_account/widgets/dashboard/teacher_week_days.dart';

class TeacherDaySchedule extends StatelessWidget {
  const TeacherDaySchedule({
    required this.workload,
    required this.week,
    required this.day,
    required this.now,
    required this.preview,
    required this.onSelectDay,
    required this.onOpenLesson,
    super.key,
  });

  final TeacherWorkload workload;
  final DateTime week;
  final DateTime day;
  final DateTime now;
  final TeacherLessonOccurrence? preview;
  final ValueChanged<DateTime> onSelectDay;
  final ValueChanged<TeacherLessonOccurrence> onOpenLesson;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final dayOccurrences = workload.occurrencesForDay(day);
    final dayLessons = dayOccurrences.where((entry) => entry != preview);
    final next = workload.currentAt(now) ?? workload.nextAt(now);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        AppOverline(DateFormat.MMMMEEEEd(l10n.localeName).format(day)),
        TeacherWeekDays(
          week: week,
          day: day,
          now: now,
          workload: workload,
          onSelect: onSelectDay,
        ),
        const SizedBox(height: AppSpacing.md),
        if (dayOccurrences.isEmpty)
          AppEmptyState(
            title: l10n.teacherNoLessons,
            subtitle: l10n.teacherNoLessonsDescription,
            lineIcon: AppLineIcon.calendar,
          )
        else if (dayLessons.isNotEmpty)
          AppListGroup(
            children: [
              for (final occurrence in dayLessons)
                TeacherLessonTile(
                  occurrence: occurrence,
                  now: now,
                  isNext: occurrence == next,
                  onTap: () => onOpenLesson(occurrence),
                ),
            ],
          ),
      ],
    );
  }
}
