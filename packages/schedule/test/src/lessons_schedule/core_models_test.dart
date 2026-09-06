import 'package:schedule/schedule.dart';
import 'package:test/test.dart';

void main() {
  group('Campus', () {
    test('round-trips JSON and keeps paired coordinates invariant', () {
      const campus = Campus(
        name: 'Main campus',
        shortName: 'Main',
        latitude: 55.75,
        longitude: 37.62,
        uid: 'main',
      );

      expect(Campus.fromJson(campus.toJson()), campus);
      expect(
        () => Campus(name: 'Broken campus', latitude: 55.75),
        throwsA(isA<AssertionError>()),
      );
    });
  });

  group('Group and Teacher', () {
    test(
      'repairs cached Cyrillic names while preserving identity and metadata',
      () {
        final teacher = Teacher.fromJson({
          'name': '  Овчинникова\u00a0МарияАндреевна\t',
          'uid': '512',
          'email': 'teacher@example.edu',
          'photo_url': 'https://example.edu/teacher.png',
        });

        expect(teacher.name, 'Овчинникова Мария Андреевна');
        expect(teacher.uid, '512');
        expect(teacher.email, 'teacher@example.edu');
        expect(teacher.photoUrl, 'https://example.edu/teacher.png');
        expect(Teacher.fromJson(teacher.toJson()), teacher);
      },
    );

    test('preserves hyphenated names, initials and Latin capitalization', () {
      for (final name in [
        'Петрова Анна-Мария Ильинична',
        'Салтыков-Щедрин М. Е.',
        'Иванов И.И.',
        'McDonald Anna',
        "O'Connor Jean-Luc",
        'de Vries Willem',
      ]) {
        expect(Teacher.fromJson({'name': name}).name, name);
      }
      expect(
        Teacher.fromJson({'name': 'СемёновПётрИльич'}).name,
        'Семёнов Пётр Ильич',
      );
    });

    test('provide generated JSON, copyWith and value equality', () {
      const group = Group(name: 'IU7-31B', uid: 'group-1');
      const teacher = Teacher(name: 'Ada Lovelace', email: 'ada@example.edu');

      expect(Group.fromJson(group.toJson()), group);
      expect(teacher.copyWith(), teacher);
      expect(teacher.copyWith(phone: '+79990000000').phone, '+79990000000');
      expect(Teacher.fromJson(teacher.toJson()), teacher);
    });
  });

  group('Classroom', () {
    test('uses generated JSON and preserves the online factory contract', () {
      final online = Classroom.online(url: 'https://meet.example.edu/room');

      expect(Classroom.fromJson(online.toJson()), online);
      expect(online.name, 'Online');
      expect(online.copyWith(name: '101').name, '101');
      expect(online.copyWith().url, online.url);
      expect(
        online.copyWith(url: 'https://meet.example.edu/next').url,
        'https://meet.example.edu/next',
      );
    });
  });

  group('LessonBells', () {
    test('round-trips time JSON and preserves compact text presentation', () {
      final bells = LessonBells(
        number: 2,
        startTime: const TimeOfDay(hour: 9, minute: 0),
        endTime: const TimeOfDay(hour: 10, minute: 30),
      );

      expect(LessonBells.fromJson(bells.toJson()), bells);
      expect(bells.toString(), '09:00-10:30');
      expect(
        () => LessonBells(
          startTime: const TimeOfDay(hour: 10, minute: 0),
          endTime: const TimeOfDay(hour: 9, minute: 0),
        ),
        throwsA(isA<AssertionError>()),
      );
    });
  });
}
