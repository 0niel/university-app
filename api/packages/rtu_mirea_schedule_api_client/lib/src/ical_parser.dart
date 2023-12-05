import 'package:icalendar_parser/icalendar_parser.dart';
import 'package:rrule/rrule.dart';
import 'package:rtu_mirea_schedule_api_client/src/fields_data_parsers.dart';
import 'package:rtu_mirea_schedule_api_client/src/lessons_bells.dart';
import 'package:schedule/schedule.dart';

/// {@template invalid_icalendar_data_exception}
/// Expetion thrown when the iCalendar data is invalid.
/// {@endtemplate}
class InvalidICalendarDataException implements Exception {
  /// {@macro invalid_icalendar_data_exception}
  const InvalidICalendarDataException({required this.error});

  /// Associated error.
  final Object error;
}

/// {@template icalendar_parsing_exception}
/// Throws when parsing of the iCalendar data fails.
/// {@endtemplate}
class ICalendarParsingException implements Exception {
  /// {@macro icalendar_parsing_exception}
  const ICalendarParsingException({required this.error});

  /// Associated error.
  final Object error;
}

/// {@template ical_parser}
/// Parses the iCalendar data into the [SchedulePart]s.
/// {@endtemplate}
class ICalParser {
  ICalParser._(this._data) {
    try {
      _calendar = ICalendar.fromString(_data);
    } catch (error, stackTrace) {
      Error.throwWithStackTrace(
        InvalidICalendarDataException(error: error),
        stackTrace,
      );
    }
  }

  /// Creates a new instance of the [ICalParser] from the iCalendar string data.
  ///
  /// Throws [InvalidICalendarDataException] if the iCalendar data is invalid.
  factory ICalParser.fromString(String data) => ICalParser._(data);

  final String _data;

  late final ICalendar _calendar;

  /// General method for parsing the iCalendar data.
  List<SchedulePart> parse() {
    final scheduleParts = <SchedulePart>[];

    if (_calendar.data.isEmpty) {
      throw const ICalendarParsingException(
        error: 'The iCalendar data is empty.',
      );
    }

    for (final tmpData in _calendar.data) {
      final data = tmpData.map(
        (key, value) => MapEntry(key.toLowerCase(), value),
      );

      if (data['type'].toString().toLowerCase() != 'vevent') {
        continue;
      }

      final datesAndTime = _getEventDatesAndTime(data);

      var description = data['description'] as String?;

      if (description == null) {
        throw const ICalendarParsingException(
          error: 'The iCalendar data is invalid. The DESCRIPTION field is '
              'required.',
        );
      }

      description = description.replaceAll(RegExp(r'\\n'), '\n');

      final teachers = parseTeachersFromDescription(description);
      final groups = parseGroupsFromDescription(description);

      var location = data['location'] as String?;

      location = location?.replaceAll(RegExp(r'\\n'), '\n');

      final classrooms = parseClassroomsFromLocation(location ?? '');

      final summary = data['summary'] as String?;

      if (summary == null) {
        throw const ICalendarParsingException(
          error: 'The iCalendar data is invalid. The SUMMARY field is '
              'required.',
        );
      }

      final (subject, lessonType) = parseSubjectAndLessonTypeFromSummary(
        summary,
      );

      final schedulePart = LessonSchedulePart(
        subject: subject,
        lessonType: lessonType,
        teachers: teachers.map((e) => Teacher(name: e)).toList(),
        classrooms: classrooms,
        lessonBells: defaultLessonsBells
            .where(
              (element) =>
                  element.startTime == datesAndTime.timeStart &&
                  element.endTime == datesAndTime.timeEnd,
            )
            .first,
        dates: datesAndTime.dates,
        groups: groups.isEmpty ? null : groups,
      );

      scheduleParts.add(schedulePart);
    }

    return scheduleParts;
  }

  EventDatesAndTime _getEventDatesAndTime(Map<String, dynamic> data) {
    final EventDatesAndTime datesAndTime;

    final dtstart = data['dtstart'] as IcsDateTime?;
    final dtend = data['dtend'] as IcsDateTime?;

    if (dtstart == null || dtend == null) {
      throw const ICalendarParsingException(
        error: 'The iCalendar data is invalid.',
      );
    }

    var dtstartObject = dtstart.toDateTime();
    var dtendObject = dtend.toDateTime();

    if (dtstartObject == null || dtendObject == null) {
      throw const ICalendarParsingException(
        error: 'The iCalendar data is invalid. The DTSTART or DTEND cannot '
            'convert to DateTime.',
      );
    }

    // Remove timezone (to utc) without changing the time. It is necessary
    // because the RRule package does not support timezones.
    dtstartObject = dtstartObject
        .add(Duration(hours: dtstartObject.timeZoneOffset.inHours))
        .toUtc();
    dtendObject = dtendObject
        .add(Duration(hours: dtendObject.timeZoneOffset.inHours))
        .toUtc();

    final rrule = data['rrule'] as String?;

    final timeStart = TimeOfDay(
      hour: dtstartObject.hour,
      minute: dtstartObject.minute,
    );

    final timeEnd = TimeOfDay(
      hour: dtendObject.hour,
      minute: dtendObject.minute,
    );

    if (rrule != null) {
      final dates = _getDatesByRrule(
        rrule,
        dtstartObject,
      );

      datesAndTime = EventDatesAndTime(
        dates,
        timeStart,
        timeEnd,
      );
    } else {
      datesAndTime = EventDatesAndTime(
        [dtstartObject],
        timeStart,
        timeEnd,
      );
    }

    return datesAndTime;
  }

  static List<DateTime> _getDatesByRrule(
    String rrule,
    DateTime start,
  ) {
    final rruleObject = RecurrenceRule.fromString('RRULE:$rrule');

    final instances = rruleObject.getInstances(
      start: start,
    );

    return instances.toList();
  }
}

/// {@template event_dates_and_time}
/// Includes a list of dates and a time of the event.
/// {@endtemplate}
class EventDatesAndTime {
  /// {@macro event_dates_and_time}
  EventDatesAndTime(this.dates, this.timeStart, this.timeEnd);

  /// All dates when the event is active.
  final List<DateTime> dates;

  /// The time of the event in each day.
  final TimeOfDay timeStart;

  /// The time when the event ends in each day.
  final TimeOfDay timeEnd;
}
