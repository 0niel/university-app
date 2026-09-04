import 'dart:math' as math;

import 'package:academic_calendar/academic_calendar.dart';
import 'package:app_ui/app_ui.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:rtu_mirea_app/config/config.dart';
import 'package:rtu_mirea_app/l10n/l10n.dart';
import 'package:rtu_mirea_app/navigation/routes/routes.dart';
import 'package:rtu_mirea_app/schedule/cubit/cubit.dart';
import 'package:rtu_mirea_app/schedule/models/models.dart';
import 'package:rtu_mirea_app/schedule/view/compare/comparison_logic.dart';
import 'package:rtu_mirea_app/schedule/view/schedule_page/lesson_status.dart';
import 'package:rtu_mirea_app/schedule/view/schedule_page/lesson_text.dart';
import 'package:rtu_mirea_app/schedule/view/schedule_page/schedule_calendar_notice.dart';
import 'package:rtu_mirea_app/schedule/view/schedule_page/schedule_dates.dart';
import 'package:rtu_mirea_app/schedule/view/schedule_page/schedule_day_marks.dart';
import 'package:rtu_mirea_app/schedule/view/schedule_page/schedule_overlap_switcher.dart';
import 'package:rtu_mirea_app/schedule/view/schedule_page/schedule_time_slots.dart';
import 'package:rtu_mirea_app/schedule/view/schedule_page/sheets.dart';
import 'package:rtu_mirea_app/schedule/widgets/schedule_metrics.dart';
import 'package:schedule_repository/schedule_repository.dart';

class ScheduleWeekView extends StatelessWidget {
  const ScheduleWeekView({
    required this.day,
    required this.schedule,
    required this.changes,
    required this.preferences,
    required this.display,
    required this.activities,
    required this.onDay,
    this.friend,
    this.friendActivities = const [],
    this.onCompare,
    this.now,
    super.key,
  });

  final DateTime day;
  final List<SchedulePart> schedule;
  final List<ScheduleChange> changes;
  final SchedulePreferencesState preferences;
  final ScheduleDisplayState display;
  final List<UserActivity> activities;
  final SelectedSchedule? friend;
  final List<UserActivity> friendActivities;
  final ValueChanged<DateTime> onDay;
  final VoidCallback? onCompare;
  final DateTime? now;

  List<LessonSchedulePart> _lessons(DateTime date) => visibleLessonsForDay(
    schedule: schedule,
    day: date,
    now: now ?? DateTime.now(),
    preferences: preferences,
    display: display,
    changes: changes,
  );

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final locale = Localizations.localeOf(context).toString();
    final dates = weekDaysFor(day);
    final friendOccupancy = {
      for (final date in dates)
        date: comparisonOccupancyForDay(
          day: date,
          schedule: friend?.schedule ?? const [],
          activities: friend == null ? const [] : friendActivities,
        ),
    };
    final showSunday =
        _lessons(dates.last).isNotEmpty ||
        friendOccupancy[dates.last]!.hasEntries ||
        _activitySlots(dates.last).isNotEmpty ||
        _events(dates.last).isNotEmpty ||
        _untimedActivities(activities, [dates.last]).isNotEmpty ||
        schedule
            .where((part) => part is! LessonSchedulePart)
            .any(
              (part) => _noticeDates(part).any(
                (date) => isSameDate(date, dates.last),
              ),
            );
    final days = dates.take(showSunday ? 7 : 6).toList();
    String calendarLabel(SchedulePart part) {
      final title = part is HolidaySchedulePart
          ? part.title
          : (part as CalendarSchedulePart).title;
      final dateLabels = _noticeDates(part)
          .where((date) => days.any((day) => isSameDate(day, date)))
          .map((date) => DateFormat.MMMd(locale).format(date));
      final time =
          part is CalendarSchedulePart &&
              !part.isAllDay &&
              part.startsAt != null
          ? ' · ${DateFormat.Hm(locale).format(part.startsAt!)}'
          : '';
      return '$title · ${dateLabels.join(', ')}$time';
    }

    String activityLabel(UserActivity activity) {
      final time = DateFormat.MMMd(locale).add_Hm().format(activity.startsAt);
      return '${activity.title} · $time';
    }

    String dayLabel(DateTime date) =>
        '${DateFormat.yMMMMd(locale).format(date)}, '
        '${scheduleDayLabel(context, date)}';

    final configured =
        context.read<UniversityConfig?>()?.lessonBellSlots ??
        UniversityConfig.defaultLessonBellSlots;
    final bells = scheduleWeekSlots(
      configured: configured,
      occupied: [
        for (final date in days) ...[
          for (final lesson in _lessons(date))
            LessonBellSlotConfig(
              startMinutes: minutesOfDay(lesson.lessonBells.startTime),
              endMinutes: minutesOfDay(lesson.lessonBells.endTime),
            ),
          for (final range in friendOccupancy[date]!.ranges)
            LessonBellSlotConfig(
              startMinutes: range.$1,
              endMinutes: range.$2,
            ),
          ..._activitySlots(date),
          for (final event in _events(date))
            scheduleSlotForDay(
              startsAt: event.startsAt!,
              endsAt: event.endsAt,
              day: date,
            )!,
        ],
      ],
    );
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            Expanded(
              child: AppButton.secondary(
                label: l10n.scheduleCompareFriend,
                size: AppButtonSize.small,
                icon: const AppLineIconWidget(AppLineIcon.people, size: 16),
                backgroundColor: friend == null
                    ? context.colors.surface
                    : context.colors.accent,
                foregroundColor: friend == null
                    ? null
                    : context.colors.onAccent,
                onPressed: onCompare ?? () => showCompareSheet(context),
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.md),
        for (final part in schedule)
          if ((part is HolidaySchedulePart ||
                  part is CalendarSchedulePart &&
                      (part.isAllDay || !_hasTimeRange(part))) &&
              _noticeDates(part).any(
                (date) => days.any((day) => isSameDate(day, date)),
              ))
            Padding(
              padding: const EdgeInsets.only(bottom: AppSpacing.sm),
              child: AppBanner(message: calendarLabel(part)),
            ),
        for (final activity in _untimedActivities(activities, days))
          Padding(
            padding: const EdgeInsets.only(bottom: AppSpacing.sm),
            child: AppBanner(message: activityLabel(activity)),
          ),
        if (friend != null) ...[
          for (final part in friend!.schedule.whereType<CalendarSchedulePart>())
            if ((part.isAllDay || !_hasTimeRange(part)) &&
                _noticeDates(part).any(
                  (date) => days.any((day) => isSameDate(day, date)),
                ))
              Padding(
                padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                child: AppBanner(
                  message: '${friend!.name} · ${calendarLabel(part)}',
                ),
              ),
          for (final activity in _untimedActivities(friendActivities, days))
            Padding(
              padding: const EdgeInsets.only(bottom: AppSpacing.sm),
              child: AppBanner(
                message: '${friend!.name} · ${activityLabel(activity)}',
              ),
            ),
        ],
        AppCard(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.md,
            AppSpacing.sectionGap,
            AppSpacing.md,
            AppSpacing.lg,
          ),
          child: LayoutBuilder(
            builder: (context, constraints) {
              final width = math.max(
                constraints.maxWidth,
                MediaQuery.textScalerOf(context).scale(324),
              );
              return SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: SizedBox(
                  width: width,
                  child: Column(
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(width: ScheduleMetrics.timeColumn),
                          for (final date in days)
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.only(
                                  left: AppSpacing.xs,
                                ),
                                child: AppDayPill(
                                  dense: true,
                                  selected: isSameDate(date, day),
                                  day: AppWeekDay(
                                    '${date.day}',
                                    short: DateFormat.E(
                                      locale,
                                    ).format(date).toUpperCase(),
                                    isToday: isSameDate(
                                      date,
                                      now ?? DateTime.now(),
                                    ),
                                    isWeekend: RussianWorkCalendar.dayInfo(
                                      date,
                                    ).isNonWorking,
                                    semanticsLabel: dayLabel(date),
                                    dots: [
                                      for (final mark in scheduleDayMarks(
                                        context,
                                        schedule: schedule,
                                        day: date,
                                        now: now ?? DateTime.now(),
                                        preferences: preferences,
                                        display: display,
                                        changes: changes,
                                      ))
                                        mark.$2,
                                    ],
                                  ),
                                  onTap: () => onDay(date),
                                ),
                              ),
                            ),
                        ],
                      ),
                      for (var index = 0; index < bells.length; index++)
                        Padding(
                          padding: EdgeInsets.only(
                            top: index == AppSpacing.zero
                                ? AppSpacing.sm
                                : AppSpacing.xs,
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                width: ScheduleMetrics.timeColumn,
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                    top: AppSpacing.xsm,
                                  ),
                                  child: Text(
                                    _time(bells[index].startMinutes),
                                    style: AppText.micro.copyWith(
                                      color: context.colors.muted,
                                    ),
                                  ),
                                ),
                              ),
                              for (final date in days)
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                      left: AppSpacing.xs,
                                    ),
                                    child: KeyedSubtree(
                                      key: ValueKey(
                                        'week-cell-${date.toIso8601String()}-'
                                        '${bells[index].startMinutes}',
                                      ),
                                      child: _cell(
                                        context,
                                        date,
                                        bells[index],
                                        friendOccupancy[date]!,
                                      ),
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.xsm,
            AppSpacing.sectionGap,
            AppSpacing.xsm,
            AppSpacing.zero,
          ),
          child: Wrap(
            spacing: AppSpacing.sectionGap,
            runSpacing: AppSpacing.sm,
            children: [
              for (final item in [
                (l10n.lecture, context.colors.lecture),
                (l10n.practice, context.colors.practice),
                (l10n.lessonTypeLabName, context.colors.lab),
                (l10n.scheduleChangeTagCancelled, context.colors.exam),
                (l10n.scheduleLegendAddOwn, null),
              ])
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      key: ValueKey('schedule-legend-${item.$1}'),
                      width: AppSpacing.gap,
                      height: AppSpacing.gap,
                      decoration: BoxDecoration(
                        color: item.$2,
                        border: item.$2 == null
                            ? Border.all(color: context.colors.muted2)
                            : null,
                        borderRadius: BorderRadius.circular(AppRadius.bar),
                      ),
                    ),
                    const SizedBox(width: AppSpacing.xsm),
                    Flexible(
                      child: Text(
                        item.$1,
                        style: AppText.sans(
                          12,
                          FontWeight.w600,
                        ).copyWith(color: context.colors.muted),
                      ),
                    ),
                  ],
                ),
            ],
          ),
        ),
        Wrap(
          alignment: WrapAlignment.spaceBetween,
          children: [
            AppButton.text(
              label: l10n.schedulePrevWeek,
              size: AppButtonSize.small,
              onPressed: () => onDay(day.subtract(const Duration(days: 7))),
            ),
            AppButton.text(
              label: l10n.todayLower,
              size: AppButtonSize.small,
              onPressed: () => onDay(now ?? DateTime.now()),
            ),
            AppButton.text(
              label: l10n.scheduleNextWeek,
              size: AppButtonSize.small,
              onPressed: () => onDay(day.add(const Duration(days: 7))),
            ),
          ],
        ),
      ],
    );
  }

  Widget _cell(
    BuildContext context,
    DateTime date,
    LessonBellSlotConfig bell,
    ComparisonDayOccupancy occupancy,
  ) {
    final lessons = _lessons(date).where((l) => _overlap(l, bell)).toList();
    final busy = occupancy.isBusy(bell.startMinutes, bell.endMinutes);
    final uncertain = occupancy.isUncertain(bell.startMinutes, bell.endMinutes);
    final friendFree = occupancy.isFree(bell.startMinutes, bell.endMinutes);
    final own = activities
        .where(
          (activity) =>
              _activityOverlap(activity, date, bell) &&
              (display.showPast ||
                  activity.endsAt!.isAfter(now ?? DateTime.now())),
        )
        .toList();
    final events = _events(
      date,
    ).where((event) => _eventOverlap(event, date, bell)).toList();
    if (lessons.isNotEmpty || own.isNotEmpty || events.isNotEmpty) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        spacing: AppSpacing.xs,
        children: [
          if (lessons.isNotEmpty)
            ScheduleOverlapSwitcher(
              key: ValueKey(
                'week-overlap-${date.toIso8601String()}-${bell.startMinutes}',
              ),
              compact: true,
              labels: [for (final lesson in lessons) lesson.subject],
              colors: [
                for (final lesson in lessons) lessonAccentOf(context, lesson),
              ],
              children: [
                for (final lesson in lessons)
                  _adaptiveCell(
                    context,
                    AppWeekGridCell(
                      scheduleStyle: true,
                      selected: isSameDate(date, day),
                      variant: isCancelled(changeFor(changes, lesson, date))
                          ? AppWeekGridCellVariant.cancelled
                          : AppWeekGridCellVariant.filled,
                      topLabel: isCancelled(changeFor(changes, lesson, date))
                          ? context.l10n.scheduleShortCancelled
                          : lessonShortLabel(context.l10n, lesson.lessonType),
                      bottomLabel: _availabilityLabel(
                        switch (lesson.classrooms.firstOrNull) {
                          final classroom? => classroomLabel(classroom),
                          null => '—',
                        },
                        free: friendFree,
                      ),
                      tone: lessonAccentOf(context, lesson),
                      onTap: () => ScheduleDetailsRoute(
                        $extra: (lesson, date),
                      ).push<void>(context),
                    ),
                  ),
              ],
            ),
          for (final activity in own)
            _adaptiveCell(
              context,
              AppWeekGridCell(
                scheduleStyle: true,
                selected: isSameDate(date, day),
                topLabel: activity.title,
                bottomLabel: _availabilityLabel(
                  activity.place,
                  free: friendFree,
                ),
                tone: context.colors.ink,
              ),
            ),
          for (final event in events)
            _adaptiveCell(
              context,
              AppWeekGridCell(
                scheduleStyle: true,
                selected: isSameDate(date, day),
                topLabel: event.title,
                bottomLabel: _availabilityLabel(
                  event.location,
                  free: friendFree,
                ),
                tone: context.colors.accent,
                onTap: () => onDay(date),
              ),
            ),
        ],
      );
    }
    return _adaptiveCell(
      context,
      AppWeekGridCell(
        scheduleStyle: true,
        variant: busy
            ? AppWeekGridCellVariant.busy
            : uncertain
            ? AppWeekGridCellVariant.filled
            : AppWeekGridCellVariant.empty,
        tone: uncertain ? context.colors.muted : null,
        topLabel: busy
            ? context.l10n.compareFriend.toUpperCase()
            : uncertain
            ? context.l10n.legendEvent
            : null,
        bottomLabel: uncertain ? context.l10n.toolsNoValue : null,
        onTap: uncertain
            ? () => onDay(date)
            : !busy
            ? () => showAddLessonSheet(context, day: date, bell: bell)
            : null,
      ),
    );
  }

  String? _availabilityLabel(String? label, {required bool free}) =>
      friend != null && free ? '${label ?? '—'} ✓' : label;

  Widget _adaptiveCell(BuildContext context, Widget child) => ConstrainedBox(
    constraints: BoxConstraints(
      minHeight: math.max(54, MediaQuery.textScalerOf(context).scale(23) + 12),
    ),
    child: child,
  );

  bool _activityOverlap(
    UserActivity activity,
    DateTime date,
    LessonBellSlotConfig slot,
  ) {
    final activitySlot = scheduleSlotForDay(
      startsAt: activity.startsAt,
      endsAt: activity.endsAt,
      day: date,
    );
    return activitySlot != null && scheduleSlotsOverlap(activitySlot, slot);
  }

  bool _overlap(LessonSchedulePart lesson, LessonBellSlotConfig slot) =>
      minutesOfDay(lesson.lessonBells.startTime) < slot.endMinutes &&
      minutesOfDay(lesson.lessonBells.endTime) > slot.startMinutes;

  Iterable<CalendarSchedulePart> _events(DateTime date) =>
      schedule.whereType<CalendarSchedulePart>().where(
        (event) =>
            !event.isAllDay &&
            _hasTimeRange(event) &&
            scheduleSlotForDay(
                  startsAt: event.startsAt!,
                  endsAt: event.endsAt,
                  day: date,
                ) !=
                null &&
            (display.showPast || event.endsAt!.isAfter(now ?? DateTime.now())),
      );

  bool _hasTimeRange(CalendarSchedulePart event) =>
      event.startsAt != null &&
      event.endsAt != null &&
      event.endsAt!.isAfter(event.startsAt!);

  Iterable<DateTime> _noticeDates(SchedulePart part) =>
      part is CalendarSchedulePart && !part.isAllDay && part.startsAt != null
      ? [part.startsAt!]
      : part.dates;

  Iterable<UserActivity> _untimedActivities(
    List<UserActivity> source,
    List<DateTime> days,
  ) => source.where(
    (activity) =>
        (activity.endsAt == null ||
            !activity.endsAt!.isAfter(activity.startsAt)) &&
        days.any((date) => isSameDate(date, activity.startsAt)),
  );

  Iterable<LessonBellSlotConfig> _activitySlots(DateTime date) sync* {
    for (final activity in activities) {
      if (activity.endsAt == null ||
          (!display.showPast &&
              !activity.endsAt!.isAfter(now ?? DateTime.now()))) {
        continue;
      }
      final slot = scheduleSlotForDay(
        startsAt: activity.startsAt,
        endsAt: activity.endsAt,
        day: date,
      );
      if (slot != null) yield slot;
    }
  }

  bool _eventOverlap(
    CalendarSchedulePart event,
    DateTime date,
    LessonBellSlotConfig slot,
  ) =>
      event.startsAt!.isBefore(
        dateOnly(date).add(Duration(minutes: slot.endMinutes)),
      ) &&
      event.endsAt!.isAfter(
        dateOnly(date).add(Duration(minutes: slot.startMinutes)),
      );

  String _time(int minutes) =>
      '${(minutes ~/ 60).toString().padLeft(2, '0')}:'
      '${(minutes % 60).toString().padLeft(2, '0')}';
}
