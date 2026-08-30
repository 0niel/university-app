import 'package:flutter_test/flutter_test.dart';
import 'package:rtu_mirea_app/watch/models/models.dart';

void main() {
  test('preserves an unknown watch action without throwing', () {
    final message = WatchMessage.fromMap({
      'action': 'futureAction',
      'payload': 'value',
    });

    expect(message.action, WatchMessageAction.unknown);
    expect(message.data, {'action': 'futureAction', 'payload': 'value'});
  });

  test('round-trips a serialized message', () {
    final message = WatchMessage.fromJson({
      'action': 'requestSchedule',
      'data': {'scheduleId': '123'},
    });

    expect(message.action, WatchMessageAction.requestSchedule);
    expect(message.toJson(), {
      'action': 'requestSchedule',
      'data': {'scheduleId': '123'},
    });
  });
}
