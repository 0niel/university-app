import 'package:academic_calendar/academic_calendar.dart';
import 'package:test/test.dart';

void main() {
  test('classifies regular weekdays and weekends', () {
    expect(
      RussianWorkCalendar.dayInfo(DateTime(2026, 4, 10)).kind,
      RussianDayKind.workday,
    );
    expect(
      RussianWorkCalendar.dayInfo(DateTime(2026, 4, 11)).kind,
      RussianDayKind.weekend,
    );
  });

  test('classifies federal holidays independently of the year', () {
    final info = RussianWorkCalendar.dayInfo(DateTime(2027, 5));

    expect(info.kind, RussianDayKind.publicHoliday);
    expect(info.holiday, RussianHoliday.springAndLaborDay);
    expect(info.isNonWorking, isTrue);
    expect(info.transferCalendarKnown, isFalse);
  });

  test('distinguishes Orthodox Christmas from New Year holidays', () {
    final christmas = RussianWorkCalendar.dayInfo(DateTime(2026, 1, 7));
    final newYear = RussianWorkCalendar.dayInfo(DateTime(2026, 1, 8));

    expect(christmas.holiday, RussianHoliday.orthodoxChristmas);
    expect(newYear.holiday, RussianHoliday.newYearHolidays);
  });

  test('exposes when transfer data is not officially available', () {
    final known = RussianWorkCalendar.dayInfo(DateTime(2026, 8, 31));
    final unknown = RussianWorkCalendar.dayInfo(DateTime(2027, 8, 30));

    expect(known.transferCalendarKnown, isTrue);
    expect(unknown.transferCalendarKnown, isFalse);
    expect(unknown.kind, RussianDayKind.workday);
    expect(unknown.isNonWorking, isFalse);
  });

  test('uses official transferred days for supported years', () {
    expect(
      RussianWorkCalendar.dayInfo(DateTime(2025, 5, 2)).kind,
      RussianDayKind.transferredDayOff,
    );
    expect(
      RussianWorkCalendar.dayInfo(DateTime(2025, 11)).kind,
      RussianDayKind.transferredWorkday,
    );
    expect(
      RussianWorkCalendar.dayInfo(DateTime(2026, 12, 31)).kind,
      RussianDayKind.transferredDayOff,
    );
  });

  test('keeps a transferred workday out of non-working days', () {
    final info = RussianWorkCalendar.dayInfo(DateTime(2024, 4, 27));

    expect(info.kind, RussianDayKind.transferredWorkday);
    expect(info.isNonWorking, isFalse);
  });

  test('keeps an official source for every transfer dataset', () {
    expect(
      RussianWorkCalendar.officialTransferSources.keys,
      RussianWorkCalendar.supportedTransferYears,
    );
  });
}
