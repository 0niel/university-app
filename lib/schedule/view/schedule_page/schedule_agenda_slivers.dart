part of '../schedule_page.dart';

List<Widget> _agendaSlivers({
  required DateTime day,
  required List<SchedulePart> parts,
  required _ScheduleDayModel model,
  required _ScheduleFilter filter,
  required bool showPast,
  required GlobalKey? nowMarkerKey,
  required VoidCallback onTogglePast,
  required VoidCallback onAddActivity,
  required VoidCallback onShowWeek,
  required ValueChanged<_ScheduleFilter> onFilterChanged,
  required void Function(LessonSchedulePart lesson, DateTime day) onLessonTap,
  required void Function(LessonSchedulePart lesson, DateTime day)
  onLessonActions,
}) {
  return [
    SliverToBoxAdapter(
      child: _ScheduleHeader(
        selectedDay: day,
        lessons: model.lessons,
      ),
    ),
    if (model.busy)
      SliverToBoxAdapter(
        child: _BusyDayDensityBar(
          lessons: model.lessons,
          activities: model.activities,
        ),
      ),
    if (model.lessons.isNotEmpty)
      SliverToBoxAdapter(
        child: _FilterChips(value: filter, onChanged: onFilterChanged),
      ),
    if (model.isEmpty)
      _ScheduleEmptySliver(
        day: day,
        schedule: parts,
        onAddActivity: onAddActivity,
        onShowWeek: onShowWeek,
        onLessonTap: onLessonTap,
      )
    else if (model.isFilteredOut)
      _EmptyFilterSliver(
        filter: filter,
        onReset: () => onFilterChanged(.all),
      )
    else
      _ListScheduleSliver(
        day: day,
        lessons: model.filteredLessons,
        filtered: filter != .all,
        showPast: showPast,
        nowMarkerKey: nowMarkerKey,
        onTogglePast: onTogglePast,
        onLessonTap: onLessonTap,
        onLessonActions: onLessonActions,
      ),
  ];
}
