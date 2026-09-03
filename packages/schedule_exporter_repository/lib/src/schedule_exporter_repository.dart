import 'dart:convert';
import 'dart:developer';

import 'package:collection/collection.dart';
import 'package:device_calendar/device_calendar.dart';
import 'package:flutter/material.dart' as m;
import 'package:schedule/schedule.dart';
import 'package:schedule_exporter_repository/src/calendar_exception.dart';
import 'package:timezone/timezone.dart' as tz;

/// Exports lessons to a device calendar.
class ScheduleExporterRepository {
  /// Creates an exporter with optional tenant-specific event metadata.
  ScheduleExporterRepository({
    DeviceCalendarPlugin? deviceCalendarPlugin,
    Uri? eventUrl,
    String calendarAccountName = 'University',
  }) : _deviceCalendarPlugin = deviceCalendarPlugin ?? DeviceCalendarPlugin(),
       _eventUrl = eventUrl,
       _calendarAccountName = calendarAccountName;

  final DeviceCalendarPlugin _deviceCalendarPlugin;
  final Uri? _eventUrl;
  final String _calendarAccountName;

  /// Writes lessons into a named calendar.
  Future<void> exportScheduleToCalendar({
    required String calendarName,
    required List<LessonSchedulePart> lessons,
    List<CalendarSchedulePart> events = const [],
    bool includeEmojis = true,
    bool includeShortTypeNames = false,
    List<int> reminderMinutes = const [
      10,
      30,
      720,
    ], // 10 minutes, 30 minutes, 12 hours
    bool deleteExistingCalendar = false,
  }) async {
    try {
      if (calendarName.trim().isEmpty) {
        throw const CalendarException('Failed to determine calendar name');
      }
      final occurrences = <String, _ExportOccurrence>{};
      for (final lesson in lessons) {
        for (final date in lesson.dates) {
          final start = _combineDateAndTime(date, lesson.lessonBells.startTime);
          var end = _combineDateAndTime(date, lesson.lessonBells.endTime);
          if (!end.isAfter(start)) end = end.add(const Duration(days: 1));
          final key = base64Url.encode(
            utf8.encode(
              jsonEncode([
                calendarName.trim(),
                lesson.uid ?? lesson.subject,
                lesson.lessonType.name,
                DateTime(date.year, date.month, date.day).toIso8601String(),
                '${lesson.lessonBells.startTime}',
                if (lesson.uid == null)
                  lesson.teachers.map((t) => t.name).toList()..sort(),
              ]),
            ),
          );
          final prefix = _getLessonTypeRepresentation(
            lesson.lessonType,
            includeEmojis,
            includeShortTypeNames,
          );
          occurrences[key] = (
            title: '$prefix ${lesson.subject}'.trim(),
            description: [
              'Преподаватели: ${lesson.teachers.map((t) => t.name).join(', ')}',
              'Аудитории: ${lesson.classrooms.map((c) => c.name).join(', ')}',
            ].join('\n'),
            location: lesson.classrooms.map((c) => c.name).join(', '),
            start: start,
            end: end,
            allDay: false,
          );
        }
      }
      for (final event in events) {
        final dates = <DateTime?>[
          if (event.isAllDay) ...event.dates.toSet() else event.startsAt,
        ];
        for (final date in dates) {
          if (date == null || event.title.trim().isEmpty) {
            throw const CalendarException(
              'Event is missing a title or start date',
            );
          }
          final start =
              event.isAllDay ? DateTime(date.year, date.month, date.day) : date;
          final end =
              event.isAllDay
                  ? start.add(const Duration(days: 1))
                  : event.endsAt;
          if (end == null || !end.isAfter(start)) {
            throw const CalendarException('Event is missing a valid end date');
          }
          final key = base64Url.encode(
            utf8.encode(
              jsonEncode([
                calendarName.trim(),
                'calendar-event',
                event.uid ?? event.title,
                start.toIso8601String(),
              ]),
            ),
          );
          occurrences[key] = (
            title: event.title,
            description: event.description ?? '',
            location: event.location ?? '',
            start: start,
            end: end,
            allDay: event.isAllDay,
          );
        }
      }
      if (occurrences.isEmpty) return;

      var permissionsGranted = await _deviceCalendarPlugin.hasPermissions();
      if (!(permissionsGranted.data ?? false)) {
        permissionsGranted = await _deviceCalendarPlugin.requestPermissions();
        if (!(permissionsGranted.data ?? false)) {
          throw const PermissionDeniedException();
        }
      }

      final existingCalendarsResult =
          await _deviceCalendarPlugin.retrieveCalendars();
      if (!existingCalendarsResult.isSuccess ||
          existingCalendarsResult.data == null) {
        throw const CalendarException('Failed to read calendars');
      }
      final existingCalendar = existingCalendarsResult.data!.firstWhereOrNull(
        (cal) => cal.name == calendarName.trim() && cal.isReadOnly == false,
      );
      final calendarId =
          existingCalendar?.id ?? await _createCalendar(calendarName.trim());
      if (calendarId == null || calendarId.isEmpty) {
        throw CalendarCreationException('Failed to create calendar');
      }
      final existingIds = <String, String>{};
      if (existingCalendar != null) {
        final dates =
            occurrences.values.map((entry) => entry.start).toList()..sort();
        final events = await _deviceCalendarPlugin.retrieveEvents(
          calendarId,
          RetrieveEventsParams(
            startDate: dates.first.subtract(const Duration(days: 1)),
            endDate: dates.last.add(const Duration(days: 2)),
          ),
        );
        if (!events.isSuccess || events.data == null) {
          throw const CalendarException('Failed to read calendar events');
        }
        for (final event in events.data!) {
          final marker = event.description?.split('\n').lastOrNull;
          if (event.eventId != null &&
              marker != null &&
              marker.startsWith(_marker)) {
            existingIds[marker.substring(_marker.length)] = event.eventId!;
          }
        }
      }
      for (final entry in occurrences.entries) {
        final occurrence = entry.value;

        final event = Event(
          calendarId,
          eventId: existingIds[entry.key],
          title: occurrence.title,
          description: '${occurrence.description}\n$_marker${entry.key}',
          location: occurrence.location,
          start: _calendarTime(occurrence.start, allDay: occurrence.allDay),
          end: _calendarTime(occurrence.end, allDay: occurrence.allDay),
          allDay: occurrence.allDay,
          reminders:
              reminderMinutes
                  .where((minutes) => minutes >= 0 && !occurrence.allDay)
                  .toSet()
                  .map((minutes) => Reminder(minutes: minutes))
                  .toList(),
          url: _eventUrl,
        );

        final createEvent = await _deviceCalendarPlugin.createOrUpdateEvent(
          event,
        );
        if (createEvent?.isSuccess != true) {
          throw EventCreationException(
            createEvent?.errors.firstOrNull?.errorMessage ?? 'Unknown error',
          );
        }
      }
    } on Exception catch (e, st) {
      log(
        'Failed to export schedule to calendar',
        error: e,
        stackTrace: st,
        name: 'ScheduleExporterRepository',
      );
      rethrow;
    }
  }

  static const _marker = 'university-schedule:';

  tz.TZDateTime _calendarTime(DateTime date, {required bool allDay}) =>
      allDay
          ? tz.TZDateTime(tz.local, date.year, date.month, date.day)
          : tz.TZDateTime.from(date, tz.local);

  Future<String?> _createCalendar(String calendarName) async {
    final result = await _deviceCalendarPlugin.createCalendar(
      calendarName,
      localAccountName: _calendarAccountName,
      calendarColor: m.Colors.blue,
    );
    return result.isSuccess ? result.data : null;
  }

  String _getLessonTypeRepresentation(
    LessonType lessonType,
    bool includeEmojis,
    bool includeShortTypeNames,
  ) {
    final shortName = _shortTypeNames[lessonType] ?? '';
    final emoji =
        includeEmojis ? '${_lessonTypeEmojis[lessonType] ?? ''} ' : '';
    return includeShortTypeNames && shortName.isNotEmpty
        ? '$shortName. $emoji'
        : emoji;
  }

  DateTime _combineDateAndTime(DateTime date, TimeOfDay time) {
    return DateTime(date.year, date.month, date.day, time.hour, time.minute);
  }

  static const Map<LessonType, String> _lessonTypeEmojis = {
    LessonType.practice: '🎓',
    LessonType.lecture: '📖',
    LessonType.laboratoryWork: '🧪',
    LessonType.individualWork: '👨‍🏫',
    LessonType.physicalEducation: '🏋️‍♂️',
    LessonType.consultation: '💬',
    LessonType.exam: '📝',
    LessonType.credit: '💼',
    LessonType.courseWork: '📑',
    LessonType.courseProject: '📊',
    LessonType.unknown: '❓',
  };

  static const Map<LessonType, String> _shortTypeNames = {
    LessonType.practice: 'ПР',
    LessonType.lecture: 'ЛЕК',
    LessonType.laboratoryWork: 'ЛАБ',
    LessonType.individualWork: 'САМ/РАБ',
    LessonType.physicalEducation: 'ФИЗ-РА',
    LessonType.consultation: 'КОНС',
    LessonType.exam: 'ЭКЗ',
    LessonType.credit: 'ЗАЧ',
    LessonType.courseWork: 'К/Р',
    LessonType.courseProject: 'К/П',
    LessonType.unknown: '???',
  };
}

typedef _ExportOccurrence =
    ({
      String title,
      String description,
      String location,
      DateTime start,
      DateTime end,
      bool allDay,
    });
