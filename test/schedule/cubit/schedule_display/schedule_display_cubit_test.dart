import 'package:flutter_test/flutter_test.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:mocktail/mocktail.dart';
import 'package:rtu_mirea_app/schedule/cubit/schedule_display/schedule_display_cubit.dart';

class _MockStorage extends Mock implements Storage {}

void main() {
  setUp(() {
    final storage = _MockStorage();
    when(() => storage.read(any())).thenReturn(null);
    when(() => storage.write(any(), any<dynamic>())).thenAnswer((_) async {});
    when(() => storage.delete(any())).thenAnswer((_) async {});
    HydratedBloc.storage = storage;
  });

  group('ScheduleDisplayCubit', () {
    test('markLessonActionsHintShown flips the flag once', () {
      final cubit = ScheduleDisplayCubit();
      addTearDown(cubit.close);
      expect(cubit.state.lessonActionsHintShown, isFalse);
      cubit.markLessonActionsHintShown();
      expect(cubit.state.lessonActionsHintShown, isTrue);
      cubit.markLessonActionsHintShown();
      expect(cubit.state.lessonActionsHintShown, isTrue);
    });

    test('display toggles stay independent from the hint flag', () {
      final cubit = ScheduleDisplayCubit();
      addTearDown(cubit.close);
      cubit
        ..setShowPast(value: false)
        ..markLessonActionsHintShown();
      expect(cubit.state.showPast, isFalse);
      expect(cubit.state.showCancelled, isTrue);
      expect(cubit.state.lessonActionsHintShown, isTrue);
    });
  });

  group('ScheduleDisplayState', () {
    test('round-trips through JSON including the hint flag', () {
      const state = ScheduleDisplayState(
        showPast: false,
        showCancelled: false,
        lessonActionsHintShown: true,
      );
      final restored = ScheduleDisplayState.fromJson(state.toJson());
      expect(restored, state);
    });

    test('missing keys fall back to the documented defaults', () {
      final restored = ScheduleDisplayState.fromJson(const {});
      expect(restored, const ScheduleDisplayState());
      expect(restored.lessonActionsHintShown, isFalse);
    });
  });
}
