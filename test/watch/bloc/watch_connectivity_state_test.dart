import 'package:flutter_test/flutter_test.dart';
import 'package:rtu_mirea_app/watch/bloc/bloc.dart';
import 'package:rtu_mirea_app/watch/models/models.dart';

void main() {
  test('copies a new message without mutating the previous state', () {
    const initial = WatchConnectivityState();
    final message = WatchMessage.fromMap({'action': 'requestPassId'});

    final updated = initial.copyWith(lastMessage: message);

    expect(initial.lastMessage, isNull);
    expect(updated.lastMessage, message);
    expect(updated.isConnected, isFalse);
  });
}
