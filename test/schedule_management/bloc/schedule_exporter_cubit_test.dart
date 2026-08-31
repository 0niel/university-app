import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:rtu_mirea_app/schedule_management/bloc/schedule_exporter_cubit.dart';
import 'package:schedule_exporter_repository/schedule_exporter_repository.dart';
import 'package:schedule_repository/schedule_repository.dart';

class MockScheduleExporterRepository extends Mock
    implements ScheduleExporterRepository {}

void main() {
  late ScheduleExporterRepository repository;

  setUpAll(() {
    registerFallbackValue(<LessonSchedulePart>[]);
  });

  setUp(() {
    repository = MockScheduleExporterRepository();
    when(
      () => repository.exportScheduleToCalendar(
        calendarName: any(named: 'calendarName'),
        lessons: any(named: 'lessons'),
        includeEmojis: any(named: 'includeEmojis'),
        includeShortTypeNames: any(named: 'includeShortTypeNames'),
        reminderMinutes: any(named: 'reminderMinutes'),
      ),
    ).thenAnswer((_) async {});
  });

  ScheduleExporterCubit buildCubit() => ScheduleExporterCubit(repository);

  group('ScheduleExporterCubit', () {
    test('initial state is ScheduleExporterState()', () {
      expect(buildCubit().state, equals(const ScheduleExporterState()));
    });

    group('exportSchedule', () {
      blocTest<ScheduleExporterCubit, ScheduleExporterState>(
        'emits [loading, success] when the export succeeds',
        build: buildCubit,
        act: (cubit) => cubit.exportSchedule(
          calendarName: 'Учёба',
          lessons: const [],
        ),
        verify: (_) {
          verify(
            () => repository.exportScheduleToCalendar(
              calendarName: 'Учёба',
              lessons: const [],
              includeShortTypeNames: true,
            ),
          ).called(1);
        },
        expect: () => const <ScheduleExporterState>[
          ScheduleExporterState(isLoading: true),
          ScheduleExporterState(isSuccess: true),
        ],
      );

      blocTest<ScheduleExporterCubit, ScheduleExporterState>(
        'forwards the provided export options to the repository',
        build: buildCubit,
        act: (cubit) => cubit.exportSchedule(
          calendarName: 'Учёба',
          lessons: const [],
          includeEmojis: false,
          includeShortTypeNames: false,
          reminderMinutes: const [5],
        ),
        verify: (_) {
          verify(
            () => repository.exportScheduleToCalendar(
              calendarName: 'Учёба',
              lessons: const [],
              includeEmojis: false,
              reminderMinutes: const [5],
            ),
          ).called(1);
        },
        expect: () => const <ScheduleExporterState>[
          ScheduleExporterState(isLoading: true),
          ScheduleExporterState(isSuccess: true),
        ],
      );

      blocTest<ScheduleExporterCubit, ScheduleExporterState>(
        'clears a previous success state before starting another export',
        build: buildCubit,
        seed: () => const ScheduleExporterState(isSuccess: true),
        act: (cubit) => cubit.exportSchedule(
          calendarName: 'Учёба',
          lessons: const [],
        ),
        expect: () => const <ScheduleExporterState>[
          ScheduleExporterState(isLoading: true),
          ScheduleExporterState(isSuccess: true),
        ],
      );

      blocTest<ScheduleExporterCubit, ScheduleExporterState>(
        'emits [loading, failure] with the error message when export throws',
        setUp: () => when(
          () => repository.exportScheduleToCalendar(
            calendarName: any(named: 'calendarName'),
            lessons: any(named: 'lessons'),
            includeEmojis: any(named: 'includeEmojis'),
            includeShortTypeNames: any(named: 'includeShortTypeNames'),
            reminderMinutes: any(named: 'reminderMinutes'),
          ),
        ).thenThrow(const PermissionDeniedException()),
        build: buildCubit,
        act: (cubit) => cubit.exportSchedule(
          calendarName: 'Учёба',
          lessons: const [],
        ),
        expect: () => <ScheduleExporterState>[
          const ScheduleExporterState(isLoading: true),
          ScheduleExporterState(
            errorMessage: const PermissionDeniedException().toString(),
          ),
        ],
      );
    });
  });
}
