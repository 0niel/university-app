enum RussianDayKind {
  workday,
  weekend,
  publicHoliday,
  transferredDayOff,
  transferredWorkday,
}

enum RussianHoliday {
  newYearHolidays,
  orthodoxChristmas,
  defenderOfFatherlandDay,
  internationalWomensDay,
  springAndLaborDay,
  victoryDay,
  russiaDay,
  nationalUnityDay,
}

class RussianDayInfo {
  const RussianDayInfo({
    required this.kind,
    required this.transferCalendarKnown,
    this.holiday,
  });

  final RussianDayKind kind;
  final RussianHoliday? holiday;
  final bool transferCalendarKnown;

  bool get isNonWorking => switch (kind) {
    RussianDayKind.weekend ||
    RussianDayKind.publicHoliday ||
    RussianDayKind.transferredDayOff => true,
    RussianDayKind.workday || RussianDayKind.transferredWorkday => false,
  };

  bool get isSpecial => kind != RussianDayKind.workday;
}

abstract final class RussianWorkCalendar {
  static const supportedTransferYears = {2024, 2025, 2026};

  static const officialTransferSources = {
    2024: 'https://government.ru/news/49258/',
    2025: 'https://government.ru/docs/all/155500/',
    2026: 'https://government.ru/docs/all/161028/',
  };

  static const _transferredDaysOff = {
    2024: {429, 430, 510, 1230, 1231},
    2025: {502, 508, 613, 1103, 1231},
    2026: {109, 1231},
  };

  static const _transferredWorkdays = {
    2024: {427, 1102, 1228},
    2025: {1101},
  };

  static RussianDayInfo dayInfo(DateTime value) {
    final day = DateTime(value.year, value.month, value.day);
    final key = day.month * 100 + day.day;
    final transferCalendarKnown = supportedTransferYears.contains(day.year);
    if (_transferredWorkdays[day.year]?.contains(key) ?? false) {
      return RussianDayInfo(
        kind: RussianDayKind.transferredWorkday,
        transferCalendarKnown: transferCalendarKnown,
      );
    }
    if (_transferredDaysOff[day.year]?.contains(key) ?? false) {
      return RussianDayInfo(
        kind: RussianDayKind.transferredDayOff,
        transferCalendarKnown: transferCalendarKnown,
      );
    }
    final holiday = _holidayFor(key);
    if (holiday != null) {
      return RussianDayInfo(
        kind: RussianDayKind.publicHoliday,
        holiday: holiday,
        transferCalendarKnown: transferCalendarKnown,
      );
    }
    if (day.weekday == DateTime.saturday || day.weekday == DateTime.sunday) {
      return RussianDayInfo(
        kind: RussianDayKind.weekend,
        transferCalendarKnown: transferCalendarKnown,
      );
    }
    return RussianDayInfo(
      kind: RussianDayKind.workday,
      transferCalendarKnown: transferCalendarKnown,
    );
  }

  static RussianHoliday? _holidayFor(int key) {
    if ((key >= 101 && key <= 106) || key == 108) {
      return RussianHoliday.newYearHolidays;
    }
    return switch (key) {
      107 => RussianHoliday.orthodoxChristmas,
      223 => RussianHoliday.defenderOfFatherlandDay,
      308 => RussianHoliday.internationalWomensDay,
      501 => RussianHoliday.springAndLaborDay,
      509 => RussianHoliday.victoryDay,
      612 => RussianHoliday.russiaDay,
      1104 => RussianHoliday.nationalUnityDay,
      _ => null,
    };
  }
}
