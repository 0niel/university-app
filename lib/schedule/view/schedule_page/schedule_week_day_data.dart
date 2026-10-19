import 'package:rtu_mirea_app/config/config.dart';
import 'package:rtu_mirea_app/schedule/cubit/cubit.dart';
import 'package:rtu_mirea_app/schedule/view/schedule_page/lesson_status.dart';
import 'package:rtu_mirea_app/schedule/view/schedule_page/schedule_dates.dart';
import 'package:rtu_mirea_app/schedule/view/schedule_page/schedule_time_slots.dart';
import 'package:schedule_repository/schedule_repository.dart';

class ScheduleWeekDayData {
  factory ScheduleWeekDayData({
    required DateTime day,
    required DateTime now,
    required List<SchedulePart> schedule,
    required List<ScheduleChange> changes,
    required SchedulePreferencesState preferences,
    required ScheduleDisplayState display,
    required List<UserActivity> activities,
  }) {
    final lessons = visibleLessonsForDay(
      schedule: schedule,
      day: day,
      now: now,
      preferences: preferences,
      display: display,
      changes: changes,
    );
    final dayActivities = <(UserActivity, LessonBellSlotConfig)>[];
    for (final activity in activities) {
      final end = activity.endsAt;
      if (end == null || (!display.showPast && !end.isAfter(now))) continue;
      final slot = scheduleSlotForDay(
        startsAt: activity.startsAt,
        endsAt: end,
        day: day,
      );
      if (slot != null) dayActivities.add((activity, slot));
    }
    final events = <(CalendarSchedulePart, LessonBellSlotConfig)>[];
    for (final event in schedule.whereType<CalendarSchedulePart>()) {
      final start = event.startsAt;
      final end = event.endsAt;
      if (event.isAllDay ||
          start == null ||
          end == null ||
          !end.isAfter(start) ||
          (!display.showPast && !end.isAfter(now))) {
        continue;
      }
      final slot = scheduleSlotForDay(
        startsAt: start,
        endsAt: end,
        day: day,
      );
      if (slot != null) events.add((event, slot));
    }
    return ScheduleWeekDayData._(
      day: day,
      lessons: lessons,
      activities: dayActivities,
      events: events,
    );
  }

  const ScheduleWeekDayData._({
    required this.day,
    required this.lessons,
    required this.activities,
    required this.events,
  });

  final DateTime day;
  final List<LessonSchedulePart> lessons;
  final List<(UserActivity, LessonBellSlotConfig)> activities;
  final List<(CalendarSchedulePart, LessonBellSlotConfig)> events;

  Iterable<LessonBellSlotConfig> get lessonSlots sync* {
    for (final lesson in lessons) {
      yield LessonBellSlotConfig(
        startMinutes: minutesOfDay(lesson.lessonBells.startTime),
        endMinutes: minutesOfDay(lesson.lessonBells.endTime),
      );
    }
  }

  List<LessonSchedulePart> lessonsIn(LessonBellSlotConfig slot) => lessons
      .where(
        (lesson) =>
            minutesOfDay(lesson.lessonBells.startTime) < slot.endMinutes &&
            minutesOfDay(lesson.lessonBells.endTime) > slot.startMinutes,
      )
      .toList();

  List<UserActivity> activitiesIn(LessonBellSlotConfig slot) => activities
      .where((activity) => scheduleSlotsOverlap(activity.$2, slot))
      .map((activity) => activity.$1)
      .toList();

  List<CalendarSchedulePart> eventsIn(LessonBellSlotConfig slot) {
    final start = dateOnly(day).add(Duration(minutes: slot.startMinutes));
    final end = dateOnly(day).add(Duration(minutes: slot.endMinutes));
    return events
        .where(
          (event) =>
              event.$1.startsAt!.isBefore(end) &&
              event.$1.endsAt!.isAfter(start),
        )
        .map((event) => event.$1)
        .toList();
  }
}
