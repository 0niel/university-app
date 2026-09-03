import 'dart:collection';

import 'package:device_calendar/device_calendar.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:schedule/schedule.dart';
import 'package:schedule_exporter_repository/schedule_exporter_repository.dart';

class _CalendarPlugin extends Mock implements DeviceCalendarPlugin {}

Result<T> _result<T>(T value) => Result<T>()..data = value;

void main() {
  group('ScheduleExporterRepository', () {
    test('can be instantiated', () {
      expect(ScheduleExporterRepository(), isA<ScheduleExporterRepository>());
    });
  });

  group('safe calendar export', () {
    late _CalendarPlugin plugin;
    late ScheduleExporterRepository repository;
    final lesson = LessonSchedulePart(
      uid: 'lesson-1',
      subject: 'Algebra',
      lessonType: LessonType.lecture,
      teachers: const [Teacher(name: 'Teacher', email: 'teacher@example.com')],
      classrooms: const [Classroom(name: 'A-1')],
      lessonBells: LessonBells(
        startTime: const TimeOfDay(hour: 9, minute: 0),
        endTime: const TimeOfDay(hour: 10, minute: 30),
      ),
      dates: [DateTime(2030, 9, 2), DateTime(2030, 9, 2)],
    );

    setUpAll(() {
      registerFallbackValue(Event('calendar'));
      registerFallbackValue(const RetrieveEventsParams());
    });

    setUp(() {
      plugin = _CalendarPlugin();
      repository = ScheduleExporterRepository(deviceCalendarPlugin: plugin);
      when(plugin.hasPermissions).thenAnswer((_) async => _result(true));
      when(plugin.retrieveCalendars).thenAnswer(
        (_) async => _result(
          UnmodifiableListView([
            Calendar(id: 'calendar', name: 'Schedule', isReadOnly: false),
          ]),
        ),
      );
      when(() => plugin.retrieveEvents(any(), any())).thenAnswer(
        (_) async => _result(
          UnmodifiableListView([
            Event('calendar', eventId: 'personal', title: 'Personal'),
          ]),
        ),
      );
      when(
        () => plugin.createOrUpdateEvent(any()),
      ).thenAnswer((_) async => _result('created'));
    });

    test(
      'deduplicates occurrences and never deletes personal calendars or events',
      () async {
        await repository.exportScheduleToCalendar(
          calendarName: 'Schedule',
          lessons: [lesson, lesson],
          deleteExistingCalendar: true,
        );
        final event =
            verify(
                  () => plugin.createOrUpdateEvent(captureAny()),
                ).captured.single
                as Event;
        expect(event.title, contains('Algebra'));
        expect(event.attendees, isNull);
        expect(event.eventId, isNull);
        verifyNever(() => plugin.deleteCalendar(any()));
        verifyNever(() => plugin.deleteEvent(any(), any()));
      },
    );

    test('a repeated export updates only its own marked event', () async {
      await repository.exportScheduleToCalendar(
        calendarName: 'Schedule',
        lessons: [lesson],
      );
      final first =
          verify(() => plugin.createOrUpdateEvent(captureAny())).captured.single
              as Event;
      when(() => plugin.retrieveEvents(any(), any())).thenAnswer(
        (_) async => _result(
          UnmodifiableListView([
            Event(
              'calendar',
              eventId: 'own-event',
              description: first.description,
            ),
            Event('calendar', eventId: 'personal', title: 'Personal'),
          ]),
        ),
      );
      await repository.exportScheduleToCalendar(
        calendarName: 'Schedule',
        lessons: [lesson.copyWith(subject: 'Updated algebra')],
      );
      final second =
          verify(() => plugin.createOrUpdateEvent(captureAny())).captured.single
              as Event;
      expect(second.eventId, 'own-event');
      expect(second.title, contains('Updated algebra'));
      verifyNever(() => plugin.deleteEvent(any(), any()));
    });

    test(
      'empty export does not request permission or write calendars',
      () async {
        await repository.exportScheduleToCalendar(
          calendarName: 'Schedule',
          lessons: [],
        );
        verifyNever(plugin.hasPermissions);
        verifyNever(() => plugin.createOrUpdateEvent(any()));
      },
    );

    test('exports timed and all-day events with their source times', () async {
      final day = DateTime(2030, 9, 2);
      await repository.exportScheduleToCalendar(
        calendarName: 'Schedule',
        lessons: [],
        events: [
          CalendarSchedulePart(
            uid: 'event',
            title: 'Meeting',
            dates: [day],
            startsAt: day.add(const Duration(hours: 12)),
            endsAt: day.add(const Duration(hours: 13)),
            description: 'Personal event',
            location: 'Hall',
          ),
          CalendarSchedulePart(
            uid: 'holiday',
            title: 'Holiday',
            dates: [day],
            isAllDay: true,
          ),
        ],
      );
      final events =
          verify(
            () => plugin.createOrUpdateEvent(captureAny()),
          ).captured.cast<Event>();
      expect(events.map((event) => event.title), ['Meeting', 'Holiday']);
      expect(
        events.first.start!.toUtc(),
        day.add(const Duration(hours: 12)).toUtc(),
      );
      expect(
        events.first.end!.toUtc(),
        day.add(const Duration(hours: 13)).toUtc(),
      );
      expect(events.last.allDay, isTrue);
      expect(events.last.reminders, isEmpty);
      expect(
        (
          events.last.start!.year,
          events.last.start!.month,
          events.last.start!.day,
          events.last.end!.day,
        ),
        (2030, 9, 2, 3),
      );
    });

    test('missing event end fails before any calendar mutation', () async {
      await expectLater(
        repository.exportScheduleToCalendar(
          calendarName: 'Schedule',
          lessons: [],
          events: [
            CalendarSchedulePart(
              title: 'Unknown end',
              dates: [DateTime(2030)],
              startsAt: DateTime(2030),
            ),
          ],
        ),
        throwsA(isA<CalendarException>()),
      );
      verifyNever(plugin.hasPermissions);
      verifyNever(() => plugin.createOrUpdateEvent(any()));
    });

    test('denied permission prevents every calendar mutation', () async {
      when(plugin.hasPermissions).thenAnswer((_) async => _result(false));
      when(plugin.requestPermissions).thenAnswer((_) async => _result(false));
      await expectLater(
        repository.exportScheduleToCalendar(
          calendarName: 'Schedule',
          lessons: [lesson],
        ),
        throwsA(isA<PermissionDeniedException>()),
      );
      verifyNever(plugin.retrieveCalendars);
      verifyNever(() => plugin.createOrUpdateEvent(any()));
    });

    test(
      'creates a calendar if no writable matching calendar exists',
      () async {
        when(plugin.retrieveCalendars).thenAnswer(
          (_) async => _result(
            UnmodifiableListView([
              Calendar(id: 'readonly', name: 'Schedule', isReadOnly: true),
            ]),
          ),
        );
        when(
          () => plugin.createCalendar(
            any(),
            localAccountName: any(named: 'localAccountName'),
            calendarColor: any(named: 'calendarColor'),
          ),
        ).thenAnswer((_) async => _result('new-calendar'));
        await repository.exportScheduleToCalendar(
          calendarName: 'Schedule',
          lessons: [lesson],
        );
        final event =
            verify(
                  () => plugin.createOrUpdateEvent(captureAny()),
                ).captured.single
                as Event;
        expect(event.calendarId, 'new-calendar');
        verifyNever(() => plugin.deleteCalendar(any()));
      },
    );
  });
}
