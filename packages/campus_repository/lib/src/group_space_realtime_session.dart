import 'dart:async';

abstract interface class GroupSpaceRealtimeSession {
  Stream<void> get changes;

  Future<void> close();
}
