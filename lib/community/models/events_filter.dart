import 'package:campus_repository/campus_repository.dart';

enum EventsFilter {
  all,
  today,
  going;

  bool matches(CampusEvent event, DateTime now) => switch (this) {
    .all => true,
    .today => _isSameDay(event.startsAt.toLocal(), now),
    .going => event.isGoing,
  };

  static bool _isSameDay(DateTime a, DateTime b) =>
      a.year == b.year && a.month == b.month && a.day == b.day;
}
