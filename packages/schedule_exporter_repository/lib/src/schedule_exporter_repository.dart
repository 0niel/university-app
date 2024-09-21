import 'package:collection/collection.dart';
import 'package:device_calendar/device_calendar.dart';
import 'package:flutter/material.dart' as m;
import 'package:timezone/timezone.dart' as tz;
import 'package:university_app_server_api/client.dart';

/// Exception related to calendar operations.
class CalendarException implements Exception {
  CalendarException(this.message);
  final String message;

  @override
  String toString() => 'CalendarException: $message';
}

/// Exception thrown when calendar access is denied.
class PermissionDeniedException extends CalendarException {
  PermissionDeniedException() : super('Access to the calendar is denied');
}

/// Exception thrown when calendar creation fails.
class CalendarCreationException extends CalendarException {
  CalendarCreationException(String reason) : super('Failed to create calendar: $reason');
}

/// Exception thrown when event creation fails.
class EventCreationException extends CalendarException {
  EventCreationException(String reason) : super('Failed to add event: $reason');
}

/// Repository responsible for exporting schedules to device calendars.
class ScheduleExporterRepository {
  /// Creates an instance of [ScheduleExporterRepository].
  ScheduleExporterRepository();
  final DeviceCalendarPlugin _deviceCalendarPlugin = DeviceCalendarPlugin();

  /// Exports the given [lessons] to a device calendar with the specified [calendarName].
  ///
  /// [includeEmojis] determines if emojis should be included in event titles.
  /// [includeShortTypeNames] determines if short type names should be included in event titles.
  /// [reminderMinutes] specifies the reminder times in minutes.
  ///
  /// Throws [CalendarException] if the calendar name is invalid.
  /// Throws [PermissionDeniedException] if calendar access is denied.
  /// Throws [CalendarCreationException] if the calendar creation fails.
  /// Throws [EventCreationException] if adding an event fails.
  Future<void> exportScheduleToCalendar({
    required String calendarName,
    required List<LessonSchedulePart> lessons,
    bool includeEmojis = true,
    bool includeShortTypeNames = false,
    List<int> reminderMinutes = const [10, 30, 720], // 10 minutes, 30 minutes, 12 hours
    bool deleteExistingCalendar = true,
  }) async {
    try {
      if (calendarName.isEmpty) {
        throw CalendarException('Failed to determine calendar name');
      }

      var permissionsGranted = await _deviceCalendarPlugin.hasPermissions();
      if (!(permissionsGranted.data ?? false)) {
        permissionsGranted = await _deviceCalendarPlugin.requestPermissions();
        if (!(permissionsGranted.data ?? false)) {
          throw PermissionDeniedException();
        }
      }

      // Проверяем существование календаря
      final existingCalendarsResult = await _deviceCalendarPlugin.retrieveCalendars();
      if (existingCalendarsResult.isSuccess && existingCalendarsResult.data != null) {
        final existingCalendar = existingCalendarsResult.data!.firstWhereOrNull(
          (cal) => cal.name == calendarName,
        );

        if (deleteExistingCalendar && existingCalendar != null) {
          final deleteResult = await _deviceCalendarPlugin.deleteCalendar(existingCalendar.id!);
          if (!deleteResult.isSuccess) {
            throw CalendarException('Failed to delete existing calendar: ${deleteResult.errors.first.errorMessage}');
          }
        } else {
          // Удаляем все события в существующем календаре
          final eventsResult = await _deviceCalendarPlugin.retrieveEvents(
            existingCalendar?.id,
            RetrieveEventsParams(
              startDate: DateTime.now().subtract(const Duration(days: 365 * 5)),
              endDate: DateTime.now().add(const Duration(days: 365 * 5)),
            ),
          );
          if (eventsResult.isSuccess && eventsResult.data != null) {
            for (final event in eventsResult.data!) {
              final deleteEventResult = await _deviceCalendarPlugin.deleteEvent(existingCalendar?.id, event.eventId);
              if (!deleteEventResult.isSuccess) {
                throw CalendarException(
                  'Failed to delete event ${event.eventId}: ${deleteEventResult.errors.first.errorMessage}',
                );
              }
            }
          }
        }
      }

      final createCalendarResult = await _createOrGetCalendar(calendarName, deleteExistingCalendar);
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
          final startDate = _combineDateAndTime(date, lesson.lessonBells.startTime);
          final endDate = _combineDateAndTime(date, lesson.lessonBells.endTime);

          final event = Event(
            calendarId,
            title: '$lessonTypeRepresentation ${lesson.subject}',
            description: 'Преподаватели: ${lesson.teachers.map((t) => t.name).join(', ')}\n'
                'Аудитории: ${lesson.classrooms.map((c) => c.name).join(', ')}',
            location: lesson.classrooms.map((c) => c.name).join(', '),
            start: tz.TZDateTime.from(startDate, tz.local),
            end: tz.TZDateTime.from(endDate, tz.local),
            reminders: reminderMinutes.map((minutes) => Reminder(minutes: minutes)).toList(),
            url: Uri.parse('ninja.mirea.mireaapp://open'),
            attendees: _getAttendeesForLesson(lesson),
          );

          final createEvent = await _deviceCalendarPlugin.createOrUpdateEvent(event);
          if (createEvent?.isSuccess != true) {
            throw EventCreationException(createEvent?.errors.first.errorMessage ?? 'Unknown error');
          }
        }
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<String?> _createOrGetCalendar(String calendarName, bool wasDeleted) async {
    if (wasDeleted) {
      return _createCalendar(calendarName);
    }

    // Иначе, пытаемся найти существующий календарь и вернуть его ID
    final calendarsResult = await _deviceCalendarPlugin.retrieveCalendars();
    if (calendarsResult.isSuccess && calendarsResult.data != null) {
      final existingCalendar = calendarsResult.data!.firstWhereOrNull(
        (cal) => cal.name == calendarName,
      );

      return existingCalendar?.id!;
    }

    // Если календарь не найден, создаем новый
    return _createCalendar(calendarName);
  }

  Future<String?> _createCalendar(String calendarName) async {
    final result = await _deviceCalendarPlugin.createCalendar(
      calendarName,
      localAccountName: 'Университет',
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
    final emoji = includeEmojis ? '${_lessonTypeEmojis[lessonType] ?? ''} ' : '';
    return includeShortTypeNames && shortName.isNotEmpty ? '$shortName. $emoji' : emoji;
  }

  DateTime _combineDateAndTime(DateTime date, TimeOfDay time) {
    return DateTime(date.year, date.month, date.day, time.hour, time.minute);
  }

  // Emojis for lesson types
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

  // Short names for lesson types
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
