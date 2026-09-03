import 'dart:async';

import 'package:campus_repository/src/models/collab_note_change.dart';

abstract interface class CollabNoteRealtimeSession {
  Stream<List<String>> get editors;

  Stream<CollabNoteChange> get changes;

  Stream<void> get connections;

  Future<void> broadcastChange(CollabNoteChange change);

  Future<void> close();
}
