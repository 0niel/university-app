import 'dart:math' as math;

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

  double extent(BuildContext context) {
    final scaler = MediaQuery.textScalerOf(context);
    final maxMarks = weekDaysFor(
      day,
    ).map((date) => _marks(context, date).length).fold(0, math.max);
    final markRows = (maxMarks / 5).ceil();
    final marksHeight = markRows == 0 ? 0 : markRows * 6 - 2;
    return math.max(
      AppControlSize.dayPill,
      scaler.scale(10) * 1.3 +
          scaler.scale(15) * 1.3 +
          AppSpacing.micro * 2 +
          AppSpacing.xsm * 2 +
          marksHeight,
    );
  }

  @override
  Widget build(BuildContext context) {
    final locale = Localizations.localeOf(context).toString();
    final days = weekDaysFor(day);
    return AppTourAnchor(
      target: AppTourTarget.scheduleWeek,
      child: AppWeekStrip(
        key: const ValueKey('schedule-day-strip'),
        scheduleStyle: true,
        padding: EdgeInsets.zero,
        selectedIndex: day.weekday - 1,
        onSelected: (index) => onDay(days[index]),
        days: [
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
        ],
      ),
    );
  }
}

class ScheduleDayStripHeader extends SliverPersistentHeaderDelegate {
  const ScheduleDayStripHeader({
    required this.strip,
    required this.height,
    required this.background,
  });

  final ScheduleDayStrip strip;
  final double height;
  final Color background;

  @override
  double get minExtent => height + AppSpacing.lg;

  @override
  double get maxExtent => minExtent;

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) => ColoredBox(
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

  @override
  bool shouldRebuild(covariant ScheduleDayStripHeader oldDelegate) =>
      oldDelegate.strip != strip ||
      oldDelegate.height != height ||
      oldDelegate.background != background;
}
