import 'dart:async';

import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:rtu_mirea_app/l10n/l10n.dart';
import 'package:rtu_mirea_app/teacher_account/bloc/teacher_picker_bloc.dart';
import 'package:rtu_mirea_app/teacher_account/widgets/picker/teacher_picker_selection.dart';
import 'package:rtu_mirea_app/teacher_account/widgets/teacher_picker.dart';
import 'package:schedule_repository/schedule_repository.dart';

class _ScheduleRepository extends Mock implements ScheduleRepository {}

const _first = Teacher(name: 'Иванов Иван Иванович', uid: 'first');
const _namesake = Teacher(name: 'Иванов Иван Иванович', uid: 'namesake');
const _other = Teacher(name: 'Петров Пётр Петрович', uid: 'other');

void main() {
  late _ScheduleRepository repository;

  setUp(() {
    repository = _ScheduleRepository();
    when(
      () => repository.searchTeachers(query: any(named: 'query')),
    ).thenAnswer((_) async => const SearchTeachersResponse(results: []));
  });

  TeacherPickerBloc subject({
    Teacher? selected,
    Duration debounce = const Duration(milliseconds: 350),
  }) {
    final bloc = TeacherPickerBloc(
      scheduleRepository: repository,
      selected: selected,
      debounce: debounce,
    );
    addTearDown(() => bloc.isClosed ? null : bloc.close());
    return bloc;
  }

  testWidgets('initial selection requires a canonical external id', (
    tester,
  ) async {
    final linked = subject(selected: _first);
    final legacy = subject(selected: const Teacher(name: 'Legacy'));
    final blank = subject(
      selected: const Teacher(name: 'Blank', uid: ' '),
    );
    expect(linked.state.selected, _first);
    expect(linked.state.query, _first.name);
    expect(linked.state.results.isLoading, isTrue);
    expect(legacy.state.selected, isNull);
    expect(legacy.state.query, 'Legacy');
    expect(blank.state.selected, isNull);
  });

  testWidgets('catalog deduplicates external ids without merging namesakes', (
    tester,
  ) async {
    when(() => repository.searchTeachers()).thenAnswer(
      (_) async => const SearchTeachersResponse(
        results: [
          _first,
          _first,
          _namesake,
          Teacher(name: '', uid: 'empty'),
          Teacher(name: 'Legacy'),
        ],
      ),
    );
    final bloc = subject()
      ..add(
        const TeacherPickerEvent.searchRequested(query: '', immediate: true),
      );
    await tester.pump();
    expect(bloc.state.teachers, const [
      _first,
      _namesake,
      Teacher(name: 'Legacy'),
    ]);
    expect(bloc.state.selected, isNull);
    expect(bloc.state.isAmbiguous(_first), isTrue);
    expect(bloc.state.isAmbiguous(_namesake), isTrue);
  });

  testWidgets('query edits retain the pinned selection and trim the query', (
    tester,
  ) async {
    final bloc = subject(selected: _first)
      ..add(const TeacherPickerEvent.searchRequested(query: '  Петров  '));
    await tester.pump();
    expect(bloc.state.query, 'Петров');
    expect(bloc.state.selected, _first);
    expect(bloc.state.results.isLoading, isTrue);
    verifyNever(() => repository.searchTeachers(query: 'Петров'));
    await tester.pump(const Duration(milliseconds: 350));
    verify(() => repository.searchTeachers(query: 'Петров')).called(1);
    expect(bloc.state.selected, _first);
  });

  testWidgets(
    'rapid edits debounce repository calls inside restartable handler',
    (
      tester,
    ) async {
      final bloc = subject()
        ..add(const TeacherPickerEvent.searchRequested(query: 'И'));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));
      bloc.add(const TeacherPickerEvent.searchRequested(query: 'Ив'));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 349));
      verifyNever(() => repository.searchTeachers(query: any(named: 'query')));
      await tester.pump(const Duration(milliseconds: 1));
      verify(() => repository.searchTeachers(query: 'Ив')).called(1);
      verifyNever(() => repository.searchTeachers(query: 'И'));
    },
  );

  test(
    'a new request finishes while the previous RPC is still pending',
    () async {
      final previous = Completer<SearchTeachersResponse>();
      final previousStarted = Completer<void>();
      when(() => repository.searchTeachers(query: 'Ив')).thenAnswer((_) {
        previousStarted.complete();
        return previous.future;
      });
      when(() => repository.searchTeachers(query: 'Петров')).thenAnswer(
        (_) async => const SearchTeachersResponse(results: [_other]),
      );
      final bloc = subject(debounce: const Duration(milliseconds: 10));
      final initialReady = bloc.stream.firstWhere(
        (state) => !state.results.isLoading,
      );
      bloc.add(
        const TeacherPickerEvent.searchRequested(query: '', immediate: true),
      );
      await initialReady;
      bloc.add(const TeacherPickerEvent.searchRequested(query: 'И'));
      await Future<void>.delayed(Duration.zero);
      bloc.add(const TeacherPickerEvent.searchRequested(query: 'Ив'));
      await previousStarted.future.timeout(const Duration(seconds: 1));
      final nextReady = bloc.stream.firstWhere(
        (state) => state.query == 'Петров' && !state.results.isLoading,
      );
      bloc.add(const TeacherPickerEvent.searchRequested(query: 'Петров'));
      await nextReady.timeout(const Duration(seconds: 1));
      expect(previous.isCompleted, isFalse);
      expect(bloc.state.query, 'Петров');
      expect(bloc.state.teachers, const [_other]);
      verifyNever(() => repository.searchTeachers(query: 'И'));
      verify(() => repository.searchTeachers(query: 'Ив')).called(1);
      verify(() => repository.searchTeachers(query: 'Петров')).called(1);
      previous.complete(const SearchTeachersResponse(results: [_first]));
      await Future<void>.delayed(Duration.zero);
      expect(bloc.state.query, 'Петров');
      expect(bloc.state.teachers, const [_other]);
    },
  );

  testWidgets(
    'new query invalidates the previous response before debounce ends',
    (
      tester,
    ) async {
      final previous = Completer<SearchTeachersResponse>();
      when(
        () => repository.searchTeachers(query: 'Иванов'),
      ).thenAnswer((_) => previous.future);
      when(() => repository.searchTeachers(query: 'Петров')).thenAnswer(
        (_) async => const SearchTeachersResponse(results: [_other]),
      );
      final bloc = subject(selected: _first)
        ..add(
          const TeacherPickerEvent.searchRequested(
            query: 'Иванов',
            immediate: true,
          ),
        );
      await tester.pump();
      bloc.add(const TeacherPickerEvent.searchRequested(query: 'Петров'));
      await tester.pump();
      previous.complete(const SearchTeachersResponse(results: [_namesake]));
      await tester.pump();
      expect(bloc.state.query, 'Петров');
      expect(bloc.state.results.isLoading, isTrue);
      expect(bloc.state.teachers, isEmpty);
      expect(bloc.state.ambiguousNames, isEmpty);
      expect(bloc.state.selected, _first);
      verifyNever(() => repository.searchTeachers(query: 'Петров'));
      await tester.pump(const Duration(milliseconds: 350));
      expect(bloc.state.teachers, const [_other]);
      expect(bloc.state.ambiguousNames, isEmpty);
    },
  );

  testWidgets('late previous failure cannot replace the latest results', (
    tester,
  ) async {
    final previous = Completer<SearchTeachersResponse>();
    when(
      () => repository.searchTeachers(query: 'Иванов'),
    ).thenAnswer((_) => previous.future);
    when(() => repository.searchTeachers(query: 'Петров')).thenAnswer(
      (_) async => const SearchTeachersResponse(results: [_other]),
    );
    final bloc = subject()
      ..add(
        const TeacherPickerEvent.searchRequested(
          query: 'Иванов',
          immediate: true,
        ),
      );
    await tester.pump();
    bloc.add(
      const TeacherPickerEvent.searchRequested(
        query: 'Петров',
        immediate: true,
      ),
    );
    await tester.pump();
    previous.completeError(Exception('offline'));
    await tester.pump();
    expect(bloc.state.teachers, const [_other]);
    expect(bloc.state.results.hasError, isFalse);
    expect(bloc.state.query, 'Петров');
  });

  testWidgets('explicit choice hides its record and retains other namesakes', (
    tester,
  ) async {
    when(() => repository.searchTeachers()).thenAnswer(
      (_) async => const SearchTeachersResponse(results: [_first, _namesake]),
    );
    final bloc = subject()
      ..add(
        const TeacherPickerEvent.searchRequested(query: '', immediate: true),
      );
    await tester.pump();
    expect(bloc.state.selected, isNull);
    bloc.add(const TeacherPickerEvent.teacherSelected(_first));
    await tester.pump();
    expect(bloc.state.selected, _first);
    expect(bloc.state.visibleTeachers, const [_namesake]);
    bloc.add(
      const TeacherPickerEvent.searchRequested(query: 'Other', immediate: true),
    );
    await tester.pump();
    expect(bloc.state.selected, _first);
    expect(bloc.state.isAmbiguous(_first), isTrue);
  });

  testWidgets(
    'selected namesake counts when its record is absent from results',
    (
      tester,
    ) async {
      when(() => repository.searchTeachers()).thenAnswer(
        (_) async => const SearchTeachersResponse(results: [_namesake]),
      );
      final bloc = subject(selected: _first)
        ..add(
          const TeacherPickerEvent.searchRequested(query: '', immediate: true),
        );
      await tester.pump();
      expect(bloc.state.visibleTeachers, const [_namesake]);
      expect(bloc.state.isAmbiguous(_first), isTrue);
      expect(bloc.state.isAmbiguous(_namesake), isTrue);
    },
  );

  testWidgets('prop selection changes survive a pending catalog response', (
    tester,
  ) async {
    final response = Completer<SearchTeachersResponse>();
    when(
      () => repository.searchTeachers(),
    ).thenAnswer((_) => response.future);
    final bloc = subject(selected: _other)
      ..add(
        const TeacherPickerEvent.searchRequested(query: '', immediate: true),
      );
    await tester.pump();
    bloc.add(const TeacherPickerEvent.selectionChanged(_first));
    await tester.pump();
    response.complete(
      const SearchTeachersResponse(results: [_first, _namesake]),
    );
    await tester.pump();
    expect(bloc.state.selected, _first);
    expect(bloc.state.visibleTeachers, const [_namesake]);
    expect(bloc.state.isAmbiguous(_first), isTrue);
    bloc.add(const TeacherPickerEvent.selectionChanged(null));
    await tester.pump();
    expect(bloc.state.selected, isNull);
    expect(bloc.state.visibleTeachers, const [_first, _namesake]);
  });

  testWidgets('records without ids cannot replace a valid pinned selection', (
    tester,
  ) async {
    final bloc = subject(selected: _first)
      ..add(const TeacherPickerEvent.teacherSelected(Teacher(name: 'Legacy')))
      ..add(
        const TeacherPickerEvent.teacherSelected(
          Teacher(name: 'Blank', uid: ' '),
        ),
      );
    await tester.pump();
    expect(bloc.state.selected, _first);
    bloc.add(
      const TeacherPickerEvent.selectionChanged(Teacher(name: 'Legacy')),
    );
    await tester.pump();
    expect(bloc.state.selected, isNull);
  });

  testWidgets(
    'immediate retry cancels a pending debounce without duplicate calls',
    (
      tester,
    ) async {
      final bloc = subject()
        ..add(const TeacherPickerEvent.searchRequested(query: 'Петров'));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));
      bloc.add(
        const TeacherPickerEvent.searchRequested(
          query: 'Петров',
          immediate: true,
        ),
      );
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 350));
      verify(() => repository.searchTeachers(query: 'Петров')).called(1);
      expect(bloc.state.results.isLoading, isFalse);
    },
  );

  testWidgets('failure and retry preserve the confirmed selection', (
    tester,
  ) async {
    var attempts = 0;
    when(() => repository.searchTeachers(query: _first.name)).thenAnswer((
      _,
    ) async {
      if (attempts++ == 0) throw Exception('offline');
      return const SearchTeachersResponse(results: [_first]);
    });
    final bloc = subject(selected: _first)
      ..add(
        TeacherPickerEvent.searchRequested(query: _first.name, immediate: true),
      );
    await tester.pump();
    expect(bloc.state.results.hasError, isTrue);
    expect(bloc.state.selected, _first);
    bloc.add(
      TeacherPickerEvent.searchRequested(query: _first.name, immediate: true),
    );
    await tester.pump();
    expect(bloc.state.results.hasError, isFalse);
    expect(bloc.state.selected, _first);
    expect(bloc.state.visibleTeachers, isEmpty);
    expect(attempts, 2);
  });

  test('closing invalidates an in-flight response', () async {
    final response = Completer<SearchTeachersResponse>();
    when(
      () => repository.searchTeachers(),
    ).thenAnswer((_) => response.future);
    final bloc = subject();
    final states = <TeacherPickerState>[];
    final subscription = bloc.stream.listen(states.add);
    addTearDown(subscription.cancel);
    bloc.add(
      const TeacherPickerEvent.searchRequested(query: '', immediate: true),
    );
    await Future<void>.delayed(Duration.zero);
    await bloc.close();
    final count = states.length;
    response.complete(const SearchTeachersResponse(results: [_first]));
    await Future<void>.delayed(Duration.zero);
    expect(bloc.isClosed, isTrue);
    expect(states, hasLength(count));
    expect(bloc.state.teachers, isEmpty);
  });

  test('closing before debounce prevents a repository request', () async {
    final bloc = subject()
      ..add(const TeacherPickerEvent.searchRequested(query: 'Иванов'));
    await Future<void>.delayed(Duration.zero);
    await bloc.close();
    verifyNever(() => repository.searchTeachers(query: any(named: 'query')));
  });

  test(
    'close discards a response already queued in the same event turn',
    () async {
      final response = Completer<SearchTeachersResponse>();
      when(repository.searchTeachers).thenAnswer((_) => response.future);
      final bloc = subject()
        ..add(
          const TeacherPickerEvent.searchRequested(query: '', immediate: true),
        );
      await Future<void>.delayed(Duration.zero);
      response.complete(const SearchTeachersResponse(results: [_first]));
      await bloc.close();
      expect(bloc.state.teachers, isEmpty);
      expect(bloc.isClosed, isTrue);
    },
  );

  testWidgets('picker updates the confirmed selection when props change', (
    tester,
  ) async {
    Widget picker(Teacher? selected) =>
        RepositoryProvider<ScheduleRepository>.value(
          value: repository,
          child: MaterialApp(
            theme: AppTheme.lightTheme,
            locale: const Locale('ru'),
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            home: Scaffold(
              body: TeacherPicker(selected: selected, onSelected: (_) {}),
            ),
          ),
        );
    await tester.pumpWidget(picker(_first));
    await tester.pumpAndSettle();
    expect(
      tester
          .widget<TeacherPickerSelection>(find.byType(TeacherPickerSelection))
          .teacher,
      _first,
    );
    await tester.pumpWidget(picker(_other));
    await tester.pumpAndSettle();
    expect(
      tester
          .widget<TeacherPickerSelection>(find.byType(TeacherPickerSelection))
          .teacher,
      _other,
    );
    await tester.pumpWidget(picker(null));
    await tester.pumpAndSettle();
    expect(find.byType(TeacherPickerSelection), findsNothing);
  });
}
