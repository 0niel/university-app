import 'package:academic_calendar/academic_calendar.dart';
import 'package:app_ui/app_ui.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:rtu_mirea_app/schedule/cubit/cubit.dart';
import 'package:rtu_mirea_app/schedule/view/schedule_page/schedule_calendar_notice.dart';
import 'package:rtu_mirea_app/schedule/view/schedule_page/schedule_dates.dart';
import 'package:rtu_mirea_app/schedule/view/schedule_page/schedule_day_marks.dart';
import 'package:rtu_mirea_app/tour/tour.dart';
import 'package:schedule_repository/schedule_repository.dart';

class ScheduleDayStrip extends StatelessWidget {
  const ScheduleDayStrip({
    required this.day,
    required this.now,
    required this.schedule,
    required this.preferences,
    required this.display,
    required this.changes,
    required this.onDay,
    super.key,
  });

  final DateTime day;
  final DateTime now;
  final List<SchedulePart> schedule;
  final SchedulePreferencesState preferences;
  final ScheduleDisplayState display;
  final List<ScheduleChange> changes;
  final ValueChanged<DateTime> onDay;

  List<(String, Color)> _marks(BuildContext context, DateTime date) =>
      scheduleDayMarks(
        context,
        schedule: schedule,
        day: date,
        now: now,
        preferences: preferences,
        display: display,
        changes: changes,
      );

  List<AppWeekDay> _days(BuildContext context, DateTime start) {
    final locale = Localizations.localeOf(context).toString();
    final days = [
      for (var offset = 0; offset < 7; offset++)
        DateTime(start.year, start.month, start.day + offset),
    ];
    return [
      for (final date in days)
        AppWeekDay(
          '${date.day}',
          short: DateFormat.E(locale).format(date).toUpperCase(),
          isWeekend: RussianWorkCalendar.dayInfo(date).isNonWorking,
          isToday: isSameDate(date, now),
          semanticsLabel: [
            DateFormat.yMMMMd(locale).format(date),
            scheduleDayLabel(context, date),
            ..._marks(context, date).map((mark) => mark.$1),
          ].join(', '),
          dots: _marks(context, date).map((mark) => mark.$2).toList(),
        ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final days = weekDaysFor(day);
    return AppTourAnchor(
      target: AppTourTarget.scheduleWeek,
      child: AppWeekPager(
        key: const ValueKey('schedule-day-strip'),
        scheduleStyle: true,
        weekStart: days.first,
        selectedIndex: day.weekday - 1,
        onSelected: (index) => onDay(days[index]),
        daysBuilder: (start) => _days(context, start),
        onWeekChanged: (start) => onDay(
          DateTime(start.year, start.month, start.day + day.weekday - 1),
        ),
      ),
    );
  }
}

class ScheduleDayStripHeader extends StatelessWidget {
  const ScheduleDayStripHeader({
    required this.strip,
    required this.background,
    super.key,
  });

  final ScheduleDayStrip strip;
  final Color background;

  @override
  Widget build(BuildContext context) => ColoredBox(
    key: const ValueKey('schedule-pinned-days'),
    color: background,
    child: Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.screen,
        AppSpacing.sm,
        AppSpacing.screen,
        AppSpacing.sm,
      ),
      child: strip,
    ),
  );
}
