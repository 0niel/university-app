import 'package:flutter_test/flutter_test.dart';
import 'package:rtu_mirea_app/schedule/models/models.dart';
import 'package:rtu_mirea_app/schedule/view/schedule_page/lesson_meta.dart';
import 'package:rtu_mirea_app/schedule/view/schedule_page/lesson_text.dart';
import 'package:schedule_repository/schedule_repository.dart';

void main() {
  LessonSchedulePart lessonWithGroups(List<String>? groups) {
    return LessonSchedulePart(
      subject: 'Дискретная математика',
      lessonType: LessonType.lecture,
      teachers: const [Teacher(name: 'Иванов Иван Иванович', uid: '1')],
      classrooms: const [Classroom(name: 'А-1', uid: 'c1')],
      lessonBells: LessonBells(
        startTime: const TimeOfDay(hour: 9, minute: 0),
        endTime: const TimeOfDay(hour: 10, minute: 30),
        number: 1,
      ),
      dates: [DateTime(2026, 3, 6)],
      groups: groups,
    );
  }

  const groupSchedule = SelectedGroupSchedule(
    group: Group(name: 'ИКБО-01-25', uid: 'g1'),
    schedule: [],
  );
  const teacherSchedule = SelectedTeacherSchedule(
    teacher: Teacher(name: 'Иванов Иван Иванович', uid: '1'),
    schedule: [],
  );
  const classroomSchedule = SelectedClassroomSchedule(
    classroom: Classroom(name: 'А-1', uid: 'c1'),
    schedule: [],
  );

  group('lessonGroupsLabel', () {
    test('shows the group on a teacher schedule', () {
      expect(
        lessonGroupsLabel(
          lessonWithGroups(const ['ИКБО-01-25']),
          teacherSchedule,
        ),
        'ИКБО-01-25',
      );
    });

    test('shows the group on a classroom schedule', () {
      expect(
        lessonGroupsLabel(
          lessonWithGroups(const ['ИКБО-01-25']),
          classroomSchedule,
        ),
        'ИКБО-01-25',
      );
    });

    test('joins multiple groups for a combined lecture (поток)', () {
      expect(
        lessonGroupsLabel(
          lessonWithGroups(const ['ИКБО-01-25', 'ИКБО-02-25']),
          teacherSchedule,
        ),
        'ИКБО-01-25, ИКБО-02-25',
      );
    });

    test('hides the single implied group on a group schedule', () {
      expect(
        lessonGroupsLabel(
          lessonWithGroups(const ['ИКБО-01-25']),
          groupSchedule,
        ),
        isNull,
      );
    });

    test('still shows a combined lecture on a group schedule', () {
      expect(
        lessonGroupsLabel(
          lessonWithGroups(const ['ИКБО-01-25', 'ИКБО-02-25']),
          groupSchedule,
        ),
        'ИКБО-01-25, ИКБО-02-25',
      );
    });

    test('returns null when the lesson has no groups', () {
      expect(
        lessonGroupsLabel(lessonWithGroups(null), teacherSchedule),
        isNull,
      );
      expect(
        lessonGroupsLabel(lessonWithGroups(const []), teacherSchedule),
        isNull,
      );
    });
  });

  test('derives a missing pair number from the standard bell slot', () {
    final lesson = lessonWithGroups(null).copyWith(
      lessonBells: LessonBells(
        startTime: const TimeOfDay(hour: 9, minute: 0),
        endTime: const TimeOfDay(hour: 10, minute: 30),
      ),
    );

    expect(lessonNumberOf(lesson), 1);
  });

  group('schedule labels', () {
    test('shortens a full teacher name without changing compact names', () {
      expect(
        shortTeacherName('Акатьев Ярослав Алексеевич'),
        'Акатьев Я. А.',
      );
      expect(shortTeacherName('Соколова М. В.'), 'Соколова М. В.');
      expect(shortTeacherName('Иванов И.И.'), 'Иванов И. И.');
    });

    test('adds the short campus name to the classroom', () {
      expect(
        classroomLabel(
          const Classroom(
            name: 'А-415-6',
            campus: Campus(
              name: 'Проспект Вернадского, д.78',
              shortName: 'В-78',
            ),
          ),
        ),
        'А-415-6 · В-78',
      );
      expect(classroomLabel(const Classroom(name: 'Online')), 'Online');
    });
  });
}
