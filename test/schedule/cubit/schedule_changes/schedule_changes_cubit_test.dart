import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:rtu_mirea_app/schedule/cubit/cubit.dart';
import 'package:schedule_repository/schedule_repository.dart';

class MockScheduleRepository extends Mock implements ScheduleRepository {}

void main() {
  group('ScheduleChangesCubit', () {
    late ScheduleRepository scheduleRepository;

    final change = ScheduleChange(
      id: '1',
      kind: ScheduleChangeKind.room,
      subject: 'Системы ИИ',
      lessonDate: DateTime(2026, 5, 22),
      createdAt: DateTime(2026, 5, 22, 9),
    );

    setUpAll(() {
      registerFallbackValue(ScheduleTargetType.group);
    });

    setUp(() {
      scheduleRepository = MockScheduleRepository();
      when(
        () => scheduleRepository.getScheduleChanges(
          targetType: any(named: 'targetType'),
          target: any(named: 'target'),
        ),
      ).thenAnswer((_) async => [change]);
    });

    ScheduleChangesCubit buildCubit() =>
        ScheduleChangesCubit(scheduleRepository: scheduleRepository);

    test('initial state is empty ScheduleChangesState', () {
      expect(buildCubit().state, equals(const ScheduleChangesState()));
    });

    group('load', () {
      blocTest<ScheduleChangesCubit, ScheduleChangesState>(
        'emits [loading, populated] when getScheduleChanges succeeds',
        build: buildCubit,
        act: (cubit) => cubit.load(
          targetType: ScheduleTargetType.group,
          target: 'ИКБО-09-22',
        ),
        expect: () => [
          const ScheduleChangesState(status: ScheduleChangesStatus.loading),
          ScheduleChangesState(
            changes: [change],
            status: ScheduleChangesStatus.populated,
          ),
        ],
      );

      blocTest<ScheduleChangesCubit, ScheduleChangesState>(
        'emits [loading, failure] and reports the error on failure',
        setUp: () => when(
          () => scheduleRepository.getScheduleChanges(
            targetType: any(named: 'targetType'),
            target: any(named: 'target'),
          ),
        ).thenThrow(Exception('boom')),
        build: buildCubit,
        act: (cubit) => cubit.load(
          targetType: ScheduleTargetType.group,
          target: 'ИКБО-09-22',
        ),
        expect: () => const [
          ScheduleChangesState(status: ScheduleChangesStatus.loading),
          ScheduleChangesState(status: ScheduleChangesStatus.failure),
        ],
        errors: () => [isA<Exception>()],
      );
    });
  });
}
