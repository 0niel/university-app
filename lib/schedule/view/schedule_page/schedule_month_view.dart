import 'package:academic_calendar/academic_calendar.dart';
import 'package:app_ui/app_ui.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:rtu_mirea_app/l10n/l10n.dart';
import 'package:rtu_mirea_app/schedule/cubit/cubit.dart';
import 'package:rtu_mirea_app/schedule/view/schedule_page/lesson_status.dart';
import 'package:rtu_mirea_app/schedule/view/schedule_page/lesson_text.dart';
import 'package:rtu_mirea_app/schedule/view/schedule_page/schedule_calendar_notice.dart';
import 'package:rtu_mirea_app/schedule/view/schedule_page/schedule_dates.dart';
import 'package:schedule_repository/schedule_repository.dart';

class ScheduleMonthView extends StatelessWidget {
  const ScheduleMonthView({
    required this.day,
    required this.schedule,
    required this.preferences,
    required this.onDay,
    required this.onMonth,
    this.now,
    this.display = const ScheduleDisplayState(),
    this.changes = const [],
    this.activities = const [],
    super.key,
  });

  final DateTime day;
  final List<SchedulePart> schedule;
  final SchedulePreferencesState preferences;
  final ValueChanged<DateTime> onDay;
  final ValueChanged<DateTime> onMonth;
  final DateTime? now;
  final ScheduleDisplayState display;
  final List<ScheduleChange> changes;
  final List<UserActivity> activities;

  List<(String, Color, bool)> _markers(BuildContext context, DateTime date) => [
    if (scheduleSpecialDay(date))
      (scheduleDayLabel(context, date), context.colors.warn, false),
    for (final activity in activities)
      if (activity.startsAt.isBefore(date.add(const Duration(days: 1))) &&
          (activity.endsAt ?? activity.startsAt.add(const Duration(hours: 1)))
              .isAfter(date) &&
          (display.showPast ||
              (activity.endsAt ??
                      activity.startsAt.add(const Duration(hours: 1)))
                  .isAfter(now ?? DateTime.now())))
        (activity.title, context.colors.ink, true),
    for (final part in schedule)
      if (part.dates.any((day) => isSameDate(day, date)))
        if (part is HolidaySchedulePart)
          (part.title, context.colors.warn, false)
        else if (part is CalendarSchedulePart &&
            (display.showPast ||
                (part.endsAt ??
                        (part.isAllDay || part.startsAt == null
                            ? date.add(const Duration(days: 1))
                            : part.startsAt!.add(const Duration(hours: 1))))
                    .isAfter(now ?? DateTime.now())))
          (part.title, context.colors.accent, true),
  ];

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
    final colors = context.colors;
    final locale = Localizations.localeOf(context).toString();
    final start = DateTime(day.year, day.month);
    final end = DateTime(day.year, day.month + 1);
    final gridStart = weekStartFor(start);
    final cells = ((end.difference(gridStart).inDays + 6) ~/ 7) * 7;
    final all = <LessonSchedulePart>[];
    for (var d = start; d.isBefore(end); d = d.add(const Duration(days: 1))) {
      final lessons = _lessons(d);
      all.addAll(lessons);
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        AppCard(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.sectionGap,
            AppSpacing.lg,
            AppSpacing.sectionGap,
            AppSpacing.lg,
          ),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.xs,
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.baseline,
                  textBaseline: TextBaseline.alphabetic,
                  children: [
                    Expanded(
                      child: Text(
                        capitalizeFirst(DateFormat.MMMM(locale).format(day)),
                        style: AppText.section.copyWith(color: colors.ink),
                      ),
                    ),
                    const SizedBox(width: AppSpacing.sm),
                    Flexible(
                      child: Text(
                        l10n.scheduleMonthMeta(
                          day.year,
                          day.month >= 9 || day.month == 1 ? 1 : 2,
                        ),
                        textAlign: TextAlign.end,
                        style: AppText.sans(
                          12.5,
                          FontWeight.w500,
                        ).copyWith(color: colors.muted),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.sectionGap),
              Row(
                children: [
                  for (final date in weekDaysFor(day))
                    Expanded(
                      child: Center(
                        child: Text(
                          DateFormat.E(locale).format(date).toUpperCase(),
                          style:
                              AppText.sans(
                                10,
                                FontWeight.w700,
                                letterSpacingEm: .04,
                              ).copyWith(
                                color: date.weekday >= 6
                                    ? colors.muted2
                                    : colors.muted,
                              ),
                        ),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: AppSpacing.xs),
              for (var row = 0; row < cells ~/ 7; row++)
                Row(
                  children: [
                    for (var column = 0; column < 7; column++)
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(AppSpacing.xxs),
                          child: _MonthCell(
                            day: gridStart.add(
                              Duration(days: row * 7 + column),
                            ),
                            selected: day,
                            now: now ?? DateTime.now(),
                            month: day.month,
                            lessons: _lessons(
                              gridStart.add(Duration(days: row * 7 + column)),
                            ),
                            markers: _markers(
                              context,
                              gridStart.add(Duration(days: row * 7 + column)),
                            ),
                            onTap: onDay,
                          ),
                        ),
                      ),
                  ],
                ),
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.gap),
        AppCard(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.lg,
            vertical: AppSpacing.sectionGap,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                l10n.scheduleMonthStatsTitle.toUpperCase(),
                style: AppText.sans(
                  11.5,
                  FontWeight.w700,
                  letterSpacingEm: .06,
                ).copyWith(color: colors.muted),
              ),
              const SizedBox(height: AppSpacing.gap),
              ScheduleMonthTypeChart(lessons: all),
            ],
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            AppIconButton(
              icon: const AppLineIconWidget(AppLineIcon.chevronL),
              tooltip: l10n.previousMonth,
              tone: AppIconButtonTone.plain,
              onPressed: () => onMonth(DateTime(day.year, day.month - 1)),
            ),
            AppIconButton(
              icon: const AppLineIconWidget(AppLineIcon.chevronR),
              tooltip: l10n.nextMonth,
              tone: AppIconButtonTone.plain,
              onPressed: () => onMonth(DateTime(day.year, day.month + 1)),
            ),
          ],
        ),
      ],
    );
  }
}

class ScheduleMonthTypeChart extends StatelessWidget {
  const ScheduleMonthTypeChart({required this.lessons, super.key});

  final List<LessonSchedulePart> lessons;

  @override
  Widget build(BuildContext context) {
    final counts = <LessonType, int>{};
    final colors = <LessonType, Color>{};
    for (final lesson in lessons) {
      counts.update(lesson.lessonType, (count) => count + 1, ifAbsent: () => 1);
      colors[lesson.lessonType] = lessonAccentOf(context, lesson);
    }
    final types = LessonType.values.where(counts.containsKey).toList();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        AppSegmentedBar(
          key: const ValueKey('schedule-month-type-chart'),
          height: AppSpacing.sm,
          segments: [
            for (final type in types)
              AppSegmentedBarPart(flex: counts[type]!, color: colors[type]!),
          ],
          restFlex: types.isEmpty ? 1 : 0,
        ),
        const SizedBox(height: AppSpacing.md),
        if (types.isEmpty)
          Text(
            context.l10n.scheduleDayLessons(0),
            style: AppText.captionSmall.copyWith(color: context.colors.muted),
          )
        else
          Wrap(
            spacing: AppSpacing.md,
            runSpacing: AppSpacing.sm,
            children: [
              for (final type in types)
                Row(
                  key: ValueKey('schedule-month-type-${type.name}'),
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    AppDot(color: colors[type]),
                    const SizedBox(width: AppSpacing.xsm),
                    Flexible(
                      child: Text(
                        '${lessonTypeName(context.l10n, type)} · '
                        '${counts[type]}',
                        style: AppText.captionSmall.copyWith(
                          color: context.colors.muted,
                        ),
                      ),
                    ),
                  ],
                ),
            ],
          ),
      ],
    );
  }
}

class _MonthCell extends StatelessWidget {
  const _MonthCell({
    required this.day,
    required this.selected,
    required this.now,
    required this.month,
    required this.lessons,
    required this.markers,
    required this.onTap,
  });
  final DateTime day;
  final DateTime selected;
  final DateTime now;
  final int month;
  final List<LessonSchedulePart> lessons;
  final List<(String, Color, bool)> markers;
  final ValueChanged<DateTime> onTap;

  @override
  Widget build(BuildContext context) {
    if (day.month != month) {
      return const SizedBox(height: AppControlSize.navCircle);
    }
    final picked = isSameDate(day, selected);
    final today = isSameDate(day, now);
    final colors = context.colors;
    return AppPressState(
      key: ValueKey('schedule-month-day-${day.day}'),
      semanticsLabel: [
        DateFormat.yMMMMd(
          Localizations.localeOf(context).toString(),
        ).format(day),
        ...markers.map((marker) => marker.$1),
        ...lessons.map(
          (lesson) =>
              '${lessonTypeName(context.l10n, lesson.lessonType)} · '
              '${lesson.subject}',
        ),
        if (RussianWorkCalendar.dayInfo(day).kind == RussianDayKind.weekend)
          scheduleDayLabel(context, day),
      ].join(', '),
      semanticsSelected: picked,
      onTap: () => onTap(day),
      builder: (context, {required pressed}) => AnimatedContainer(
        duration:
            MediaQuery.disableAnimationsOf(context) ||
                MediaQuery.accessibleNavigationOf(context)
            ? Duration.zero
            : const Duration(milliseconds: 240),
        constraints: const BoxConstraints(minHeight: AppControlSize.navCircle),
        padding: const EdgeInsets.symmetric(vertical: 5),
        decoration: BoxDecoration(
          color: picked
              ? colors.accent
              : pressed
              ? colors.surface2
              : colors.surface,
          borderRadius: BorderRadius.circular(AppRadius.iconTile),
          border: today && !picked
              ? Border.all(color: colors.accent, width: AppSpacing.xxs)
              : null,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '${day.day}',
              style: AppText.time.copyWith(
                color: picked
                    ? colors.onAccent
                    : RussianWorkCalendar.dayInfo(day).isNonWorking
                    ? colors.muted2
                    : colors.ink,
              ),
            ),
            const SizedBox(height: AppSpacing.xs),
            ConstrainedBox(
              constraints: const BoxConstraints(minHeight: AppSpacing.xs),
              child: Wrap(
                alignment: WrapAlignment.center,
                spacing: AppSpacing.xxs,
                runSpacing: AppSpacing.xxs,
                children: [
                  for (final color in [
                    for (final marker in markers.where((marker) => marker.$3))
                      marker.$2,
                    for (final lesson in lessons)
                      lessonAccentOf(context, lesson),
                  ])
                    DecoratedBox(
                      decoration: BoxDecoration(
                        color: picked ? colors.surface : null,
                        shape: BoxShape.circle,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(.75),
                        child: AppDot(size: 4, color: color),
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
