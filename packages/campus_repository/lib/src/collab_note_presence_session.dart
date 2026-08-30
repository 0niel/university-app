import 'dart:async';

abstract interface class CollabNotePresenceSession {
  Stream<List<String>> get editors;

  Future<void> close();
}
