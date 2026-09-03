import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rtu_mirea_app/community/view/deadlines/deadline_labels.dart';
import 'package:schedule_repository/schedule_repository.dart';

import '../../helpers/pump_app.dart';

Deadline _deadline({
  required DateTime dueAt,
  bool isDone = false,
  DeadlinePriority priority = DeadlinePriority.medium,
  String subjectName = '',
}) {
  return Deadline(
    id: '1',
    title: 'T',
    subjectName: subjectName,
    dueAt: dueAt,
    source: DeadlineSource.me,
    priority: priority,
    isDone: isDone,
    isMine: true,
  );
}

void main() {
  Future<BuildContext> pumpContext(WidgetTester tester) async {
    late BuildContext captured;
    await tester.pumpApp(
      Builder(
        builder: (context) {
          captured = context;
          return const SizedBox.shrink();
        },
      ),
    );
    return captured;
  }

  group('deadlineDateLabel', () {
    testWidgets('formats today as "сегодня, HH:mm"', (tester) async {
      final context = await pumpContext(tester);
      final now = DateTime(2026, 9, 3, 10);
      final due = DateTime(2026, 9, 3, 23, 59);
      expect(
        deadlineDateLabel(context, due, now: now),
        'сегодня, 23:59',
      );
    });

    testWidgets('formats tomorrow as "завтра, HH:mm"', (tester) async {
      final context = await pumpContext(tester);
      final now = DateTime(2026, 9, 3, 10);
      final due = DateTime(2026, 9, 4, 18);
      expect(
        deadlineDateLabel(context, due, now: now),
        'завтра, 18:00',
      );
    });

    testWidgets('formats a within-week date as weekday, date', (
      tester,
    ) async {
      final context = await pumpContext(tester);
      final now = DateTime(2026, 9, 3, 10);
      final due = DateTime(2026, 9, 6, 12);
      final label = deadlineDateLabel(context, due, now: now);
      expect(label, contains(','));
      expect(label, isNot(contains(':')));
    });

    testWidgets('formats a far date as "d MMM · HH:mm"', (tester) async {
      final context = await pumpContext(tester);
      final now = DateTime(2026, 9, 3, 10);
      final due = DateTime(2026, 10, 15, 23, 59);
      final label = deadlineDateLabel(context, due, now: now);
      expect(label, contains('·'));
      expect(label, contains('23:59'));
    });
  });

  group('deadlineMetaLabel', () {
    testWidgets('joins subject and date with a middle dot', (tester) async {
      final context = await pumpContext(tester);
      final now = DateTime(2026, 9, 3, 10);
      final deadline = _deadline(
        dueAt: DateTime(2026, 9, 3, 23, 59),
        subjectName: 'Математика',
      );
      expect(
        deadlineMetaLabel(context, deadline, now: now),
        'Математика · сегодня, 23:59',
      );
    });

    testWidgets('omits the subject separator when empty', (tester) async {
      final context = await pumpContext(tester);
      final now = DateTime(2026, 9, 3, 10);
      final deadline = _deadline(dueAt: DateTime(2026, 9, 3, 23, 59));
      expect(
        deadlineMetaLabel(context, deadline, now: now),
        'сегодня, 23:59',
      );
    });
  });

  group('deadlineLeftLabel', () {
    testWidgets('shows "через N ч" under 24h', (tester) async {
      final context = await pumpContext(tester);
      final now = DateTime(2026, 9, 3, 10);
      final deadline = _deadline(dueAt: now.add(const Duration(hours: 2)));
      expect(deadlineLeftLabel(context, deadline, now: now), 'через 2 ч');
    });

    testWidgets('shows "через N дня" for multi-day windows', (tester) async {
      final context = await pumpContext(tester);
      final now = DateTime(2026, 9, 3, 10);
      final deadline = _deadline(dueAt: now.add(const Duration(days: 3)));
      expect(deadlineLeftLabel(context, deadline, now: now), 'через 3 дня');
    });

    testWidgets('shows overdue-by-days once a day has passed', (
      tester,
    ) async {
      final context = await pumpContext(tester);
      final now = DateTime(2026, 9, 3, 10);
      final deadline = _deadline(
        dueAt: now.subtract(const Duration(days: 1, hours: 1)),
      );
      expect(deadlineLeftLabel(context, deadline, now: now), 'просрочено 1 д');
    });

    testWidgets('shows done label for completed deadlines', (tester) async {
      final context = await pumpContext(tester);
      final deadline = _deadline(dueAt: DateTime(2026, 9, 3), isDone: true);
      expect(deadlineLeftLabel(context, deadline), 'готово');
    });
  });

  group('deadlineUrgencyTierAt', () {
    test('done overrides urgency', () {
      final now = DateTime(2026, 9, 3, 10);
      final deadline = _deadline(
        dueAt: now.add(const Duration(hours: 1)),
        isDone: true,
      );
      expect(deadlineUrgencyTierAt(deadline, now), DeadlineUrgencyTier.done);
    });

    test('danger under 48h or urgent priority', () {
      final now = DateTime(2026, 9, 3, 10);
      final deadline = _deadline(dueAt: now.add(const Duration(hours: 10)));
      expect(
        deadlineUrgencyTierAt(deadline, now),
        DeadlineUrgencyTier.danger,
      );
    });

    test('warn under 3 days', () {
      final now = DateTime(2026, 9, 3, 10);
      final deadline = _deadline(dueAt: now.add(const Duration(days: 2)));
      expect(deadlineUrgencyTierAt(deadline, now), DeadlineUrgencyTier.warn);
    });

    test('normal beyond the warn window', () {
      final now = DateTime(2026, 9, 3, 10);
      final deadline = _deadline(dueAt: now.add(const Duration(days: 10)));
      expect(
        deadlineUrgencyTierAt(deadline, now),
        DeadlineUrgencyTier.normal,
      );
    });
  });
}
