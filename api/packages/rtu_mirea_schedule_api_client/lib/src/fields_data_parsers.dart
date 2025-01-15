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
            return const Classroom.online();
          }

          return Classroom(
            name: classroom.trim(),
            campus: campusObject,
          );
        })
        .where((element) => element != null)
        .map((e) => e!)
        .toList();
  } catch (e) {
    return [];
  }
}

/// Parse lesson type from the text.
LessonType getLessonTypeFromText(String lessonType) {
  final parsedLessonType = _getLessonTypeByAbbreviation(lessonType.trim());

  if (parsedLessonType != LessonType.unknown) {
    return parsedLessonType;
  }

  if (lessonType.contains('Экзамен')) {
    return LessonType.exam;
  } else if (lessonType.contains('Зачет')) {
    return LessonType.credit;
  } else if (lessonType.contains('Консультация')) {
    return LessonType.consultation;
  } else if (lessonType.contains('Курсовая работа')) {
    return LessonType.courseWork;
  } else if (lessonType.contains('Курсовой проект')) {
    return LessonType.courseProject;
  }

  return LessonType.unknown;
}

LessonType _getLessonTypeByAbbreviation(String abbreviation) {
  switch (abbreviation) {
    case 'ЛК':
      return LessonType.lecture;
    case 'ПР':
      return LessonType.practice;
    case 'ЛР':
      return LessonType.laboratoryWork;
    case 'СР':
      return LessonType.individualWork;
    case 'КП':
      return LessonType.courseWork;
    case 'КР':
      return LessonType.courseProject;
    case 'ЭКЗ':
      return LessonType.exam;
    case 'ЗАЧ':
      return LessonType.credit;
    case 'ЛАБ':
      return LessonType.laboratoryWork;

    default:
      return LessonType.unknown;
  }
}
