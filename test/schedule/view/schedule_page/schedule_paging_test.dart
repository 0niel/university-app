import 'package:flutter_test/flutter_test.dart';
import 'package:rtu_mirea_app/schedule/view/schedule_page/schedule_paging.dart';

void main() {
  group('scheduleDayIndex', () {
    test('anchors on the monday of the first week', () {
      expect(scheduleDayIndex(DateTime(2020, 1, 6)), 0);
      expect(scheduleDayIndex(DateTime(2020, 1, 12)), 6);
      expect(scheduleDayIndex(DateTime(2020, 1, 13)), 7);
      expect(scheduleDayIndex(DateTime(2020)), -5);
    });

    test('ignores the time of day', () {
      expect(
        scheduleDayIndex(DateTime(2026, 8, 27, 23, 59)),
        scheduleDayIndex(DateTime(2026, 8, 27)),
      );
    });

    test('round-trips through scheduleDayOfIndex', () {
      final day = DateTime(2026, 3, 29);
      expect(scheduleDayOfIndex(scheduleDayIndex(day)), day);
    });
  });

  group('scheduleWeekIndex', () {
    test('groups a monday-to-sunday week under one index', () {
      for (var offset = 0; offset < 7; offset++) {
        expect(scheduleWeekIndex(DateTime(2026, 8, 24 + offset)), 346);
      }
      expect(scheduleWeekIndex(DateTime(2026, 8, 31)), 347);
    });

    test('floors below the anchor instead of truncating', () {
      expect(scheduleWeekIndex(DateTime(2019, 12, 30)), -1);
      expect(scheduleWeekIndex(DateTime(2020)), -1);
    });
  });

  group('schedulePagerShouldJump', () {
    test('jumps a week or more away', () {
      expect(schedulePagerShouldJump(10, 17), isTrue);
      expect(schedulePagerShouldJump(17, 10), isTrue);
      expect(schedulePagerShouldJump(10, 16), isFalse);
      expect(schedulePagerShouldJump(10, 10), isFalse);
    });

    test('honours a custom threshold', () {
      expect(schedulePagerShouldJump(4, 6, threshold: 2), isTrue);
      expect(schedulePagerShouldJump(4, 5, threshold: 2), isFalse);
    });
  });

  group('SchedulePaging', () {
    final today = DateTime(2026, 8, 27);
    final paging = SchedulePaging(today: today);

    test('spans two years on both sides of today', () {
      expect(paging.weekPageCount, 209);
      expect(paging.dayPageCount, 1463);
      expect(
        paging.dayOfPage(0).difference(today).inDays,
        lessThanOrEqualTo(-728),
      );
      expect(
        paging.dayOfPage(paging.dayPageCount - 1).difference(today).inDays,
        greaterThanOrEqualTo(727),
      );
    });

    test('starts every week page on a monday', () {
      expect(paging.dayOfPage(0).weekday, DateTime.monday);
      expect(paging.dayOfPage(7).weekday, DateTime.monday);
      expect(paging.daysOfWeekPage(3).first.weekday, DateTime.monday);
      expect(paging.daysOfWeekPage(3).last.weekday, DateTime.sunday);
    });

    test('maps a day to its page and back', () {
      final page = paging.dayPageOf(today);
      expect(paging.dayOfPage(page), today);
      expect(paging.dayOfPage(page + 1), DateTime(2026, 8, 28));
      expect(paging.dayOfPage(page - 1), DateTime(2026, 8, 26));
    });

    test('keeps day and week pages in sync', () {
      final page = paging.dayPageOf(today);
      expect(paging.weekPageOfDayPage(page), paging.weekPageOf(today));
      expect(
        paging.weekPageOfDayPage(page + 7),
        paging.weekPageOf(today) + 1,
      );
      expect(paging.daysOfWeekPage(paging.weekPageOf(today)), contains(today));
    });

    test('keeps the weekday when a week page settles', () {
      final weekPage = paging.weekPageOf(today);
      final target = paging.dayPageInWeek(weekPage + 1, today.weekday);
      expect(paging.dayOfPage(target).weekday, today.weekday);
      expect(paging.dayOfPage(target), DateTime(2026, 9, 3));
      expect(target - paging.dayPageOf(today), 7);
    });

    test('clamps out-of-range days and pages', () {
      expect(paging.dayPageOf(DateTime(1990)), 0);
      expect(paging.dayPageOf(DateTime(2200)), paging.dayPageCount - 1);
      expect(paging.dayOfPage(-10), paging.dayOfPage(0));
      expect(
        paging.dayOfPage(paging.dayPageCount + 10),
        paging.dayOfPage(paging.dayPageCount - 1),
      );
      expect(paging.weekPageOfDayPage(-1), 0);
      expect(
        paging.weekPageOfDayPage(paging.dayPageCount * 2),
        paging.weekPageCount - 1,
      );
      expect(
        paging.dayPageInWeek(paging.weekPageCount, DateTime.sunday),
        paging.dayPageCount - 1,
      );
    });
  });

  group('ScheduleMonthPaging', () {
    final paging = ScheduleMonthPaging(
      today: DateTime(2026, 8, 29),
      radius: 2,
    );

    test('maps the center and adjacent months', () {
      expect(paging.pageCount, 5);
      expect(paging.pageOf(DateTime(2026, 8)), 2);
      expect(paging.monthOfPage(1), DateTime(2026, 7));
      expect(paging.monthOfPage(3), DateTime(2026, 9));
    });

    test('keeps the preferred day and clamps short months', () {
      expect(paging.dayInPage(2, 17), DateTime(2026, 8, 17));
      expect(paging.dayInPage(0, 31), DateTime(2026, 6, 30));
    });

    test('clamps dates and pages to the available window', () {
      expect(paging.pageOf(DateTime(2020)), 0);
      expect(paging.pageOf(DateTime(2030)), 4);
      expect(paging.monthOfPage(-1), DateTime(2026, 6));
      expect(paging.monthOfPage(20), DateTime(2026, 10));
    });
  });
}
