import 'package:rtu_mirea_app/schedule_management/utils/ongoing_lesson.dart';
import 'package:schedule_repository/schedule_repository.dart';

export 'package:rtu_mirea_app/schedule_management/utils/ongoing_lesson.dart';

class ScheduleLiveStatus {
  const ScheduleLiveStatus({
    required this.todayLessons,
    this.ongoing,
    this.next,
  });

  factory ScheduleLiveStatus.of(List<SchedulePart> schedule, {DateTime? now}) {
    final moment = now ?? DateTime.now();
    final lessons =
        schedule
            .whereType<LessonSchedulePart>()
            .where((part) => part.dates.any((date) => _isSameDay(date, moment)))
            .toList()
          ..sort(
            (a, b) => _minutes(
              a.lessonBells.startTime,
            ).compareTo(_minutes(b.lessonBells.startTime)),
          );

    OngoingLesson? ongoing;
    LessonSchedulePart? next;
    for (final lesson in lessons) {
      final start = _at(moment, lesson.lessonBells.startTime);
      final end = _at(moment, lesson.lessonBells.endTime);
      if (!moment.isBefore(start) && moment.isBefore(end)) {
        ongoing = OngoingLesson(
          lesson: lesson,
          minutesLeft: end.difference(moment).inMinutes.clamp(0, 1 << 31),
        );
      } else if (start.isAfter(moment) && next == null) {
        next = lesson;
      }
    }

    return ScheduleLiveStatus(
      todayLessons: lessons,
      ongoing: ongoing,
      next: next,
    );
  }

  final List<LessonSchedulePart> todayLessons;

  final OngoingLesson? ongoing;

  final LessonSchedulePart? next;

  int get todayCount => todayLessons.length;

  bool get isLive => ongoing != null;

  static DateTime _at(DateTime day, TimeOfDay time) =>
      .new(day.year, day.month, day.day, time.hour, time.minute);

  static int _minutes(TimeOfDay time) => time.hour * 60 + time.minute;

  static bool _isSameDay(DateTime a, DateTime b) =>
      a.year == b.year && a.month == b.month && a.day == b.day;
}
