import 'package:rtu_mirea_schedule_api_client/src/ical_parser.dart';
import 'package:schedule/schedule.dart';
import 'package:test/test.dart';

void main() {
  group('ICalParser', () {
    late ICalParser iCalParser;

    setUp(() {
      iCalParser = ICalParser.fromString('BEGIN:VCALENDAR\n'
          'PRODID:-//github.com/rianjs/ical.net//NONSGML ical.net 4.0//EN\n'
          'VERSION:2.0\n'
          'BEGIN:VEVENT\n'
          'DTEND:20210901T123000\n'
          'DTSTAMP:00010101T000000\n'
          'DTSTART:20210901T122000\n'
          'END:VEVENT\n'
          'END:VCALENDAR');
    });

    test('can be instantiated', () {
      expect(iCalParser, isNotNull);
    });

    test('parse throws InvalidICalendarDataException if iCalendar data is invalid', () {
      expect(
        () => ICalParser.fromString(''),
        throwsA(isA<InvalidICalendarDataException>()),
      );
    });

    test('parse throws ICalendarParsingException if DTSTART is null', () {
      iCalParser = ICalParser.fromString('BEGIN:VCALENDAR\n'
          'PRODID:-//github.com/rianjs/ical.net//NONSGML ical.net 4.0//EN\n'
          'VERSION:2.0\n'
          'BEGIN:VEVENT\n'
          'DTEND:20210901T123000\n'
          'END:VEVENT\n'
          'END:VCALENDAR');
      expect(
        () => iCalParser.parse(),
        throwsA(isA<ICalendarParsingException>()),
      );
    });

    test('get SchedulePart if calendar data is valid', () {
      iCalParser = ICalParser.fromString('''
BEGIN:VCALENDAR
PRODID:-//github.com/rianjs/ical.net//NONSGML ical.net 4.0//EN\n'
VERSION:2.0
BEGIN:VEVENT
CATEGORIES:СР
DESCRIPTION:ХЕБО-08-21 \n
DTEND;TZID=Europe/Moscow:20230901T175000
DTSTAMP:00010101T000000
DTSTART;TZID=Europe/Moscow:20230901T162000
EXDATE;TZID=Europe/Moscow:20231222T162000
LOCATION:А-110 (МП-1) А-153 (МП-1) Б-304 (МП-1) А-111 (МП-1) А-155 (МП-1) 
 А-112 (МП-1) А-150 (МП-1) А-156 (МП-1) А-157 (МП-1) А-109 (МП-1) Б-308 (М
 П-1) Б-305 (МП-1) Б-306 (МП-1) Б-307 (МП-1)
RRULE:FREQ=WEEKLY;INTERVAL=2;UNTIL=20231222T205959Z
SEQUENCE:0
SUMMARY:СР Ознакомительная практика
UID:a531566f-f11e-dd25-c3bb-b5c525ee5ae0
END:VEVENT
END:VCALENDAR''');
      final scheduleParts = iCalParser.parse();
      expect(scheduleParts, isA<List<SchedulePart>>());
    });
  });
}
