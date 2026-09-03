import 'dart:async';

import 'package:bloc_test/bloc_test.dart';
import 'package:collection/collection.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:rtu_mirea_app/community/cubit/deadlines/deadlines.dart';
import 'package:rtu_mirea_app/community/models/deadline_draft.dart';
import 'package:schedule_repository/schedule_repository.dart';

import '../../helpers/mocks/mock_schedule_repository.dart';

void main() {
  setUpAll(() {
    registerFallbackValue(DeadlineSource.me);
    registerFallbackValue(DeadlinePriority.medium);
  });

  group('DeadlinesCubit', () {
    late ScheduleRepository repository;
    late Deadline personalDeadline;
    late Deadline groupDeadline;

    setUp(() {
      repository = MockScheduleRepository();
      personalDeadline = Deadline(
        id: 'personal-1',
        title: 'Lab report',
        subjectName: 'Physics',
        dueAt: DateTime(2099, 9, 1, 12),
        source: .me,
        isMine: true,
      );
      groupDeadline = Deadline(
        id: 'group-1',
        title: 'Exam',
        subjectName: 'Math',
        dueAt: DateTime(2099, 9, 2, 12),
        source: .group,
        priority: .urgent,
      );
    });

    DeadlinesCubit buildCubit() => .new(repository: repository);

    test('starts with an empty initial state', () {
      expect(buildCubit().state, const DeadlinesState());
    });

    blocTest<DeadlinesCubit, DeadlinesState>(
      'loads deadlines',
      setUp: () {
        when(
          () => repository.getDeadlines(),
        ).thenAnswer((_) async => [personalDeadline, groupDeadline]);
      },
      build: buildCubit,
      act: (cubit) => cubit.load(),
      expect: () => [
        const DeadlinesState(status: .loading),
        DeadlinesState(
          status: .ready,
          deadlines: [personalDeadline, groupDeadline],
        ),
      ],
    );

    test('ignores a superseded load response', () async {
      final first = Completer<List<Deadline>>();
      final second = Completer<List<Deadline>>();
      var request = 0;
      when(() => repository.getDeadlines()).thenAnswer((_) {
        request++;
        return request == 1 ? first.future : second.future;
      });
      final cubit = buildCubit();

      final loads = (cubit.load(), cubit.load());
      second.complete([groupDeadline]);
      await loads.$2;
      first.complete([personalDeadline]);
      await loads.$1;

      expect(cubit.state.deadlines, [groupDeadline]);
      await cubit.close();
    });

    test('applies typed filters and timeline buckets', () {
      final done = personalDeadline.copyWith(isDone: true);
      final state = DeadlinesState(
        status: .ready,
        deadlines: [done, groupDeadline],
      );

      expect(state.hotCount, 1);
      expect(state.copyWith(filter: .hot).visibleDeadlines, [
        groupDeadline,
      ]);
      expect(state.copyWith(filter: .done).visibleDeadlines, [
        done,
      ]);
      expect(state.inBucket(.hot), [groupDeadline]);
    });

    test('prevents duplicate completion mutations', () async {
      var loadCount = 0;
      when(() => repository.getDeadlines()).thenAnswer((_) async {
        loadCount++;
        final deadline = loadCount == 1
            ? personalDeadline
            : personalDeadline.copyWith(isDone: true);
        return [deadline];
      });
      final mutation = Completer<void>();
      when(
        () => repository.setDeadlineState(
          id: 'personal-1',
          done: true,
        ),
      ).thenAnswer((_) => mutation.future);
      final cubit = buildCubit();
      await cubit.load();

      final toggles = (
        cubit.toggleDone('personal-1'),
        cubit.toggleDone('personal-1'),
      );

      expect(cubit.state.deadlines.firstOrNull?.isDone, isTrue);
      expect(cubit.state.pendingDeadlineIds, {'personal-1'});
      expect(await toggles.$2, isTrue);
      verify(
        () => repository.setDeadlineState(id: 'personal-1', done: true),
      ).called(1);

      mutation.complete();
      expect(await toggles.$1, isTrue);
      expect(cubit.state.pendingDeadlineIds, isEmpty);
      await cubit.close();
    });

    blocTest<DeadlinesCubit, DeadlinesState>(
      'rolls completion back when the repository rejects it',
      setUp: () {
        when(
          () => repository.getDeadlines(),
        ).thenAnswer((_) async => [personalDeadline]);
        when(
          () => repository.setDeadlineState(
            id: 'personal-1',
            done: true,
          ),
        ).thenThrow(Exception('rls'));
      },
      build: buildCubit,
      act: (cubit) async {
        await cubit.load();
        expect(await cubit.toggleDone('personal-1'), isFalse);
      },
      skip: 2,
      expect: () => [
        DeadlinesState(
          status: .ready,
          deadlines: [personalDeadline.copyWith(isDone: true)],
          pendingDeadlineIds: {'personal-1'},
        ),
        DeadlinesState(
          status: .ready,
          deadlines: [personalDeadline],
        ),
      ],
      errors: () => [isA<Exception>()],
    );

    test('does not mutate a deadline owned by someone else', () async {
      when(
        () => repository.getDeadlines(),
      ).thenAnswer((_) async => [groupDeadline]);
      final cubit = buildCubit();
      await cubit.load();

      expect(await cubit.toggleDone('group-1'), isFalse);
      verifyNever(
        () => repository.setDeadlineState(
          id: any(named: 'id'),
          done: any(named: 'done'),
        ),
      );
      await cubit.close();
    });

    test('creates a deadline with exact wire model values', () async {
      final draft = DeadlineDraft(
        title: 'Coursework',
        subjectName: 'Algorithms',
        dueAt: DateTime(2026, 12, 1, 23, 59),
        source: .group,
        priority: .urgent,
        remind: false,
      );
      when(
        () => repository.createDeadline(
          title: any(named: 'title'),
          subjectName: any(named: 'subjectName'),
          dueAt: any(named: 'dueAt'),
          source: any(named: 'source'),
          priority: any(named: 'priority'),
          remind: any(named: 'remind'),
        ),
      ).thenAnswer((_) => Future.value());
      when(
        () => repository.getDeadlines(),
      ).thenAnswer((_) async => [personalDeadline]);
      final cubit = buildCubit();

      expect(await cubit.createDeadline(draft), isTrue);
      verify(
        () => repository.createDeadline(
          title: 'Coursework',
          subjectName: 'Algorithms',
          dueAt: DateTime(2026, 12, 1, 23, 59),
          source: .group,
          priority: .urgent,
          remind: false,
        ),
      ).called(1);
      expect(cubit.state.deadlines, [personalDeadline]);
      await cubit.close();
    });

    blocTest<DeadlinesCubit, DeadlinesState>(
      'reports create failure and restores the creating flag',
      setUp: () {
        when(
          () => repository.createDeadline(
            title: any(named: 'title'),
            subjectName: any(named: 'subjectName'),
            dueAt: any(named: 'dueAt'),
            source: any(named: 'source'),
            priority: any(named: 'priority'),
            remind: any(named: 'remind'),
          ),
        ).thenThrow(Exception('offline'));
      },
      build: buildCubit,
      act: (cubit) async {
        final created = await cubit.createDeadline(
          DeadlineDraft(
            title: 'Coursework',
            dueAt: DateTime(2026, 12, 1, 23, 59),
            source: .me,
          ),
        );
        expect(created, isFalse);
      },
      expect: () => [
        const DeadlinesState(isCreating: true),
        const DeadlinesState(),
      ],
      errors: () => [isA<Exception>()],
    );

    blocTest<DeadlinesCubit, DeadlinesState>(
      'keeps stale data and reports refresh failure after successful create',
      setUp: () {
        var loadCount = 0;
        when(() => repository.getDeadlines()).thenAnswer((_) async {
          if (loadCount++ == 0) return [personalDeadline];
          throw Exception('refresh failed');
        });
        when(
          () => repository.createDeadline(
            title: any(named: 'title'),
            subjectName: any(named: 'subjectName'),
            dueAt: any(named: 'dueAt'),
            source: any(named: 'source'),
            priority: any(named: 'priority'),
            remind: any(named: 'remind'),
          ),
        ).thenAnswer((_) => Future<void>.value());
      },
      build: buildCubit,
      act: (cubit) async {
        await cubit.load();
        final created = await cubit.createDeadline(
          DeadlineDraft(
            title: 'Coursework',
            dueAt: DateTime(2026, 12, 1, 23, 59),
            source: .me,
          ),
        );
        expect(created, isTrue);
      },
      expect: () => [
        const DeadlinesState(status: .loading),
        DeadlinesState(status: .ready, deadlines: [personalDeadline]),
        DeadlinesState(
          status: .ready,
          deadlines: [personalDeadline],
          isCreating: true,
        ),
        DeadlinesState(status: .ready, deadlines: [personalDeadline]),
        DeadlinesState(status: .loading, deadlines: [personalDeadline]),
        DeadlinesState(status: .failure, deadlines: [personalDeadline]),
      ],
      errors: () => [isA<Exception>()],
    );

    DeadlinesCubit buildDeleteCubit() => DeadlinesCubit(
      repository: repository,
      deleteUndoWindow: const Duration(milliseconds: 10),
    );

    test('deleteDeadline hides then commits after the undo window', () async {
      when(
        () => repository.getDeadlines(),
      ).thenAnswer((_) async => [personalDeadline]);
      when(
        () => repository.deleteDeadline('personal-1'),
      ).thenAnswer((_) async {});
      final cubit = buildDeleteCubit();
      await cubit.load();

      cubit.deleteDeadline('personal-1');
      expect(cubit.state.pendingDeleteIds, {'personal-1'});
      expect(cubit.state.displayDeadlines, isEmpty);
      verifyNever(() => repository.deleteDeadline('personal-1'));

      await Future<void>.delayed(const Duration(milliseconds: 50));
      expect(cubit.state.pendingDeleteIds, isEmpty);
      expect(cubit.state.deadlines, isEmpty);
      verify(() => repository.deleteDeadline('personal-1')).called(1);
      await cubit.close();
    });

    test('undoDeleteDeadline cancels the pending delete', () async {
      when(
        () => repository.getDeadlines(),
      ).thenAnswer((_) async => [personalDeadline]);
      final cubit = buildDeleteCubit();
      await cubit.load();

      cubit
        ..deleteDeadline('personal-1')
        ..undoDeleteDeadline('personal-1');
      expect(cubit.state.pendingDeleteIds, isEmpty);
      expect(cubit.state.displayDeadlines, [personalDeadline]);

      await Future<void>.delayed(const Duration(milliseconds: 50));
      verifyNever(() => repository.deleteDeadline(any()));
      expect(cubit.state.deadlines, [personalDeadline]);
      await cubit.close();
    });

    test('closing the cubit flushes any pending deletes immediately', () async {
      when(
        () => repository.getDeadlines(),
      ).thenAnswer((_) async => [personalDeadline]);
      when(
        () => repository.deleteDeadline('personal-1'),
      ).thenAnswer((_) async {});
      final cubit = DeadlinesCubit(
        repository: repository,
        deleteUndoWindow: const Duration(seconds: 30),
      );
      await cubit.load();

      cubit.deleteDeadline('personal-1');
      await cubit.close();
      verify(() => repository.deleteDeadline('personal-1')).called(1);
    });

    test('deleteDeadline ignores a shared deadline it does not own', () async {
      when(
        () => repository.getDeadlines(),
      ).thenAnswer((_) async => [groupDeadline]);
      final cubit = buildDeleteCubit();
      await cubit.load();

      cubit.deleteDeadline('group-1');
      expect(cubit.state.pendingDeleteIds, isEmpty);
      verifyNever(() => repository.deleteDeadline(any()));
      await cubit.close();
    });

    test('updateDeadline forwards changed fields and reloads', () async {
      when(
        () => repository.updateDeadline(
          id: 'personal-1',
          title: 'Renamed',
          subjectName: any(named: 'subjectName'),
          dueAt: any(named: 'dueAt'),
          priority: any(named: 'priority'),
          progress: 50,
          remind: any(named: 'remind'),
          remindMinutes: any(named: 'remindMinutes'),
        ),
      ).thenAnswer((_) async {});
      when(
        () => repository.getDeadlines(),
      ).thenAnswer((_) async => [personalDeadline]);
      final cubit = buildCubit();

      final ok = await cubit.updateDeadline(
        personalDeadline,
        title: 'Renamed',
        progress: 50,
      );

      expect(ok, isTrue);
      verify(
        () => repository.updateDeadline(
          id: 'personal-1',
          title: 'Renamed',
          subjectName: any(named: 'subjectName'),
          dueAt: any(named: 'dueAt'),
          priority: any(named: 'priority'),
          progress: 50,
          remind: any(named: 'remind'),
          remindMinutes: any(named: 'remindMinutes'),
        ),
      ).called(1);
      await cubit.close();
    });

    test('updateDeadline refuses a deadline it does not own', () async {
      final cubit = buildCubit();
      final ok = await cubit.updateDeadline(groupDeadline, title: 'Nope');
      expect(ok, isFalse);
      verifyNever(
        () => repository.updateDeadline(
          id: any(named: 'id'),
          title: any(named: 'title'),
        ),
      );
      await cubit.close();
    });

    test('postponeOverdueToTomorrow moves only owned overdue items', () async {
      final overdue = personalDeadline.copyWith(dueAt: DateTime(2020));
      when(
        () => repository.getDeadlines(),
      ).thenAnswer((_) async => [overdue, groupDeadline]);
      when(
        () => repository.postponeDeadlines(
          ids: ['personal-1'],
          until: any(named: 'until'),
        ),
      ).thenAnswer((_) async => 1);
      final cubit = buildCubit();
      await cubit.load();

      final moved = await cubit.postponeOverdueToTomorrow(
        now: DateTime(2026, 1, 10),
      );

      expect(moved, isTrue);
      verify(
        () => repository.postponeDeadlines(
          ids: ['personal-1'],
          until: any(named: 'until'),
        ),
      ).called(1);
      await cubit.close();
    });

    test('postponeOverdueToTomorrow is a no-op with nothing overdue', () async {
      when(
        () => repository.getDeadlines(),
      ).thenAnswer((_) async => [personalDeadline]);
      final cubit = buildCubit();
      await cubit.load();

      final moved = await cubit.postponeOverdueToTomorrow(
        now: DateTime(2026, 1, 10),
      );

      expect(moved, isFalse);
      verifyNever(
        () => repository.postponeDeadlines(
          ids: any(named: 'ids'),
          until: any(named: 'until'),
        ),
      );
      await cubit.close();
    });

    blocTest<DeadlinesCubit, DeadlinesState>(
      'toggleDoneGroupExpanded flips the flag',
      build: buildCubit,
      act: (cubit) => cubit.toggleDoneGroupExpanded(),
      expect: () => [const DeadlinesState(doneGroupExpanded: true)],
    );
  });
}
