import 'package:flutter_test/flutter_test.dart';
import 'package:local_notifications_client/local_notifications_client.dart';

void main() {
  group('PendingReminder', () {
    test('has value equality', () {
      expect(
        const PendingReminder(id: 1, payload: 'lesson'),
        equals(const PendingReminder(id: 1, payload: 'lesson')),
      );
    });
  });
}
