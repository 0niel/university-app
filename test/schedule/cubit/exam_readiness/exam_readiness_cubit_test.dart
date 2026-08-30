import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:rtu_mirea_app/schedule/cubit/cubit.dart';
import 'package:schedule_repository/schedule_repository.dart';

class MockScheduleRepository extends Mock implements ScheduleRepository {}

void main() {
  group('ExamReadinessCubit', () {
    late ScheduleRepository scheduleRepository;

    const entry = ExamReadiness(
      subjectName: 'Машинное обучение',
      readiness: 80,
    );

    setUp(() {
      scheduleRepository = MockScheduleRepository();
      when(() => scheduleRepository.hasAuthenticatedUser).thenReturn(true);
      when(
        () => scheduleRepository.getExamReadiness(),
      ).thenAnswer((_) async => [entry]);
      when(
        () => scheduleRepository.setExamReadiness(
          subjectName: any(named: 'subjectName'),
          readiness: any(named: 'readiness'),
        ),
      ).thenAnswer((_) async {});
    });

    ExamReadinessCubit buildCubit() =>
        ExamReadinessCubit(scheduleRepository: scheduleRepository);

    test('initial state is empty ExamReadinessState', () {
      expect(buildCubit().state, equals(const ExamReadinessState()));
    });

    group('load', () {
      blocTest<ExamReadinessCubit, ExamReadinessState>(
        'emits [loading, populated] when getExamReadiness succeeds',
        build: buildCubit,
        act: (cubit) => cubit.load(),
        expect: () => const [
          ExamReadinessState(status: ExamReadinessStatus.loading),
          ExamReadinessState(
            entries: [entry],
            status: ExamReadinessStatus.populated,
          ),
        ],
      );

      blocTest<ExamReadinessCubit, ExamReadinessState>(
        'does nothing when there is no authenticated user',
        setUp: () => when(
          () => scheduleRepository.hasAuthenticatedUser,
        ).thenReturn(false),
        build: buildCubit,
        act: (cubit) => cubit.load(),
        expect: () => const <ExamReadinessState>[],
        verify: (_) => verifyNever(() => scheduleRepository.getExamReadiness()),
      );

      blocTest<ExamReadinessCubit, ExamReadinessState>(
        'emits [loading, failure] and reports the error on failure',
        setUp: () => when(
          () => scheduleRepository.getExamReadiness(),
        ).thenThrow(Exception('boom')),
        build: buildCubit,
        act: (cubit) => cubit.load(),
        expect: () => const [
          ExamReadinessState(status: ExamReadinessStatus.loading),
          ExamReadinessState(status: ExamReadinessStatus.failure),
        ],
        errors: () => [isA<Exception>()],
      );
    });

    group('setReadiness', () {
      blocTest<ExamReadinessCubit, ExamReadinessState>(
        'optimistically stores the readiness and persists it',
        build: buildCubit,
        act: (cubit) => cubit.setReadiness('Базы данных', 45),
        expect: () => [
          isA<ExamReadinessState>().having(
            (s) => s.readinessFor('Базы данных'),
            'readinessFor Базы данных',
            0.45,
          ),
        ],
        verify: (_) => verify(
          () => scheduleRepository.setExamReadiness(
            subjectName: 'Базы данных',
            readiness: 45,
          ),
        ).called(1),
      );

      blocTest<ExamReadinessCubit, ExamReadinessState>(
        'reverts the optimistic value and reports the error on failure',
        setUp: () => when(
          () => scheduleRepository.setExamReadiness(
            subjectName: any(named: 'subjectName'),
            readiness: any(named: 'readiness'),
          ),
        ).thenThrow(Exception('boom')),
        build: buildCubit,
        seed: () => const ExamReadinessState(entries: [entry]),
        act: (cubit) => cubit.setReadiness('Базы данных', 45),
        expect: () => const [
          ExamReadinessState(
            entries: [
              entry,
              ExamReadiness(subjectName: 'Базы данных', readiness: 45),
            ],
          ),
          ExamReadinessState(entries: [entry]),
        ],
        errors: () => [isA<Exception>()],
      );
    });
  });
}
