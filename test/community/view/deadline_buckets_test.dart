import 'package:flutter_test/flutter_test.dart';
import 'package:rtu_mirea_app/community/view/deadline_buckets.dart';
import 'package:schedule_repository/schedule_repository.dart';

Deadline _deadline({
  required Duration dueIn,
  bool isDone = false,
  DeadlinePriority priority = .medium,
}) {
  return Deadline(
    id: '1',
    title: 'T',
    subjectName: 'S',
    dueAt: DateTime.now().add(dueIn),
    source: .me,
    priority: priority,
    isDone: isDone,
    isMine: true,
  );
}

void main() {
  group('deadlineBucket', () {
    test('a done deadline is bucketed as done regardless of due date', () {
      expect(
        deadlineBucket(
          _deadline(dueIn: const Duration(hours: 1), isDone: true),
        ),
        DeadlineBucket.done,
      );
    });

    test('a deadline due within 48h is hot', () {
      expect(
        deadlineBucket(_deadline(dueIn: const Duration(hours: 30))),
        DeadlineBucket.hot,
      );
    });

    test('an urgent-priority deadline is hot even if far away', () {
      expect(
        deadlineBucket(
          _deadline(
            dueIn: const Duration(days: 20),
            priority: .urgent,
          ),
        ),
        DeadlineBucket.hot,
      );
    });

    test('a deadline due within a week (not urgent) is in the week bucket', () {
      expect(
        deadlineBucket(_deadline(dueIn: const Duration(days: 4))),
        DeadlineBucket.week,
      );
    });

    test('a deadline due beyond a week is in the later bucket', () {
      expect(
        deadlineBucket(_deadline(dueIn: const Duration(days: 20))),
        DeadlineBucket.later,
      );
    });
  });
}
