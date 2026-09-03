import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:local_notifications_repository/local_notifications_repository.dart';
import 'package:mocktail/mocktail.dart';
import 'package:rtu_mirea_app/config/config.dart';
import 'package:rtu_mirea_app/schedule/cubit/cubit.dart';
import 'package:rtu_mirea_app/schedule/view/custom_lesson_editor_view.dart';
import 'package:schedule_repository/schedule_repository.dart';

import '../../helpers/pump_app.dart';

class _MockCustomScheduleCubit extends Mock implements CustomScheduleCubit {}

class _FakeLessonSchedulePart extends Fake implements LessonSchedulePart {}

class _Notifications extends Mock implements LocalNotificationsRepository {}

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

  testWidgets('tapping a color swatch updates the editor color', (
    tester,
  ) async {
    await tester.pumpApp(buildSubject());
    final target = UniversityConfig.defaultLessonColorValues[1];
    await tester.scrollUntilVisible(
      find.byKey(ValueKey('app-color-swatch-$target')),
      200,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.tap(find.byKey(ValueKey('app-color-swatch-$target')));
    await tester.pump();
    expect(editor.state.color, target);
    expect(tester.takeException(), isNull);
  });

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
    final semantics = tester.ensureSemantics();
    try {
      await tester.pumpApp(buildSubject());
      await tester.tap(find.bySemanticsLabel('Сохранить'));
      await tester.pump();
      expect(find.text('Новая пара'), findsOneWidget);
      verifyNever(() => schedules.addLesson(any(), any()));
      await tester.pump(const Duration(seconds: 4));
    } finally {
      semantics.dispose();
    }
  });

  testWidgets('does not close when persistence target is missing', (
    tester,
  ) async {
    when(
      () => schedules.addLesson(any(), any()),
    ).thenReturn(.scheduleNotFound);
    final semantics = tester.ensureSemantics();
    try {
      await tester.pumpApp(buildSubject());
      await tester.enterText(find.byType(TextField).first, 'Math');
      await tester.tap(find.bySemanticsLabel('Сохранить'));
      await tester.pump();
      expect(find.text('Новая пара'), findsOneWidget);
      verify(() => schedules.addLesson('schedule-id', any())).called(1);
      await tester.pump(const Duration(seconds: 4));
    } finally {
      semantics.dispose();
    }
  });

  testWidgets('denied reminder permission preserves the form without saving', (
    tester,
  ) async {
    final notifications = _Notifications();
    when(notifications.ensurePermission).thenAnswer((_) async => false);
    editor
      ..subjectChanged('Math')
      ..reminderEnabledChanged(enabled: true);
    final semantics = tester.ensureSemantics();
    try {
      await tester.pumpApp(
        RepositoryProvider<LocalNotificationsRepository>.value(
          value: notifications,
          child: buildSubject(),
        ),
      );
      await tester.tap(find.bySemanticsLabel('Сохранить'));
      await tester.pumpAndSettle();
      expect(find.text('Новая пара'), findsOneWidget);
      expect(editor.state.reminderMinutes, isNotNull);
      verifyNever(() => schedules.addLesson(any(), any()));
      await tester.pump(const Duration(seconds: 4));
    } finally {
      semantics.dispose();
    }
  });
}
