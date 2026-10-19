import 'package:campus_repository/campus_repository.dart';

enum EventsFilter {
  all,
  today,
  going,
  past;

  bool matches(CampusEvent event, DateTime now) {
    final hasEnded = isEventPast(event, now);
    return switch (this) {
      .all => !hasEnded,
      .today => _isSameDay(event.startsAt, now) && !hasEnded,
      .going => event.isGoing && !hasEnded,
      .past => hasEnded,
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
