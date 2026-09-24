import 'dart:developer';

import 'package:collection/collection.dart';
import 'package:rtu_mirea_schedule_api_client/src/campuses.dart';
import 'package:schedule/schedule.dart';

/// Parse classrooms from the location field.
List<Classroom> getClassroomsFromLocationText(String location) {
  try {
    final exp = RegExp(
      r'([\wА-Яа-яёЁ\s\-]+)\s\(([\wА-Яа-яёЁ\s\-]+)\)',
      multiLine: true,
    );

    final matches = exp.allMatches(location);

    if (matches.isEmpty) {
      return [];
    }

    return matches
        .map((e) {
          final classroom = e.group(1);
          final campus = e.group(2);

          if (classroom == null) {
            return null;
          }

          final campusObject = campuses.firstWhereOrNull(
            (element) => element.shortName == campus?.trim(),
          );

          if (classroom.contains('Дистанционно')) {
            return Classroom.online();
          }

          return Classroom(name: classroom.trim(), campus: campusObject);
        })
        .whereType<Classroom>()
        .toList();
  } on Exception catch (e, st) {
    log(
      'Failed to parse classrooms from location text',
      error: e,
      stackTrace: st,
      name: 'fields_data_parsers',
    );
    return [];
  }
}

/// Parse lesson type from the abbreviation, preferring the full type name
/// because branches use their own abbreviations (e.g. `ЛЕК` for lectures).
LessonType getLessonTypeFromText(
  String lessonType, {
  String? fullLessonType,
}) {
  final byName = _getLessonTypeByName(fullLessonType ?? '');
  if (byName != LessonType.unknown) return byName;
  return _getLessonTypeByAbbreviation(lessonType.trim().toUpperCase());
}

LessonType _getLessonTypeByName(String name) {
  final value = name.trim().toLowerCase().replaceAll('ё', 'е');
  if (value.startsWith('лекц')) return LessonType.lecture;
  if (value.startsWith('практическ')) return LessonType.practice;
  if (value.startsWith('лабораторн')) return LessonType.laboratoryWork;
  if (value.startsWith('самостоятельн')) return LessonType.individualWork;
  if (value.startsWith('курсовая')) return LessonType.courseWork;
  if (value.startsWith('курсовой')) return LessonType.courseProject;
  if (value.startsWith('экзамен')) return LessonType.exam;
  if (value.startsWith('зачет')) return LessonType.credit;
  if (value.startsWith('консультац')) return LessonType.consultation;
  return LessonType.unknown;
}

LessonType _getLessonTypeByAbbreviation(String abbreviation) {
  return switch (abbreviation) {
    'ЛК' || 'ЛЕК' => LessonType.lecture,
    'ПР' => LessonType.practice,
    'ЛР' || 'ЛАБ' => LessonType.laboratoryWork,
    'СР' => LessonType.individualWork,
    'КР' => LessonType.courseWork,
    'КП' => LessonType.courseProject,
    'ЭКЗ' || 'Э' => LessonType.exam,
    'ЗАЧ' || 'З' || 'ЗД' || 'ДЗ' => LessonType.credit,
    'КОНС' || 'КТ' => LessonType.consultation,
    _ => LessonType.unknown,
  };
}
