import 'dart:convert';

import 'package:schedule_repository/schedule_repository.dart';

class TeacherLessonOccurrence {
  const TeacherLessonOccurrence({
    required this.lesson,
    required this.date,
    required this.start,
    required this.end,
    required this.groups,
    this.isCancelled = false,
  });

  final LessonSchedulePart lesson;
  final DateTime date;
  final DateTime start;
  final DateTime end;
  final List<Group> groups;
  final bool isCancelled;

  Duration get duration => end.difference(start);
}

class TeacherScheduleGap {
  const TeacherScheduleGap({
    required this.date,
    required this.start,
    required this.end,
  });

  final DateTime date;
  final DateTime start;
  final DateTime end;

  Duration get duration => end.difference(start);
}

class TeacherWorkload {
  const TeacherWorkload._({
    required this.weekStart,
    required this.occurrences,
    required this.totalDuration,
    required this.groups,
    required this.subjects,
    required this.classrooms,
    required this.gaps,
  });

  factory TeacherWorkload.fromSchedule({
    required List<SchedulePart> schedule,
    required DateTime weekStart,
    List<ScheduleChange> changes = const [],
  }) {
    final anchor = _dateOnly(weekStart);
    final monday = anchor.subtract(Duration(days: anchor.weekday - 1));
    final sunday = monday.add(const Duration(days: 6));
    final unique = <String, TeacherLessonOccurrence>{};
    for (final lesson in schedule.whereType<LessonSchedulePart>()) {
      for (final sourceDate in lesson.dates) {
        final date = _dateOnly(sourceDate);
        if (date.isBefore(monday) || date.isAfter(sunday)) continue;
        final start = _atTime(date, lesson.lessonBells.startTime);
        final end = _atTime(date, lesson.lessonBells.endTime);
        if (!end.isAfter(start)) continue;
        final key = _occurrenceKey(lesson, date, start, end);
        final previous = unique[key];
        final groups = _distinctGroups([
          if (previous != null) ...previous.groups,
          ..._lessonGroups(lesson),
        ]);
        final classrooms = _distinctClassrooms([
          if (previous != null) ...previous.lesson.classrooms,
          ...lesson.classrooms,
        ]);
        unique[key] = TeacherLessonOccurrence(
          lesson: lesson.copyWith(
            dates: [date],
            groups: groups.map((group) => group.name).toList(),
            groupEntities: groups,
            classrooms: classrooms,
          ),
          date: date,
          start: start,
          end: end,
          groups: groups,
        );
      }
    }
    final ordered = unique.values.toList()
      ..sort((a, b) {
        final time = a.start.compareTo(b.start);
        return time == 0 ? a.lesson.subject.compareTo(b.lesson.subject) : time;
      });
    final occurrences = [
      for (final occurrence in ordered)
        TeacherLessonOccurrence(
          lesson: occurrence.lesson,
          date: occurrence.date,
          start: occurrence.start,
          end: occurrence.end,
          groups: occurrence.groups,
          isCancelled: _isCancelled(occurrence, ordered, changes),
        ),
    ];
    final active = occurrences.where((entry) => !entry.isCancelled).toList();
    final subjects =
        active
            .map((entry) => entry.lesson.subject.trim())
            .where((subject) => subject.isNotEmpty)
            .toSet()
            .toList()
          ..sort();
    return TeacherWorkload._(
      weekStart: monday,
      occurrences: List.unmodifiable(occurrences),
      totalDuration: active.fold(
        Duration.zero,
        (total, entry) => total + entry.duration,
      ),
      groups: List.unmodifiable(
        _distinctGroups(active.expand((entry) => entry.groups)),
      ),
      subjects: List.unmodifiable(subjects),
      classrooms: List.unmodifiable(
        _distinctClassrooms(active.expand((entry) => entry.lesson.classrooms)),
      ),
      gaps: List.unmodifiable(_gaps(active)),
    );
  }

  final DateTime weekStart;
  final List<TeacherLessonOccurrence> occurrences;
  final Duration totalDuration;
  final List<Group> groups;
  final List<String> subjects;
  final List<Classroom> classrooms;
  final List<TeacherScheduleGap> gaps;

  List<TeacherLessonOccurrence> occurrencesForDay(DateTime day) => [
    for (final occurrence in occurrences)
      if (occurrence.date == _dateOnly(day)) occurrence,
  ];

  TeacherLessonOccurrence? currentAt(DateTime now) => occurrences
      .where(
        (entry) =>
            !entry.isCancelled &&
            !entry.start.isAfter(now) &&
            entry.end.isAfter(now),
      )
      .firstOrNull;

  TeacherLessonOccurrence? nextAt(DateTime now) => occurrences
      .where((entry) => !entry.isCancelled && entry.start.isAfter(now))
      .firstOrNull;
}

DateTime _dateOnly(DateTime value) =>
    DateTime(value.year, value.month, value.day);

DateTime _atTime(DateTime date, TimeOfDay time) =>
    DateTime(date.year, date.month, date.day, time.hour, time.minute);

String _identity(String? uid, String name) => uid?.trim().isNotEmpty == true
    ? 'id:${uid!.trim()}'
    : 'name:${name.trim().toLowerCase()}';

String _occurrenceKey(
  LessonSchedulePart lesson,
  DateTime date,
  DateTime start,
  DateTime end,
) {
  final uid = lesson.uid?.trim();
  final teachers =
      lesson.teachers
          .map((teacher) => _identity(teacher.uid, teacher.name))
          .toSet()
          .toList()
        ..sort();
  final classrooms =
      lesson.classrooms
          .map(
            (room) => _identity(
              room.uid,
              '${room.campus?.uid ?? room.campus?.name}:'
              '${room.name}:${room.url}',
            ),
          )
          .toSet()
          .toList()
        ..sort();
  return jsonEncode([
    date.toIso8601String(),
    start.toIso8601String(),
    end.toIso8601String(),
    if (uid?.isNotEmpty == true)
      uid
    else ...[
      lesson.subject.trim().toLowerCase(),
      lesson.lessonType.name,
      teachers,
      classrooms,
    ],
  ]);
}

List<Group> _lessonGroups(LessonSchedulePart lesson) => [
  ...?lesson.groupEntities,
  for (final name in lesson.groups ?? const <String>[])
    if (!(lesson.groupEntities ?? const <Group>[]).any(
      (group) => group.name.trim().toLowerCase() == name.trim().toLowerCase(),
    ))
      Group(name: name),
];

List<Group> _distinctGroups(Iterable<Group> groups) {
  final unique = <String, Group>{};
  for (final group in groups) {
    if (group.name.trim().isEmpty) continue;
    final nameKey = _identity(null, group.name);
    if (group.uid?.trim().isNotEmpty == true) {
      unique.remove(nameKey);
    } else if (unique.values.any(
      (candidate) =>
          candidate.name.trim().toLowerCase() ==
          group.name.trim().toLowerCase(),
    )) {
      continue;
    }
    unique[_identity(group.uid, group.name)] = group;
  }
  return unique.values.toList()..sort((a, b) => a.name.compareTo(b.name));
}

List<Classroom> _distinctClassrooms(Iterable<Classroom> classrooms) {
  final unique = <String, Classroom>{};
  for (final room in classrooms) {
    if (room.name.trim().isEmpty) continue;
    unique[_identity(
          room.uid,
          '${room.campus?.uid ?? room.campus?.name}:${room.name}:${room.url}',
        )] =
        room;
  }
  return unique.values.toList()..sort((a, b) => a.name.compareTo(b.name));
}

bool _isCancelled(
  TeacherLessonOccurrence occurrence,
  List<TeacherLessonOccurrence> occurrences,
  List<ScheduleChange> changes,
) {
  final matching = changes.where((change) {
    if (change.kind == .add ||
        _dateOnly(change.lessonDate) != occurrence.date ||
        change.subject.trim().toLowerCase() !=
            occurrence.lesson.subject.trim().toLowerCase()) {
      return false;
    }
    final start = occurrence.lesson.lessonBells.startTime;
    final slot =
        '${start.hour.toString().padLeft(2, '0')}:'
        '${start.minute.toString().padLeft(2, '0')}';
    if (change.oldValue.start != null || change.newValue.start != null) {
      return _normalizedTime(change.oldValue.start) == slot ||
          _normalizedTime(change.newValue.start) == slot;
    }
    final number = occurrence.lesson.lessonBells.number;
    if (change.lessonNumber != null && number != null) {
      return change.lessonNumber == number;
    }
    return occurrences
            .where(
              (entry) =>
                  entry.date == occurrence.date &&
                  entry.lesson.subject.trim().toLowerCase() ==
                      occurrence.lesson.subject.trim().toLowerCase(),
            )
            .length ==
        1;
  }).toList()..sort((a, b) => b.createdAt.compareTo(a.createdAt));
  return matching.firstOrNull?.kind == .cancel;
}

String? _normalizedTime(String? value) {
  final parts = value?.trim().split(':');
  if (parts == null || parts.length < 2) return null;
  final hour = int.tryParse(parts[0]);
  final minute = int.tryParse(parts[1]);
  if (hour == null ||
      minute == null ||
      hour < 0 ||
      minute < 0 ||
      hour > 23 ||
      minute > 59) {
    return null;
  }
  return '${hour.toString().padLeft(2, '0')}:'
      '${minute.toString().padLeft(2, '0')}';
}

List<TeacherScheduleGap> _gaps(List<TeacherLessonOccurrence> occurrences) {
  final gaps = <TeacherScheduleGap>[];
  DateTime? date;
  DateTime? end;
  for (final occurrence in occurrences) {
    if (date == occurrence.date && end != null) {
      if (occurrence.start.difference(end) >= const Duration(minutes: 30)) {
        gaps.add(
          TeacherScheduleGap(
            date: occurrence.date,
            start: end,
            end: occurrence.start,
          ),
        );
      }
      if (occurrence.end.isAfter(end)) end = occurrence.end;
    } else {
      date = occurrence.date;
      end = occurrence.end;
    }
  }
  return gaps;
}
