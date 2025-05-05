import 'package:rtu_mirea_app/schedule/schedule.dart';
import 'package:university_app_server_api/client.dart';

String formatClassrooms(List<Classroom> classrooms) => classrooms.map((c) => c.name).join(', ');

String formatTeachers(List<Teacher> teachers) => teachers.map((t) => t.name).join(', ');

String formatLessonBells(LessonBells bells) => bells.toString();

bool areDatesEqual(List<DateTime> a, List<DateTime> b) {
  final setA = a.map((d) => d.toIso8601String()).toSet();
  final setB = b.map((d) => d.toIso8601String()).toSet();
  return setA.length == setB.length && setA.containsAll(setB);
}

bool areClassroomsEqual(List<Classroom> a, List<Classroom> b) {
  final setA = a.map((c) => c.name).toSet();
  final setB = b.map((c) => c.name).toSet();
  return setA.length == setB.length && setA.containsAll(setB);
}

bool areTeachersEqual(List<Teacher> a, List<Teacher> b) {
  final setA = a.map((t) => t.name).toSet();
  final setB = b.map((t) => t.name).toSet();
  return setA.length == setB.length && setA.containsAll(setB);
}

LessonSchedulePart? findMatchingLesson(LessonSchedulePart lesson, List<LessonSchedulePart> list) {
  final candidates = list.where((l) => l.subject == lesson.subject).toList();
  if (candidates.isEmpty) return null;
  candidates.sort((a, b) {
    final aIntersection = a.dates.where((d) => lesson.dates.contains(d)).length;
    final bIntersection = b.dates.where((d) => lesson.dates.contains(d)).length;
    return bIntersection.compareTo(aIntersection);
  });
  return candidates.first;
}

ScheduleDiff? calculateScheduleDiff(List<SchedulePart> oldParts, List<SchedulePart> newParts) {
  final oldLessons = oldParts.whereType<LessonSchedulePart>().toList();
  final newLessons = newParts.whereType<LessonSchedulePart>().toList();

  final Set<ScheduleChange> changes = {};
  final Set<int> matchedNewIndices = {};

  for (final oldLesson in oldLessons) {
    final candidate = findMatchingLesson(oldLesson, newLessons);
    if (candidate == null) {
      final List<FieldDiff> fieldDiffs = [
        FieldDiff(
          fieldName: 'Даты',
          removedDates: List<DateTime>.from(oldLesson.dates)..sort(),
          addedDates: [],
          unchangedDates: [],
        ),
        FieldDiff(fieldName: 'Аудитории', oldValue: formatClassrooms(oldLesson.classrooms), newValue: ''),
        FieldDiff(fieldName: 'Преподаватели', oldValue: formatTeachers(oldLesson.teachers), newValue: ''),
        FieldDiff(fieldName: 'Время пары', oldValue: formatLessonBells(oldLesson.lessonBells), newValue: ''),
      ];

      changes.add(ScheduleChange(type: ChangeType.removed, subject: oldLesson.subject, fieldDiffs: fieldDiffs));
    } else {
      final index = newLessons.indexOf(candidate);
      if (index != -1) matchedNewIndices.add(index);

      final List<FieldDiff> fieldDiffs = [];

      final Set<DateTime> oldDatesSet = oldLesson.dates.toSet();
      final Set<DateTime> newDatesSet = candidate.dates.toSet();

      final List<DateTime> removedDates = oldDatesSet.difference(newDatesSet).toList()..sort();
      final List<DateTime> addedDates = newDatesSet.difference(oldDatesSet).toList()..sort();
      final List<DateTime> unchangedDates = oldDatesSet.intersection(newDatesSet).toList()..sort();

      if (removedDates.isNotEmpty || addedDates.isNotEmpty) {
        fieldDiffs.add(
          FieldDiff(
            fieldName: 'Даты',
            addedDates: addedDates,
            removedDates: removedDates,
            unchangedDates: unchangedDates,
          ),
        );
      }

      if (!areClassroomsEqual(oldLesson.classrooms, candidate.classrooms)) {
        fieldDiffs.add(
          FieldDiff(
            fieldName: 'Аудитории',
            oldValue: formatClassrooms(oldLesson.classrooms),
            newValue: formatClassrooms(candidate.classrooms),
          ),
        );
      }
      if (!areTeachersEqual(oldLesson.teachers, candidate.teachers)) {
        fieldDiffs.add(
          FieldDiff(
            fieldName: 'Преподаватели',
            oldValue: formatTeachers(oldLesson.teachers),
            newValue: formatTeachers(candidate.teachers),
          ),
        );
      }
      if (oldLesson.lessonBells != candidate.lessonBells) {
        fieldDiffs.add(
          FieldDiff(
            fieldName: 'Время пары',
            oldValue: formatLessonBells(oldLesson.lessonBells),
            newValue: formatLessonBells(candidate.lessonBells),
          ),
        );
      }

      if (fieldDiffs.isNotEmpty) {
        changes.add(ScheduleChange(type: ChangeType.modified, subject: oldLesson.subject, fieldDiffs: fieldDiffs));
      }
    }
  }

  for (var i = 0; i < newLessons.length; i++) {
    if (matchedNewIndices.contains(i)) continue;
    final newLesson = newLessons[i];

    final List<FieldDiff> fieldDiffs = [
      FieldDiff(
        fieldName: 'Даты',
        addedDates: List<DateTime>.from(newLesson.dates)..sort(),
        removedDates: [],
        unchangedDates: [],
      ),
      FieldDiff(fieldName: 'Аудитории', oldValue: '', newValue: formatClassrooms(newLesson.classrooms)),
      FieldDiff(fieldName: 'Преподаватели', oldValue: '', newValue: formatTeachers(newLesson.teachers)),
      FieldDiff(fieldName: 'Время пары', oldValue: '', newValue: formatLessonBells(newLesson.lessonBells)),
    ];

    changes.add(ScheduleChange(type: ChangeType.added, subject: newLesson.subject, fieldDiffs: fieldDiffs));
  }

  return changes.isEmpty ? null : ScheduleDiff(changes: changes);
}
