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
  });
}
