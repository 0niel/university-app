import 'dart:async';

import 'package:campus_repository/campus_repository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:rtu_mirea_app/community/cubit/note_editor/note_editor.dart';
import 'package:rtu_mirea_app/community/data/note_draft_store.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';

import '../../helpers/fakes/note_draft_memory_storage.dart';
import '../../helpers/mocks/mock_campus_repository.dart';

class _MockSpeech extends Mock implements SpeechToText {}

class _FakeRealtimeSession implements CollabNoteRealtimeSession {
  final _editorsController = StreamController<List<String>>.broadcast();
  final _changesController = StreamController<CollabNoteChange>.broadcast();
  final _connectionsController = StreamController<void>.broadcast();
  final broadcasted = <CollabNoteChange>[];
  bool closed = false;

  @override
  Stream<List<String>> get editors => _editorsController.stream;

  @override
  Stream<CollabNoteChange> get changes => _changesController.stream;

  @override
  Stream<void> get connections => _connectionsController.stream;

  void reconnect() => _connectionsController.add(null);

  void emitEditors(List<String> names) => _editorsController.add(names);

  void emitRemoteChange(CollabNoteChange change) =>
      _changesController.add(change);

  @override
  Future<void> broadcastChange(CollabNoteChange change) async {
    broadcasted.add(change);
  }

  @override
  Future<void> close() async {
    closed = true;
    await _editorsController.close();
    await _changesController.close();
    await _connectionsController.close();
  }
}

Future<void> _settle() => Future<void>.delayed(Duration.zero);

void main() {
  setUpAll(() => registerFallbackValue(SpeechListenOptions()));
  group('NoteEditorCubit', () {
    late CampusRepository repository;
    late CollabNote note;

    setUp(() {
      repository = MockCampusRepository();
      note = const CollabNote(
        id: 'note-1',
        title: 'Initial',
        content: 'Body text',
        isMine: true,
        isPersonal: true,
      );
    });

    NoteEditorCubit buildCubit({
      CollabNote? withNote,
      Duration? debounce,
      NoteDraftStore? draftStore,
      String? userId,
      Duration? closeTimeout,
      SpeechToText? speech,
    }) {
      when(
        () => repository.getGroupNote('note-1'),
      ).thenAnswer((_) async => withNote ?? note);
      return NoteEditorCubit(
        repository: repository,
        note: withNote ?? note,
        editorName: 'Alex',
        saveDebounce: debounce ?? const Duration(days: 1),
        currentUserId: userId,
        draftStore: draftStore,
        closeTimeout: closeTimeout ?? const Duration(seconds: 8),
        speech: speech,
      );
    }

    GroupNoteDocumentSaveResult saved(int revision, List<Object?> document) =>
        GroupNoteDocumentSaveResult(
          revision: revision,
          updatedAt: DateTime(2026, 7, 11, 12),
          document: document,
          content: plainTextFromDelta(document),
        );

    test('builds the initial document from plain content', () {
      final cubit = buildCubit();

      expect(cubit.controller.document.toPlainText(), 'Body text\n');
      expect(cubit.state.title, 'Initial');
      expect(cubit.state.canDelete, isTrue);
    });

    test('builds the initial document from a stored delta', () {
      final withDoc = note.copyWith(
        document: [
          {'insert': 'Rich text\n'},
        ],
        documentRevision: 2,
        content: 'stale plain text',
      );
      final cubit = buildCubit(withNote: withDoc);

      expect(cubit.controller.document.toPlainText(), 'Rich text\n');
    });

    test('debounces and saves a local edit', () async {
      when(
        () => repository.saveGroupNoteDocument(
          id: any(named: 'id'),
          document: any(named: 'document'),
          expectedRevision: any(named: 'expectedRevision'),
        ),
      ).thenAnswer((invocation) async {
        final document = invocation.namedArguments[#document] as List<Object?>;
        return saved(1, document);
      });
      final cubit = buildCubit();

      cubit.controller.document.insert(0, 'Hi ');
      await _settle();
      expect(cubit.state.status, NoteEditorStatus.dirty);

      final ok = await cubit.flush();

      expect(ok, isTrue);
      expect(cubit.state.status, NoteEditorStatus.saved);
      verify(
        () => repository.saveGroupNoteDocument(
          id: 'note-1',
          document: any(named: 'document'),
          expectedRevision: 0,
        ),
      ).called(1);
      await cubit.close();
    });

    test('coalesces edits made while a save is in flight', () async {
      final first = Completer<GroupNoteDocumentSaveResult>();
      var calls = 0;
      when(
        () => repository.saveGroupNoteDocument(
          id: any(named: 'id'),
          document: any(named: 'document'),
          expectedRevision: any(named: 'expectedRevision'),
        ),
      ).thenAnswer((invocation) {
        calls++;
        final document = invocation.namedArguments[#document] as List<Object?>;
        if (calls == 1) return first.future;
        return Future.value(saved(2, document));
      });
      final cubit = buildCubit();
      cubit.controller.document.insert(0, 'One ');
      await _settle();

      final save = cubit.flush();
      cubit.controller.document.insert(0, 'Two ');
      await _settle();
      first.complete(
        saved(1, [
          {'insert': 'One Body text\n'},
        ]),
      );

      expect(await save, isTrue);
      expect(calls, 2);
      expect(cubit.state.status, NoteEditorStatus.saved);
      await cubit.close();
    });

    test('rebases pending edits on a save conflict', () async {
      when(
        () => repository.saveGroupNoteDocument(
          id: any(named: 'id'),
          document: any(named: 'document'),
          expectedRevision: any(named: 'expectedRevision'),
        ),
      ).thenAnswer((invocation) async {
        final revision = invocation.namedArguments[#expectedRevision] as int;
        if (revision == 0) {
          return GroupNoteDocumentSaveResult(
            revision: 3,
            updatedAt: DateTime(2026, 7, 11, 12),
            conflict: true,
            document: [
              {'insert': 'Body text from someone else\n'},
            ],
            content: 'Body text from someone else',
          );
        }
        final document = invocation.namedArguments[#document] as List<Object?>;
        return saved(revision + 1, document);
      });
      final cubit = buildCubit();
      cubit.controller.document.insert(0, 'Mine ');
      await _settle();

      final ok = await cubit.flush();

      expect(ok, isTrue);
      expect(cubit.state.status, NoteEditorStatus.saved);
      expect(
        cubit.controller.document.toPlainText(),
        contains('Mine'),
      );
      expect(
        cubit.controller.document.toPlainText(),
        contains('someone else'),
      );
      await cubit.close();
    });

    test('marks the note read-only when it is no longer available', () async {
      when(
        () => repository.saveGroupNoteDocument(
          id: any(named: 'id'),
          document: any(named: 'document'),
          expectedRevision: any(named: 'expectedRevision'),
        ),
      ).thenThrow(const CollabNoteUnavailableException());
      final cubit = buildCubit();
      cubit.controller.document.insert(0, 'Edit ');
      await _settle();

      expect(await cubit.flush(), isFalse);
      expect(cubit.state.status, NoteEditorStatus.readOnly);
      expect(cubit.state.readOnly, isTrue);
      await cubit.close();
    });

    test('debounces a title rename separately from the document', () async {
      when(
        () => repository.renameGroupNote('note-1', 'New title'),
      ).thenAnswer((_) async {});
      final cubit = buildCubit()..titleChanged('New title');

      expect(cubit.state.title, 'New title');
      verifyNever(() => repository.renameGroupNote(any(), any()));

      await cubit.flush();

      verify(() => repository.renameGroupNote('note-1', 'New title')).called(1);
      await cubit.close();
    });

    test('waits for an active save before deleting', () async {
      final save = Completer<GroupNoteDocumentSaveResult>();
      when(
        () => repository.saveGroupNoteDocument(
          id: any(named: 'id'),
          document: any(named: 'document'),
          expectedRevision: any(named: 'expectedRevision'),
        ),
      ).thenAnswer((_) => save.future);
      when(() => repository.deleteGroupNote('note-1')).thenAnswer((_) async {});
      final cubit = buildCubit();
      cubit.controller.document.insert(0, 'Draft ');
      await _settle();
      final saving = cubit.flush();

      final deleting = cubit.delete();
      verifyNever(() => repository.deleteGroupNote(any()));
      save.complete(saved(1, cubit.controller.document.toDelta().toJson()));

      await saving;
      expect(await deleting, isTrue);
      verify(() => repository.deleteGroupNote('note-1')).called(1);
      expect(cubit.state.status, NoteEditorStatus.deleted);
      await cubit.close();
    });

    test('tracks presence and applies remote deltas', () async {
      final session = _FakeRealtimeSession();
      when(
        () => repository.openGroupNoteRealtime(
          noteId: 'note-1',
          editorName: 'Alex',
        ),
      ).thenReturn(session);
      final groupNote = note.copyWith(isPersonal: false);
      final cubit = buildCubit(withNote: groupNote);

      session.emitEditors(['Alex', 'Sam']);
      await _settle();
      expect(cubit.state.editors, ['Alex', 'Sam']);

      session.emitRemoteChange(
        const CollabNoteChange(
          clientId: 'someone-else',
          revision: 1,
          document: [
            {'insert': 'Body text!!!\n'},
          ],
        ),
      );
      await _settle();
      expect(cubit.controller.document.toPlainText(), contains('!!!'));

      await cubit.close();
      expect(session.closed, isTrue);
    });

    test('ignores its own broadcast client id', () async {
      final session = _FakeRealtimeSession();
      when(
        () => repository.openGroupNoteRealtime(
          noteId: 'note-1',
          editorName: 'Alex',
        ),
      ).thenReturn(session);
      when(
        () => repository.saveGroupNoteDocument(
          id: any(named: 'id'),
          document: any(named: 'document'),
          expectedRevision: any(named: 'expectedRevision'),
        ),
      ).thenAnswer(
        (invocation) async =>
            saved(1, invocation.namedArguments[#document] as List<Object?>),
      );
      final groupNote = note.copyWith(isPersonal: false);
      final cubit = buildCubit(withNote: groupNote);

      cubit.controller.document.insert(0, 'Typed ');
      await _settle();

      expect(session.broadcasted, isEmpty);
      await cubit.flush();
      expect(session.broadcasted, hasLength(1));
      session.emitRemoteChange(session.broadcasted.single);
      await _settle();
      expect(cubit.controller.document.toPlainText(), 'Typed Body text\n');
      await cubit.close();
    });

    void stubSave() {
      when(
        () => repository.saveGroupNoteDocument(
          id: any(named: 'id'),
          document: any(named: 'document'),
          expectedRevision: any(named: 'expectedRevision'),
        ),
      ).thenAnswer(
        (invocation) async => saved(
          (invocation.namedArguments[#expectedRevision] as int) + 1,
          invocation.namedArguments[#document] as List<Object?>,
        ),
      );
    }

    _FakeRealtimeSession stubRealtime() {
      final session = _FakeRealtimeSession();
      when(
        () => repository.openGroupNoteRealtime(
          noteId: 'note-1',
          editorName: 'Alex',
        ),
      ).thenReturn(session);
      return session;
    }

    CollabNoteChange snapshot(int revision, String text) => CollabNoteChange(
      clientId: 'other',
      revision: revision,
      document: [
        {'insert': '$text\n'},
      ],
    );

    test(
      'remote snapshot followed by a conflict is not inserted twice',
      () async {
        final session = stubRealtime();
        final cubit = buildCubit(
          withNote: note.copyWith(content: 'AB', isPersonal: false),
        );
        await _settle();
        session.emitRemoteChange(snapshot(1, 'AXB'));
        await _settle();
        cubit.controller.document.insert(0, 'Y');
        await _settle();
        var calls = 0;
        when(
          () => repository.saveGroupNoteDocument(
            id: any(named: 'id'),
            document: any(named: 'document'),
            expectedRevision: any(named: 'expectedRevision'),
          ),
        ).thenAnswer((invocation) async {
          calls++;
          if (calls == 1) {
            return saved(2, [
              {'insert': 'AXB\n'},
            ]).copyWith(conflict: true);
          }
          expect(invocation.namedArguments[#expectedRevision], 2);
          return saved(
            3,
            invocation.namedArguments[#document] as List<Object?>,
          );
        });
        expect(await cubit.flush(), isTrue);
        expect(cubit.controller.document.toPlainText(), 'YAXB\n');
        expect(calls, 2);
        await cubit.close();
      },
    );

    test('rebases a remote deletion past a pending local insertion', () async {
      stubSave();
      final session = stubRealtime();
      final cubit = buildCubit(
        withNote: note.copyWith(content: 'AB', isPersonal: false),
      );
      await _settle();
      cubit.controller.document.insert(0, 'Q');
      await _settle();
      session.emitRemoteChange(snapshot(1, 'A'));
      await _settle();
      expect(cubit.controller.document.toPlainText(), 'QA\n');
      expect(await cubit.flush(), isTrue);
      await cubit.close();
    });

    test('ignores duplicate and reversed revision snapshots', () async {
      final session = stubRealtime();
      final cubit = buildCubit(withNote: note.copyWith(isPersonal: false));
      await _settle();
      session
        ..emitRemoteChange(snapshot(3, 'Latest'))
        ..emitRemoteChange(snapshot(2, 'Old'))
        ..emitRemoteChange(snapshot(3, 'Latest'));
      await _settle();
      expect(cubit.controller.document.toPlainText(), 'Latest\n');
      expect(cubit.state.hasUnsavedChanges, isFalse);
      await cubit.close();
      verifyNever(
        () => repository.saveGroupNoteDocument(
          id: any(named: 'id'),
          document: any(named: 'document'),
          expectedRevision: any(named: 'expectedRevision'),
        ),
      );
    });

    test(
      'queues a newer snapshot until its own save is acknowledged',
      () async {
        final session = stubRealtime();
        final first = Completer<GroupNoteDocumentSaveResult>();
        final sent = <List<Object?>>[];
        when(
          () => repository.saveGroupNoteDocument(
            id: any(named: 'id'),
            document: any(named: 'document'),
            expectedRevision: any(named: 'expectedRevision'),
          ),
        ).thenAnswer((invocation) {
          final document =
              invocation.namedArguments[#document] as List<Object?>;
          sent.add(document);
          if (sent.length == 1) return first.future;
          expect(invocation.namedArguments[#expectedRevision], 2);
          return Future.value(saved(3, document));
        });
        final cubit = buildCubit(
          withNote: note.copyWith(content: 'AB', isPersonal: false),
        );
        await _settle();
        cubit.controller.document.insert(0, 'Y');
        await _settle();
        final flushing = cubit.flush();
        session.emitRemoteChange(snapshot(2, 'YAXB'));
        cubit.controller.document.insert(0, 'Z');
        await _settle();
        first.complete(saved(1, sent.first));
        expect(await flushing, isTrue);
        expect(cubit.controller.document.toPlainText(), 'ZYAXB\n');
        expect(sent, hasLength(2));
        await cubit.close();
      },
    );

    test(
      'reconnect fetches a missed committed snapshot preserving local edits',
      () async {
        stubSave();
        final session = stubRealtime();
        final cubit = buildCubit(
          withNote: note.copyWith(content: 'AB', isPersonal: false),
        );
        await _settle();
        cubit.controller.document.insert(0, 'Q');
        await _settle();
        when(() => repository.getGroupNote('note-1')).thenAnswer(
          (_) async => note.copyWith(
            content: 'AXB',
            documentRevision: 4,
          ),
        );
        session.reconnect();
        await _settle();
        expect(cubit.controller.document.toPlainText(), 'QAXB\n');
        expect(await cubit.flush(), isTrue);
        verify(
          () => repository.saveGroupNoteDocument(
            id: 'note-1',
            document: any(named: 'document'),
            expectedRevision: 4,
          ),
        ).called(1);
        await cubit.close();
      },
    );

    test(
      'title failure is observable even when the document is clean',
      () async {
        when(
          () => repository.renameGroupNote(any(), any()),
        ).thenThrow(Exception('offline'));
        final cubit = buildCubit()..titleChanged('Unsaved title');
        expect(cubit.state.hasUnsavedChanges, isTrue);
        expect(await cubit.flush(), isFalse);
        expect(cubit.state.status, NoteEditorStatus.failure);
        expect(cubit.state.hasUnsavedChanges, isTrue);
        cubit.discardChanges();
        await cubit.close();
        verify(
          () => repository.renameGroupNote('note-1', 'Unsaved title'),
        ).called(1);
      },
    );

    test('serializes title edits while a rename is in flight', () async {
      final first = Completer<void>();
      when(
        () => repository.renameGroupNote('note-1', 'First'),
      ).thenAnswer((_) => first.future);
      when(
        () => repository.renameGroupNote('note-1', 'Latest'),
      ).thenAnswer((_) async {});
      final cubit = buildCubit()..titleChanged('First');
      final flushing = cubit.flush();
      cubit.titleChanged('Latest');
      final secondFlush = cubit.flush();
      verifyNever(() => repository.renameGroupNote('note-1', 'Latest'));
      first.complete();
      expect(await flushing, isTrue);
      expect(await secondFlush, isTrue);
      expect(cubit.state.title, 'Latest');
      expect(cubit.state.hasUnsavedChanges, isFalse);
      verify(() => repository.renameGroupNote('note-1', 'First')).called(1);
      verify(() => repository.renameGroupNote('note-1', 'Latest')).called(1);
      await cubit.close();
    });

    test('collaborator can edit document but cannot rename it', () async {
      stubSave();
      final cubit = buildCubit(withNote: note.copyWith(isMine: false))
        ..titleChanged('Forbidden title');
      cubit.controller.document.insert(0, 'Allowed ');
      await _settle();
      expect(cubit.state.title, 'Initial');
      expect(cubit.state.canRename, isFalse);
      expect(await cubit.flush(), isTrue);
      verifyNever(() => repository.renameGroupNote(any(), any()));
      await cubit.close();
    });

    test(
      'document success does not hide a simultaneous title failure',
      () async {
        stubSave();
        when(
          () => repository.renameGroupNote(any(), any()),
        ).thenThrow(Exception('rename failed'));
        final cubit = buildCubit()..titleChanged('Unsaved');
        cubit.controller.document.insert(0, 'Saved ');
        await _settle();
        expect(await cubit.flush(), isFalse);
        expect(cubit.state.status, NoteEditorStatus.failure);
        cubit.discardChanges();
        await cubit.close();
      },
    );

    test(
      'malformed remote snapshots cannot advance the base revision',
      () async {
        stubSave();
        final session = stubRealtime();
        final cubit = buildCubit(withNote: note.copyWith(isPersonal: false));
        await _settle();
        session
          ..emitRemoteChange(
            const CollabNoteChange(
              clientId: 'other',
              revision: 100,
              document: [
                {'retain': 500},
              ],
            ),
          )
          ..emitRemoteChange(snapshot(1, 'Valid'));
        await _settle();
        expect(cubit.controller.document.toPlainText(), 'Valid\n');
        cubit.controller.document.insert(0, 'Local ');
        await _settle();
        expect(await cubit.flush(), isTrue);
        verify(
          () => repository.saveGroupNoteDocument(
            id: 'note-1',
            document: any(named: 'document'),
            expectedRevision: 1,
          ),
        ).called(1);
        await cubit.close();
      },
    );

    test(
      'snapshot merging preserves rich formatting and embedded images',
      () async {
        stubSave();
        final session = stubRealtime();
        final cubit = buildCubit(
          withNote: note.copyWith(content: 'A', isPersonal: false),
        );
        await _settle();
        cubit.controller.document.insert(0, 'Local ');
        await _settle();
        session.emitRemoteChange(
          const CollabNoteChange(
            clientId: 'other',
            revision: 1,
            document: [
              {
                'insert': 'A',
                'attributes': {'bold': true},
              },
              {
                'insert': {'image': 'https://example.com/image.png'},
              },
              {'insert': '\n'},
            ],
          ),
        );
        await _settle();
        final document = cubit.controller.document.toDelta().toJson();
        expect(
          document,
          contains(
            equals({
              'insert': 'A',
              'attributes': {'bold': true},
            }),
          ),
        );
        expect(
          document,
          contains(
            equals({
              'insert': {'image': 'https://example.com/image.png'},
            }),
          ),
        );
        expect(cubit.controller.document.toPlainText(), startsWith('Local A'));
        expect(await cubit.flush(), isTrue);
        await cubit.close();
      },
    );

    test('a stale resync cannot replace a newly saved title', () async {
      when(
        () => repository.renameGroupNote(any(), any()),
      ).thenAnswer((_) async {});
      final cubit = buildCubit();
      final oldSnapshot = Completer<CollabNote?>();
      when(
        () => repository.getGroupNote('note-1'),
      ).thenAnswer((_) => oldSnapshot.future);
      final syncing = cubit.resynchronize();
      cubit.titleChanged('New title');
      expect(await cubit.flush(), isTrue);
      oldSnapshot.complete(note);
      await syncing;
      expect(cubit.state.title, 'New title');
      await cubit.close();
    });

    test(
      'nonadvancing conflict fails instead of retrying indefinitely',
      () async {
        when(
          () => repository.saveGroupNoteDocument(
            id: any(named: 'id'),
            document: any(named: 'document'),
            expectedRevision: any(named: 'expectedRevision'),
          ),
        ).thenAnswer(
          (_) async => saved(0, [
            {'insert': 'Body text\n'},
          ]).copyWith(conflict: true),
        );
        final cubit = buildCubit();
        cubit.controller.document.insert(0, 'Local ');
        await _settle();
        expect(await cubit.flush(), isFalse);
        expect(cubit.state.status, NoteEditorStatus.failure);
        cubit.discardChanges();
        await cubit.close();
      },
    );

    test(
      'rejects blank and oversized titles without silently succeeding',
      () async {
        final cubit = buildCubit();
        for (final invalid in ['', 'x' * 201]) {
          cubit.titleChanged(invalid);
          expect(await cubit.flush(), isFalse);
        }
        verifyNever(() => repository.renameGroupNote(any(), any()));
        cubit.discardChanges();
        await cubit.close();
      },
    );

    void stubOffline() {
      when(
        () => repository.saveGroupNoteDocument(
          id: any(named: 'id'),
          document: any(named: 'document'),
          expectedRevision: any(named: 'expectedRevision'),
        ),
      ).thenThrow(Exception('SocketException: offline'));
      when(
        () => repository.renameGroupNote(any(), any()),
      ).thenThrow(Exception('SocketException: offline'));
    }

    NoteDraft recoveryDraft({
      String body = 'QAB',
      String title = 'Initial',
      List<Object?>? submittedDocument,
    }) => NoteDraft(
      noteId: 'note-1',
      userId: 'user',
      token: 'previous-session',
      baseRevision: 0,
      baseDocument: const [
        {'insert': 'AB\n'},
      ],
      document: [
        {'insert': '$body\n'},
      ],
      baseTitle: 'Initial',
      title: title,
      submittedDocument: submittedDocument,
    );

    test(
      'offline close retains both title and delta for a fresh process',
      () async {
        stubOffline();
        final storage = NoteDraftMemoryStorage();
        final store = NoteDraftStore(storage: storage);
        final cubit = buildCubit(draftStore: store, userId: 'user')
          ..titleChanged('Local title');
        cubit.controller.document.insert(0, 'Local ');
        await _settle();
        expect(await cubit.persistLocalDraft(), isTrue);
        expect(await cubit.flush(), isFalse);
        await cubit.close();
        expect(storage.values, hasLength(1));
        final restartStorage = NoteDraftMemoryStorage()
          ..values.addAll(storage.values);
        final restarted = buildCubit(
          draftStore: NoteDraftStore(storage: restartStorage),
          userId: 'user',
        );
        expect(restarted.state.title, 'Local title');
        expect(
          restarted.controller.document.toPlainText(),
          'Local Body text\n',
        );
        expect(restarted.state.hasUnsavedChanges, isTrue);
        restarted.discardChanges();
        await restarted.close();
        expect(restartStorage.values, isEmpty);
      },
    );

    test(
      'recovery rebases a local insertion over a changed server document',
      () async {
        stubSave();
        final storage = NoteDraftMemoryStorage();
        final store = NoteDraftStore(storage: storage);
        await store.write(recoveryDraft());
        final cubit = buildCubit(
          withNote: note.copyWith(content: 'AXB', documentRevision: 2),
          draftStore: store,
          userId: 'user',
        );
        expect(cubit.controller.document.toPlainText(), 'QAXB\n');
        expect(cubit.hasRecoveryConflict, isFalse);
        expect(await cubit.flush(), isTrue);
        verify(
          () => repository.saveGroupNoteDocument(
            id: 'note-1',
            document: [
              {'insert': 'QAXB\n'},
            ],
            expectedRevision: 2,
          ),
        ).called(1);
        expect(storage.values, isEmpty);
        await cubit.close();
      },
    );

    test(
      'an acknowledged draft is cleared without inserting its text twice',
      () async {
        final storage = NoteDraftMemoryStorage();
        final store = NoteDraftStore(storage: storage);
        await store.write(
          recoveryDraft(
            submittedDocument: const [
              {'insert': 'QAB\n'},
            ],
          ),
        );
        final cubit = buildCubit(
          withNote: note.copyWith(content: 'QAB', documentRevision: 1),
          draftStore: store,
          userId: 'user',
        );
        await _settle();
        expect(cubit.controller.document.toPlainText(), 'QAB\n');
        expect(cubit.state.hasUnsavedChanges, isFalse);
        await cubit.close();
        expect(storage.values, isEmpty);
        verifyNever(
          () => repository.saveGroupNoteDocument(
            id: any(named: 'id'),
            document: any(named: 'document'),
            expectedRevision: any(named: 'expectedRevision'),
          ),
        );
      },
    );

    test(
      'recovered formatting and embeds survive another rebase and restart',
      () async {
        stubSave();
        final session = stubRealtime();
        final storage = NoteDraftMemoryStorage();
        final store = NoteDraftStore(storage: storage);
        await store.write(
          const NoteDraft(
            noteId: 'note-1',
            userId: 'user',
            token: 'rich',
            baseRevision: 0,
            baseDocument: [
              {'insert': 'AB\n'},
            ],
            document: [
              {
                'insert': 'Q',
                'attributes': {'bold': true},
              },
              {
                'insert': {'image': 'https://example.com/note.png'},
              },
              {'insert': 'AB\n'},
            ],
            baseTitle: 'Initial',
            title: 'Initial',
          ),
        );
        final remote = note.copyWith(
          content: 'AXB',
          documentRevision: 1,
          isPersonal: false,
        );
        final cubit = buildCubit(
          withNote: remote,
          draftStore: store,
          userId: 'user',
        );
        await _settle();
        session.emitRemoteChange(snapshot(2, 'AXB!'));
        await _settle();
        await cubit.persistLocalDraft();
        final restartStorage = NoteDraftMemoryStorage()
          ..values.addAll(storage.values);
        cubit.discardChanges();
        await cubit.close();
        final restored = buildCubit(
          withNote: remote.copyWith(
            content: 'AXB!',
            documentRevision: 2,
            isPersonal: true,
          ),
          draftStore: NoteDraftStore(storage: restartStorage),
          userId: 'user',
        );
        expect(restored.controller.document.toDelta().toJson(), [
          {
            'insert': 'Q',
            'attributes': {'bold': true},
          },
          {
            'insert': {'image': 'https://example.com/note.png'},
          },
          {'insert': 'AXB!\n'},
        ]);
        expect(await restored.flush(), isTrue);
        expect(restartStorage.values, isEmpty);
        await restored.close();
      },
    );

    test(
      'an ambiguous in-flight save requires an explicit recovery choice',
      () async {
        final storage = NoteDraftMemoryStorage();
        final store = NoteDraftStore(storage: storage);
        await store.write(
          recoveryDraft(
            submittedDocument: const [
              {'insert': 'QAB\n'},
            ],
          ),
        );
        final cubit = buildCubit(
          withNote: note.copyWith(content: 'QAXB', documentRevision: 2),
          draftStore: store,
          userId: 'user',
        );
        expect(cubit.hasRecoveryConflict, isTrue);
        expect(await cubit.flush(), isFalse);
        expect(cubit.controller.document.toPlainText(), 'QAB\n');
        verifyNever(
          () => repository.saveGroupNoteDocument(
            id: any(named: 'id'),
            document: any(named: 'document'),
            expectedRevision: any(named: 'expectedRevision'),
          ),
        );
        cubit.resolveRecoveryConflict(keepLocal: false);
        expect(cubit.controller.document.toPlainText(), 'QAXB\n');
        expect(cubit.hasRecoveryConflict, isFalse);
        await cubit.close();
        expect(storage.values, isEmpty);
      },
    );

    test(
      'a recovered title cannot silently replace a concurrent server rename',
      () async {
        stubSave();
        final storage = NoteDraftMemoryStorage();
        final store = NoteDraftStore(storage: storage);
        await store.write(recoveryDraft(title: 'Local title'));
        final cubit = buildCubit(
          withNote: note.copyWith(content: 'AB', title: 'Remote title'),
          draftStore: store,
          userId: 'user',
        );
        expect(cubit.hasRecoveryConflict, isTrue);
        expect(cubit.recoveryServerTitle, 'Remote title');
        expect(await cubit.flush(), isFalse);
        verifyNever(() => repository.renameGroupNote(any(), any()));
        cubit.resolveRecoveryConflict(keepLocal: false);
        expect(cubit.state.title, 'Remote title');
        expect(cubit.controller.document.toPlainText(), 'QAB\n');
        expect(await cubit.flush(), isTrue);
        expect(storage.values, isEmpty);
        await cubit.close();
      },
    );

    test('missing identity disables local recovery and persistence', () async {
      stubSave();
      final storage = NoteDraftMemoryStorage();
      final store = NoteDraftStore(storage: storage);
      await store.write(recoveryDraft());
      final cubit = buildCubit(draftStore: store);
      expect(cubit.canRecoverLocally, isFalse);
      expect(cubit.controller.document.toPlainText(), 'Body text\n');
      cubit.controller.document.insert(0, 'Unscoped ');
      await _settle();
      expect(await cubit.persistLocalDraft(), isTrue);
      expect(
        store.read(userId: 'user', noteId: 'note-1')?.token,
        'previous-session',
      );
      await cubit.close();
      expect(storage.values, hasLength(1));
    });

    test(
      'a persisted title conflict survives another process restart',
      () async {
        final storage = NoteDraftMemoryStorage();
        final store = NoteDraftStore(storage: storage);
        await store.write(recoveryDraft(title: 'Local title'));
        final remote = note.copyWith(content: 'AB', title: 'Remote title');
        final first = buildCubit(
          withNote: remote,
          draftStore: store,
          userId: 'user',
        );
        await first.close();
        final restartedStorage = NoteDraftMemoryStorage()
          ..values.addAll(storage.values);
        final second = buildCubit(
          withNote: remote,
          draftStore: NoteDraftStore(storage: restartedStorage),
          userId: 'user',
        );
        expect(second.hasRecoveryConflict, isTrue);
        expect(await second.flush(), isFalse);
        verifyNever(() => repository.renameGroupNote(any(), any()));
        second.discardChanges();
        await second.close();
      },
    );

    test(
      'close releases the editor after a stalled save '
      'and preserves recovery for its late acknowledgement',
      () async {
        final storage = NoteDraftMemoryStorage();
        final store = NoteDraftStore(storage: storage);
        final save = Completer<GroupNoteDocumentSaveResult>();
        when(
          () => repository.saveGroupNoteDocument(
            id: any(named: 'id'),
            document: any(named: 'document'),
            expectedRevision: any(named: 'expectedRevision'),
          ),
        ).thenAnswer((_) => save.future);
        final cubit = buildCubit(
          draftStore: store,
          userId: 'user',
          closeTimeout: const Duration(milliseconds: 10),
        );
        expect(cubit.canRecoverLocally, isTrue);
        cubit.controller.document.insert(0, 'Local ');
        await _settle();
        final flushing = cubit.flush();
        await _settle();
        await cubit.close();
        expect(cubit.isClosed, isTrue);
        expect(storage.values, hasLength(1));
        save.complete(
          saved(1, [
            {'insert': 'Local Body text\n'},
          ]),
        );
        expect(await flushing, isFalse);
        final restartedStorage = NoteDraftMemoryStorage()
          ..values.addAll(storage.values);
        final restored = buildCubit(
          withNote: note.copyWith(
            content: 'Local Body text',
            documentRevision: 1,
          ),
          draftStore: NoteDraftStore(storage: restartedStorage),
          userId: 'user',
        );
        expect(restored.controller.document.toPlainText(), 'Local Body text\n');
        expect(restored.state.hasUnsavedChanges, isFalse);
        await restored.close();
        expect(restartedStorage.values, isEmpty);
      },
    );

    test(
      'a local storage error preserves the existing disk draft '
      'and permits retry',
      () async {
        stubOffline();
        final storage = NoteDraftMemoryStorage();
        final store = NoteDraftStore(storage: storage);
        final cubit = buildCubit(draftStore: store, userId: 'user');
        cubit.controller.document.insert(0, 'First ');
        await _settle();
        await cubit.persistLocalDraft();
        storage.failWrites = true;
        cubit.controller.document.insert(0, 'Latest ');
        await _settle();
        expect(await cubit.persistLocalDraft(), isFalse);
        expect(cubit.localDraftSaveFailed, isTrue);
        expect(NoteDraft.fromJson(storage.values.values.single)?.document, [
          {'insert': 'First Body text\n'},
        ]);
        storage.failWrites = false;
        expect(await cubit.persistLocalDraft(), isTrue);
        expect(cubit.localDraftSaveFailed, isFalse);
        await cubit.close();
        expect(NoteDraft.fromJson(storage.values.values.single)?.document, [
          {'insert': 'Latest First Body text\n'},
        ]);
      },
    );

    test('voice ignores read-only and stale session results', () async {
      stubSave();
      final speech = _MockSpeech();
      final callbacks = <SpeechResultListener>[];
      when(
        () => speech.initialize(onError: any(named: 'onError')),
      ).thenAnswer((_) async => true);
      when(
        () => speech.listen(
          onResult: any(named: 'onResult'),
          listenOptions: any(named: 'listenOptions'),
        ),
      ).thenAnswer((call) async {
        callbacks.add(call.namedArguments[#onResult] as SpeechResultListener);
      });
      when(speech.stop).thenAnswer((_) async {});
      when(speech.cancel).thenAnswer((_) async {});
      final cubit = buildCubit(speech: speech);
      await cubit.startVoiceInput(mutedColorHex: '#999999');
      final words = SpeechRecognitionResult.init([
        const SpeechRecognitionWords('Voice ', null, 1),
      ], ResultType.finalResult);
      cubit.controller.readOnly = true;
      callbacks.first(words);
      expect(cubit.controller.document.toPlainText(), 'Body text\n');
      await cubit.stopVoiceInput();
      cubit.controller.readOnly = false;
      await cubit.startVoiceInput(mutedColorHex: '#999999');
      callbacks.first(words);
      expect(cubit.controller.document.toPlainText(), 'Body text\n');
      callbacks.last(words);
      expect(cubit.controller.document.toPlainText(), 'Voice Body text\n');
      await _settle();
      await cubit.close();
      await cubit.close();
      verify(speech.cancel).called(1);
    });

    test(
      'read-only during speech initialization never starts listening',
      () async {
        final speech = _MockSpeech();
        final initialize = Completer<bool>();
        when(
          () => speech.initialize(onError: any(named: 'onError')),
        ).thenAnswer((_) => initialize.future);
        when(speech.cancel).thenAnswer((_) async {});
        final cubit = buildCubit(speech: speech);
        final starting = cubit.startVoiceInput(mutedColorHex: '#999999');
        cubit.controller.readOnly = true;
        initialize.complete(true);
        await starting;
        expect(cubit.state.voiceStatus, NoteVoiceStatus.idle);
        verifyNever(
          () => speech.listen(
            onResult: any(named: 'onResult'),
            listenOptions: any(named: 'listenOptions'),
          ),
        );
        await cubit.close();
      },
    );
  });
}
