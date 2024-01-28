import 'package:collection/collection.dart';
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
  /// Creates a new instance of the [ICalParser] from the iCalendar string data.
  ///
  /// Throws [InvalidICalendarDataException] if the iCalendar data is invalid.
  factory ICalParser.fromString(String data) => ICalParser._(data);
  ICalParser._(this._data) {
    try {
      _registerCustomFields();

      _calendar = ICalendar.fromString(_data);
    } catch (error, stackTrace) {
      Error.throwWithStackTrace(
        InvalidICalendarDataException(error: error),
        stackTrace,
      );
    }
  }

  void _registerCustomFields() {
    if (!ICalendar.objects.containsKey('RDATE')) {
      ICalendar.registerField(
        field: 'RDATE',
        function: (value, params, event, lastEvent) {
          try {
            final datesString = value.split(',');

            final dates = datesString.map((e) {
              final date = IcsDateTime(dt: e);

              return date;
            }).toList();

            lastEvent['RDATE'] = dates;

            return lastEvent;
          } catch (error, stackTrace) {
            Error.throwWithStackTrace(
              InvalidICalendarDataException(error: error),
              stackTrace,
            );
          }
        },
      );
    }

    if (!ICalendar.objects.containsKey('X-META-AUDITORIUM')) {
      ICalendar.registerField(
        field: 'X-META-AUDITORIUM',
        function: (value, params, event, lastEvent) {
          try {
            lastEvent['X-META-AUDITORIUM'] = [
              ...(lastEvent['X-META-AUDITORIUM'] ?? []) as Iterable,
              value,
            ];

            return lastEvent;
          } catch (error, stackTrace) {
            Error.throwWithStackTrace(
              InvalidICalendarDataException(error: error),
              stackTrace,
            );
          }
        },
      );
    }

    if (!ICalendar.objects.containsKey('X-META-DISCIPLINE')) {
      ICalendar.registerField(
        field: 'X-META-DISCIPLINE',
        function: (value, params, event, lastEvent) {
          try {
            lastEvent['X-META-DISCIPLINE'] = value;

            return lastEvent;
          } catch (error, stackTrace) {
            Error.throwWithStackTrace(
              InvalidICalendarDataException(error: error),
              stackTrace,
            );
          }
        },
      );
    }

    if (!ICalendar.objects.containsKey('X-META-GROUP')) {
      ICalendar.registerField(
        field: 'X-META-GROUP',
        function: (value, params, event, lastEvent) {
          try {
            lastEvent['X-META-GROUP'] = [
              ...(lastEvent['X-META-GROUP'] ?? []) as Iterable,
              value,
            ];

            return lastEvent;
          } catch (error, stackTrace) {
            Error.throwWithStackTrace(
              InvalidICalendarDataException(error: error),
              stackTrace,
            );
          }
        },
      );
    }

    if (!ICalendar.objects.containsKey('X-META-LESSON_TYPE')) {
      ICalendar.registerField(
        field: 'X-META-LESSON_TYPE',
        function: (value, params, event, lastEvent) {
          try {
            lastEvent['X-META-LESSON_TYPE'] = value;

            return lastEvent;
          } catch (error, stackTrace) {
            Error.throwWithStackTrace(
              InvalidICalendarDataException(error: error),
              stackTrace,
            );
          }
        },
      );
    }

    if (!ICalendar.objects.containsKey('X-META-TEACHER')) {
      ICalendar.registerField(
        field: 'X-META-TEACHER',
        function: (value, params, event, lastEvent) {
          try {
            lastEvent['X-META-TEACHER'] = [
              ...(lastEvent['X-META-TEACHER'] ?? []) as Iterable,
              value,
            ];

            return lastEvent;
          } catch (error, stackTrace) {
            Error.throwWithStackTrace(
              InvalidICalendarDataException(error: error),
              stackTrace,
            );
          }
        },
      );
    }
  }

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

      final discipline = data['x-meta-discipline'] as String?;

      if (discipline == null) {
        throw const ICalendarParsingException(
          error: 'The iCalendar data is invalid. The X-META-DISCIPLINE field '
              'is required.',
        );
      }

      final teachers = List<String>.from(data['x-meta-teacher'] as Iterable<dynamic>? ?? []);

      final groups = List<String>.from(data['x-meta-group'] as Iterable<dynamic>? ?? []);

      final location = List<String>.from(
        data['x-meta-auditorium'] as Iterable<dynamic>? ?? [],
      );

      final classrooms = location.map(parseClassroomsFromLocation).flattened.toList();

      final type = data['x-meta-lesson_type'] as String?;

      final lessonType = parseSubjectAndLessonTypeFromSummary(type ?? '');

      final schedulePart = LessonSchedulePart(
        subject: discipline,
        lessonType: lessonType,
        teachers: teachers.map((e) => Teacher(name: e)).toList(),
        classrooms: classrooms,
        lessonBells: defaultLessonsBells
            .where(
              (element) => element.startTime == datesAndTime.timeStart && element.endTime == datesAndTime.timeEnd,
            )
            .first,
        dates: datesAndTime.dates,
        groups: groups,
      );

      scheduleParts.add(schedulePart);
    }

    final exams = <SchedulePart>[];
    var lessons = <SchedulePart>[];

    for (final schedulePart in scheduleParts) {
      if (_isSessionLesson(schedulePart)) {
        exams.add(schedulePart);
      } else {
        lessons.add(schedulePart);
      }
    }

    final excludeDates = [
      DateTime(2023, 12, 23),
      DateTime(2023, 12, 24),
      DateTime(2023, 12, 25),
      DateTime(2023, 12, 26),
      DateTime(2023, 12, 27),
      DateTime(2023, 12, 28),
      DateTime(2023, 12, 29),
      DateTime(2023, 12, 30),
      DateTime(2023, 12, 31),
      DateTime(2024),
      DateTime(2024, 1, 2),
      DateTime(2024, 1, 3),
      DateTime(2024, 1, 4),
      DateTime(2024, 1, 5),
      DateTime(2024, 1, 6),
      DateTime(2024, 1, 7),
      DateTime(2024, 1, 8),
    ];

    lessons = lessons.map((lesson) {
      if (lesson is LessonSchedulePart) {
        final lessonDates = lesson.dates;

        final dates = lessonDates.where((date) {
          return !excludeDates.any((excludeDate) => date.isSameDate(excludeDate));
        }).toList();

        return lesson.copyWith(dates: dates);
      } else {
        return lesson;
      }
    }).toList();

    return lessons..addAll(exams);
  }

  bool _isSessionLesson(SchedulePart schedulePart) {
    if (schedulePart is LessonSchedulePart) {
      return schedulePart.lessonType == LessonType.exam ||
          schedulePart.lessonType == LessonType.credit ||
          schedulePart.lessonType == LessonType.courseWork ||
          schedulePart.lessonType == LessonType.courseProject ||
          schedulePart.lessonType == LessonType.consultation;
    }

    return false;
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
    dtstartObject = dtstartObject.add(Duration(hours: dtstartObject.timeZoneOffset.inHours)).toUtc();
    dtendObject = dtendObject.add(Duration(hours: dtendObject.timeZoneOffset.inHours)).toUtc();

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

    final rdate = data['rdate'] as List<IcsDateTime>?;
    if (rdate != null) {
      final dates = rdate.map((e) => e.toDateTime()).toList();

      datesAndTime.dates.addAll(dates.whereNotNull());
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

extension DateOnlyCompare on DateTime {
  bool isSameDate(DateTime other) {
    return year == other.year && month == other.month && day == other.day;
  }
}
