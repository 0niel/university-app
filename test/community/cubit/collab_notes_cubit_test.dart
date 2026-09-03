import 'dart:async';

import 'package:bloc_test/bloc_test.dart';
import 'package:campus_repository/campus_repository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:rtu_mirea_app/community/community.dart';

import '../../helpers/mocks/mock_campus_repository.dart';

void main() {
  setUpAll(() => registerFallbackValue(CollabNoteVisibility.group));

  group('CollabNotesCubit', () {
    late CampusRepository repository;
    late CollabNote note;

    setUp(() {
      repository = MockCampusRepository();
      note = const CollabNote(id: 'note-1', title: 'Algorithms');
    });

    CollabNotesCubit buildCubit() => .new(repository: repository);

    blocTest<CollabNotesCubit, CollabNotesState>(
      'loads notes',
      setUp: () {
        when(() => repository.getGroupNotes()).thenAnswer((_) async => [note]);
      },
      build: buildCubit,
      act: (cubit) => cubit.load(),
      expect: () => [
        const CollabNotesState(status: .loading),
        CollabNotesState(status: .ready, notes: [note]),
      ],
    );

    test('ignores a superseded load', () async {
      final first = Completer<List<CollabNote>>();
      final second = Completer<List<CollabNote>>();
      var calls = 0;
      when(() => repository.getGroupNotes()).thenAnswer(
        (_) => calls++ == 0 ? first.future : second.future,
      );
      final cubit = buildCubit();

      final loads = (cubit.load(), cubit.load());
      second.complete([note]);
      await loads.$2;
      first.complete(const []);
      await loads.$1;

      expect(cubit.state, CollabNotesState(status: .ready, notes: [note]));
      await cubit.close();
    });

    test('keeps cached notes when refresh fails', () async {
      when(() => repository.getGroupNotes()).thenAnswer((_) async => [note]);
      final cubit = buildCubit();
      await cubit.load();
      when(() => repository.getGroupNotes()).thenThrow(Exception('offline'));

      expect(await cubit.load(), isFalse);
      expect(cubit.state.status, CollabNotesStatus.failure);
      expect(cubit.state.notes, [note]);
      await cubit.close();
    });

    test('creates a typed personal note optimistically', () async {
      when(
        () => repository.createGroupNote(
          'Private draft',
          visibility: CollabNoteVisibility.personal,
        ),
      ).thenAnswer((_) async => 'created-id');
      final cubit = buildCubit();

      final created = await cubit.create(
        title: '  Private draft  ',
        visibility: CollabNoteVisibility.personal,
      );

      expect(created?.id, 'created-id');
      expect(created?.isPersonal, isTrue);
      expect(cubit.state.notes, [created]);
      verify(
        () => repository.createGroupNote(
          'Private draft',
          visibility: CollabNoteVisibility.personal,
        ),
      ).called(1);
      await cubit.close();
    });

    test('reports create failure without inventing a note', () async {
      when(
        () => repository.createGroupNote(
          any(),
          visibility: any(named: 'visibility'),
        ),
      ).thenThrow(Exception('rate limited'));
      final cubit = buildCubit();

      final created = await cubit.create(
        title: 'Shared',
        visibility: CollabNoteVisibility.group,
      );

      expect(created, isNull);
      expect(cubit.state.notes, isEmpty);
      expect(cubit.state.isCreating, isFalse);
      await cubit.close();
    });

    test('renames a note optimistically', () async {
      when(
        () => repository.getGroupNotes(),
      ).thenAnswer((_) async => [note]);
      when(
        () => repository.renameGroupNote('note-1', 'New title'),
      ).thenAnswer((_) async {});
      final cubit = buildCubit();
      await cubit.load();

      final ok = await cubit.rename('note-1', 'New title');

      expect(ok, isTrue);
      expect(cubit.state.notes.single.title, 'New title');
      await cubit.close();
    });

    test('rolls back a rename that fails on the server', () async {
      when(
        () => repository.getGroupNotes(),
      ).thenAnswer((_) async => [note]);
      when(
        () => repository.renameGroupNote('note-1', 'New title'),
      ).thenThrow(Exception('offline'));
      final cubit = buildCubit();
      await cubit.load();

      final ok = await cubit.rename('note-1', 'New title');

      expect(ok, isFalse);
      expect(cubit.state.notes.single.title, 'Algorithms');
      await cubit.close();
    });

    test('changes visibility optimistically', () async {
      when(
        () => repository.getGroupNotes(),
      ).thenAnswer((_) async => [note]);
      when(
        () => repository.setGroupNoteVisibility(
          'note-1',
          CollabNoteVisibility.personal,
        ),
      ).thenAnswer((_) async {});
      final cubit = buildCubit();
      await cubit.load();

      final ok = await cubit.setVisibility(
        'note-1',
        CollabNoteVisibility.personal,
      );

      expect(ok, isTrue);
      expect(cubit.state.notes.single.isPersonal, isTrue);
      await cubit.close();
    });

    test('removes a note optimistically and rolls back on failure', () async {
      when(
        () => repository.getGroupNotes(),
      ).thenAnswer((_) async => [note]);
      when(
        () => repository.deleteGroupNote('note-1'),
      ).thenThrow(Exception('offline'));
      final cubit = buildCubit();
      await cubit.load();

      final ok = await cubit.delete('note-1');

      expect(ok, isFalse);
      expect(cubit.state.notes, [note]);
      await cubit.close();
    });

    test('refreshes when the realtime list stream fires', () async {
      final controller = StreamController<void>();
      when(
        () => repository.watchGroupNotesList(),
      ).thenAnswer((_) => controller.stream);
      when(
        () => repository.getGroupNotes(),
      ).thenAnswer((_) async => [note]);
      final cubit = buildCubit();
      await cubit.load();
      cubit.startWatching();

      controller.add(null);
      await Future<void>.delayed(const Duration(milliseconds: 700));

      verify(() => repository.getGroupNotes()).called(2);
      await cubit.close();
      await controller.close();
    });
  });
}
