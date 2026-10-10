import 'package:schedule_fetcher/reingest_plan.dart';
import 'package:test/test.dart';

void main() {
  const keys = ['group:3', 'classroom:1', 'teacher:2', 'group:1', 'group:2'];

  test('takes the first slice in sorted order from an empty cursor', () {
    final plan = planUnchangedReingest(
      targetKeys: keys,
      cursor: '',
      budget: 2,
    );
    expect(plan.due, {'classroom:1', 'group:1'});
    expect(plan.nextCursor, 'group:1');
    expect(plan.wrapped, isFalse);
  });

  test('resumes after the cursor', () {
    final plan = planUnchangedReingest(
      targetKeys: keys,
      cursor: 'group:1',
      budget: 2,
    );
    expect(plan.due, {'group:2', 'group:3'});
    expect(plan.nextCursor, 'group:3');
    expect(plan.wrapped, isFalse);
  });

  test('wraps and clears the cursor when the tail fits the budget', () {
    final plan = planUnchangedReingest(
      targetKeys: keys,
      cursor: 'group:3',
      budget: 2,
    );
    expect(plan.due, {'teacher:2'});
    expect(plan.nextCursor, '');
    expect(plan.wrapped, isTrue);
  });

  test('covers every target across consecutive runs', () {
    final seen = <String>{};
    var cursor = '';
    var runs = 0;
    while (true) {
      final plan = planUnchangedReingest(
        targetKeys: keys,
        cursor: cursor,
        budget: 2,
      );
      seen.addAll(plan.due);
      runs++;
      if (plan.wrapped) break;
      cursor = plan.nextCursor;
    }
    expect(seen, keys.toSet());
    expect(runs, 3);
  });

  test('a stale cursor past every key wraps with nothing due', () {
    final plan = planUnchangedReingest(
      targetKeys: keys,
      cursor: 'zzz',
      budget: 2,
    );
    expect(plan.due, isEmpty);
    expect(plan.nextCursor, '');
    expect(plan.wrapped, isTrue);
  });

  test('a non-positive budget schedules nothing', () {
    final plan = planUnchangedReingest(
      targetKeys: keys,
      cursor: '',
      budget: 0,
    );
    expect(plan.due, isEmpty);
    expect(plan.wrapped, isFalse);
  });
}
