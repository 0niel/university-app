import 'package:flutter_test/flutter_test.dart';
import 'package:rtu_mirea_app/schedule_management/utils/schedule_live_status.dart';
import 'package:schedule_repository/schedule_repository.dart';

void main() {
  LessonSchedulePart lessonAt(
    int startH,
    int startM,
    int endH,
    int endM, {
    String subject = 'Машинное обучение',
    DateTime? date,
  }) {
    return LessonSchedulePart(
      subject: subject,
      lessonType: LessonType.lecture,
      teachers: const [],
      classrooms: const [Classroom(name: 'Г-407')],
      lessonBells: LessonBells(
        startTime: TimeOfDay(hour: startH, minute: startM),
        endTime: TimeOfDay(hour: endH, minute: endM),
      ),
      dates: [date ?? DateTime(2026, 6, 13)],
    );
  }

  group('ScheduleLiveStatus.of', () {
    final today = DateTime(2026, 6, 13);

    test('counts only lessons that fall on the given day', () {
      final status = ScheduleLiveStatus.of(
        [
          lessonAt(10, 40, 12, 10),
          lessonAt(14, 20, 15, 50),
          lessonAt(9, 0, 10, 30, date: DateTime(2026, 6, 14)),
        ],
        now: DateTime(2026, 6, 13, 8),
      );

      expect(status.todayCount, 2);
    });

    test('flags the lesson in progress and the minutes left', () {
      final status = ScheduleLiveStatus.of(
        [lessonAt(10, 40, 12, 10), lessonAt(14, 20, 15, 50)],
        now: DateTime(2026, 6, 13, 11),
      );

      expect(status.isLive, isTrue);
      expect(status.ongoing?.lesson.lessonBells.startTime.hour, 10);
      expect(status.ongoing?.minutesLeft, 70);
    });

    test('exposes the next lesson when nothing is live yet', () {
      final status = ScheduleLiveStatus.of(
        [lessonAt(10, 40, 12, 10), lessonAt(14, 20, 15, 50)],
        now: DateTime(2026, 6, 13, 8),
      );

      expect(status.isLive, isFalse);
      expect(status.next?.lessonBells.startTime.hour, 10);
    });

    test('has no ongoing or next lesson once the day is over', () {
      final status = ScheduleLiveStatus.of(
        [lessonAt(10, 40, 12, 10)],
        now: DateTime(2026, 6, 13, 20),
      );

      expect(status.todayCount, 1);
      expect(status.ongoing, isNull);
      expect(status.next, isNull);
    });

    test('is empty for a day off', () {
      final status = ScheduleLiveStatus.of(
        [lessonAt(10, 40, 12, 10, date: DateTime(2026, 6, 10))],
        now: today,
      );

      expect(status.todayCount, 0);
      expect(status.isLive, isFalse);
    });
  });
}
