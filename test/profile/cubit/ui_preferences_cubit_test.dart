import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:mocktail/mocktail.dart';
import 'package:rtu_mirea_app/profile/cubit/ui_preferences_cubit.dart';

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

  group('UiPreferencesCubit', () {
    test('defaults to all sections enabled and reactions on', () {
      final state = UiPreferencesCubit().state;
      for (final section in HomeSection.values) {
        expect(state.isSectionEnabled(section), isTrue);
      }
      expect(state.showLessonReactions, isTrue);
      expect(state.lessonTypeColor('lecture'), 0xFF087F5B);
    });

    blocTest<UiPreferencesCubit, UiPreferencesState>(
      'setSection hides a home section',
      build: UiPreferencesCubit.new,
      act: (cubit) => cubit.setSection(HomeSection.deadlines, enabled: false),
      verify: (cubit) {
        expect(cubit.state.isSectionEnabled(HomeSection.deadlines), isFalse);
        expect(cubit.state.isSectionEnabled(HomeSection.today), isTrue);
      },
    );

    blocTest<UiPreferencesCubit, UiPreferencesState>(
      'setShowLessonReactions toggles the flag',
      build: UiPreferencesCubit.new,
      act: (cubit) => cubit.setShowLessonReactions(value: false),
      expect: () => [
        isA<UiPreferencesState>().having(
          (s) => s.showLessonReactions,
          'showLessonReactions',
          isFalse,
        ),
      ],
    );

    blocTest<UiPreferencesCubit, UiPreferencesState>(
      'lesson type colors are customizable and resettable',
      build: UiPreferencesCubit.new,
      act: (cubit) {
        cubit
          ..setLessonTypeColor('lecture', 0xFFE5484D)
          ..resetLessonTypeColors();
      },
      expect: () => [
        isA<UiPreferencesState>().having(
          (state) => state.lessonTypeColor('lecture'),
          'lecture color',
          0xFFE5484D,
        ),
        isA<UiPreferencesState>().having(
          (state) => state.lessonTypeColor('lecture'),
          'reset lecture color',
          0xFF087F5B,
        ),
      ],
    );

    test('toJson/fromJson round-trips enabled sections and reactions', () {
      final cubit = UiPreferencesCubit()
        ..setSection(HomeSection.trending, enabled: false)
        ..setShowLessonReactions(value: false);
      final json = cubit.toJson(cubit.state);
      expect(json, isNotNull);
      expect(cubit.fromJson(json), equals(cubit.state));
    });
  });
}
