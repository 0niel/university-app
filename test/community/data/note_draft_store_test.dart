import 'dart:async';
import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:rtu_mirea_app/community/data/note_draft_store.dart';

import '../../helpers/fakes/note_draft_memory_storage.dart';

class _JsonReadingStorage extends NoteDraftMemoryStorage {
  @override
  Object? read(String key) {
    final value = super.read(key);
    return value is String ? jsonDecode(value) : value;
  }
}

void main() {
  NoteDraft draft(String token, {String user = 'user', String note = 'note'}) =>
      NoteDraft(
        noteId: note,
        userId: user,
        token: token,
        baseRevision: 3,
        baseDocument: const [
          {'insert': 'Base\n'},
        ],
        document: [
          {'insert': '$token\n'},
        ],
        baseTitle: 'Title',
        title: token,
      );

  test(
    'serializes writes and removal across instances sharing storage',
    () async {
      final storage = NoteDraftMemoryStorage();
      final first = NoteDraftStore(storage: storage);
      final second = NoteDraftStore(storage: storage);
      final gate = Completer<void>();
      storage.nextWrite = gate;
      final one = first.write(draft('first'));
      final two = second.write(draft('second'));
      final remove = second.remove(
        userId: 'user',
        noteId: 'note',
        token: 'second',
      );
      await Future<void>.delayed(Duration.zero);
      expect(storage.calls, ['write']);
      gate.complete();
      await Future.wait([one, two, remove]);
      expect(storage.calls, ['write', 'write', 'delete']);
      expect(storage.values, isEmpty);
    },
  );

  test('stale acknowledgement cannot delete a newer editor draft', () async {
    final storage = NoteDraftMemoryStorage();
    final store = NoteDraftStore(storage: storage);
    await store.write(draft('old'));
    await NoteDraftStore(storage: storage).write(draft('new'));
    await store.remove(userId: 'user', noteId: 'note', token: 'old');
    expect(store.read(userId: 'user', noteId: 'note')?.token, 'new');
    expect(storage.calls, ['write', 'write']);
  });

  test('a stale editor cannot overwrite a newer session checkpoint', () async {
    final storage = NoteDraftMemoryStorage();
    final store = NoteDraftStore(storage: storage);
    expect(
      await store.writeIfCurrent(draft('old'), expectedToken: null),
      isTrue,
    );
    expect(
      await store.writeIfCurrent(draft('new'), expectedToken: 'old'),
      isTrue,
    );
    expect(
      await store.writeIfCurrent(draft('stale'), expectedToken: 'old'),
      isFalse,
    );
    expect(store.read(userId: 'user', noteId: 'note')?.token, 'new');
    expect(storage.calls, ['write', 'write']);
  });

  test(
    'isolates identities and tolerates unsupported or corrupt records',
    () async {
      final storage = NoteDraftMemoryStorage();
      final store = NoteDraftStore(storage: storage);
      await store.write(draft('one'));
      expect(store.read(userId: 'other', noteId: 'note'), isNull);
      expect(store.read(userId: 'user', noteId: 'other'), isNull);
      final key = storage.values.keys.single;
      for (final value in [
        null,
        {'schema': 99},
        {'schema': 1, 'noteId': 7},
      ]) {
        final fresh = NoteDraftMemoryStorage()..values[key] = value;
        expect(
          NoteDraftStore(storage: fresh).read(userId: 'user', noteId: 'note'),
          isNull,
        );
      }
    },
  );

  test('a corrupt platform value is retained until a valid write', () async {
    final seed = NoteDraftMemoryStorage();
    await NoteDraftStore(storage: seed).write(draft('seed'));
    final key = seed.values.keys.single;
    final storage = _JsonReadingStorage()..values[key] = '{';
    final store = NoteDraftStore(storage: storage);

    expect(store.read(userId: 'user', noteId: 'note'), isNull);
    expect(storage.values[key], '{');
    expect(storage.calls, isEmpty);
    expect(
      await store.writeIfCurrent(draft('recovered'), expectedToken: null),
      isTrue,
    );
    expect(store.read(userId: 'user', noteId: 'note')?.token, 'recovered');
    expect(NoteDraft.fromJson(storage.values[key])?.token, 'recovered');
  });

  test(
    'failed persistence does not block later writes '
    'or discard the last disk copy',
    () async {
      final storage = NoteDraftMemoryStorage();
      final store = NoteDraftStore(storage: storage);
      await store.write(draft('saved'));
      storage.failWrites = true;
      await expectLater(store.write(draft('new')), throwsStateError);
      expect(NoteDraft.fromJson(storage.values.values.single)?.token, 'saved');
      storage.failWrites = false;
      await store.write(draft('new'));
      storage.failDeletes = true;
      await expectLater(
        store.remove(userId: 'user', noteId: 'note', token: 'new'),
        throwsStateError,
      );
      expect(store.read(userId: 'user', noteId: 'note')?.token, 'new');
      storage.failDeletes = false;
      await store.remove(userId: 'user', noteId: 'note', token: 'new');
      expect(storage.values, isEmpty);
    },
  );
}
