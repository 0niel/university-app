import 'package:academic_calendar/academic_calendar.dart';
import 'package:test/test.dart';

void main() {
  group('AcademicCalendar', () {
    test('getPeriod returns correct period for given date', () {
      final period1 = getPeriod(DateTime(2022, 9));
      expect(period1.yearStart, 2022);
      expect(period1.yearEnd, 2023);
      expect(period1.semester, 1);

      final period2 = getPeriod(DateTime(2022, 2));
      expect(period2.yearStart, 2021);
      expect(period2.yearEnd, 2022);
      expect(period2.semester, 2);
    });

    test('getWeek returns correct week number for given date', () {
      final week1 = getWeek(DateTime(2022, 9));
      expect(week1, 1);

      final week2 = getWeek(DateTime(2022, 9, 6));
      expect(week2, 2);

      final week3 = getWeek(DateTime(2023, 9, 4));
      expect(week3, 2);

      final week4 = getWeek(DateTime(2023, 9, 5));
      expect(week4, 2);

      final week5 = getWeek(DateTime(2023, 9, 9));
      expect(week5, 2);

      final week6 = getWeek(DateTime(2023, 9, 10));
      expect(week6, 2);

      final week7 = getWeek(DateTime(2023, 9, 11));
      expect(week7, 3);

      final week8 = getWeek(DateTime(2023, 9, 17));
      expect(week8, 3);

      final week9 = getWeek(DateTime(2023, 9, 18));
      expect(week9, 4);

      final week10 = getWeek(DateTime(2023, 11, 29));
      expect(week10, 14);
    });

    test('getSemesterStart returns correct start date for given date', () {
      final startDate1 = getSemesterStart(DateTime(2022, 9));
      expect(startDate1, DateTime(2022, 9));

      final startDate2 = getSemesterStart(DateTime(2022, 2));
      expect(startDate2, DateTime(2022, 2, 9));
    });
  });
}
