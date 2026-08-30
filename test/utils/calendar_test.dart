import 'package:flutter_test/flutter_test.dart';

import 'package:rtu_mirea_app/common/utils/calendar_utils.dart' as m_cal;

void main() {
  group('Get start of semester |', () {
    final startSecondHalf = DateTime(2021, DateTime.march, 3);

    test('Winter start in 2021', () {
      final semStart = m_cal.CalendarUtils.getSemesterStart(
        mCurrentDate: startSecondHalf,
      );
      expect(semStart, DateTime(2021, DateTime.february, 9));
    });

    test('If 1st of Sep is a weekend', () {
      final semStart = m_cal.CalendarUtils.getSemesterStart(
        mCurrentDate: DateTime(2019, DateTime.september, 20),
      );

      expect(semStart, DateTime(2019, DateTime.september, 2));
    });
  });

  group('Get days in week |', () {
    test('First week in September', () {
      final startFirstSemester = DateTime(2020, DateTime.september, 2);
      final days = m_cal.CalendarUtils.getDaysInWeek(
        1,
        startFirstSemester,
      );

      expect(days.map((date) => date.day), [31, 1, 2, 3, 4, 5, 6]);
    });

    test('4 week in March 2021', () {
      final dateToTest = DateTime(2021, DateTime.march, 3);
      final days = m_cal.CalendarUtils.getDaysInWeek(4, dateToTest);

      expect(days.map((date) => date.day), [1, 2, 3, 4, 5, 6, 7]);
    });

    test('12 week in April-May 2021', () {
      final dateToTest = DateTime(2021, DateTime.march, 3);
      final days = m_cal.CalendarUtils.getDaysInWeek(12, dateToTest);

      expect(days.map((date) => date.day), [26, 27, 28, 29, 30, 1, 2]);
    });
  });
}
