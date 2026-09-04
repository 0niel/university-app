import 'package:rtu_mirea_app/schedule/view/schedule_page/lesson_status.dart';
import 'package:rtu_mirea_app/schedule/view/schedule_page/schedule_dates.dart';
import 'package:schedule_repository/schedule_repository.dart';

sealed class ScheduleTimelineEntry {
  const ScheduleTimelineEntry();
}

class ScheduleLessonEntry extends ScheduleTimelineEntry {
  const ScheduleLessonEntry({
    required this.lesson,
    required this.status,
    required this.isNew,
    required this.isNext,
    this.change,
  });

  final LessonSchedulePart lesson;
  final LessonDayStatus status;
  final ScheduleChange? change;
  final bool isNew;
  final bool isNext;

  bool get cancelled => isCancelled(change);

  bool get moved => isMoved(change);

  String? get previousRoom => change?.oldValue.rooms.firstOrNull;
}

class ScheduleGapEntry extends ScheduleTimelineEntry {
  const ScheduleGapEntry(this.minutes);

  final int minutes;
}

class ScheduleNowEntry extends ScheduleTimelineEntry {
  const ScheduleNowEntry(this.at);

  final DateTime at;
}

class ScheduleDayTimeline {
  const ScheduleDayTimeline({
    required this.entries,
    required this.visibleLessons,
    required this.totalLessons,
  });

  final List<ScheduleTimelineEntry> entries;
  final int visibleLessons;
  final int totalLessons;

  bool get isEmpty => totalLessons == 0;
}

List<List<ScheduleLessonEntry>> groupTimelineLessons(
  Iterable<ScheduleTimelineEntry> entries,
) {
  final lessons = entries.whereType<ScheduleLessonEntry>().toList()
    ..sort(
      (a, b) => minutesOfDay(
        a.lesson.lessonBells.startTime,
      ).compareTo(minutesOfDay(b.lesson.lessonBells.startTime)),
    );
  final groups = <List<ScheduleLessonEntry>>[];
  var end = -1;
  for (final entry in lessons) {
    final start = minutesOfDay(entry.lesson.lessonBells.startTime);
    final currentEnd = minutesOfDay(entry.lesson.lessonBells.endTime);
    if (groups.isEmpty || start >= end) {
      groups.add([entry]);
      end = currentEnd;
    } else {
      groups.last.add(entry);
      if (currentEnd > end) end = currentEnd;
    }
  }
  return groups;
}

ScheduleDayTimeline buildDayTimeline({
  required List<LessonSchedulePart> lessons,
  required List<ScheduleChange> changes,
  required DateTime day,
  required DateTime now,
  required bool showPast,
  required bool showCancelled,
  required bool showGaps,
}) {
  final next = nextLessonOf(lessons, day, now, changes);
  final entries = <ScheduleTimelineEntry>[];
  var visible = 0;
  var active = 0;
  var nowPlaced = !isSameDate(day, now) || now.hour < 9 || now.hour >= 20;
  LessonSchedulePart? previousVisible;

  for (var index = 0; index < lessons.length; index++) {
    final lesson = lessons[index];
    final change = changeFor(changes, lesson, day);
    final cancelled = isCancelled(change);
    final status = lessonDayStatus(lesson, day, now);
    if (!cancelled) active++;

    if (status.past && !showPast) continue;
    if (cancelled && !showCancelled) continue;

    if (previousVisible != null && showGaps) {
      final previous = previousVisible;
      final gap =
          minutesOfDay(lesson.lessonBells.startTime) -
          minutesOfDay(previous.lessonBells.endTime);
      if (gap > 15) entries.add(ScheduleGapEntry(gap));
    }

    if (!nowPlaced && atTime(day, lesson.lessonBells.startTime).isAfter(now)) {
      nowPlaced = true;
      entries.add(ScheduleNowEntry(now));
    }

    visible++;
    previousVisible = lesson;
    entries.add(
      ScheduleLessonEntry(
        lesson: lesson,
        status: status,
        change: change,
        isNew: isNewLesson(changes, lesson, day),
        isNext: identical(lesson, next),
      ),
    );
  }

  if (!nowPlaced && entries.isNotEmpty) entries.add(ScheduleNowEntry(now));

  return ScheduleDayTimeline(
    entries: entries,
    visibleLessons: visible,
    totalLessons: active,
  );
}
