import 'dart:async';

abstract interface class GroupSpacePresenceSession {
  Stream<int> get onlineCount;

  Future<void> close();
}
