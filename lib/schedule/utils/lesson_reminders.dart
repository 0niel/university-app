import 'package:collection/collection.dart';
import 'package:local_notifications_repository/local_notifications_repository.dart';
import 'package:rtu_mirea_app/schedule/models/models.dart';

int reminderIdFor(
  String scheduleId,
  CustomLesson lesson, [
  DateTime? occurrence,
]) {
  var hash = 0x811c9dc5;
  final occurrenceKey = occurrence?.toUtc().toIso8601String() ?? '';
  for (final byte in '$scheduleId:${lesson.id}:$occurrenceKey'.codeUnits) {
    hash = ((hash ^ byte) * 0x01000193) & 0xffffffff;
  }
  return hash & 0x7fffffff;
}

List<LessonReminder> buildLessonReminders({
  required String scheduleId,
  required CustomSchedule schedule,
  required DateTime now,
  required String Function(CustomLesson lesson) bodyOf,
}) {
  final reminders = <LessonReminder>[];
  for (final lesson in schedule.lessons) {
    final minutes = lesson.reminderMinutes;
    if (minutes == null) continue;
    final dates = lesson.recurrence.expand(now);
    for (final date in dates) {
      final start = DateTime(
        date.year,
        date.month,
        date.day,
        lesson.lessonBells.startTime.hour,
        lesson.lessonBells.startTime.minute,
      );
      final candidate = start.subtract(Duration(minutes: minutes));
      if (!candidate.isAfter(now)) continue;
      reminders.add(
        LessonReminder(
          id: reminderIdFor(scheduleId, lesson, start),
          title: lesson.subject,
          body: bodyOf(lesson),
          when: candidate,
        ),
      );
    }
  }
  return reminders;
}

String defaultLessonReminderBody(CustomLesson lesson) {
  final start = lesson.lessonBells.startTime.toString();
  final classroom = lesson.classrooms.firstOrNull;
  if (classroom != null) return 'Начало в $start · ауд. ${classroom.name}';
  return 'Начало в $start';
}
