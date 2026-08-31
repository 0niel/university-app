import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:rtu_mirea_app/config/config.dart';
import 'package:rtu_mirea_app/schedule/cubit/cubit.dart';
import 'package:rtu_mirea_app/schedule/view/custom_lesson_editor_view.dart';
import 'package:schedule_repository/schedule_repository.dart';

import '../../helpers/pump_app.dart';

class _MockCustomScheduleCubit extends Mock implements CustomScheduleCubit {}

class _FakeLessonSchedulePart extends Fake implements LessonSchedulePart {}

void main() {
  late CustomScheduleCubit schedules;
  late CustomLessonEditorCubit editor;

  setUpAll(() => registerFallbackValue(_FakeLessonSchedulePart()));

  setUp(() {
    schedules = _MockCustomScheduleCubit();
    editor = CustomLessonEditorCubit(
      customScheduleCubit: schedules,
      scheduleId: 'schedule-id',
      bellSlots: UniversityConfig.defaultLessonBellSlots,
      colors: UniversityConfig.defaultLessonColorValues,
      reminderLeadMinutes: UniversityConfig.defaultLessonReminderLeadMinutes,
      weekday: DateTime.monday,
      now: () => DateTime(2026, 7, 6),
    );
  });

  tearDown(() => editor.close());

  Widget buildSubject() => BlocProvider.value(
    value: editor,
    child: const CustomLessonEditorView(
      isEditing: false,
      bellSlots: UniversityConfig.defaultLessonBellSlots,
      colors: UniversityConfig.defaultLessonColorValues,
      reminderLeadMinutes: UniversityConfig.defaultLessonReminderLeadMinutes,
    ),
  );

  testWidgets('fits a 320 px viewport at 200 percent text scale', (
    tester,
  ) async {
    await tester.pumpApp(
      buildSubject(),
      size: const Size(320, 800),
      textScaler: const TextScaler.linear(2),
    );

    expect(tester.takeException(), isNull);
    expect(find.text('Новая пара'), findsOneWidget);
  });

  testWidgets('does not close or mutate when validation fails', (tester) async {
    await tester.pumpApp(buildSubject());

    await tester.tap(find.byTooltip('Сохранить'));
    await tester.pump();

    expect(find.text('Новая пара'), findsOneWidget);
    verifyNever(() => schedules.addLesson(any(), any()));
    await tester.pump(const Duration(seconds: 4));
  });

  testWidgets('does not close when persistence target is missing', (
    tester,
  ) async {
    when(
      () => schedules.addLesson(any(), any()),
    ).thenReturn(.scheduleNotFound);
    await tester.pumpApp(buildSubject());
    await tester.enterText(find.byType(TextField), 'Math');

    await tester.tap(find.byTooltip('Сохранить'));
    await tester.pump();

    expect(find.text('Новая пара'), findsOneWidget);
    verify(() => schedules.addLesson('schedule-id', any())).called(1);
    await tester.pump(const Duration(seconds: 4));
  });
}
