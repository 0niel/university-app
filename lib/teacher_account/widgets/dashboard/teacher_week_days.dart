import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:rtu_mirea_app/l10n/l10n.dart';
import 'package:rtu_mirea_app/schedule/view/schedule_page/lesson_text.dart';
import 'package:rtu_mirea_app/teacher_account/domain/teacher_workload.dart';
import 'package:rtu_mirea_app/teacher_account/models/teacher_resource.dart';
import 'package:rtu_mirea_app/teacher_account/models/teacher_schedule_snapshot.dart';

class TeacherWeekDays extends StatelessWidget {
  const TeacherWeekDays({
    required this.week,
    required this.day,
    required this.now,
    required this.workload,
    required this.schedule,
    required this.onSelect,
    super.key,
  });

  final DateTime week;
  final DateTime day;
  final DateTime now;
  final TeacherWorkload workload;
  final TeacherResource<TeacherScheduleSnapshot> schedule;
  final ValueChanged<DateTime> onSelect;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final dateFormat = DateFormat.E(l10n.localeName);
    List<AppWeekDay> days(DateTime start) => [
      for (var index = 0; index < 7; index++)
        _day(
          context,
          dateFormat,
          DateTime(start.year, start.month, start.day + index),
        ),
    ];
    return Semantics(
      container: true,
      label: l10n.schedule,
      onIncrease: () => onSelect(DateTime(day.year, day.month, day.day + 7)),
      onDecrease: () => onSelect(DateTime(day.year, day.month, day.day - 7)),
      child: AppWeekPager(
        key: const ValueKey('teacher-dashboard-week-days'),
        weekStart: week,
        selectedIndex: day.weekday - 1,
        onSelected: (index) =>
            onSelect(DateTime(week.year, week.month, week.day + index)),
        onWeekChanged: (start) => onSelect(
          DateTime(start.year, start.month, start.day + day.weekday - 1),
        ),
        daysBuilder: days,
      ),
    );
  }

  AppWeekDay _day(BuildContext context, DateFormat format, DateTime date) {
    final l10n = context.l10n;
    final lessons = _activeLessons(date);
    final week = date.subtract(Duration(days: date.weekday - 1));
    final available =
        DateUtils.isSameDay(week, workload.weekStart) && schedule.data != null;
    final summary = available
        ? l10n.scheduleDayLessons(lessons.length)
        : l10n.loadingContent;
    return AppWeekDay(
      '${date.day}',
      short: format.format(date).replaceAll('.', '').toUpperCase(),
      isWeekend: date.weekday >= DateTime.saturday,
      isToday: DateUtils.isSameDay(now, date),
      semanticsLabel:
          '${DateFormat.MMMMEEEEd(l10n.localeName).format(date)}, '
          '$summary',
      dots: [
        for (final lesson in available ? lessons : <TeacherLessonOccurrence>[])
          lessonAccentOf(context, lesson.lesson),
      ],
    );
  }

  List<TeacherLessonOccurrence> _activeLessons(DateTime date) => workload
      .occurrencesForDay(date)
      .where((lesson) => !lesson.isCancelled)
      .toList();
}
