import 'package:flutter_test/flutter_test.dart';
import 'package:rtu_mirea_app/community/view/deadlines/deadline_groups.dart';
import 'package:schedule_repository/schedule_repository.dart';

Deadline _deadline({
  required DateTime dueAt,
  bool isDone = false,
  String id = '1',
}) {
  return Deadline(
    id: id,
    title: 'T',
    dueAt: dueAt,
    source: DeadlineSource.me,
    isDone: isDone,
    isMine: true,
  );
}

void main() {
  final now = DateTime(2026, 9, 3, 12);

  group('deadlineGroupKind', () {
    test('a done deadline is always in the done group', () {
      final deadline = _deadline(
        dueAt: now.add(const Duration(hours: 1)),
        isDone: true,
      );
      expect(deadlineGroupKind(deadline, now: now), DeadlineGroupKind.done);
    });

    test('a past-due deadline is overdue regardless of same-day time', () {
      final deadline = _deadline(
        dueAt: now.subtract(const Duration(minutes: 1)),
      );
      expect(deadlineGroupKind(deadline, now: now), DeadlineGroupKind.overdue);
    });

    test('due later today is today, not overdue', () {
      final deadline = _deadline(dueAt: DateTime(2026, 9, 3, 23, 59));
      expect(deadlineGroupKind(deadline, now: now), DeadlineGroupKind.today);
    });

    test('due tomorrow is tomorrow', () {
      final deadline = _deadline(dueAt: DateTime(2026, 9, 4, 8));
      expect(
        deadlineGroupKind(deadline, now: now),
        DeadlineGroupKind.tomorrow,
      );
    });

    test('due within a week is week', () {
      final deadline = _deadline(dueAt: DateTime(2026, 9, 8, 8));
      expect(deadlineGroupKind(deadline, now: now), DeadlineGroupKind.week);
    });

    test('due beyond a week is later', () {
      final deadline = _deadline(dueAt: DateTime(2026, 9, 20, 8));
      expect(deadlineGroupKind(deadline, now: now), DeadlineGroupKind.later);
    });
  });

  group('deadlineGroups', () {
    test('buckets and sorts each group by due date', () {
      final overdue = _deadline(
        id: 'overdue',
        dueAt: now.subtract(const Duration(hours: 2)),
      );
      final todayLate = _deadline(
        id: 'today-late',
        dueAt: DateTime(2026, 9, 3, 23),
      );
      final todayEarly = _deadline(
        id: 'today-early',
        dueAt: DateTime(2026, 9, 3, 18),
      );
      final done = _deadline(
        id: 'done',
        dueAt: now.add(const Duration(hours: 1)),
        isDone: true,
      );

      final groups = deadlineGroups(
        [overdue, todayLate, todayEarly, done],
        now: now,
      );

      expect(groups[DeadlineGroupKind.overdue], [overdue]);
      expect(groups[DeadlineGroupKind.today], [todayEarly, todayLate]);
      expect(groups[DeadlineGroupKind.done], [done]);
      expect(groups[DeadlineGroupKind.tomorrow], isEmpty);
    });

    test('exposes every kind in display order', () {
      expect(deadlineGroupOrder, [
        DeadlineGroupKind.overdue,
        DeadlineGroupKind.today,
        DeadlineGroupKind.tomorrow,
        DeadlineGroupKind.week,
        DeadlineGroupKind.later,
        DeadlineGroupKind.done,
      ]);
    });
  });
}
