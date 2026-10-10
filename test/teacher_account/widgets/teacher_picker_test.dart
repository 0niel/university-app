import 'dart:async';

import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:rtu_mirea_app/l10n/l10n.dart';
import 'package:rtu_mirea_app/teacher_account/bloc/teacher_picker_bloc.dart';
import 'package:rtu_mirea_app/teacher_account/widgets/teacher_picker.dart';
import 'package:schedule_repository/schedule_repository.dart';

class _ScheduleRepository extends Mock implements ScheduleRepository {}

Widget _subject(
  ScheduleRepository repository, {
  required ValueChanged<Teacher> onSelected,
  Teacher? selected,
  bool enabled = true,
  double textScale = 1,
}) => RepositoryProvider<ScheduleRepository>.value(
  value: repository,
  child: MaterialApp(
    theme: AppTheme.lightTheme,
    locale: const Locale('ru'),
    localizationsDelegates: AppLocalizations.localizationsDelegates,
    supportedLocales: AppLocalizations.supportedLocales,
    builder: (context, child) => MediaQuery(
      data: MediaQuery.of(context).copyWith(
        textScaler: TextScaler.linear(textScale),
      ),
      child: child!,
    ),
    home: Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: TeacherPicker(
          selected: selected,
          enabled: enabled,
          onSelected: onSelected,
        ),
      ),
    ),
  ),
);

void main() {
  testWidgets('catalog distinguishes identical names and requires a tap', (
    tester,
  ) async {
    final repository = _ScheduleRepository();
    const first = Teacher(name: 'Иванов Иван Иванович', uid: 'teacher-a');
    const second = Teacher(name: 'Иванов Иван Иванович', uid: 'teacher-b');
    when(repository.searchTeachers).thenAnswer(
      (_) async => const SearchTeachersResponse(results: [first, second]),
    );
    Teacher? selected;
    await tester.pumpWidget(
      _subject(repository, onSelected: (teacher) => selected = teacher),
    );
    await tester.pumpAndSettle();
    expect(selected, isNull);
    final l10n = tester.element(find.byType(TeacherPicker)).l10n;
    expect(find.text(l10n.teacherPickerIdentity('teacher-a')), findsOneWidget);
    expect(find.text(l10n.teacherPickerIdentity('teacher-b')), findsOneWidget);
    await tester.tap(find.byKey(const ValueKey('teacher-picker-id:teacher-b')));
    await tester.pumpAndSettle();
    expect(selected, second);
    expect(find.text(l10n.teacherPickerSelectionLabel), findsOneWidget);
    expect(
      find.byKey(const ValueKey('teacher-picker-id:teacher-b')),
      findsNothing,
    );
    expect(
      find.byKey(const ValueKey('teacher-picker-id:teacher-a')),
      findsOneWidget,
    );
    expect(
      tester
          .widget<Semantics>(
            find.byKey(const ValueKey('teacher-picker-selection')),
          )
          .properties
          .label,
      l10n.teacherPickerSelected(second.name),
    );
    expect(tester.takeException(), isNull);
  });

  testWidgets('typing a matching name does not select its catalog record', (
    tester,
  ) async {
    final repository = _ScheduleRepository();
    const teacher = Teacher(name: 'Иванов', uid: 'teacher');
    when(
      () => repository.searchTeachers(query: any(named: 'query')),
    ).thenAnswer(
      (_) async => const SearchTeachersResponse(results: [teacher]),
    );
    Teacher? selected;
    await tester.pumpWidget(
      _subject(repository, onSelected: (value) => selected = value),
    );
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextField), teacher.name);
    await tester.pump(const Duration(milliseconds: 400));
    await tester.pumpAndSettle();
    expect(selected, isNull);
    expect(
      find.byKey(const ValueKey('teacher-picker-selection')),
      findsNothing,
    );
    verify(() => repository.searchTeachers(query: teacher.name)).called(1);
    final field = tester.widget<TextField>(find.byType(TextField));
    expect(field.autofillHints, isNull);
    expect(field.textInputAction, TextInputAction.search);
  });

  testWidgets('editing search visibly retains the confirmed selection', (
    tester,
  ) async {
    final repository = _ScheduleRepository();
    const teacher = Teacher(name: 'Иванов', uid: 'ivanov');
    when(
      () => repository.searchTeachers(query: any(named: 'query')),
    ).thenAnswer(
      (_) async => const SearchTeachersResponse(
        results: [Teacher(name: 'Петров', uid: 'petrov')],
      ),
    );
    Teacher? changed;
    await tester.pumpWidget(
      _subject(
        repository,
        selected: teacher,
        onSelected: (value) => changed = value,
      ),
    );
    await tester.pumpAndSettle();
    final l10n = tester.element(find.byType(TeacherPicker)).l10n;
    await tester.enterText(find.byType(TextField), 'Петров');
    await tester.pump(const Duration(milliseconds: 400));
    await tester.pumpAndSettle();
    expect(changed, isNull);
    expect(find.text(l10n.teacherPickerSelectionLabel), findsOneWidget);
    expect(find.text(teacher.name), findsOneWidget);
    await tester.tap(find.byKey(const ValueKey('teacher-picker-id:petrov')));
    await tester.pumpAndSettle();
    expect(changed?.uid, 'petrov');
    expect(find.text(l10n.teacherPickerSelectionLabel), findsOneWidget);
    expect(
      find.descendant(
        of: find.byKey(const ValueKey('teacher-picker-selection')),
        matching: find.text('Петров'),
      ),
      findsOneWidget,
    );
  });

  testWidgets('catalog entries without external ids cannot be linked', (
    tester,
  ) async {
    final repository = _ScheduleRepository();
    when(repository.searchTeachers).thenAnswer(
      (_) async => const SearchTeachersResponse(
        results: [
          Teacher(name: 'Legacy'),
          Teacher(name: 'Blank', uid: ' '),
        ],
      ),
    );
    Teacher? selected;
    await tester.pumpWidget(
      _subject(repository, onSelected: (value) => selected = value),
    );
    await tester.pumpAndSettle();
    final l10n = tester.element(find.byType(TeacherPicker)).l10n;
    expect(find.text(l10n.teacherPickerUnavailable), findsNWidgets(2));
    await tester.tap(find.byKey(const ValueKey('teacher-picker-name:legacy')));
    await tester.tap(find.byKey(const ValueKey('teacher-picker-name:blank')));
    await tester.pumpAndSettle();
    expect(selected, isNull);
  });

  testWidgets('confirmed duplicate-name identity stays visible during search', (
    tester,
  ) async {
    final repository = _ScheduleRepository();
    const first = Teacher(name: 'Иванов', uid: 'first');
    const second = Teacher(name: 'Иванов', uid: 'second');
    when(() => repository.searchTeachers(query: first.name)).thenAnswer(
      (_) async => const SearchTeachersResponse(results: [first, second]),
    );
    when(() => repository.searchTeachers(query: 'Другой')).thenAnswer(
      (_) async => const SearchTeachersResponse(results: []),
    );
    await tester.pumpWidget(
      _subject(repository, selected: second, onSelected: (_) {}),
    );
    await tester.pumpAndSettle();
    final firstRow = tester.widget<AppPressable>(
      find.byKey(const ValueKey('teacher-picker-id:first')),
    );
    expect(firstRow.semanticsSelected, isFalse);
    expect(
      find.byKey(const ValueKey('teacher-picker-id:second')),
      findsNothing,
    );
    await tester.enterText(find.byType(TextField), 'Другой');
    await tester.pump(const Duration(milliseconds: 400));
    await tester.pumpAndSettle();
    final l10n = tester.element(find.byType(TeacherPicker)).l10n;
    expect(find.text(l10n.teacherPickerIdentity(second.uid!)), findsOneWidget);
    expect(find.text(l10n.teacherPickerSelectionLabel), findsOneWidget);
    expect(find.text(second.name), findsOneWidget);
  });

  testWidgets('legacy name without an id is not shown as a confirmed link', (
    tester,
  ) async {
    final repository = _ScheduleRepository();
    when(() => repository.searchTeachers(query: 'Legacy')).thenAnswer(
      (_) async =>
          const SearchTeachersResponse(results: [Teacher(name: 'Legacy')]),
    );
    await tester.pumpWidget(
      _subject(
        repository,
        selected: const Teacher(name: 'Legacy'),
        onSelected: (_) {},
      ),
    );
    await tester.pumpAndSettle();
    expect(
      find.byKey(const ValueKey('teacher-picker-selection')),
      findsNothing,
    );
    final l10n = tester.element(find.byType(TeacherPicker)).l10n;
    expect(find.text(l10n.teacherPickerUnavailable), findsOneWidget);
  });

  testWidgets('debounces queries and discards a late previous response', (
    tester,
  ) async {
    final repository = _ScheduleRepository();
    when(repository.searchTeachers).thenAnswer(
      (_) async => const SearchTeachersResponse(results: []),
    );
    final old = Completer<SearchTeachersResponse>();
    when(
      () => repository.searchTeachers(query: 'Ив'),
    ).thenAnswer((_) => old.future);
    when(() => repository.searchTeachers(query: 'Петров')).thenAnswer(
      (_) async => const SearchTeachersResponse(
        results: [Teacher(name: 'Петров', uid: 'petrov')],
      ),
    );
    await tester.pumpWidget(_subject(repository, onSelected: (_) {}));
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextField), 'И');
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 100));
    await tester.enterText(find.byType(TextField), 'Ив');
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 400));
    verifyNever(() => repository.searchTeachers(query: 'И'));
    verify(() => repository.searchTeachers(query: 'Ив')).called(1);
    await tester.enterText(find.byType(TextField), 'Петров');
    await tester.runAsync(() => Future<void>.delayed(Duration.zero));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 400));
    final bloc = tester
        .widget<BlocBuilder<TeacherPickerBloc, TeacherPickerState>>(
          find.byType(BlocBuilder<TeacherPickerBloc, TeacherPickerState>),
        )
        .bloc!;
    expect(bloc.state.query, 'Петров');
    verify(() => repository.searchTeachers(query: 'Петров')).called(1);
    await tester.pumpAndSettle();
    expect(old.isCompleted, isFalse);
    expect(
      find.byKey(const ValueKey('teacher-picker-id:petrov')),
      findsOneWidget,
    );
    old.complete(
      const SearchTeachersResponse(
        results: [Teacher(name: 'Иванов', uid: 'old')],
      ),
    );
    await tester.pumpAndSettle();
    expect(find.byKey(const ValueKey('teacher-picker-id:old')), findsNothing);
    expect(
      find.byKey(const ValueKey('teacher-picker-id:petrov')),
      findsOneWidget,
    );
  });

  testWidgets('failed catalog retries without losing the selected teacher', (
    tester,
  ) async {
    final repository = _ScheduleRepository();
    const teacher = Teacher(name: 'Teacher', uid: 'teacher');
    var attempts = 0;
    when(() => repository.searchTeachers(query: teacher.name)).thenAnswer((
      _,
    ) async {
      if (attempts++ == 0) throw Exception('offline');
      return const SearchTeachersResponse(results: [teacher]);
    });
    await tester.pumpWidget(
      _subject(repository, selected: teacher, onSelected: (_) {}),
    );
    await tester.pumpAndSettle();
    final l10n = tester.element(find.byType(TeacherPicker)).l10n;
    expect(find.byKey(const ValueKey('teacher-picker-error')), findsOneWidget);
    expect(find.text(l10n.teacherPickerSelectionLabel), findsOneWidget);
    await tester.tap(find.text(l10n.retry));
    await tester.pumpAndSettle();
    expect(find.byKey(const ValueKey('teacher-picker-error')), findsNothing);
    expect(
      find.byKey(const ValueKey('teacher-picker-id:teacher')),
      findsNothing,
    );
    expect(attempts, 2);
  });

  testWidgets(
    'confirmed unique teacher is not repeated or exposed as a raw id',
    (
      tester,
    ) async {
      final repository = _ScheduleRepository();
      const teacher = Teacher(name: 'Unique Teacher', uid: 'teacher-unique');
      when(() => repository.searchTeachers(query: teacher.name)).thenAnswer(
        (_) async => const SearchTeachersResponse(results: [teacher]),
      );
      await tester.pumpWidget(
        _subject(repository, selected: teacher, onSelected: (_) {}),
      );
      await tester.pumpAndSettle();
      final l10n = tester.element(find.byType(TeacherPicker)).l10n;
      expect(
        find.descendant(
          of: find.byKey(const ValueKey('teacher-picker-selection')),
          matching: find.text(teacher.name),
        ),
        findsOneWidget,
      );
      expect(find.text(l10n.teacherPickerIdentity(teacher.uid!)), findsNothing);
      expect(
        find.byKey(const ValueKey('teacher-picker-results')),
        findsNothing,
      );
      expect(find.text(l10n.teacherPickerEmpty), findsNothing);
      expect(find.text(l10n.teacherPickerCatalogEmpty), findsNothing);
    },
  );

  testWidgets('empty catalog offers an honest recoverable state', (
    tester,
  ) async {
    final repository = _ScheduleRepository();
    when(
      () => repository.searchTeachers(query: any(named: 'query')),
    ).thenAnswer(
      (_) async => const SearchTeachersResponse(results: []),
    );
    await tester.pumpWidget(_subject(repository, onSelected: (_) {}));
    await tester.pumpAndSettle();
    final l10n = tester.element(find.byType(TeacherPicker)).l10n;
    expect(find.text(l10n.teacherPickerCatalogEmpty), findsOneWidget);
    expect(find.text(l10n.teacherPickerCatalogEmptyHint), findsOneWidget);
    expect(find.text(l10n.teacherPickerHint), findsNothing);
    await tester.tap(find.text(l10n.retry));
    await tester.pumpAndSettle();
    verify(repository.searchTeachers).called(2);
    expect(find.byType(TextField), findsOneWidget);
  });

  testWidgets(
    'empty typed search suggests spelling without claiming an empty catalog',
    (
      tester,
    ) async {
      final repository = _ScheduleRepository();
      when(
        () => repository.searchTeachers(query: any(named: 'query')),
      ).thenAnswer(
        (_) async => const SearchTeachersResponse(results: []),
      );
      await tester.pumpWidget(_subject(repository, onSelected: (_) {}));
      await tester.pumpAndSettle();
      await tester.enterText(find.byType(TextField), 'Иванов');
      await tester.pump(const Duration(milliseconds: 400));
      await tester.pumpAndSettle();
      final l10n = tester.element(find.byType(TeacherPicker)).l10n;
      expect(find.text(l10n.teacherPickerEmpty), findsOneWidget);
      expect(find.text(l10n.teacherPickerEmptyHint), findsOneWidget);
      expect(find.text(l10n.teacherPickerCatalogEmpty), findsNothing);
    },
  );

  testWidgets('disabled picker cannot change the linked teacher', (
    tester,
  ) async {
    final repository = _ScheduleRepository();
    when(repository.searchTeachers).thenAnswer(
      (_) async => const SearchTeachersResponse(
        results: [Teacher(name: 'Teacher', uid: 'teacher')],
      ),
    );
    Teacher? selected;
    await tester.pumpWidget(
      _subject(
        repository,
        enabled: false,
        onSelected: (teacher) => selected = teacher,
      ),
    );
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const ValueKey('teacher-picker-id:teacher')));
    await tester.pumpAndSettle();
    expect(selected, isNull);
    expect(tester.widget<TextField>(find.byType(TextField)).enabled, isFalse);
  });

  testWidgets('disposed picker ignores a pending request', (tester) async {
    final repository = _ScheduleRepository();
    final response = Completer<SearchTeachersResponse>();
    when(
      repository.searchTeachers,
    ).thenAnswer((_) => response.future);
    await tester.pumpWidget(_subject(repository, onSelected: (_) {}));
    await tester.pump();
    await tester.pumpWidget(const SizedBox.shrink());
    response.complete(const SearchTeachersResponse(results: []));
    await tester.pump();
    expect(tester.takeException(), isNull);
  });

  testWidgets('long catalog rows fit narrow layouts with large text', (
    tester,
  ) async {
    final repository = _ScheduleRepository();
    when(repository.searchTeachers).thenAnswer(
      (_) async => const SearchTeachersResponse(
        results: [
          Teacher(name: 'Александровский Александр Александрович', uid: 'one'),
          Teacher(name: 'Александровский Александр Александрович', uid: 'two'),
        ],
      ),
    );
    tester.view
      ..physicalSize = const Size(320, 780)
      ..devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    await tester.pumpWidget(
      _subject(repository, textScale: 2, onSelected: (_) {}),
    );
    await tester.pumpAndSettle();
    expect(
      find.byKey(const ValueKey('teacher-picker-results')),
      findsOneWidget,
    );
    expect(tester.takeException(), isNull);
  });

  testWidgets(
    'keyboard keeps narrow large-text results bounded and selectable',
    (
      tester,
    ) async {
      final repository = _ScheduleRepository();
      when(repository.searchTeachers).thenAnswer(
        (_) async => const SearchTeachersResponse(
          results: [
            Teacher(
              name: 'Александровский Александр Александрович',
              uid: 'one',
            ),
            Teacher(
              name: 'Александровский Александр Александрович',
              uid: 'two',
            ),
          ],
        ),
      );
      tester.view
        ..physicalSize = const Size(320, 780)
        ..devicePixelRatio = 1
        ..viewInsets = const FakeViewPadding(bottom: 300);
      addTearDown(tester.view.reset);
      Teacher? selected;
      await tester.pumpWidget(
        _subject(
          repository,
          textScale: 1.6,
          onSelected: (teacher) => selected = teacher,
        ),
      );
      await tester.pumpAndSettle();
      expect(
        tester
            .getSize(find.byKey(const ValueKey('teacher-picker-results')))
            .height,
        lessThanOrEqualTo(240),
      );
      await tester.tap(find.byType(TextField));
      await tester.pump();
      final focus = tester
          .widget<EditableText>(find.byType(EditableText))
          .focusNode;
      expect(focus.hasFocus, isTrue);
      await tester.tap(find.byKey(const ValueKey('teacher-picker-id:one')));
      await tester.pumpAndSettle();
      expect(selected?.uid, 'one');
      expect(focus.hasFocus, isFalse);
      expect(tester.takeException(), isNull);
    },
  );
}
