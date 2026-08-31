import 'package:collection/collection.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mini_apps_repository/mini_apps_repository.dart';

void main() {
  group('MiniAppsModerationQueue.fromJson', () {
    test('deserializes pending apps and nested reports', () {
      final queue = MiniAppsModerationQueue.fromJson(const {
        'pending': [
          {'id': 'pending-1', 'slug': 'calendar', 'name': 'Calendar'},
        ],
        'reported': [
          {
            'app': {'id': 'reported-1', 'slug': 'notes', 'name': 'Notes'},
            'reports': [
              {
                'id': 'report-1',
                'reason': 'spam',
                'details': 'Repeated promotions',
              },
            ],
          },
        ],
      });

      expect(queue.pending.singleOrNull?.slug, 'calendar');
      expect(queue.reported.singleOrNull?.app.slug, 'notes');
      expect(
        queue.reported.singleOrNull?.reports.singleOrNull?.reason,
        MiniAppReportReason.spam,
      );
      expect(queue.isEmpty, isFalse);
    });

    test('uses empty lists for an absent payload', () {
      expect(MiniAppsModerationQueue.fromJson(const {}).isEmpty, isTrue);
    });
  });
}
