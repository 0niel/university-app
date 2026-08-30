import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:mocktail/mocktail.dart';
import 'package:rtu_mirea_app/schedule/cubit/schedule_preferences/schedule_preferences_cubit.dart';

class MockStorage extends Mock implements Storage {}

void main() {
  late Storage storage;

  setUp(() {
    storage = MockStorage();
    when(() => storage.read(any())).thenReturn(null);
    when(() => storage.write(any(), any<dynamic>())).thenAnswer((_) async {});
    when(() => storage.delete(any())).thenAnswer((_) async {});
    HydratedBloc.storage = storage;
  });

  group('SchedulePreferencesCubit', () {
    test('initial state is SchedulePreferencesState()', () {
      expect(
        SchedulePreferencesCubit().state,
        equals(const SchedulePreferencesState()),
      );
    });

    group('applyFilters', () {
      blocTest<SchedulePreferencesCubit, SchedulePreferencesState>(
        'applies every filter selection in one emission',
        build: SchedulePreferencesCubit.new,
        act: (cubit) => cubit.applyFilters(
          showLectures: false,
          showSeminars: false,
          showLabs: true,
          showExams: false,
          showGaps: false,
          collapsePast: false,
        ),
        expect: () => const <SchedulePreferencesState>[
          SchedulePreferencesState(
            showLectures: false,
            showSeminars: false,
            showExams: false,
            showGaps: false,
            collapsePast: false,
          ),
        ],
      );
    });

    group('resetFilters', () {
      blocTest<SchedulePreferencesCubit, SchedulePreferencesState>(
        'restores every filter back to its default',
        build: SchedulePreferencesCubit.new,
        seed: () => const SchedulePreferencesState(
          showLectures: false,
          showSeminars: false,
          showLabs: false,
          showExams: false,
          showGaps: false,
          collapsePast: false,
        ),
        act: (cubit) => cubit.resetFilters(),
        expect: () => const <SchedulePreferencesState>[
          SchedulePreferencesState(),
        ],
      );
    });

    group('hideSubject / unhideSubject', () {
      blocTest<SchedulePreferencesCubit, SchedulePreferencesState>(
        'hideSubject appends the subject once',
        build: SchedulePreferencesCubit.new,
        act: (cubit) => cubit
          ..hideSubject('Матан')
          ..hideSubject('Матан'),
        expect: () => const <SchedulePreferencesState>[
          SchedulePreferencesState(hiddenSubjects: ['Матан']),
        ],
      );

      blocTest<SchedulePreferencesCubit, SchedulePreferencesState>(
        'unhideSubject removes the subject',
        build: SchedulePreferencesCubit.new,
        seed: () => const SchedulePreferencesState(
          hiddenSubjects: ['Матан', 'Физика'],
        ),
        act: (cubit) => cubit.unhideSubject('Матан'),
        expect: () => const <SchedulePreferencesState>[
          SchedulePreferencesState(hiddenSubjects: ['Физика']),
        ],
      );
    });

    test('toJson/fromJson round-trips the preferences', () {
      final cubit = SchedulePreferencesCubit()
        ..applyFilters(
          showLectures: false,
          showSeminars: true,
          showLabs: false,
          showExams: true,
          showGaps: false,
          collapsePast: false,
        )
        ..hideSubject('Матан');
      final json = cubit.toJson(cubit.state);
      expect(json, isNotNull);
      expect(cubit.fromJson(json), equals(cubit.state));
    });
  });
}
