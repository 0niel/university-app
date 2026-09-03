import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:rtu_mirea_app/schedule/cubit/cubit.dart';
import 'package:rtu_mirea_app/schedule/models/models.dart';
import 'package:rtu_mirea_app/schedule/view/schedule_page/lesson_status.dart';
import 'package:schedule_repository/schedule_repository.dart';

import 'schedule_test_data.dart';

class _Repository extends Mock implements ScheduleRepository {}

void main() {
  final lesson = scheduleTestLesson();
  final selected = SelectedGroupSchedule(
    group: const Group(name: 'A'),
    schedule: [lesson],
  );
  final change = ScheduleChange(
    id: '1',
    kind: ScheduleChangeKind.cancel,
    subject: lesson.subject,
    lessonDate: lesson.dates.single,
    createdAt: lesson.dates.single,
  );
  late ScheduleChangesCubit cubit;

  setUp(() async {
    final repository = _Repository();
    when(
      () => repository.getScheduleChanges(
        targetType: ScheduleTargetType.group,
        target: 'A',
      ),
    ).thenAnswer((_) async => [change]);
    cubit = ScheduleChangesCubit(scheduleRepository: repository);
    await cubit.load(targetType: ScheduleTargetType.group, target: 'A');
    addTearDown(cubit.close);
  });

  test('matching selected lesson can display its changes', () {
    expect(changesForSelectedLesson(cubit, selected, lesson), [change]);
  });

  test('custom lessons do not inherit a group cancellation', () {
    final custom = SelectedCustomSchedule(
      id: 'custom',
      name: 'Personal',
      schedule: [lesson],
    );
    expect(changesForSelectedLesson(cubit, custom, lesson), isEmpty);
  });

  test('other target and lessons outside the target cannot reuse changes', () {
    final other = SelectedGroupSchedule(
      group: const Group(name: 'B'),
      schedule: [lesson],
    );
    expect(changesForSelectedLesson(cubit, other, lesson), isEmpty);
    expect(
      changesForSelectedLesson(
        cubit,
        selected,
        lesson.copyWith(classrooms: const [Classroom(name: 'B')]),
      ),
      isEmpty,
    );
  });
}
