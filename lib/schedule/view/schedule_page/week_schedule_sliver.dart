part of '../schedule_page.dart';

class _WeekScheduleSliver extends StatelessWidget {
  const _WeekScheduleSliver({
    required this.days,
    required this.schedule,
    required this.activities,
    required this.preferences,
    required this.filter,
    required this.onWeekShift,
    required this.onDaySelected,
  });

  final List<DateTime> days;
  final List<SchedulePart> schedule;
  final UserActivitiesState activities;
  final SchedulePreferencesState preferences;
  final _ScheduleFilter filter;
  final ValueChanged<int> onWeekShift;
  final ValueChanged<DateTime> onDaySelected;

  @override
  Widget build(BuildContext context) {
    final workDays = days.take(7).toList();
    final weekStart = workDays.firstOrNull;
    if (weekStart == null) {
      return const SliverToBoxAdapter(child: SizedBox.shrink());
    }
    final unconfirmedDay = workDays
        .where(
          (day) => !RussianWorkCalendar.dayInfo(day).transferCalendarKnown,
        )
        .firstOrNull;
    return SliverPadding(
      padding: const .fromLTRB(
        NinjaMetrics.screenPadding,
        6,
        NinjaMetrics.screenPadding,
        84,
      ),
      sliver: SliverToBoxAdapter(
        child: Column(
          children: [
            _WeekParitySwitcher(
              weekStart: weekStart,
              onPrev: () => onWeekShift(-1),
              onNext: () => onWeekShift(1),
            ),
            if (unconfirmedDay != null) ...[
              const SizedBox(height: 8),
              Align(
                alignment: Alignment.centerLeft,
                child: _ScheduleTransferCoveragePill(
                  year: unconfirmedDay.year,
                ),
              ),
            ],
            const SizedBox(height: 10),
            for (final day in workDays) ...[
              _WeekDayColumn(
                key: ValueKey('schedule-week-day-${_dayKey(day)}'),
                day: day,
                today: isSameDate(day, DateTime.now()),
                activities: activities.forDay(day),
                lessons: _filteredLessonsStatic(
                  _applyPreferences(
                    _lessonsForDay(schedule, day),
                    preferences,
                  ),
                  filter,
                ),
                onTap: () => onDaySelected(day),
              ),
              const SizedBox(height: 10),
            ],
          ],
        ),
      ),
    );
  }
}
