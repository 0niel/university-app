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
  static int getCurrentWeek([DateTime? mCurrentDate]) {
    DateTime currentDate = mCurrentDate ?? DateTime.now();
    int currentYear = currentDate.year;

    DateTime startDate;

    if (currentDate.month >= DateTime.september) {
      startDate = DateTime.utc(currentYear, 9, 1);
    } else {
      startDate = DateTime.utc(currentYear, 2, 8);
    }

    int milliseconds = currentDate.difference(startDate).inMilliseconds;
    int week = (milliseconds ~/ (24 * 60 * 60 * 1000) / 7).round() + 1;

    return week;
  }

  /// Возвращает список дат по номеру недели [week]
  static List<DateTime> getDaysInWeek(int week, [DateTime? mCurrentDate]) {
    List<DateTime> daysInWeek = [];

    DateTime semStart = getSemesterStart(mCurrentDate);

    // Понедельник недели начала семестра
    var firstDayOfWeek =
        semStart.subtract(Duration(days: semStart.weekday - 1));

    // Прибавляем сколько дней прошло с начала семестра
    var firstDayOfChosenWeek = firstDayOfWeek.add(Duration(days: (week-1) * 7));

    // Добавляем дни в массив, увеличивая счётчик на 1 день
    for (int i = 0; i < 6; ++i) {
      daysInWeek.add(firstDayOfChosenWeek);
      firstDayOfChosenWeek = firstDayOfChosenWeek.add(Duration(days: 1));
    }
    return daysInWeek;
  }

  /// Получить дату начала семестра
  ///
  /// [mCurrentDate] отвечает за дату,
  /// для которой будет рассчитано начало семестра.
  /// 
  /// Если оставить null, функция вернёт начало семестра для текущей даты.
  static DateTime getSemesterStart([DateTime? mCurrentDate]) {
    return _CurrentSemesterStart.getCurrentSemesterStart(mCurrentDate);
  }
}


/// Получение даты с которой начинается семестр
class _CurrentSemesterStart {
  /// Получить первый понедельник месяца с которого начинается текущий семестр
  static DateTime _getFirstMondayOfMonth(int year, int month) {
    var firstOfMonth = DateTime(year, month, 1);
    var firstMonday = firstOfMonth.add(
        Duration(days: (7 - (firstOfMonth.weekday - DateTime.monday)) % 7));
    return firstMonday;
  }

  /// Скоректировать дату начала семестра
  /// Если выбранный день выходной, то взять первый понедельник месяца,
  /// иначе выбранный день и так выбран правильно
  static DateTime _getCorrectedDate(DateTime date) {
    if (date.weekday == DateTime.saturday || date.weekday == DateTime.sunday) {
      return _getFirstMondayOfMonth(date.year, date.month);
    } else {
      return date;
    }
  }

  /// Получить ожидаемую дату начала семестра.
  /// Для первого полугодия это 1-е сентября
  /// Для второго полугодия это 8-е февраля
  static DateTime _getExpectedSemesterStart(DateTime currentDate) {
    if (currentDate.month >= DateTime.september) {
      return DateTime(currentDate.year, DateTime.september, 1);
    } else {
      return DateTime(currentDate.year, DateTime.february, 8);
    }
  }

  /// Получить дату начала текущего семестра
  static DateTime getCurrentSemesterStart([DateTime? mCurrentDate]) {
    DateTime currentDate = mCurrentDate ?? DateTime.now();
    // ожидаемая дата начала семестра
    DateTime expectedStart = _getExpectedSemesterStart(currentDate);
    // скорректировать на случай, если она попала на выходной день
    return _getCorrectedDate(expectedStart);
  }
}
