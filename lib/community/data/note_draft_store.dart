import 'dart:convert';

import 'package:hydrated_bloc/hydrated_bloc.dart';

class NoteDraft {
  const NoteDraft({
    required this.noteId,
    required this.userId,
    required this.token,
    required this.baseRevision,
    required this.baseDocument,
    required this.document,
    required this.baseTitle,
    required this.title,
    this.submittedDocument,
    this.submittedTitle,
    this.titleConflict = false,
  });

  final String noteId;
  final String userId;
  final String token;
  final int baseRevision;
  final List<Object?> baseDocument;
  final List<Object?> document;
  final String baseTitle;
  final String title;
  final List<Object?>? submittedDocument;
  final String? submittedTitle;
  final bool titleConflict;

  Map<String, Object?> toJson() => {
    'schema': 1,
    'noteId': noteId,
    'userId': userId,
    'token': token,
    'baseRevision': baseRevision,
    'baseDocument': baseDocument,
    'document': document,
    'baseTitle': baseTitle,
    'title': title,
    'submittedDocument': submittedDocument,
    'submittedTitle': submittedTitle,
    'titleConflict': titleConflict,
  };

  static NoteDraft? fromJson(Object? value) {
    if (value is! Map || value['schema'] != 1) return null;
    try {
      final draft = NoteDraft(
        noteId: value['noteId'] as String,
        userId: value['userId'] as String,
        token: value['token'] as String,
        baseRevision: value['baseRevision'] as int,
        baseDocument: List<Object?>.from(value['baseDocument'] as List),
        document: List<Object?>.from(value['document'] as List),
        baseTitle: value['baseTitle'] as String,
        title: value['title'] as String,
        submittedDocument: value['submittedDocument'] == null
            ? null
            : List<Object?>.from(value['submittedDocument'] as List),
        submittedTitle: value['submittedTitle'] as String?,
        titleConflict: value['titleConflict'] == true,
      );
      return draft.baseRevision >= 0 ? draft : null;
    } on Object {
      return null;
    }
  }
}

class NoteDraftStore {
  NoteDraftStore({required Storage storage})
    : _storage = storage,
      _queue = _queues[storage] ??= _DraftQueue();

  static final _queues = Expando<_DraftQueue>();
  final Storage _storage;
  final _DraftQueue _queue;

  String _key(String userId, String noteId) {
    final identity = base64Url.encode(
      utf8.encode(jsonEncode([userId, noteId])),
    );
    return 'note_draft.v1.$identity';
  }

  NoteDraft? read({required String userId, required String noteId}) {
    final key = _key(userId, noteId);
    try {
      final draft = NoteDraft.fromJson(
        _queue.cache.containsKey(key) ? _queue.cache[key] : _storage.read(key),
      );
      return draft?.userId == userId && draft?.noteId == noteId ? draft : null;
    } on Object {
      return null;
    }
  }

  Future<void> write(NoteDraft draft) {
    final key = _key(draft.userId, draft.noteId);
    final payload = jsonDecode(jsonEncode(draft.toJson())) as Object?;
    _queue.cache[key] = payload;
    return _queue.append(key, () => _storage.write(key, payload));
  }

  Future<bool> writeIfCurrent(
    NoteDraft draft, {
    required String? expectedToken,
  }) async {
    if (read(userId: draft.userId, noteId: draft.noteId)?.token !=
        expectedToken) {
      return false;
    }
    await write(draft);
    return true;
  }

  Future<void> remove({
    required String userId,
    required String noteId,
    required String token,
  }) {
    final key = _key(userId, noteId);
    if (read(userId: userId, noteId: noteId)?.token != token) {
      return Future<void>.value();
    }
    final previous = _queue.cache[key] ?? _storage.read(key);
    _queue.cache[key] = null;
    return _queue.append(key, () async {
      try {
        await _storage.delete(key);
      } on Object {
        if (_queue.cache[key] == null) _queue.cache[key] = previous;
        rethrow;
      }
    });
  }
}

class _DraftQueue {
  final cache = <String, Object?>{};
  final _tails = <String, Future<void>>{};

  Future<void> append(String key, Future<void> Function() action) {
    final previous = _tails[key] ?? Future<void>.value();
    final next = previous.then(
      (_) => action(),
      onError: (Object _) => action(),
    );
    _tails[key] = next.then<void>((_) {}, onError: (Object _) {});
    return next;
  }
}
