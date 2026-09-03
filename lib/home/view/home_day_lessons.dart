import 'package:collection/collection.dart';
import 'package:flutter/material.dart' hide TimeOfDay;
import 'package:rtu_mirea_app/home/view/home_bell_time.dart';
import 'package:schedule_repository/schedule_repository.dart';

enum HomeHeroKind { before, during, pause, done, other, free }

class HomeLessonEntry {
  const HomeLessonEntry({
    required this.lesson,
    required this.start,
    required this.end,
    this.isPast = false,
    this.isCurrent = false,
    this.isNext = false,
    this.isCancelled = false,
    this.movedFrom,
  });

  final LessonSchedulePart lesson;
  final DateTime start;
  final DateTime end;
  final bool isPast;
  final bool isCurrent;
  final bool isNext;
  final bool isCancelled;
  final String? movedFrom;

  bool get isMoved => movedFrom != null;

  bool get isDimmed => isPast || isCancelled;

  String get room => lesson.classrooms.map((c) => c.name).join(', ');

  String get teacher => lesson.teachers.map((t) => t.name).join(', ');
}

List<LessonSchedulePart> homeLessonsForDay(
  List<SchedulePart> schedule,
  DateTime day,
) {
  final lessons =
      schedule
          .whereType<LessonSchedulePart>()
          .where((l) => l.dates.any((d) => DateUtils.isSameDay(d, day)))
          .toList()
        ..sort(
          (a, b) => a.lessonBells.startTime
              .toDateTime(day)
              .compareTo(b.lessonBells.startTime.toDateTime(day)),
        );
  return lessons;
}

List<HomeLessonEntry> homeDayEntries({
  required DateTime day,
  required List<LessonSchedulePart> lessons,
  required DateTime now,
  List<ScheduleChange> changes = const [],
}) {
  final isToday = DateUtils.isSameDay(day, now);
  var nextFound = false;
  return [
    for (final lesson in lessons)
      () {
        final start = lesson.lessonBells.startTime.toDateTime(day);
        final end = lesson.lessonBells.endTime.toDateTime(day);
        final matching =
            changes
                .where(
                  (change) => homeChangeMatches(change, lesson, day, lessons),
                )
                .toList()
              ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
        final change = matching.firstOrNull;
        final cancelled = change?.kind == ScheduleChangeKind.cancel;
        final moved =
            change != null &&
            (change.kind == ScheduleChangeKind.move ||
                change.kind == ScheduleChangeKind.room);
        final movedFrom = moved
            ? (change.oldValue.rooms.isNotEmpty
                  ? change.oldValue.rooms.join(', ')
                  : change.oldValue.start ?? '')
            : null;
        final past = isToday && !end.isAfter(now);
        final current =
            isToday && !start.isAfter(now) && now.isBefore(end) && !cancelled;
        final next =
            isToday &&
            !current &&
            start.isAfter(now) &&
            !nextFound &&
            !cancelled;
        if (next) nextFound = true;
        return HomeLessonEntry(
          lesson: lesson,
          start: start,
          end: end,
          isPast: past,
          isCurrent: current,
          isNext: next,
          isCancelled: cancelled,
          movedFrom: movedFrom,
        );
      }(),
  ];
}

bool homeChangeMatches(
  ScheduleChange change,
  LessonSchedulePart lesson,
  DateTime day,
  List<LessonSchedulePart> lessons,
) {
  if (!DateUtils.isSameDay(change.lessonDate, day) ||
      change.subject.trim().toLowerCase() !=
          lesson.subject.trim().toLowerCase()) {
    return false;
  }
  final start = lesson.lessonBells.startTime;
  final slot =
      '${start.hour.toString().padLeft(2, '0')}:'
      '${start.minute.toString().padLeft(2, '0')}';
  if (change.newValue.start != null || change.oldValue.start != null) {
    String? normalized(String? time) {
      final parts = time?.trim().split(':');
      if (parts == null || parts.length < 2) return null;
      final hour = int.tryParse(parts[0]);
      final minute = int.tryParse(parts[1]);
      if (hour == null || minute == null) return null;
      return '${hour.toString().padLeft(2, '0')}:'
          '${minute.toString().padLeft(2, '0')}';
    }

    return normalized(change.newValue.start) == slot ||
        normalized(change.oldValue.start) == slot;
  }
  if (change.lessonNumber != null && lesson.lessonBells.number != null) {
    return change.lessonNumber == lesson.lessonBells.number;
  }
  return lessons
          .where(
            (candidate) =>
                candidate.subject.trim().toLowerCase() ==
                lesson.subject.trim().toLowerCase(),
          )
          .length ==
      1;
}

HomeHeroKind homeHeroKind({
  required List<HomeLessonEntry> entries,
  required bool isToday,
}) {
  final active = entries.where((e) => !e.isCancelled).toList();
  if (active.isEmpty) return .free;
  if (!isToday) return .other;
  if (active.any((e) => e.isCurrent)) return .during;
  final hasNext = active.any((e) => e.isNext);
  final hasPast = active.any((e) => e.isPast);
  if (hasNext && !hasPast) return .before;
  if (hasNext) return .pause;
  return .done;
}

HomeLessonEntry? homeHeroEntry(
  List<HomeLessonEntry> entries,
  HomeHeroKind kind,
) {
  final active = entries.where((e) => !e.isCancelled).toList();
  return switch (kind) {
    .during => active.firstWhereOrNull((e) => e.isCurrent),
    .other => active.firstOrNull,
    .free => null,
    _ => active.firstWhereOrNull((e) => e.isNext) ?? active.firstOrNull,
  };
}

int homeMinutesUntil(DateTime target, DateTime now) {
  final minutes = (target.difference(now).inSeconds / 60).ceil();
  return minutes < 0 ? 0 : minutes;
}

List<DateTime> homeWeekDays(DateTime anchor) {
  final date = DateTime(anchor.year, anchor.month, anchor.day);
  final monday = date.subtract(Duration(days: date.weekday - DateTime.monday));
  return [for (var i = 0; i < 7; i++) monday.add(Duration(days: i))];
}
