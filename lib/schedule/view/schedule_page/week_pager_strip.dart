part of '../schedule_page.dart';

const _kWeekStripMaxTextScale = 1.3;

double _weekStripExtent(BuildContext context) {
  final scale = MediaQuery.textScalerOf(
    context,
  ).scale(1).clamp(1.0, _kWeekStripMaxTextScale);
  return 74 + (scale - 1) * 36;
}

int _dayKey(DateTime date) => date.year * 10000 + date.month * 100 + date.day;

class _WeekPagerStrip extends StatelessWidget {
  const _WeekPagerStrip({
    required this.controller,
    required this.paging,
    required this.selectedDay,
    required this.schedule,
    required this.activities,
    required this.preferences,
    required this.dayLayoutKeyBuilder,
    required this.onDaySelected,
    required this.onWeekPageChanged,
  });

  final PageController controller;
  final SchedulePaging paging;
  final DateTime selectedDay;
  final List<SchedulePart> schedule;
  final UserActivitiesState activities;
  final SchedulePreferencesState preferences;
  final GlobalKey Function(DateTime day) dayLayoutKeyBuilder;
  final ValueChanged<DateTime> onDaySelected;
  final ValueChanged<int> onWeekPageChanged;

  @override
  Widget build(BuildContext context) {
    final colors = context.ninja;
    final lessons = _applyPreferences(
      schedule.whereType<LessonSchedulePart>().toList(),
      preferences,
    );
    final lessonColors = <int, List<Color>>{};
    for (final lesson in lessons) {
      for (final date in lesson.dates) {
        lessonColors
            .putIfAbsent(_dayKey(date), () => <Color>[])
            .add(colors.subjectColor(lesson.subject));
      }
    }

    return ColoredBox(
      key: const ValueKey('schedule-sticky-day-calendar'),
      color: colors.canvas,
      child: SizedBox(
        height: _weekStripExtent(context),
        child: MediaQuery.withClampedTextScaling(
          maxScaleFactor: _kWeekStripMaxTextScale,
          child: PageView.builder(
            key: const ValueKey('schedule-week-pager'),
            controller: controller,
            itemCount: paging.weekPageCount,
            onPageChanged: onWeekPageChanged,
            itemBuilder: (context, index) => _WeekStripPage(
              days: paging.daysOfWeekPage(index),
              selectedDay: selectedDay,
              lessonColors: lessonColors,
              activities: activities,
              dayLayoutKeyBuilder: dayLayoutKeyBuilder,
              onDaySelected: onDaySelected,
            ),
          ),
        ),
      ),
    );
  }
}
