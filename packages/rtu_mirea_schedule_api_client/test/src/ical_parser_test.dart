import 'package:collection/collection.dart';
import 'package:rtu_mirea_schedule_api_client/src/ical_parser.dart';
import 'package:schedule/schedule.dart';
import 'package:test/test.dart';

void main() {
  group('ICalParser', () {
    late ICalParser iCalParser;

    setUp(() {
      iCalParser = ICalParser.fromString(
        'BEGIN:VCALENDAR\n'
        'PRODID:-//github.com/rianjs/ical.net//NONSGML ical.net 4.0//EN\n'
        'VERSION:2.0\n'
        'BEGIN:VEVENT\n'
        'DTEND:20210901T123000\n'
        'DTSTAMP:00010101T000000\n'
        'DTSTART:20210901T122000\n'
        'END:VEVENT\n'
        'END:VCALENDAR',
      );
    });

    test(
      'parse throws InvalidICalendarDataException if iCalendar data is invalid',
      () {
        expect(
          () => ICalParser.fromString(''),
          throwsA(isA<InvalidICalendarDataException>()),
        );
      },
    );

    test('parse throws ICalendarParsingException if DTSTART is null', () {
      iCalParser = ICalParser.fromString(
        'BEGIN:VCALENDAR\n'
        'PRODID:-//github.com/rianjs/ical.net//NONSGML ical.net 4.0//EN\n'
        'VERSION:2.0\n'
        'BEGIN:VEVENT\n'
        'DTEND:20210901T123000\n'
        'END:VEVENT\n'
        'END:VCALENDAR',
      );
      expect(
        () => iCalParser.parse(),
        throwsA(isA<ICalendarParsingException>()),
      );
    });

    test('parses lesson metadata from a calendar event', () {
      iCalParser = ICalParser.fromString('''
BEGIN:VCALENDAR
PRODID:-//github.com/ical-org/ical.net//NONSGML ical.net 4.0//EN
VERSION:2.0
BEGIN:VEVENT
CATEGORIES:ПР
DESCRIPTION:Преподаватель: Поляков Артём Сергеевич\n\nГруппа: БББО-05-23\n
DTEND;TZID=Europe/Moscow:20250210T121000
DTSTAMP:00010101T000000
DTSTART;TZID=Europe/Moscow:20250210T104000
EXDATE;TZID=Europe/Moscow:20250210T104000,20250224T104000,20250310T104000,
 20250324T104000,20250407T104000,20250421T104000,20250505T104000,20250519T
 104000
LOCATION:10 (С-20)
RRULE:FREQ=WEEKLY;INTERVAL=2;UNTIL=20250615T210000Z
SEQUENCE:0
SUMMARY:ПР Угрозы информационной безопасности автоматизированных систем
TRANSP:OPAQUE
UID:91285961-321a-5965-80fc-222d40f11b6d
X-META-AUDITORIUM;VALUE=TEXT;ID=99;TYPE=3;NUMBER=10;CAMPUS=С-20:10 (С-20)
X-META-DISCIPLINE;VALUE=TEXT:Угрозы информационной безопасности автоматизи
 рованных систем
X-META-GROUP;VALUE=TEXT;ID=679;TYPE=1:БББО-05-23
X-META-LESSON_TYPE;VALUE=TEXT:ПР
X-META-TEACHER;VALUE=TEXT;ID=2295;TYPE=2:Поляков Артём Сергеевич
X-SCHEDULE_VERSION-ID:11
END:VEVENT
END:VCALENDAR
''');
      final scheduleParts = iCalParser.parse();
      expect(scheduleParts, isA<List<SchedulePart>>());
      final lessonSchedulePart =
          scheduleParts.firstOrNull as LessonSchedulePart?;
      expect(lessonSchedulePart, isNotNull);
      final lesson = lessonSchedulePart!;
      expect(lesson.classrooms, isA<List<Classroom>>());
      expect(lesson.classrooms.firstOrNull?.name, '10');
      expect(lesson.classrooms.firstOrNull?.campus?.shortName, 'С-20');
      expect(lesson.lessonType, LessonType.practice);
      expect(
        lesson.subject,
        'Угрозы информационной безопасности автоматизированных систем',
      );
      expect(lesson.teachers, isA<List<Teacher>>());
      expect(lesson.teachers.firstOrNull?.name, 'Поляков Артём Сергеевич');
      expect(lesson.groups, isA<List<String>>());
      expect(lesson.groups?.firstOrNull, 'БББО-05-23');
    });

    test('get LessonSchedulePart if calendar data is valid', () {
      iCalParser = ICalParser.fromString('''
BEGIN:VCALENDAR
PRODID:-//github.com/ical-org/ical.net//NONSGML ical.net 4.0//EN
VERSION:2.0
BEGIN:VEVENT
CATEGORIES:ПР
DESCRIPTION:ИНБО-07-22\n
DTEND;TZID=Europe/Moscow:20250210T121000
DTSTAMP:00010101T000000
DTSTART;TZID=Europe/Moscow:20250210T104000
EXDATE;TZID=Europe/Moscow:20250210T104000,20250224T104000,20250310T104000,
 20250324T104000,20250407T104000,20250421T104000,20250505T104000,20250519T
 104000
LOCATION:А-423 (В-78)
RRULE:FREQ=WEEKLY;INTERVAL=2;UNTIL=20250615T210000Z
SEQUENCE:0
SUMMARY:ПР Архитектура интеграции и развертывания
TRANSP:OPAQUE
UID:170295bc-f71e-5d4c-8a7e-482c52a183f3
X-META-AUDITORIUM;VALUE=TEXT;ID=204;TYPE=3;NUMBER=А-423;CAMPUS=В-78:А-423
 (В-78)
X-META-DISCIPLINE;VALUE=TEXT:Архитектура интеграции и развертывания
X-META-GROUP;VALUE=TEXT;ID=547;TYPE=1:ИНБО-07-22
X-META-LESSON_TYPE;VALUE=TEXT:ПР
X-META-TEACHER;VALUE=TEXT;ID=1079;TYPE=2:Лаптев Иван Александрович
X-SCHEDULE_VERSION-ID:11
END:VEVENT
END:VCALENDAR
''');
      final scheduleParts = iCalParser.parse();
      expect(scheduleParts, isA<List<SchedulePart>>());
      final lessonSchedulePart =
          scheduleParts.firstOrNull as LessonSchedulePart?;
      expect(lessonSchedulePart, isNotNull);
      final lesson = lessonSchedulePart!;
      expect(lesson.classrooms, isA<List<Classroom>>());
      expect(lesson.classrooms.firstOrNull?.name, 'А-423');
      expect(lesson.classrooms.firstOrNull?.campus?.shortName, 'В-78');
      expect(lesson.lessonType, LessonType.practice);
      expect(
        lesson.subject,
        'Архитектура интеграции и развертывания',
      );
      expect(lesson.teachers, isA<List<Teacher>>());
      expect(
        lesson.teachers.firstOrNull?.name,
        'Лаптев Иван Александрович',
      );
      expect(lesson.groups, isA<List<String>>());
      expect(lesson.groups?.firstOrNull, 'ИНБО-07-22');
    });
  });
}
