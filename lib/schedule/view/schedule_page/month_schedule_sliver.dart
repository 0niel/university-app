part of '../schedule_page.dart';

class _MonthScheduleSliver extends StatelessWidget {
  const _MonthScheduleSliver({
    required this.month,
    required this.selectedDay,
    required this.dayLayoutKeyBuilder,
    required this.schedule,
    required this.preferences,
    required this.onDaySelected,
  });

  final DateTime month;
  final DateTime selectedDay;
  final GlobalKey Function(DateTime day) dayLayoutKeyBuilder;
  final List<SchedulePart> schedule;
  final SchedulePreferencesState preferences;

  final ValueChanged<DateTime> onDaySelected;

  @override
  Widget build(BuildContext context) {
    final activities = context.watch<UserActivitiesCubit>().state;
    final first = DateTime(month.year, month.month);
    final daysInMonth = DateTime(month.year, month.month + 1, 0).day;
    final leading = (first.weekday - DateTime.monday) % 7;
    final today = dateOnly(DateTime.now());
    final visibleLessons = _applyPreferences(
      schedule.whereType<LessonSchedulePart>().toList(),
      preferences,
    );
    final lessonColorsByDay = <int, List<Color>>{};
    for (final lesson in visibleLessons) {
      for (final date in lesson.dates) {
        if (date.year != month.year || date.month != month.month) continue;
        lessonColorsByDay
            .putIfAbsent(date.day, () => <Color>[])
            .add(context.ninja.subjectColor(lesson.subject));
      }
    }

    final cells = <DateTime?>[
      for (var i = 0; i < leading; i++) null,
      for (var d = 1; d <= daysInMonth; d++)
        DateTime(month.year, month.month, d),
    ];

    return SliverPadding(
      padding: EdgeInsets.fromLTRB(
        0,
        8,
        0,
        84 + ninjaBottomInset(context),
      ),
      sliver: SliverList(
        delegate: SliverChildListDelegate([
          if (!RussianWorkCalendar.dayInfo(first).transferCalendarKnown)
            Padding(
              padding: const .fromLTRB(
                NinjaMetrics.screenPadding,
                0,
                NinjaMetrics.screenPadding,
                8,
              ),
              child: Align(
                alignment: Alignment.centerLeft,
                child: _ScheduleTransferCoveragePill(year: month.year),
              ),
            ),
          LayoutBuilder(
            key: ValueKey('month-${month.year}-${month.month}'),
            builder: (context, constraints) {
              final scale = math
                  .max(
                    1,
                    MediaQuery.textScalerOf(context).scale(1),
                  )
                  .toDouble();
              final cellHeight = 58 + (scale - 1) * 24;
              return SizedBox(
                width: constraints.maxWidth,
                child: GridView.count(
                  crossAxisCount: 7,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  mainAxisSpacing: 2,
                  crossAxisSpacing: 2,
                  mainAxisExtent: cellHeight,
                  children: [
                    for (final cell in cells)
                      if (cell == null)
                        const SizedBox.shrink()
                      else
                        _MonthCell(
                          day: cell,
                          lessonColors: lessonColorsByDay[cell.day] ?? const [],
                          activityTypes: activities.typesOn(cell),
                          selected: isSameDate(cell, selectedDay),
                          today: isSameDate(cell, today),
                          layoutKey: dayLayoutKeyBuilder(cell),
                          onTap: () => onDaySelected(cell),
                        ),
                  ],
                ),
              );
            },
          ),
          const SizedBox(height: 20),
          const Padding(
            padding: .symmetric(horizontal: NinjaMetrics.screenPadding),
            child: _MonthLegend(),
          ),
        ]),
      ),
    );
  }
}

class _MonthCalendarHeader extends StatelessWidget {
  const _MonthCalendarHeader({
    required this.month,
    required this.onPrev,
    required this.onNext,
  });

  final DateTime month;
  final VoidCallback onPrev;
  final VoidCallback onNext;

  @override
  Widget build(BuildContext context) {
    final colors = context.ninja;
    final l10n = context.l10n;
    final weekdayLabels = [
      l10n.weekdayShortMon,
      l10n.weekdayShortTue,
      l10n.weekdayShortWed,
      l10n.weekdayShortThu,
      l10n.weekdayShortFri,
      l10n.weekdayShortSat,
      l10n.weekdayShortSun,
    ];

    return ColoredBox(
      key: const ValueKey('schedule-sticky-month-calendar'),
      color: colors.canvas,
      child: Column(
        children: [
          Padding(
            padding: const .symmetric(
              horizontal: NinjaMetrics.screenPadding,
            ),
            child: _MonthSwitcher(
              month: month,
              onPrev: onPrev,
              onNext: onNext,
            ),
          ),
          Padding(
            padding: const .only(bottom: 8),
            child: Row(
              children: [
                for (final (index, label) in weekdayLabels.indexed)
                  Expanded(
                    child: Text(
                      label.toUpperCase(),
                      textAlign: .center,
                      style: NinjaText.badge.copyWith(
                        color: index >= 5 ? colors.amberInk : colors.muted,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
