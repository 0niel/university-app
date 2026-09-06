import 'dart:convert';

import 'package:schedule_repository/schedule_repository.dart';
import 'package:test/test.dart';

void main() {
  group('Canonical schedule changes', () {
    test('preserves an actual title correction without inventing a move', () {
      final change = ScheduleChange.fromJson({
        'id': 901,
        'changeKind': 'update',
        'subject': 'Математическая логика и теория алгоритмов',
        'lessonDate': '2026-09-11',
        'lessonNumber': 3,
        'createdAt': '2026-09-06T12:00:00Z',
        'oldValue': {
          'title': 'Математическая логика итеория алгоритмов',
          'start_time': '12:40:00',
          'end_time': '14:10:00',
          'lesson_number': 3,
          'lesson_type': 'practice',
          'dates': ['2026-09-11', '2026-09-25'],
        },
        'newValue': {
          'title': 'Математическая логика и теория алгоритмов',
          'start_time': '12:40:00',
          'end_time': '14:10:00',
          'lesson_number': 3,
          'lesson_type': 'practice',
          'dates': ['2026-09-11', '2026-09-25'],
        },
      });

      expect(change.kind, ScheduleChangeKind.update);
      expect(change.oldValue.start, '12:40');
      expect(change.newValue.end, '14:10');
      expect(
        change.oldValue.subject,
        'Математическая логика итеория алгоритмов',
      );
      expect(change.newValue.subject, change.subject);
      expect(change.oldValue.dates, change.newValue.dates);
      expect(change.oldValue.dates, [
        DateTime(2026, 9, 11),
        DateTime(2026, 9, 25),
      ]);
      expect(change.newValue.lessonNumber, 3);
      expect(change.newValue.lessonType, 'practice');
      expect(change.oldValue.rooms, isEmpty);
      expect(change.oldValue.teachers, isEmpty);
    });

    test('unknown wire kinds are generic updates', () {
      for (final kind in ['update', '', 'future_change', 'unknown']) {
        expect(
          ScheduleChangeKind.fromWireValue(kind),
          ScheduleChangeKind.update,
        );
      }
      expect(ScheduleChangeKind.fromWireValue('move'), ScheduleChangeKind.move);
    });

    test('all serialized kinds preserve read identity and change details', () {
      for (final kind in ScheduleChangeKind.values) {
        final change = ScheduleChange(
          id: '903',
          kind: kind,
          subject: 'Subject',
          lessonDate: DateTime(2026, 9, 18),
          createdAt: DateTime(2026, 9, 6, 12),
          lessonNumber: 2,
          oldValue: ScheduleChangeSlot(
            subject: 'Old Subject',
            start: '09:00',
            end: '10:30',
            dates: [DateTime(2026, 9, 11)],
          ),
          newValue: ScheduleChangeSlot(
            subject: 'Subject',
            start: '10:40',
            end: '12:10',
            dates: [DateTime(2026, 9, 18)],
          ),
        );
        expect(ScheduleChange.fromJson(change.toJson()), change);
        expect(
          ScheduleChange.fromJson(
            jsonDecode(jsonEncode(change)) as Map<String, dynamic>,
          ),
          change,
        );
      }
    });

    test('accepts legacy and camel-case clocks without truncating garbage', () {
      final old = ScheduleChangeSlot.fromJson({
        'start': ' 9:00:00.000 ',
        'end': '10:30',
        'rooms': [' A-101 ', null, <String, Object?>{}, 'A-101'],
        'teachers': ['Иванов ИванИванович', 42],
      });
      expect(old.start, '09:00');
      expect(old.end, '10:30');
      expect(old.rooms, ['A-101']);
      expect(old.teachers, ['Иванов Иван Иванович']);
      final current = ScheduleChangeSlot.fromJson({
        'start': 'not-a-clock',
        'startTime': '10:40:00',
        'endTime': '12:10:00',
        'lessonNumber': '2',
        'lessonType': ' lecture ',
      });
      expect(current.start, '10:40');
      expect(current.end, '12:10');
      expect(current.lessonNumber, 2);
      expect(current.lessonType, 'lecture');
      for (final value in [
        '99:00',
        '12:90',
        '12:00:99',
        '12',
        <String, Object?>{},
        1200,
        true,
      ]) {
        expect(
          ScheduleChangeSlot.fromJson({'start_time': value}).start,
          isNull,
        );
      }
    });

    test(
      'keeps calendar date changes and rejects invalid or invented dates',
      () {
        final slot = ScheduleChangeSlot.fromJson({
          'dates': [
            '2026-09-18',
            '2026-09-11',
            '2026-09-18',
            '2026-02-31',
            'not-a-date',
            null,
            7,
          ],
        });
        expect(slot.dates, [DateTime(2026, 9, 11), DateTime(2026, 9, 18)]);
        expect(slot.dates.every((date) => !date.isUtc), isTrue);
        expect(slot.start, isNull);
        expect(slot.isEmpty, isFalse);
        expect(ScheduleChangeSlot.fromJson({}).isEmpty, isTrue);
        expect(ScheduleChangeSlot.fromJson({'dates': null}).dates, isEmpty);
      },
    );

    test('serialized dates round-trip without changing their calendar day', () {
      final slot = ScheduleChangeSlot.fromJson({
        'title': 'Subject',
        'dates': ['2026-09-11', '2026-12-18'],
        'start_time': '12:40:00',
        'end_time': '14:10:00',
        'lesson_type': 'practice',
        'lesson_number': 3,
      });
      expect(ScheduleChangeSlot.fromJson(slot.toJson()), slot);
      expect(slot.copyWith(), slot);
      final zoned = ScheduleChangeSlot.fromJson({
        'dates': ['2026-09-11T00:00:00.000Z', '2026-12-18T00:00:00+03:00'],
      });
      expect(zoned.dates, slot.dates);
    });

    test('a real date move preserves both occurrence sets', () {
      final change = ScheduleChange.fromJson({
        'id': 902,
        'change_kind': 'move',
        'subject': 'Subject',
        'lesson_date': '2026-09-18',
        'created_at': '2026-09-06T12:00:00Z',
        'old_value': {
          'start_time': '09:00:00',
          'dates': ['2026-09-11'],
        },
        'new_value': {
          'start_time': '09:00:00',
          'dates': ['2026-09-18'],
        },
      });
      expect(change.kind, ScheduleChangeKind.move);
      expect(change.oldValue.start, change.newValue.start);
      expect(change.oldValue.dates.single, DateTime(2026, 9, 11));
      expect(change.newValue.dates.single, DateTime(2026, 9, 18));
    });
  });
}
