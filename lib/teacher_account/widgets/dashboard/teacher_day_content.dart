import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:rtu_mirea_app/l10n/l10n.dart';
import 'package:rtu_mirea_app/teacher_account/domain/teacher_workload.dart';
import 'package:rtu_mirea_app/teacher_account/models/teacher_resource.dart';
import 'package:rtu_mirea_app/teacher_account/models/teacher_schedule_snapshot.dart';
import 'package:rtu_mirea_app/teacher_account/widgets/dashboard/teacher_lesson_tile.dart';

class TeacherDayContent extends StatelessWidget {
  const TeacherDayContent({
    required this.day,
    required this.now,
    required this.schedule,
    required this.workload,
    required this.preview,
    required this.onOpenLesson,
    super.key,
  });

  final DateTime day;
  final DateTime now;
  final TeacherResource<TeacherScheduleSnapshot> schedule;
  final TeacherWorkload workload;
  final TeacherLessonOccurrence? preview;
  final ValueChanged<TeacherLessonOccurrence> onOpenLesson;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final week = day.subtract(Duration(days: day.weekday - 1));
    final available =
        DateUtils.isSameDay(week, workload.weekStart) && schedule.data != null;
    final occurrences = workload.occurrencesForDay(day);
    final lessons = occurrences.where((entry) => entry != preview);
    final next = workload.currentAt(now) ?? workload.nextAt(now);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        AppOverline(DateFormat.MMMMEEEEd(l10n.localeName).format(day)),
        if (!available)
          if (schedule.hasError &&
              DateUtils.isSameDay(week, workload.weekStart))
            const SizedBox(height: AppControlSize.touchTarget)
          else
            AppSkeletonGroup(
              semanticsLabel: l10n.loadingContent,
              child: const AppSkeleton(height: 120, radius: AppRadius.card),
            )
        else if (occurrences.isEmpty)
          AppEmptyState(
            title: l10n.teacherNoLessons,
            subtitle: l10n.teacherNoLessonsDescription,
            lineIcon: AppLineIcon.calendar,
          )
        else if (lessons.isNotEmpty)
          AppListGroup(
            children: [
              for (final occurrence in lessons)
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
