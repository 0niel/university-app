import 'package:flutter_test/flutter_test.dart';

import 'package:rtu_mirea_app/common/calendar.dart' as mCal;

/// Класс с тестами для календаря
class CalendarTest {

  /// Выполнить все тесты
  static testEverything() {
    getStudyWeekTest();
    getSemesterStart();
    getWeekDaysTest();
  }

  /// Протестировать получение номера недели
  static getStudyWeekTest() {
    group('Get study week number |', () {
      DateTime startFirstSemester = DateTime(2020, DateTime.september, 2);
      DateTime startSecondSemester = DateTime(2021, DateTime.february, 9);

      test('First week in September', () {
        expect(mCal.Calendar.getCurrentWeek(startFirstSemester), 1);
      });

      test('First week in February', () {
        expect(mCal.Calendar.getCurrentWeek(startSecondSemester), 1);
      });
    });

    print('');
  }

  /// Протестировать получение даты начала семестра по текущей дате
  static getSemesterStart() {
    group('Get start of semester |', () {
      DateTime startFirstHalf = DateTime(2020, DateTime.october, 20);
      DateTime startSecondHalf = DateTime(2021, DateTime.march, 3);

      test('September start in 2020', () {
        DateTime semStart = mCal.Calendar.getSemesterStart(startFirstHalf);
        expect(semStart.day, 1);
        expect(semStart.month, DateTime.september);
        expect(semStart.year, 2020);
      });

      test('Winter start in 2021', () {
        DateTime semStart = mCal.Calendar.getSemesterStart(startSecondHalf);
        expect(semStart.day, 8);
        expect(semStart.month, DateTime.february);
        expect(semStart.year, 2021);
      });
    });
    print('');
  }

  /// Протестировать получение дней выбранной учебной недели
  static getWeekDaysTest() {
    group('Get days in week |', () {
      test('First week in September', () {
        DateTime startFirstSemester = DateTime(2020, DateTime.september, 2);
        List<DateTime> days =
            mCal.Calendar.getDaysInWeek(1, startFirstSemester);
        var daysToTest = [31, 1, 2, 3, 4, 5];
        for (var i = 0; i < daysToTest.length; ++i) {
          expect(days[i].day, daysToTest[i]);
        }
      });

      test('4 week in March 2021', () {
        DateTime dateTotest = DateTime(2021, DateTime.march, 3);
        List<DateTime> days = mCal.Calendar.getDaysInWeek(4, dateTotest);
        var daysToTest = [1, 2, 3, 4, 5, 6];
        for (var i = 0; i < daysToTest.length; ++i) {
          expect(days[i].day, daysToTest[i]);
        }
      });

      test('12 week in April-May 2021', () {
        DateTime dateTotest = DateTime(2021, DateTime.march, 3);
        List<DateTime> days = mCal.Calendar.getDaysInWeek(12, dateTotest);
        var daysToTest = [26, 27, 28, 29, 30, 1];
        for (var i = 0; i < daysToTest.length; ++i) {
          expect(days[i].day, daysToTest[i]);
        }
      });
    });
    print('');
  }
}
