import 'package:flutter_test/flutter_test.dart';
import 'package:rtu_mirea_app/schedule/models/models.dart';

void main() {
  group('ReactionCounts', () {
    test('reads sparse legacy JSON and defaults missing reactions to zero', () {
      final counts = ReactionCounts.fromJson(
        const {'love': 2, 'sad': 3, 'flushed': 1, 'sick': 4, 'poo': 5},
      );

      expect(counts.love, 2);
      expect(counts.fire, 0);
      expect(counts.sad, 3);
      expect(counts.flushed, 1);
      expect(counts.sick, 4);
      expect(counts.poo, 5);
      expect(counts.total, 15);
    });

    test('writes only positive counts', () {
      const counts = ReactionCounts(love: 2, brain: 1);

      expect(counts.toJson(), {'brain': 1, 'love': 2});
    });

    test('rejects invalid JSON counts', () {
      for (final value in <Object>[-1, 1.5, double.nan, '1']) {
        expect(
          () => ReactionCounts.fromJson({'love': value}),
          throwsFormatException,
          reason: 'value: $value',
        );
      }
    });

    test('increments and clamps decrements at zero', () {
      const counts = ReactionCounts(love: 1);

      expect(counts.incremented(.love).love, 2);
      expect(counts.decremented(.love).isEmpty, isTrue);
      expect(counts.decremented(.fire), counts);
      expect(counts.decremented(null), counts);
    });
  });
}
