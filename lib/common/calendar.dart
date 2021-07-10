class Calendar {
  /// Максимальное количество учебных недель в семестре
  static const int kMaxWeekInSemester = 16;

  /// Номер понедельника первой учебной недели
  static const int kStartDay = 8;

  /// номер месяца, с которого начинается семестр. Например 2 = Февраль
  static const int kStartMonth = 2;

  /// Год, в котором начинается семестр
  static const int kStartYear = 2021;

  /// Возвращает текущий день недели, где 1 - ПН, 7 - ВС
  static int getCurrentDayOfWeek() {
    return DateTime.now().weekday;
  }

  /// Возвращает номер текущей недели, импользуя текущую дату
  static int getCurrentWeek() {
    DateTime currentDate = DateTime.now();
    int currentYear = currentDate.year;

    DateTime startDate;

    if (currentDate.month > 9) {
      startDate = DateTime.utc(currentYear, 9, 1);
    } else {
      startDate = DateTime.utc(currentYear, 2, 8);
    }

    int milliseconds = currentDate.difference(startDate).inMilliseconds;
    int week = (milliseconds ~/ (24 * 60 * 60 * 1000) / 7).round() + 1;

    return week;
  }

  /// Возвращает список дат по номеру недели [week]
  static List<int> getDaysInWeek(int week) {
    List<int> daysInWeek = [];

    int currentDay = kStartDay;
    int currentMonth = kStartMonth;
    int currentYear = kStartYear;

    for (int i = 1; i <= week; i++) {
      for (int j = 0; j < 7; j++) {
        if (i == week) {
          daysInWeek.add(currentDay);
        }
        currentDay += 1;

        if (currentDay > DateTime(currentYear, currentMonth + 1, 0).day) {
          if (currentMonth > 12) {
            currentMonth = 1;
            currentYear++;
          } else {
            currentMonth++;
          }
          currentDay = 1;
        }
      }
    }
    return daysInWeek;
  }
}
