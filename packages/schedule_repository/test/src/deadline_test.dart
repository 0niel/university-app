import 'package:json_annotation/json_annotation.dart';
import 'package:schedule_repository/schedule_repository.dart';
import 'package:test/test.dart';

void main() {
  group('Deadline', () {
    test('round-trips RPC wire values with checked JSON', () {
      final deadline = Deadline.fromJson({
        'id': 'deadline-1',
        'title': 'Lab report',
        'subjectName': 'Physics',
        'dueAt': '2026-09-01T12:00:00.000Z',
        'source': 'group',
        'priority': 'urgent',
        'remind': false,
        'progress': 40,
        'isDone': false,
        'isMine': true,
      });

      expect(deadline.source, DeadlineSource.group);
      expect(deadline.priority, DeadlinePriority.urgent);
      expect(deadline.dueAt.isUtc, isFalse);
      expect(deadline.toJson(), {
        'id': 'deadline-1',
        'title': 'Lab report',
        'subjectName': 'Physics',
        'dueAt': '2026-09-01T12:00:00.000Z',
        'source': 'group',
        'progress': 40,
        'isDone': false,
        'isMine': true,
        'priority': 'urgent',
        'remind': false,
        'remindMinutes': 60,
      });
    });

    test('uses safe enum defaults for unknown server values', () {
      final deadline = Deadline.fromJson({
        'id': 'deadline-1',
        'title': 'Lab report',
        'subjectName': '',
        'dueAt': '2026-09-01T12:00:00.000Z',
        'source': 'future-source',
        'priority': 'future-priority',
        'progress': 0,
        'isDone': false,
        'isMine': true,
      });

      expect(deadline.source, DeadlineSource.me);
      expect(deadline.priority, DeadlinePriority.medium);
      expect(deadline.remind, isTrue);
    });

    test('copyWith participates in complete value equality', () {
      final deadline = Deadline(
        id: 'deadline-1',
        title: 'Lab report',
        subjectName: 'Physics',
        dueAt: DateTime(2026, 9, 1, 12),
        source: DeadlineSource.me,
        isMine: true,
      );

      expect(deadline.copyWith(), deadline);
      expect(deadline.copyWith(remind: false), isNot(deadline));
      expect(deadline.copyWith(isDone: true).isDone, isTrue);
    });

    test('rejects an invalid required timestamp', () {
      expect(
        () => Deadline.fromJson({
          'id': 'deadline-1',
          'title': 'Lab report',
          'subjectName': '',
          'dueAt': 'not-a-date',
          'source': 'me',
          'progress': 0,
          'isDone': false,
          'isMine': true,
        }),
        throwsA(isA<CheckedFromJsonException>()),
      );
    });

    test('rejects unsafe identity and progress values', () {
      Map<String, Object?> payload({
        required Object? id,
        Object? progress = 0,
      }) {
        return {
          'id': id,
          'title': 'Lab report',
          'subjectName': '',
          'dueAt': '2026-09-01T12:00:00.000Z',
          'source': 'me',
          'progress': progress,
          'isDone': false,
        };
      }

      expect(
        () => Deadline.fromJson(payload(id: '')),
        throwsA(isA<CheckedFromJsonException>()),
      );
      expect(
        () => Deadline.fromJson(payload(id: 'deadline-1', progress: 101)),
        throwsA(isA<CheckedFromJsonException>()),
      );
      expect(
        Deadline.fromJson(payload(id: 'deadline-1')).isMine,
        isFalse,
      );
    });

    test('defaults remindMinutes to 60 and round-trips a custom value', () {
      final withoutLead = Deadline.fromJson({
        'id': 'deadline-1',
        'title': 'Lab report',
        'subjectName': '',
        'dueAt': '2026-09-01T12:00:00.000Z',
        'source': 'me',
        'progress': 0,
        'isDone': false,
        'isMine': true,
      });
      expect(withoutLead.remindMinutes, 60);

      final withLead = Deadline.fromJson({
        'id': 'deadline-1',
        'title': 'Lab report',
        'subjectName': '',
        'dueAt': '2026-09-01T12:00:00.000Z',
        'source': 'me',
        'progress': 0,
        'isDone': false,
        'isMine': true,
        'remindMinutes': 1440,
      });
      expect(withLead.remindMinutes, 1440);
      expect(withLead.toJson()['remindMinutes'], 1440);
    });

    test('urgency tiers: danger under 48h, warn under 3 days, else normal', () {
      final now = DateTime(2026, 1, 10);
      Deadline dueIn(Duration duration) => Deadline(
        id: 'deadline-1',
        title: 'Lab report',
        dueAt: now.add(duration),
        source: DeadlineSource.me,
        isMine: true,
      );

      expect(dueIn(const Duration(hours: 10)).isUrgentAt(now), isTrue);
      expect(dueIn(const Duration(hours: 10)).isWarnAt(now), isFalse);

      final warn = dueIn(const Duration(days: 2));
      expect(warn.isUrgentAt(now), isFalse);
      expect(warn.isWarnAt(now), isTrue);

      final normal = dueIn(const Duration(days: 5));
      expect(normal.isUrgentAt(now), isFalse);
      expect(normal.isWarnAt(now), isFalse);

      final done = dueIn(const Duration(hours: 10)).copyWith(isDone: true);
      expect(done.isUrgentAt(now), isFalse);
      expect(done.isWarnAt(now), isFalse);
    });
  });
}
