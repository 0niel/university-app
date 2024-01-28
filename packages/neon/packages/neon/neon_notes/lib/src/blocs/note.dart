import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:meta/meta.dart';
import 'package:neon_framework/blocs.dart';
import 'package:neon_framework/models.dart';
import 'package:neon_notes/src/blocs/notes.dart';
import 'package:neon_notes/src/options.dart';
import 'package:nextcloud/nextcloud.dart';
import 'package:nextcloud/notes.dart' as notes;
import 'package:queue/queue.dart';
import 'package:rxdart/rxdart.dart';

sealed class NotesNoteBloc implements InteractiveBloc {
  @internal
  factory NotesNoteBloc(
    NotesBloc notesBloc,
    Account account,
    notes.Note note,
  ) =>
      _NotesNoteBloc(
        notesBloc,
        account,
        note,
      );

  void updateContent(String content);

  void updateTitle(String title);

  void updateCategory(String category);

  BehaviorSubject<String> get category;

  NotesOptions get options;

  String get initialContent;

  String get initialTitle;
}

class _NotesNoteBloc extends InteractiveBloc implements NotesNoteBloc {
  _NotesNoteBloc(
    this.notesBloc,
    this.account,
    notes.Note note,
  ) {
    emitNote(note);
    id = note.id;
    initialContent = note.content;
    initialTitle = note.title;
  }

  void emitNote(notes.Note note) {
    category.add(note.category);
    etag = note.etag;
  }

  // ignore: avoid_void_async
  void wrapNoteAction(Future<DynamiteResponse<notes.Note, dynamic>> Function(String etag) call) async {
    await updateQueue.add(() async {
      try {
        final response = await call(etag);
        emitNote(response.body);
        await notesBloc.refresh();
      } catch (e, s) {
        debugPrint(e.toString());
        debugPrint(s.toString());
        addError(e);
      }
    });
  }

  @override
  NotesOptions get options => notesBloc.options;

  final NotesBloc notesBloc;
  final Account account;
  final updateQueue = Queue();

  late final int id;
  @override
  late final String initialContent;
  @override
  late final String initialTitle;
  late String etag;

  @override
  void dispose() {
    unawaited(category.close());
    super.dispose();
  }

  @override
  BehaviorSubject<String> category = BehaviorSubject<String>();

  @override
  Future<void> refresh() async {}

  @override
  void updateCategory(String category) {
    wrapNoteAction(
      (etag) async => account.client.notes.updateNote(
        id: id,
        category: category,
        ifMatch: '"$etag"',
      ),
    );
  }

  @override
  void updateContent(String content) {
    wrapNoteAction(
      (etag) async => account.client.notes.updateNote(
        id: id,
        content: content,
        ifMatch: '"$etag"',
      ),
    );
  }

  @override
  void updateTitle(String title) {
    wrapNoteAction(
      (etag) async => account.client.notes.updateNote(
        id: id,
        title: title,
        ifMatch: '"$etag"',
      ),
    );
  }
}
