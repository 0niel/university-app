import 'package:flutter_test/flutter_test.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:rtu_mirea_app/schedule/bloc/schedule_bloc.dart';
import 'package:rtu_mirea_app/schedule/models/models.dart';
import 'package:schedule_repository/schedule_repository.dart';

void main() {
  const groupEntity = Group(name: 'ИКБО-09-22');
  const teacher = Teacher(name: 'Соколова М. В.');
  const classroom = Classroom(name: 'А-12');
  const selectedGroup = SelectedGroupSchedule(
    group: groupEntity,
    schedule: [],
  );

  final cases = <(SelectedSchedule, Map<String, Object?>)>[
    (
      selectedGroup,
      {
        'group': groupEntity.toJson(),
        'schedule': <Object?>[],
        'type': 'group',
      },
    ),
    (
      const SelectedTeacherSchedule(teacher: teacher, schedule: []),
      {
        'teacher': teacher.toJson(),
        'schedule': <Object?>[],
        'type': 'teacher',
      },
    ),
    (
      const SelectedClassroomSchedule(classroom: classroom, schedule: []),
      {
        'classroom': classroom.toJson(),
        'schedule': <Object?>[],
        'type': 'classroom',
      },
    ),
    (
      const SelectedCustomSchedule(
        id: 'custom-1',
        name: 'Моё расписание',
        description: 'Без окон',
        schedule: [],
      ),
      {
        'id': 'custom-1',
        'name': 'Моё расписание',
        'description': 'Без окон',
        'schedule': <Object?>[],
        'type': 'custom',
      },
    ),
  ];

  group('SelectedSchedule legacy JSON', () {
    for (final (schedule, json) in cases) {
      test('round-trips ${schedule.type}', () {
        expect(schedule.toJson(), json);
        expect(SelectedSchedule.fromJson(json), schedule);
      });
    }

    test('rejects an unknown discriminator', () {
      expect(
        () => SelectedSchedule.fromJson(const {'type': 'unknown'}),
        throwsFormatException,
      );
    });

    test('rejects a payload that does not match its discriminator', () {
      expect(
        () => SelectedSchedule.fromJson({
          'type': 'group',
          'teacher': teacher.toJson(),
          'schedule': <Object?>[],
        }),
        throwsA(isA<CheckedFromJsonException>()),
      );
    });

    test('survives the persisted ScheduleState contract', () {
      const state = ScheduleState(selectedSchedule: selectedGroup);

      expect(
        ScheduleState.fromJson(state.toJson()).selectedSchedule,
        state.selectedSchedule,
      );
    });
  });
}
