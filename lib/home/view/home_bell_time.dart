import 'package:schedule_repository/schedule_repository.dart';

extension HomeBellTime on TimeOfDay {
  DateTime toDateTime(DateTime day) =>
      .new(day.year, day.month, day.day, hour, minute);
}

extension HomeLessonWindow on LessonSchedulePart {
  bool isLive(DateTime now) =>
      !now.isBefore(lessonBells.startTime.toDateTime(now)) &&
      now.isBefore(lessonBells.endTime.toDateTime(now));

  bool startsAfter(DateTime now) =>
      lessonBells.startTime.toDateTime(now).isAfter(now);
}
