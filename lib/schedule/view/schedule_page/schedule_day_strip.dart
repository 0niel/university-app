import 'package:academic_calendar/academic_calendar.dart';
import 'package:app_ui/app_ui.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:rtu_mirea_app/schedule/cubit/cubit.dart';
import 'package:rtu_mirea_app/schedule/utils/schedule_date_index.dart';
import 'package:rtu_mirea_app/schedule/view/schedule_page/schedule_calendar_notice.dart';
import 'package:rtu_mirea_app/schedule/view/schedule_page/schedule_dates.dart';
import 'package:rtu_mirea_app/schedule/view/schedule_page/schedule_day_marks.dart';
import 'package:rtu_mirea_app/tour/tour.dart';
import 'package:schedule_repository/schedule_repository.dart';

class ScheduleDayStrip extends StatefulWidget {
  const ScheduleDayStrip({
    required this.day,
    required this.now,
    required this.schedule,
    required this.preferences,
    required this.display,
    required this.changes,
    required this.onDay,
    this.dateIndex,
    super.key,
  });

  final DateTime day;
  final DateTime now;
  final List<SchedulePart> schedule;
  final SchedulePreferencesState preferences;
  final ScheduleDisplayState display;
  final List<ScheduleChange> changes;
  final ValueChanged<DateTime> onDay;
  final ScheduleDateIndex? dateIndex;

  @override
  State<ScheduleDayStrip> createState() => _ScheduleDayStripState();
}

class _ScheduleDayStripState extends State<ScheduleDayStrip> {
  late ScheduleDateIndex _dateIndex =
      widget.dateIndex ?? ScheduleDateIndex(widget.schedule);

  @override
  void didUpdateWidget(covariant ScheduleDayStrip oldWidget) {
    super.didUpdateWidget(oldWidget);
    final dateIndex = widget.dateIndex;
    if (dateIndex != null) {
      _dateIndex = dateIndex;
    } else if (!_dateIndex.matches(widget.schedule)) {
      _dateIndex = ScheduleDateIndex(widget.schedule);
    }
  }

  List<(String, Color)> _marks(BuildContext context, DateTime date) =>
      scheduleDayMarks(
        context,
        schedule: _dateIndex.partsForDay(date),
        day: date,
        now: widget.now,
        preferences: widget.preferences,
        display: widget.display,
        changes: widget.changes,
      );

  List<AppWeekDay> _days(BuildContext context, DateTime start) {
    final locale = Localizations.localeOf(context).toString();
    final weekdayFormat = DateFormat.E(locale);
    final dateFormat = DateFormat.yMMMMd(locale);
    final days = [
      for (var offset = 0; offset < 7; offset++)
        DateTime(start.year, start.month, start.day + offset),
    ];
    return days.map((date) {
      final marks = _marks(context, date);
      return AppWeekDay(
        '${date.day}',
        short: weekdayFormat.format(date).toUpperCase(),
        isWeekend: RussianWorkCalendar.dayInfo(date).isNonWorking,
        isToday: isSameDate(date, widget.now),
        semanticsLabel: [
          dateFormat.format(date),
          scheduleDayLabel(context, date),
          ...marks.map((mark) => mark.$1),
        ].join(', '),
        dots: marks.map((mark) => mark.$2).toList(),
      );
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final day = widget.day;
    final days = weekDaysFor(day);
    return AppTourAnchor(
      target: AppTourTarget.scheduleWeek,
      child: AppWeekPager(
        key: const ValueKey('schedule-day-strip'),
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.screen),
        scheduleStyle: true,
        weekStart: weekStartFor(day),
        selectedIndex: day.weekday - 1,
        onSelected: (index) {
          final selected = index < 0 ? null : days.elementAtOrNull(index);
          if (selected != null) widget.onDay(selected);
        },
        daysBuilder: (start) => _days(context, start),
        onWeekChanged: (start) => widget.onDay(
          DateTime(start.year, start.month, start.day + day.weekday - 1),
        ),
      ),
    );
  }
}

class ScheduleDayStripHeader extends StatelessWidget {
  const ScheduleDayStripHeader({
    required this.strip,
    this.elevated = false,
    this.topInset = 0,
    super.key,
  });

  final ScheduleDayStrip strip;
  final bool elevated;
  final double topInset;

  @override
  Widget build(BuildContext context) => AppPinnedSurface(
    key: const ValueKey('schedule-pinned-days'),
    elevated: elevated,
    child: Padding(
      padding: EdgeInsets.only(
        top: topInset + AppSpacing.sm,
        bottom: AppSpacing.sm,
      ),
      child: strip,
    ),
  );
}
