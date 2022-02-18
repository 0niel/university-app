import 'package:clock/clock.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:rtu_mirea_app/common/utils/calendar_utils.dart' as m_cal;

/// Calendar util testing
void main() {
  getStudyWeekTest();
  getSemesterStart();
  getWeekDaysTest();
  getCurrentDayOfWeek();
}

/// getCurrentWeek() test
getStudyWeekTest() {
  group('Get study week number |', () {
    DateTime startFirstSemester = DateTime(2020, DateTime.september, 2);
    DateTime startSecondSemester = DateTime(2021, DateTime.february, 9);

    // TODO Протестить последние недели
    test('First week in September', () {
      expect(
          m_cal.CalendarUtils.getCurrentWeek(mCurrentDate: startFirstSemester),
          1);
    });

    test('First week in February', () {
      expect(
          m_cal.CalendarUtils.getCurrentWeek(mCurrentDate: startSecondSemester),
          1);
    });

    test('First week in Sep using Clock', () {
      final mockClock = Clock.fixed(DateTime(2021, DateTime.september, 15));
      int testWeekNum = m_cal.CalendarUtils.getCurrentWeek(clock: mockClock);
      expect(3, testWeekNum);
    });
  });
}

/// getSemesterStart() test
getSemesterStart() {
  group('Get start of semester |', () {
    DateTime startSecondHalf = DateTime(2021, DateTime.march, 3);

    test('Winter start in 2021', () {
      DateTime semStart =
          m_cal.CalendarUtils.getSemesterStart(mCurrentDate: startSecondHalf);
      expect(semStart.day, 9);
      expect(semStart.month, DateTime.february);
      expect(semStart.year, 2021);
    });

    test('If 1st of Sep is a weekend', () {
      final mockClock = Clock.fixed(DateTime(2019, DateTime.september, 20));
      DateTime semStart =
          m_cal.CalendarUtils.getSemesterStart(clock: mockClock);

      expect(semStart.day, 2);
      expect(semStart.month, DateTime.september);
      expect(semStart.year, 2019);
    });
  });
}

/// week days test
getWeekDaysTest() {
  group('Get days in week |', () {
    test('First week in September', () {
      DateTime startFirstSemester = DateTime(2020, DateTime.september, 2);
      List<DateTime> days =
          m_cal.CalendarUtils.getDaysInWeek(1, startFirstSemester);
      var daysToTest = [31, 1, 2, 3, 4, 5];
      for (var i = 0; i < daysToTest.length; ++i) {
        expect(days[i].day, daysToTest[i]);
      }
    });

    test('4 week in March 2021', () {
      DateTime dateToTest = DateTime(2021, DateTime.march, 3);
      List<DateTime> days = m_cal.CalendarUtils.getDaysInWeek(4, dateToTest);
      var daysToTest = [1, 2, 3, 4, 5, 6];
      for (var i = 0; i < daysToTest.length; ++i) {
        expect(days[i].day, daysToTest[i]);
      }
    });

    test('12 week in April-May 2021', () {
      DateTime dateToTest = DateTime(2021, DateTime.march, 3);
      List<DateTime> days = m_cal.CalendarUtils.getDaysInWeek(12, dateToTest);
      var daysToTest = [26, 27, 28, 29, 30, 1];
      for (var i = 0; i < daysToTest.length; ++i) {
        expect(days[i].day, daysToTest[i]);
      }
    });
  });
}

getCurrentDayOfWeek() {
  test('27.08.2021 is Friday', () {
    final mockClock = Clock.fixed(DateTime(2021, 8, 27));
    int testDayOfWeek =
        m_cal.CalendarUtils.getCurrentDayOfWeek(clock: mockClock);
    expect(DateTime.friday, testDayOfWeek);
  });
}
