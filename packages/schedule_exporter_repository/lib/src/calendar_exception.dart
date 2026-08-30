class CalendarException implements Exception {
  const CalendarException(this.message);

  final String message;

  @override
  String toString() => 'CalendarException: $message';
}

class PermissionDeniedException extends CalendarException {
  const PermissionDeniedException() : super('Access to the calendar is denied');
}

class CalendarCreationException extends CalendarException {
  CalendarCreationException(String reason)
    : super('Failed to create calendar: $reason');
}

class EventCreationException extends CalendarException {
  EventCreationException(String reason) : super('Failed to add event: $reason');
}
