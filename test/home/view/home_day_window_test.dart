import 'package:flutter_test/flutter_test.dart';
import 'package:rtu_mirea_app/home/view/home_dashboard_page.dart';
import 'package:schedule_repository/schedule_repository.dart';

LessonSchedulePart _lesson({
  required DateTime day,
  required int startHour,
  required int startMinute,
  required int endHour,
  required int endMinute,
  String subject = 'Математика',
}) => LessonSchedulePart(
  subject: subject,
  lessonType: .lecture,
  teachers: const [],
  classrooms: const [],
  lessonBells: LessonBells(
    startTime: TimeOfDay(hour: startHour, minute: startMinute),
    endTime: TimeOfDay(hour: endHour, minute: endMinute),
  ),
  dates: [day],
);

void main() {
  group('home day window', () {
    test('spans two days back and eleven days forward', () {
      final days = homeDayWindow(DateTime(2026, 8, 18, 10, 15));

      expect(days, hasLength(kHomeDayWindowLength));
      expect(days[kHomeDayWindowTodayIndex], DateTime(2026, 8, 18));
      expect(days.first, DateTime(2026, 8, 16));
      expect(days.last, DateTime(2026, 8, 29));
    });

    test('rolls over a month boundary without drifting', () {
      final days = homeDayWindow(DateTime(2026, 8, 31, 23, 59));

      expect(days.first, DateTime(2026, 8, 29));
      expect(days[kHomeDayWindowTodayIndex], DateTime(2026, 8, 31));
      expect(days.last, DateTime(2026, 9, 11));
    });
  });

  group('home day swipe', () {
    test('a flick wins over the travelled distance', () {
      expect(
        homeDaySwipeStep(dragOffset: 4, velocity: -900, width: 360),
        HomeDayStep.next,
      );
      expect(
        homeDaySwipeStep(dragOffset: -4, velocity: 900, width: 360),
        HomeDayStep.previous,
      );
    });

    test('a slow drag needs a fifth of the width', () {
      expect(
        homeDaySwipeStep(dragOffset: -40, velocity: 0, width: 360),
        isNull,
      );
      expect(
        homeDaySwipeStep(dragOffset: -80, velocity: 0, width: 360),
        HomeDayStep.next,
      );
      expect(
        homeDaySwipeStep(dragOffset: 80, velocity: 0, width: 360),
        HomeDayStep.previous,
      );
    });

    test('narrow screens keep a 48px floor', () {
      expect(
        homeDaySwipeStep(dragOffset: -50, velocity: 0, width: 200),
        HomeDayStep.next,
      );
    });

    test('the window edges rubber-band', () {
      expect(
        homeDayStepTarget(
          selectedIndex: 0,
          dayCount: kHomeDayWindowLength,
          step: HomeDayStep.previous,
        ),
        isNull,
      );
      expect(
        homeDayStepTarget(
          selectedIndex: kHomeDayWindowLength - 1,
          dayCount: kHomeDayWindowLength,
          step: HomeDayStep.next,
        ),
        isNull,
      );
      expect(
        homeDayStepTarget(
          selectedIndex: 2,
          dayCount: kHomeDayWindowLength,
          step: HomeDayStep.next,
        ),
        3,
      );
      expect(
        homeDayStepTarget(
          selectedIndex: 2,
          dayCount: kHomeDayWindowLength,
          step: HomeDayStep.previous,
        ),
        1,
      );
    });
  });

  group('home day rail offset', () {
    test('centres the selected cell inside the viewport', () {
      expect(
        homeDayRailOffset(
          index: 7,
          cellWidth: 48,
          separator: 2,
          leadingInset: 2,
          viewport: 320,
          maxScrollExtent: 400,
        ),
        352 - 136,
      );
    });

    test('never scrolls past the rail bounds', () {
      expect(
        homeDayRailOffset(
          index: 0,
          cellWidth: 48,
          separator: 2,
          leadingInset: 2,
          viewport: 320,
          maxScrollExtent: 400,
        ),
        0,
      );
      expect(
        homeDayRailOffset(
          index: 13,
          cellWidth: 48,
          separator: 2,
          leadingInset: 2,
          viewport: 320,
          maxScrollExtent: 400,
        ),
        400,
      );
      expect(
        homeDayRailOffset(
          index: 3,
          cellWidth: 48,
          separator: 2,
          leadingInset: 2,
          viewport: 900,
          maxScrollExtent: -20,
        ),
        0,
      );
    });
  });

  group('home day status', () {
    final day = DateTime(2026, 8, 18);

    test('an empty day reports no classes', () {
      final status = homeDayStatus(
        day: day,
        lessons: const [],
        now: DateTime(2026, 8, 18, 9),
      );

      expect(status.kind, HomeDayStatusKind.free);
      expect(status.lessonCount, 0);
      expect(status.startsAt, isNull);
    });

    test('a live lesson counts the remaining minutes up', () {
      final status = homeDayStatus(
        day: day,
        lessons: [
          _lesson(
            day: day,
            startHour: 10,
            startMinute: 40,
            endHour: 12,
            endMinute: 10,
          ),
        ],
        now: DateTime(2026, 8, 18, 11, 45, 30),
      );

      expect(status.kind, HomeDayStatusKind.live);
      expect(status.minutes, 25);
    });

    test('an upcoming lesson counts down to its bell', () {
      final status = homeDayStatus(
        day: day,
        lessons: [
          _lesson(
            day: day,
            startHour: 10,
            startMinute: 40,
            endHour: 12,
            endMinute: 10,
          ),
        ],
        now: DateTime(2026, 8, 18, 10),
      );

      expect(status.kind, HomeDayStatusKind.upcoming);
      expect(status.minutes, 40);
      expect(status.startsAt, DateTime(2026, 8, 18, 10, 40));
    });

    test('a finished day is not a free day', () {
      final status = homeDayStatus(
        day: day,
        lessons: [
          _lesson(
            day: day,
            startHour: 10,
            startMinute: 40,
            endHour: 12,
            endMinute: 10,
          ),
        ],
        now: DateTime(2026, 8, 18, 18),
      );

      expect(status.kind, HomeDayStatusKind.done);
      expect(status.lessonCount, 1);
    });

    test('another day never counts down', () {
      final status = homeDayStatus(
        day: DateTime(2026, 8, 20),
        lessons: [
          _lesson(
            day: DateTime(2026, 8, 20),
            startHour: 9,
            startMinute: 0,
            endHour: 10,
            endMinute: 30,
          ),
        ],
        now: DateTime(2026, 8, 18, 10),
      );

      expect(status.kind, HomeDayStatusKind.scheduled);
      expect(status.minutes, 0);
      expect(status.startsAt, DateTime(2026, 8, 20, 9));
    });

    test('countdown minutes round up and never go negative', () {
      expect(homeCountdownMinutes(const Duration(seconds: 61)), 2);
      expect(homeCountdownMinutes(const Duration(minutes: -5)), 0);
    });
  });
}
