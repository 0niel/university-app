part of '../schedule_page.dart';

class _ScheduleDayModel {
  const _ScheduleDayModel._({
    required this.lessons,
    required this.filteredLessons,
    required this.activities,
    required this.busy,
    required this.hasNow,
  });

  factory _ScheduleDayModel.resolve({
    required List<SchedulePart> parts,
    required DateTime day,
    required SchedulePreferencesState preferences,
    required UserActivitiesState activities,
    required _ScheduleFilter filter,
  }) {
    final lessons = _applyPreferences(
      _lessonsForDay(parts, day),
      preferences,
    );
    final filtered = _filteredLessonsStatic(lessons, filter);
    final dayActivities = activities.forDay(day);
    return _ScheduleDayModel._(
      lessons: lessons,
      filteredLessons: filtered,
      activities: dayActivities,
      busy: lessons.length + dayActivities.length > 5,
      hasNow:
          isSameDate(day, DateTime.now()) &&
          (lessons.isNotEmpty || dayActivities.isNotEmpty),
    );
  }

  final List<LessonSchedulePart> lessons;
  final List<LessonSchedulePart> filteredLessons;
  final List<UserActivity> activities;
  final bool busy;
  final bool hasNow;

  bool get isEmpty => lessons.isEmpty && activities.isEmpty;

  bool get isFilteredOut => filteredLessons.isEmpty && activities.isEmpty;
}
