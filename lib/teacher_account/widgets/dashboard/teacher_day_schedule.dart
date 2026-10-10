import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:rtu_mirea_app/l10n/l10n.dart';
import 'package:rtu_mirea_app/teacher_account/domain/teacher_workload.dart';
import 'package:rtu_mirea_app/teacher_account/models/teacher_resource.dart';
import 'package:rtu_mirea_app/teacher_account/models/teacher_schedule_snapshot.dart';
import 'package:rtu_mirea_app/teacher_account/widgets/dashboard/teacher_day_content.dart';
import 'package:rtu_mirea_app/teacher_account/widgets/dashboard/teacher_day_pager.dart';
import 'package:rtu_mirea_app/teacher_account/widgets/dashboard/teacher_week_days.dart';

class TeacherDaySchedule extends StatelessWidget {
  const TeacherDaySchedule({
    required this.workload,
    required this.week,
    required this.day,
    required this.now,
    required this.preview,
    required this.schedule,
    required this.onSelectDay,
    required this.onOpenLesson,
    super.key,
  });

  final TeacherWorkload workload;
  final DateTime week;
  final DateTime day;
  final DateTime now;
  final TeacherLessonOccurrence? preview;
  final TeacherResource<TeacherScheduleSnapshot> schedule;
  final ValueChanged<DateTime> onSelectDay;
  final ValueChanged<TeacherLessonOccurrence> onOpenLesson;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const SizedBox(height: AppSpacing.contentGap),
        TeacherWeekDays(
          week: week,
          day: day,
          now: now,
          workload: workload,
          schedule: schedule,
          onSelect: onSelectDay,
        ),
        const SizedBox(height: AppSpacing.sm),
        Text(
          l10n.teacherScheduleSwipeHint,
          style: AppText.caption.copyWith(color: context.colors.muted),
        ),
        TeacherDayPager(
          day: day,
          onDay: onSelectDay,
          builder: (context, date) => TeacherDayContent(
            key: ValueKey(('teacher-day-content', date)),
            day: date,
            now: now,
            schedule: schedule,
            workload: workload,
            preview: preview,
            onOpenLesson: onOpenLesson,
          ),
        ),
      ],
    );
  }
}
