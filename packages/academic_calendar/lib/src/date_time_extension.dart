extension DateTimeExtension on DateTime {
  int _numberOfIsoWeeks(int year) {
    final dec28 = DateTime(year, 12, 28);
    final dayOfDec28 = dec28.difference(DateTime(year)).inDays + 1;
    return ((dayOfDec28 - dec28.weekday + 10) / 7).floor();
  }

  int get weekOfYear {
    final dayOfYear = difference(DateTime(year)).inDays + 1;
    var woy = ((dayOfYear - weekday + 10) / 7).floor();
    if (woy < 1) {
      woy = _numberOfIsoWeeks(year - 1);
    } else if (woy > _numberOfIsoWeeks(year)) {
      woy = 1;
    }
    return woy;
  }
}
