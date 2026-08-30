import 'package:collection/collection.dart';
import 'package:icalendar_parser/icalendar_parser.dart';
import 'package:rrule/rrule.dart';
import 'package:rtu_mirea_schedule_api_client/src/campuses.dart';
import 'package:rtu_mirea_schedule_api_client/src/fields_data_parsers.dart';
import 'package:rtu_mirea_schedule_api_client/src/ical_custom_fields_registry.dart';
import 'package:rtu_mirea_schedule_api_client/src/lessons_bells.dart';
import 'package:schedule/schedule.dart';

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
      ICalCustomFieldsRegistry.register();

      _calendar = ICalendar.fromString(_data);
    } catch (error, stackTrace) {
      Error.throwWithStackTrace(
        InvalidICalendarDataException(error: error),
        stackTrace,
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
      final data = <String, Object?>{
        for (final entry in tmpData.entries)
          entry.key.toLowerCase(): entry.value,
      };

      if (data['transp'] == IcsTransp.transparent) {
        continue;
      }

      if (data['type']?.toString().toLowerCase() != 'vevent') {
        continue;
      }

      final datesAndTime = _getEventDatesAndTime(data);

      final discipline = data['x-meta-discipline'] as String?;

      if (discipline == null) {
        throw const ICalendarParsingException(
          error:
              'The iCalendar data is invalid. The X-META-DISCIPLINE field '
              'is required.',
        );
      }

      final teachers = _metadataRefs(
        data['x-meta-teacher-raw'],
        data['x-meta-teacher'],
      );

      final groupRefs = _metadataRefs(
        data['x-meta-group-raw'],
        data['x-meta-group'],
      );
      final groups = groupRefs.map((e) => e.name).toList();
      final groupEntities = groupRefs
          .map((e) => Group(name: e.name, uid: e.uid))
          .toList();

      final location = _asObjects(
        data['x-meta-auditorium'],
      ).whereType<String>().toList();
      final classroomRefs = _metadataRefs(
        data['x-meta-auditorium-raw'],
        data['x-meta-auditorium'],
      );

      final classrooms = classroomRefs.isEmpty
          ? location.map(getClassroomsFromLocationText).flattened.toList()
          : classroomRefs.map(_classroomFromMetadataRef).toList();

      final type = data['x-meta-lesson_type'] as String?;

      final lessonType = getLessonTypeFromText(type ?? '');

      final schedulePart = LessonSchedulePart(
        uid: data['uid'] as String?,
        subject: discipline,
        lessonType: lessonType,
        teachers: teachers
            .map((e) => Teacher(name: e.name, uid: e.uid))
            .toList(),
        classrooms: classrooms,
        lessonBells:
            defaultLessonsBells.firstWhereOrNull(
              (element) =>
                  element.startTime == datesAndTime.timeStart &&
                  element.endTime == datesAndTime.timeEnd,
            ) ??
            LessonBells(
              startTime: datesAndTime.timeStart,
              endTime: datesAndTime.timeEnd,
            ),
        dates: datesAndTime.dates,
        groups: groups,
        groupEntities: groupEntities.isEmpty ? null : groupEntities,
      );

      scheduleParts.add(schedulePart);
    }

    return scheduleParts;
  }

  EventDatesAndTime _getEventDatesAndTime(Map<String, Object?> data) {
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
        error:
            'The iCalendar data is invalid. The DTSTART or DTEND cannot '
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
      final dates = _getDatesByRrule(rrule, dtstartObject);

      datesAndTime = EventDatesAndTime(dates, timeStart, timeEnd);
    } else {
      datesAndTime = EventDatesAndTime([dtstartObject], timeStart, timeEnd);
    }

    final rdate = _asObjects(data['rdate']).whereType<IcsDateTime>();
    if (rdate.isNotEmpty) {
      final dates = rdate.map((value) => value.toDateTime()).toList();

      datesAndTime.dates.addAll(dates.nonNulls);
    }

    final exdate = _asObjects(data['exdate']).whereType<IcsDateTime>();

    if (exdate.isNotEmpty) {
      final dates = exdate.map((value) => value.toDateTime()).toList();

      datesAndTime.dates.removeWhere(
        (element) => dates.any((e) => e != null && e.isSameDate(element)),
      );
    }

    return datesAndTime;
  }

  static List<DateTime> _getDatesByRrule(String rrule, DateTime start) {
    final rruleObject = RecurrenceRule.fromString('RRULE:$rrule');

    final instances = rruleObject.getInstances(start: start);

    return instances.toList();
  }
}

Classroom _classroomFromMetadataRef(_MetadataRef ref) {
  final campusName = ref.extra['campus'];
  final classroomName = ref.extra['number'] ?? ref.name;

  if (classroomName.contains('Дистанционно')) {
    return Classroom.online();
  }

  final campus = campusName == null
      ? null
      : (campuses.firstWhereOrNull(
              (element) => element.shortName == campusName.trim(),
            ) ??
            Campus(
              name: campusName.trim(),
              shortName: campusName.trim(),
              uid: campusName.trim(),
            ));

  return Classroom(name: classroomName.trim(), uid: ref.uid, campus: campus);
}

List<_MetadataRef> _metadataRefs(Object? rawValue, Object? fallbackValue) {
  final rawItems = _asObjects(rawValue);

  final refs = rawItems
      .whereType<Map<Object?, Object?>>()
      .map(_MetadataRef.fromJson)
      .where((ref) => ref.name.isNotEmpty)
      .toList();

  if (refs.isNotEmpty) return refs;

  final fallbackItems = _asObjects(fallbackValue);

  return fallbackItems
      .map((value) => _MetadataRef(name: value?.toString() ?? ''))
      .where((ref) => ref.name.isNotEmpty)
      .toList();
}

class _MetadataRef {
  const _MetadataRef({required this.name, this.uid, this.extra = const {}});

  factory _MetadataRef.fromJson(Map<Object?, Object?> json) {
    final values = json.map(
      (key, value) => MapEntry(key?.toString() ?? '', value),
    );
    return _MetadataRef(
      name: _stringOrEmpty(values['name'] ?? values['number']).trim(),
      uid: _nullableString(values['uid']),
      extra: _stringValues(values),
    );
  }

  final String name;
  final String? uid;
  final Map<String, String> extra;
}

String? _nullableString(Object? value) {
  final stringValue = value?.toString().trim();
  if (stringValue == null || stringValue.isEmpty) return null;
  return stringValue;
}

/// {@template event_dates_and_time}
/// Includes a list of dates and a time of the event.
/// {@endtemplate}
class EventDatesAndTime {
  /// {@macro event_dates_and_time}
  const EventDatesAndTime(this.dates, this.timeStart, this.timeEnd);

  /// All dates when the event is active.
  final List<DateTime> dates;

  /// The time of the event in each day.
  final TimeOfDay timeStart;

  /// The time when the event ends in each day.
  final TimeOfDay timeEnd;
}

Iterable<Object?> _asObjects(Object? value) =>
    value is Iterable ? value.cast() : const [];

String _stringOrEmpty(Object? value) => value?.toString() ?? '';

Map<String, String> _stringValues(Map<String, Object?> values) =>
    Map.fromEntries(values.entries.map(_stringEntry).nonNulls);

MapEntry<String, String>? _stringEntry(MapEntry<String, Object?> entry) {
  final value = entry.value;
  return value == null ? null : MapEntry(entry.key, value.toString());
}

class InvalidICalendarDataException implements Exception {
  const InvalidICalendarDataException({required this.error});

  final Object error;

  @override
  String toString() => 'InvalidICalendarDataException: $error';
}

class ICalendarParsingException implements Exception {
  const ICalendarParsingException({required this.error});

  final Object error;

  @override
  String toString() => 'ICalendarParsingException: $error';
}

extension _DateOnlyCompare on DateTime {
  bool isSameDate(DateTime other) {
    return year == other.year && month == other.month && day == other.day;
  }
}
