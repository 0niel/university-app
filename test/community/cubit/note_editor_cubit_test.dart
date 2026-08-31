import 'dart:async';

import 'package:campus_repository/campus_repository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:rtu_mirea_app/community/community.dart';

import '../../helpers/mocks/mock_campus_repository.dart';

class _MockPresenceSession extends Mock implements CollabNotePresenceSession {}

void main() {
  group('NoteEditorCubit', () {
    late CampusRepository repository;
    late CollabNote note;

    setUp(() {
      repository = MockCampusRepository();
      note = const CollabNote(
        id: 'note-1',
        title: 'Initial',
        content: 'Body',
        isMine: true,
        isPersonal: true,
        revision: 3,
      );
    });

    NoteEditorCubit buildCubit({Duration? debounce}) => NoteEditorCubit(
      repository: repository,
      note: note,
      editorName: 'Alex',
      saveDebounce: debounce ?? const Duration(days: 1),
    );

    GroupNoteSaveResult result(int revision) => GroupNoteSaveResult(
      revision: revision,
      updatedAt: DateTime(2026, 7, 11, 12),
    );

    test('coalesces edits made while a save is in flight', () async {
      final first = Completer<GroupNoteSaveResult>();
      final calls = <String>[];
      when(
        () => repository.saveGroupNote(
          id: any(named: 'id'),
          title: any(named: 'title'),
          content: any(named: 'content'),
          expectedRevision: any(named: 'expectedRevision'),
        ),
      ).thenAnswer((invocation) {
        calls.add(invocation.namedArguments[#content] as String);
        return calls.length == 1 ? first.future : Future.value(result(5));
      });
      final cubit = buildCubit()..contentChanged('Version one');

      final save = cubit.flush();
      cubit.contentChanged('Version two');
      expect(calls, ['Version one']);
      first.complete(result(4));

      expect(await save, isTrue);
      expect(calls, ['Version one', 'Version two']);
      expect(cubit.state.persistedRevision, cubit.state.revision);
      expect(cubit.state.serverRevision, 5);
      await cubit.close();
    });

    test('keeps a failed draft dirty and retries it', () async {
      var calls = 0;
      when(
        () => repository.saveGroupNote(
          id: any(named: 'id'),
          title: any(named: 'title'),
          content: any(named: 'content'),
          expectedRevision: any(named: 'expectedRevision'),
        ),
      ).thenAnswer((_) async {
        if (calls++ == 0) throw Exception('offline');
        return result(4);
      });
      final cubit = buildCubit()..contentChanged('Local text');

      expect(await cubit.flush(), isFalse);
      expect(cubit.state.status, NoteEditorStatus.failure);
      expect(cubit.state.hasUnsavedChanges, isTrue);
      expect(await cubit.flush(), isTrue);
      expect(cubit.state.status, NoteEditorStatus.saved);
      await cubit.close();
    });

    test(
      'surfaces revision conflicts without overwriting local text',
      () async {
        when(
          () => repository.saveGroupNote(
            id: any(named: 'id'),
            title: any(named: 'title'),
            content: any(named: 'content'),
            expectedRevision: any(named: 'expectedRevision'),
          ),
        ).thenThrow(const CollabNoteConflictException());
        final cubit = buildCubit()..contentChanged('Important local text');

        expect(await cubit.flush(), isFalse);
        expect(cubit.state.status, NoteEditorStatus.conflict);
        expect(cubit.state.content, 'Important local text');
        expect(cubit.state.hasUnsavedChanges, isTrue);
        await cubit.close();
      },
    );

    test('does not send an empty title', () async {
      final cubit = buildCubit()..titleChanged('   ');

      expect(await cubit.flush(), isFalse);
      expect(cubit.state.status, NoteEditorStatus.failure);
      verifyNever(
        () => repository.saveGroupNote(
          id: any(named: 'id'),
          title: any(named: 'title'),
          content: any(named: 'content'),
          expectedRevision: any(named: 'expectedRevision'),
        ),
      );
      await cubit.close();
    });

    test('waits for an active save before deleting', () async {
      final save = Completer<GroupNoteSaveResult>();
      when(
        () => repository.saveGroupNote(
          id: any(named: 'id'),
          title: any(named: 'title'),
          content: any(named: 'content'),
          expectedRevision: any(named: 'expectedRevision'),
        ),
      ).thenAnswer((_) => save.future);
      when(() => repository.deleteGroupNote('note-1')).thenAnswer((_) async {});
      final cubit = buildCubit()..contentChanged('Draft');
      final saving = cubit.flush();

      final deleting = cubit.delete();
      verifyNever(() => repository.deleteGroupNote(any()));
      save.complete(result(4));

      await saving;
      expect(await deleting, isTrue);
      verify(() => repository.deleteGroupNote('note-1')).called(1);
      expect(cubit.state.status, NoteEditorStatus.deleted);
      await cubit.close();
    });

    test('keeps the saved revision when a concurrent delete fails', () async {
      final save = Completer<GroupNoteSaveResult>();
      when(
        () => repository.saveGroupNote(
          id: any(named: 'id'),
          title: any(named: 'title'),
          content: any(named: 'content'),
          expectedRevision: any(named: 'expectedRevision'),
        ),
      ).thenAnswer((_) => save.future);
      when(
        () => repository.deleteGroupNote('note-1'),
      ).thenThrow(Exception('offline'));
      final cubit = buildCubit()..contentChanged('Draft');
      final saving = cubit.flush();
      final deleting = cubit.delete();

      save.complete(result(4));
      await saving;

      expect(await deleting, isFalse);
      expect(cubit.state.serverRevision, 4);
      await cubit.close();
    });

    test('owns and closes a shared-note presence session', () async {
      final presence = _MockPresenceSession();
      final editors = StreamController<List<String>>();
      when(() => presence.editors).thenAnswer((_) => editors.stream);
      when(presence.close).thenAnswer((_) async {});
      when(
        () => repository.openGroupNotePresence(
          noteId: 'note-1',
          editorName: 'Alex',
        ),
      ).thenReturn(presence);
      note = note.copyWith(isPersonal: false);
      final cubit = buildCubit();

      editors.add(['Alex', 'Sam']);
      await Future<void>.delayed(Duration.zero);
      expect(cubit.state.editors, ['Alex', 'Sam']);
      await cubit.close();

      verify(presence.close).called(1);
      await editors.close();
    });
  });
}
