part of '../schedule_page.dart';

class _ScheduleDayPager extends StatelessWidget {
  const _ScheduleDayPager({
    required this.controller,
    required this.paging,
    required this.parts,
    required this.preferences,
    required this.activities,
    required this.filter,
    required this.showPast,
    required this.nowMarkerKey,
    required this.onPageChanged,
    required this.onRefresh,
    required this.onTogglePast,
    required this.onAddActivity,
    required this.onShowWeek,
    required this.onFilterChanged,
    required this.onLessonTap,
    required this.onLessonActions,
  });

  final PageController controller;
  final SchedulePaging paging;
  final List<SchedulePart> parts;
  final SchedulePreferencesState preferences;
  final UserActivitiesState activities;
  final _ScheduleFilter filter;
  final bool showPast;
  final GlobalKey nowMarkerKey;
  final ValueChanged<int> onPageChanged;
  final Future<void> Function() onRefresh;
  final VoidCallback onTogglePast;
  final VoidCallback onAddActivity;
  final VoidCallback onShowWeek;
  final ValueChanged<_ScheduleFilter> onFilterChanged;
  final void Function(LessonSchedulePart lesson, DateTime day) onLessonTap;
  final void Function(LessonSchedulePart lesson, DateTime day) onLessonActions;

  @override
  Widget build(BuildContext context) {
    final today = DateTime.now();
    return PageView.builder(
      key: const ValueKey('schedule-day-pager'),
      controller: controller,
      itemCount: paging.dayPageCount,
      allowImplicitScrolling: true,
      onPageChanged: onPageChanged,
      itemBuilder: (context, index) {
        final day = paging.dayOfPage(index);
        return _ScheduleDayPage(
          key: ValueKey(day),
          day: day,
          parts: parts,
          preferences: preferences,
          activities: activities,
          filter: filter,
          showPast: showPast,
          nowMarkerKey: isSameDate(day, today) ? nowMarkerKey : null,
          onRefresh: onRefresh,
          onTogglePast: onTogglePast,
          onAddActivity: onAddActivity,
          onShowWeek: onShowWeek,
          onFilterChanged: onFilterChanged,
          onLessonTap: onLessonTap,
          onLessonActions: onLessonActions,
        );
      },
    );
  }
}
