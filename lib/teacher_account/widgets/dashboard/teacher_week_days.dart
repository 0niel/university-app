import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:rtu_mirea_app/l10n/l10n.dart';
import 'package:rtu_mirea_app/schedule/view/schedule_page/lesson_text.dart';
import 'package:rtu_mirea_app/teacher_account/domain/teacher_workload.dart';

class TeacherWeekDays extends StatelessWidget {
  const TeacherWeekDays({
    required this.week,
    required this.day,
    required this.now,
    required this.workload,
    required this.onSelect,
    super.key,
  });

  final DateTime week;
  final DateTime day;
  final DateTime now;
  final TeacherWorkload workload;
  final ValueChanged<DateTime> onSelect;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final dates = [
      for (var index = 0; index < 7; index++)
        DateTime(week.year, week.month, week.day + index),
    ];
    return AppWeekStrip(
      key: const ValueKey('teacher-dashboard-week-days'),
      padding: EdgeInsets.zero,
      fitWeek: true,
      selectedIndex: dates.indexWhere((date) => DateUtils.isSameDay(day, date)),
      onSelected: (index) => onSelect(dates[index]),
      days: [
        for (final date in dates)
          AppWeekDay(
            '${date.day}',
            short: DateFormat.E(
              l10n.localeName,
            ).format(date).replaceAll('.', '').toUpperCase(),
            isWeekend: date.weekday >= DateTime.saturday,
            isToday: DateUtils.isSameDay(now, date),
            semanticsLabel:
                '${DateFormat.MMMMEEEEd(l10n.localeName).format(date)}, '
                '${l10n.scheduleDayLessons(_activeLessons(date).length)}',
            dots: [
              for (final lesson in _activeLessons(date))
                lessonAccentOf(context, lesson.lesson),
            ],
          ),
      ],
    );
  }

  List<TeacherLessonOccurrence> _activeLessons(DateTime date) => workload
      .occurrencesForDay(date)
      .where((lesson) => !lesson.isCancelled)
      .toList();
}
