import 'package:campus_repository/campus_repository.dart';

enum EventsFilter {
  all,
  today,
  going,
  past;

  bool matches(CampusEvent event, DateTime now) {
    final past = isEventPast(event, now);
    return switch (this) {
      .all => !past,
      .today => _isSameDay(event.startsAt, now) && !past,
      .going => event.isGoing && !past,
      .past => past,
    };
  }

  static bool _isSameDay(DateTime a, DateTime b) =>
      a.year == b.year && a.month == b.month && a.day == b.day;
}

bool isEventPast(CampusEvent event, DateTime now) {
  final effectiveEnd =
      event.endsAt ?? event.startsAt.add(const Duration(hours: 2));
  return now.isAfter(effectiveEnd);
}
