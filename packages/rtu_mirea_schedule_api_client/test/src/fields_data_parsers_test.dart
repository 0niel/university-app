import 'package:collection/collection.dart';
import 'package:rtu_mirea_schedule_api_client/src/fields_data_parsers.dart';
import 'package:schedule/schedule.dart';
import 'package:test/test.dart';

void main() {
  group('getLessonTypeFromText', () {
    test('maps every abbreviation used by the schedule source', () {
      expect(getLessonTypeFromText('ЛК'), LessonType.lecture);
      expect(getLessonTypeFromText('ЛЕК'), LessonType.lecture);
      expect(getLessonTypeFromText('ПР'), LessonType.practice);
      expect(getLessonTypeFromText('ЛАБ'), LessonType.laboratoryWork);
      expect(getLessonTypeFromText('СР'), LessonType.individualWork);
      expect(getLessonTypeFromText('ЗД'), LessonType.credit);
      expect(getLessonTypeFromText('ЗАЧ'), LessonType.credit);
      expect(getLessonTypeFromText('ЭКЗ'), LessonType.exam);
      expect(getLessonTypeFromText('КОНС'), LessonType.consultation);
      expect(getLessonTypeFromText('КР'), LessonType.courseWork);
      expect(getLessonTypeFromText('КП'), LessonType.courseProject);
      expect(getLessonTypeFromText(' лк '), LessonType.lecture);
      expect(getLessonTypeFromText('ДОП'), LessonType.unknown);
    });

    test('prefers the full type name over the abbreviation', () {
      expect(
        getLessonTypeFromText('ЛЕК', fullLessonType: 'Лекции'),
        LessonType.lecture,
      );
      expect(
        getLessonTypeFromText('ЗД', fullLessonType: 'Зачёт дифференцированный'),
        LessonType.credit,
      );
      expect(
        getLessonTypeFromText('X', fullLessonType: 'Курсовая работа'),
        LessonType.courseWork,
      );
      expect(
        getLessonTypeFromText('X', fullLessonType: 'Курсовой проект'),
        LessonType.courseProject,
      );
      expect(
        getLessonTypeFromText('ПР', fullLessonType: 'Практические занятия'),
        LessonType.practice,
      );
      expect(
        getLessonTypeFromText('ЛАБ', fullLessonType: 'Неизвестный вид'),
        LessonType.laboratoryWork,
      );
    });
  });

  group('parseClassroomsFromLocation', () {
    test('should return empty list when location is empty', () {
      final result = getClassroomsFromLocationText('');
      expect(result, isEmpty);
    });

    test('should return empty list when location does not match pattern', () {
      const location = 'Some random location';
      final result = getClassroomsFromLocationText(location);
      expect(result, isEmpty);
    });

    test('should return list of classrooms when location matches pattern', () {
      const location =
          'А-110 (МП-1) А-153 (МП-1) Б-304 (МП-1) А-111 (МП-1) А-155 (МП-1) '
          'А-112 (МП-1) А-150 (МП-1) А-156 (МП-1) А-157 (МП-1) А-109 (МП-1) '
          'Б-308 (МП-1) Б-305 (МП-1) Б-306 (МП-1) Б-307 (МП-1)';
      final result = getClassroomsFromLocationText(location);
      expect(result, hasLength(14));
      expect(result.elementAtOrNull(0)?.name, 'А-110');
      expect(result.elementAtOrNull(0)?.campus?.shortName, 'МП-1');
      expect(result.elementAtOrNull(1)?.name, 'А-153');
      expect(result.elementAtOrNull(1)?.campus?.shortName, 'МП-1');
    });
  });

  test('should return list of classrooms when only one classroom', () {
    const location = 'А-110 (В-78)';
    final result = getClassroomsFromLocationText(location);
    expect(result, hasLength(1));
    expect(result.elementAtOrNull(0)?.name, 'А-110');
    expect(result.elementAtOrNull(0)?.campus?.shortName, 'В-78');
  });

  test(
    'returns classroom with null campus when the campus short name is unknown',
    () {
      const location = 'А-110 (З-11)';
      final result = getClassroomsFromLocationText(location);
      expect(result, hasLength(1));
      expect(result.elementAtOrNull(0)?.name, 'А-110');
      expect(result.elementAtOrNull(0)?.campus, isNull);
    },
  );
}
