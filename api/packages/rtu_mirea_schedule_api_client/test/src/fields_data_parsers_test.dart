import 'package:rtu_mirea_schedule_api_client/src/fields_data_parsers.dart';
import 'package:test/test.dart';

void main() {
  group('parseTeachersFromDescription', () {
    test('should return empty list when description is empty', () {
      final result = parseTeachersFromDescription('');
      expect(result, isEmpty);
    });

    test('should return empty list when description does not match pattern', () {
      const description = 'Some random description';
      final result = parseTeachersFromDescription(description);
      expect(result, isEmpty);
    });

    test('should return list of teachers when description matches pattern', () {
      const description = 'Преподаватели:\nБалак Павел Викторович\nМартыненков Борис Витальевич\n\n';
      final result = parseTeachersFromDescription(description);
      expect(result, hasLength(2));
      expect(
        result,
        containsAll(
          ['Балак Павел Викторович', 'Мартыненков Борис Витальевич'],
        ),
      );
    });

    test('should return list of teachers even if there is only one teacher', () {
      const description = 'Преподаватель:\nБалак Павел Викторович\n\n';
      final result = parseTeachersFromDescription(description);
      expect(result, hasLength(1));
      expect(result, contains('Балак Павел Викторович'));
    });

    test('should return list of teachers even if there is additional info', () {
      const description = 'Преподаватель: Конюхова Галина Павловна\n\nГруппа: РКБО-02-23 ';
      final result = parseTeachersFromDescription(description);
      expect(result, hasLength(1));
      expect(
        result,
        containsAll(
          ['Конюхова Галина Павловна'],
        ),
      );
    });

    test('should return list of teachers even if there is many teachers', () {
      const description =
          'Преподаватель: Царёв Роман Юрьевич\n\nГруппы:\nИКБО-01-20 \nИКБО-02-20 \nИКБО-10-20 \nИКБО-16-20 \nИКБО-24-20 \nИКБО-30-20 \n';
      final result = parseTeachersFromDescription(description);
      expect(result, hasLength(1));
      expect(result, contains('Царёв Роман Юрьевич'));
    });
  });

  group('parseGroupsFromDescription', () {
    test('should return empty list when description is empty', () {
      final result = parseGroupsFromDescription('');
      expect(result, isEmpty);
    });

    test('should return empty list when description does not match pattern', () {
      const description = 'Some random description';
      final result = parseGroupsFromDescription(description);
      expect(result, isEmpty);
    });

    test('should return list of groups when description matches pattern', () {
      const description = 'Группы:\nGroup 1\nGroup 2\n\n';
      final result = parseGroupsFromDescription(description);
      expect(result, hasLength(2));
      expect(result, containsAll(['Group 1', 'Group 2']));
    });

    test('should return list of groups even if there is many groups and info', () {
      const description =
          'Преподаватель: Царёв Роман Юрьевич\n\nГруппы:\nИКБО-01-20 \nИКБО-02-20 \nИКБО-10-20 \nИКБО-16-20 \nИКБО-24-20 \nИКБО-30-20 \n';
      final result = parseGroupsFromDescription(description);
      expect(result, hasLength(6));
      expect(result, contains('ИКБО-30-20'));
    });
  });

  group('parseClassroomsFromLocation', () {
    test('should return empty list when location is empty', () {
      final result = parseClassroomsFromLocation('');
      expect(result, isEmpty);
    });

    test('should return empty list when location does not match pattern', () {
      const location = 'Some random location';
      final result = parseClassroomsFromLocation(location);
      expect(result, isEmpty);
    });

    test('should return list of classrooms when location matches pattern', () {
      const location = 'А-110 (МП-1) А-153 (МП-1) Б-304 (МП-1) А-111 (МП-1) А-155 (МП-1) '
          'А-112 (МП-1) А-150 (МП-1) А-156 (МП-1) А-157 (МП-1) А-109 (МП-1) '
          'Б-308 (МП-1) Б-305 (МП-1) Б-306 (МП-1) Б-307 (МП-1)';
      final result = parseClassroomsFromLocation(location);
      expect(result, hasLength(14));
      expect(result[0].name, 'А-110');
      expect(result[0].campus?.shortName, 'МП-1');
      expect(result[1].name, 'А-153');
      expect(result[1].campus?.shortName, 'МП-1');
      // Add more assertions for other classrooms
    });
  });

  test('should return list of classrooms when only one classroom', () {
    const location = 'А-110 (В-78)';
    final result = parseClassroomsFromLocation(location);
    expect(result, hasLength(1));
    expect(result[0].name, 'А-110');
    expect(result[0].campus?.shortName, 'В-78');
  });

  test('shoud return classroom with null campus if campus has unknown short name', () {
    const location = 'А-110 (З-11)';
    final result = parseClassroomsFromLocation(location);
    expect(result, hasLength(1));
    expect(result[0].name, 'А-110');
    expect(result[0].campus, isNull);
  });
}
