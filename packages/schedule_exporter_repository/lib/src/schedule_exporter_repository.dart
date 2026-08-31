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
    bool includeEmojis = true,
    bool includeShortTypeNames = false,
    List<int> reminderMinutes = const [
      10,
      30,
      720,
    ], // 10 minutes, 30 minutes, 12 hours
    bool deleteExistingCalendar = true,
  }) async {
    try {
      if (calendarName.isEmpty) {
        throw const CalendarException('Failed to determine calendar name');
      }

      var permissionsGranted = await _deviceCalendarPlugin.hasPermissions();
      if (!(permissionsGranted.data ?? false)) {
        permissionsGranted = await _deviceCalendarPlugin.requestPermissions();
        if (!(permissionsGranted.data ?? false)) {
          throw const PermissionDeniedException();
        }
      }

      final existingCalendarsResult =
          await _deviceCalendarPlugin.retrieveCalendars();
      final existingCalendarsData = existingCalendarsResult.data;
      if (existingCalendarsResult.isSuccess && existingCalendarsData != null) {
        final existingCalendar = existingCalendarsData.firstWhereOrNull(
          (cal) => cal.name == calendarName,
        );

        if (deleteExistingCalendar && existingCalendar != null) {
          final deleteResult = await _deviceCalendarPlugin.deleteCalendar(
            existingCalendar.id!,
          );
          if (!deleteResult.isSuccess) {
            final errorMessage =
                deleteResult.errors.firstOrNull?.errorMessage ??
                'Unknown error';
            throw CalendarException(
              'Failed to delete existing calendar: $errorMessage',
            );
          }
        } else if (existingCalendar != null) {
          final eventsResult = await _deviceCalendarPlugin.retrieveEvents(
            existingCalendar.id,
            RetrieveEventsParams(
              startDate: DateTime.now().subtract(
                const Duration(days: 365 * 5),
              ),
              endDate: DateTime.now().add(const Duration(days: 365 * 5)),
            ),
          );
          final eventsData = eventsResult.data;
          if (eventsResult.isSuccess && eventsData != null) {
            for (final event in eventsData) {
              final eventId = event.eventId;
              final deleteEventResult = await _deviceCalendarPlugin.deleteEvent(
                existingCalendar.id,
                eventId,
              );
              if (!deleteEventResult.isSuccess) {
                final errorMessage =
                    deleteEventResult.errors.firstOrNull?.errorMessage ??
                    'Unknown error';
                final failureMessage =
                    'Failed to delete event ${eventId ?? 'unknown'}: '
                    '$errorMessage';
                throw CalendarException(failureMessage);
              }
            }
          }
        }
      }

      final createCalendarResult = await _createOrGetCalendar(
        calendarName,
        deleteExistingCalendar,
      );
      if (createCalendarResult == null) {
        throw CalendarCreationException('Failed to create calendar');
      }

      final calendarId = createCalendarResult;

      for (final lesson in lessons) {
        final lessonTypeRepresentation = _getLessonTypeRepresentation(
          lesson.lessonType,
          includeEmojis,
          includeShortTypeNames,
        );

        for (final date in lesson.dates) {
          final startDate = _combineDateAndTime(
            date,
            lesson.lessonBells.startTime,
          );
          final endDate = _combineDateAndTime(date, lesson.lessonBells.endTime);

          final event = Event(
            calendarId,
            title: '$lessonTypeRepresentation ${lesson.subject}',
            description:
                'Преподаватели: '
                '${lesson.teachers.map((t) => t.name).join(', ')}\n'
                'Аудитории: ${lesson.classrooms.map((c) => c.name).join(', ')}',
            location: lesson.classrooms.map((c) => c.name).join(', '),
            start: tz.TZDateTime.from(startDate, tz.local),
            end: tz.TZDateTime.from(endDate, tz.local),
            reminders:
                reminderMinutes
                    .map((minutes) => Reminder(minutes: minutes))
                    .toList(),
            url: _eventUrl,
            attendees: _getAttendeesForLesson(lesson),
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

  Future<String?> _createOrGetCalendar(
    String calendarName,
    bool wasDeleted,
  ) async {
    if (wasDeleted) {
      return _createCalendar(calendarName);
    }

    final calendarsResult = await _deviceCalendarPlugin.retrieveCalendars();
    final calendarsData = calendarsResult.data;
    if (calendarsResult.isSuccess && calendarsData != null) {
      final existingCalendar = calendarsData.firstWhereOrNull(
        (cal) => cal.name == calendarName,
      );

      return existingCalendar?.id;
    }

    return _createCalendar(calendarName);
  }

  Future<String?> _createCalendar(String calendarName) async {
    final result = await _deviceCalendarPlugin.createCalendar(
      calendarName,
      localAccountName: _calendarAccountName,
      calendarColor: m.Colors.blue,
    );
    return result.data;
  }

  List<Attendee> _getAttendeesForLesson(LessonSchedulePart lesson) {
    return lesson.teachers.map((teacher) {
      return Attendee(
        name: teacher.name,
        emailAddress: teacher.email ?? '',
        role: AttendeeRole.Required,
      );
    }).toList();
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
