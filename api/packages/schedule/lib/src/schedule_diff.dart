import 'package:collection/collection.dart';
import 'package:schedule/schedule.dart';

/// {@template change_kind}
/// The category of a lesson-level change detected during schedule diffing.
/// {@endtemplate}
enum ChangeKind {
  /// {@macro change_kind}
  /// The lesson did not exist before and is present now.
  added,

  /// {@macro change_kind}
  /// The lesson existed before and is no longer present.
  removed,

  /// {@macro change_kind}
  /// The lesson existed in both snapshots but differs in one or more fields.
  modified,
}

/// {@template lesson_field}
/// A field of a lesson that can change between two schedule snapshots.
/// {@endtemplate}
enum LessonField {
  /// {@macro lesson_field}
  /// Lesson type (e.g. lecture, practice, lab, ...).
  lessonType,

  /// {@macro lesson_field}
  /// Time interval (start–end) of the lesson.
  time,

  /// {@macro lesson_field}
  /// Ordinal number of the lesson within the day, when available.
  number,

  /// {@macro lesson_field}
  /// Set of teacher names associated with the lesson.
  teachers,

  /// {@macro lesson_field}
  /// Set of classroom names where the lesson takes place.
  classrooms,

  /// {@macro lesson_field}
  /// Set of active dates for the lesson.
  dates,

  /// {@macro lesson_field}
  /// Set of groups attending the lesson.
  groups,
}

/// {@template lesson_field_change}
/// Describes a change to a single [LessonField].
///
/// For non-collection fields, the change is represented by [oldValue] and
/// [newValue]. For the [LessonField.dates] field, the delta is represented by
/// [addedDates] and [removedDates].
/// {@endtemplate}
class LessonFieldChange {
  /// {@macro lesson_field_change}
  LessonFieldChange({
    required this.field,
    this.oldValue,
    this.newValue,
    this.addedDates,
    this.removedDates,
  });

  /// The lesson field that changed.
  final LessonField field;

  /// Previous value serialized as a string (when applicable).
  final String? oldValue;

  /// New value serialized as a string (when applicable).
  final String? newValue;

  /// Dates that were added (used only when [field] is [LessonField.dates]).
  final List<DateTime>? addedDates;

  /// Dates that were removed (used only when [field] is [LessonField.dates]).
  final List<DateTime>? removedDates;
}

/// {@template lesson_change_detail}
/// Aggregates all field-level changes for a single logical lesson occurrence
/// (identified by subject and time window).
/// {@endtemplate}
class LessonChangeDetail {
  /// {@macro lesson_change_detail}
  LessonChangeDetail({
    required this.kind,
    required this.subject,
    required this.lessonBells,
    required this.fieldChanges,
  });

  /// Overall change kind for the lesson (added/removed/modified).
  final ChangeKind kind;

  /// Subject name of the lesson.
  final String subject;

  /// Time window and ordinal information of the lesson.
  final LessonBells lessonBells;

  /// Detailed per-field changes for the lesson.
  final List<LessonFieldChange> fieldChanges;
}

/// {@template schedule_update_diff}
/// The top-level diff result containing added, removed and modified lessons.
/// {@endtemplate}
class ScheduleUpdateDiff {
  /// {@macro schedule_update_diff}
  ScheduleUpdateDiff({
    required this.added,
    required this.removed,
    required this.modified,
  });

  /// Lessons that exist only in the new snapshot.
  final List<LessonChangeDetail> added;

  /// Lessons that exist only in the old snapshot.
  final List<LessonChangeDetail> removed;

  /// Lessons that exist in both snapshots but differ in some fields.
  final List<LessonChangeDetail> modified;

  /// Whether any change (of any kind) is present.
  bool get hasChanges =>
      added.isNotEmpty || removed.isNotEmpty || modified.isNotEmpty;
}

/// {@template compute_schedule_diff}
/// Computes a lesson-level diff between two lists of [SchedulePart]s.
///
/// Matching between lessons is performed using a composite key consisting of
/// `subject | start-end | number` (where `number` is optional). Within the
/// same key, items are aligned by a deterministic hash of the date set, then
/// field-level differences are calculated.
///
/// Additionally, a heuristic merges certain add/remove pairs (with the same
/// subject and dates) into a single [ChangeKind.modified] entry.
/// {@endtemplate}
ScheduleUpdateDiff computeScheduleDiff(
  List<SchedulePart> oldParts,
  List<SchedulePart> newParts,
) {
  final oldLessons = oldParts.whereType<LessonSchedulePart>().toList();
  final newLessons = newParts.whereType<LessonSchedulePart>().toList();

  String keyFor(LessonSchedulePart l) {
    String two(int n) => n.toString().padLeft(2, '0');
    final start =
        '${two(l.lessonBells.startTime.hour)}:${two(l.lessonBells.startTime.minute)}';
    final end =
        '${two(l.lessonBells.endTime.hour)}:${two(l.lessonBells.endTime.minute)}';
    final number = l.lessonBells.number?.toString() ?? 'n';
    return '${l.subject}|$start-$end|$number';
  }

  final oldByKey = groupBy(oldLessons, keyFor);
  final newByKey = groupBy(newLessons, keyFor);

  final added = <LessonChangeDetail>[];
  final removed = <LessonChangeDetail>[];
  final modified = <LessonChangeDetail>[];

  final commonKeys = oldByKey.keys.toSet().intersection(newByKey.keys.toSet());
  for (final key in commonKeys) {
    final olds = oldByKey[key]!
      ..sort((a, b) => _dateListHash(a).compareTo(_dateListHash(b)));
    final news = newByKey[key]!
      ..sort((a, b) => _dateListHash(a).compareTo(_dateListHash(b)));

    final maxLen = olds.length > news.length ? olds.length : news.length;
    for (var i = 0; i < maxLen; i++) {
      final oldL = i < olds.length ? olds[i] : null;
      final newL = i < news.length ? news[i] : null;
      if (oldL == null && newL != null) {
        added.add(
          LessonChangeDetail(
            kind: ChangeKind.added,
            subject: newL.subject,
            lessonBells: newL.lessonBells,
            fieldChanges: _allFieldsSnapshot(newL),
          ),
        );
      } else if (oldL != null && newL == null) {
        removed.add(
          LessonChangeDetail(
            kind: ChangeKind.removed,
            subject: oldL.subject,
            lessonBells: oldL.lessonBells,
            fieldChanges: _allFieldsSnapshot(oldL),
          ),
        );
      } else if (oldL != null && newL != null) {
        final changes = _calcFieldChanges(oldL, newL);
        if (changes.isNotEmpty) {
          modified.add(
            LessonChangeDetail(
              kind: ChangeKind.modified,
              subject: newL.subject,
              lessonBells: newL.lessonBells,
              fieldChanges: changes,
            ),
          );
        }
      }
    }
  }

  final onlyNew = newByKey.keys.toSet().difference(oldByKey.keys.toSet());
  for (final key in onlyNew) {
    for (final l in newByKey[key]!) {
      added.add(
        LessonChangeDetail(
          kind: ChangeKind.added,
          subject: l.subject,
          lessonBells: l.lessonBells,
          fieldChanges: _allFieldsSnapshot(l),
        ),
      );
    }
  }

  final onlyOld = oldByKey.keys.toSet().difference(newByKey.keys.toSet());
  for (final key in onlyOld) {
    for (final l in oldByKey[key]!) {
      removed.add(
        LessonChangeDetail(
          kind: ChangeKind.removed,
          subject: l.subject,
          lessonBells: l.lessonBells,
          fieldChanges: _allFieldsSnapshot(l),
        ),
      );
    }
  }

  _mergeAddRemovePairsIntoModified(added, removed, modified);

  return ScheduleUpdateDiff(added: added, removed: removed, modified: modified);
}

int _dateListHash(LessonSchedulePart l) {
  final dates = l.dates.map((d) => d.toIso8601String()).toList()..sort();
  return dates.join(',').hashCode;
}

List<LessonFieldChange> _allFieldsSnapshot(LessonSchedulePart l) {
  return [
    LessonFieldChange(
      field: LessonField.lessonType,
      newValue: l.lessonType.name,
    ),
    LessonFieldChange(
      field: LessonField.time,
      newValue: '${l.lessonBells.startTime}-${l.lessonBells.endTime}',
    ),
    LessonFieldChange(
      field: LessonField.number,
      newValue: (l.lessonBells.number ?? 0).toString(),
    ),
    LessonFieldChange(
      field: LessonField.teachers,
      newValue: l.teachers.map((t) => t.name).join(', '),
    ),
    LessonFieldChange(
      field: LessonField.classrooms,
      newValue: l.classrooms.map((c) => c.name).join(', '),
    ),
    LessonFieldChange(
      field: LessonField.dates,
      newValue: l.dates.map((d) => d.toIso8601String()).join(', '),
    ),
    LessonFieldChange(
      field: LessonField.groups,
      newValue: (l.groups ?? []).join(', '),
    ),
  ];
}

List<LessonFieldChange> _calcFieldChanges(
  LessonSchedulePart oldL,
  LessonSchedulePart newL,
) {
  final changes = <LessonFieldChange>[];

  if (oldL.lessonType != newL.lessonType) {
    changes.add(
      LessonFieldChange(
        field: LessonField.lessonType,
        oldValue: oldL.lessonType.name,
        newValue: newL.lessonType.name,
      ),
    );
  }

  final oldTime = '${oldL.lessonBells.startTime}-${oldL.lessonBells.endTime}';
  final newTime = '${newL.lessonBells.startTime}-${newL.lessonBells.endTime}';
  if (oldTime != newTime) {
    changes.add(
      LessonFieldChange(
        field: LessonField.time,
        oldValue: oldTime,
        newValue: newTime,
      ),
    );
  }

  final oldNum = oldL.lessonBells.number ?? 0;
  final newNum = newL.lessonBells.number ?? 0;
  if (oldNum != newNum) {
    changes.add(
      LessonFieldChange(
        field: LessonField.number,
        oldValue: oldNum.toString(),
        newValue: newNum.toString(),
      ),
    );
  }

  final oldTeachers = oldL.teachers.map((t) => t.name).toSet();
  final newTeachers = newL.teachers.map((t) => t.name).toSet();
  if (!const SetEquality<String>().equals(oldTeachers, newTeachers)) {
    changes.add(
      LessonFieldChange(
        field: LessonField.teachers,
        oldValue: oldTeachers.join(', '),
        newValue: newTeachers.join(', '),
      ),
    );
  }

  final oldRooms = oldL.classrooms.map((c) => c.name).toSet();
  final newRooms = newL.classrooms.map((c) => c.name).toSet();
  if (!const SetEquality<String>().equals(oldRooms, newRooms)) {
    changes.add(
      LessonFieldChange(
        field: LessonField.classrooms,
        oldValue: oldRooms.join(', '),
        newValue: newRooms.join(', '),
      ),
    );
  }

  final oldDates = oldL.dates.toSet();
  final newDates = newL.dates.toSet();
  final addedDates = newDates.difference(oldDates).toList()..sort();
  final removedDates = oldDates.difference(newDates).toList()..sort();
  if (addedDates.isNotEmpty || removedDates.isNotEmpty) {
    changes.add(
      LessonFieldChange(
        field: LessonField.dates,
        addedDates: addedDates,
        removedDates: removedDates,
      ),
    );
  }

  final oldGroups = (oldL.groups ?? []).toSet();
  final newGroups = (newL.groups ?? []).toSet();
  if (!const SetEquality<String>().equals(oldGroups, newGroups)) {
    changes.add(
      LessonFieldChange(
        field: LessonField.groups,
        oldValue: oldGroups.join(', '),
        newValue: newGroups.join(', '),
      ),
    );
  }

  return changes;
}

void _mergeAddRemovePairsIntoModified(
  List<LessonChangeDetail> added,
  List<LessonChangeDetail> removed,
  List<LessonChangeDetail> modified,
) {
  String? datesValue(LessonChangeDetail d) {
    final dates =
        d.fieldChanges.firstWhereOrNull((c) => c.field == LessonField.dates);
    return dates?.newValue ?? dates?.oldValue;
  }

  Map<LessonField, String?> asMap(LessonChangeDetail d) {
    final map = <LessonField, String?>{};
    for (final c in d.fieldChanges) {
      map[c.field] = c.newValue ?? c.oldValue;
    }
    return map;
  }

  for (var i = removed.length - 1; i >= 0; i--) {
    final r = removed[i];
    final rDates = datesValue(r);
    final j = added
        .indexWhere((a) => a.subject == r.subject && datesValue(a) == rDates);
    if (j == -1) continue;

    final a = added[j];
    final oldMap = asMap(r);
    final newMap = asMap(a);
    final fieldDiffs = <LessonFieldChange>[];

    for (final field in [
      LessonField.lessonType,
      LessonField.time,
      LessonField.number,
      LessonField.teachers,
      LessonField.classrooms,
      LessonField.groups,
    ]) {
      final ov = oldMap[field];
      final nv = newMap[field];
      if (ov != nv) {
        fieldDiffs
            .add(LessonFieldChange(field: field, oldValue: ov, newValue: nv));
      }
    }

    if (fieldDiffs.isNotEmpty) {
      modified.add(
        LessonChangeDetail(
          kind: ChangeKind.modified,
          subject: a.subject,
          lessonBells: a.lessonBells,
          fieldChanges: fieldDiffs,
        ),
      );
      added.removeAt(j);
      removed.removeAt(i);
    }
  }
}
