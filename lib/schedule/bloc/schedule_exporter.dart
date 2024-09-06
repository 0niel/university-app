import 'package:device_calendar/device_calendar.dart';
import 'package:flutter/material.dart' as m;
import 'package:rtu_mirea_app/schedule/models/models.dart';
import 'package:rtu_mirea_app/schedule/widgets/lesson_card.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:university_app_server_api/client.dart';

class CalendarException implements Exception {
  final String message;
  CalendarException(this.message);
  @override
  String toString() => 'CalendarException: $message';
}

class PermissionDeniedException extends CalendarException {
  PermissionDeniedException() : super('Доступ к календарю запрещен');
}

class CalendarCreationException extends CalendarException {
  CalendarCreationException(String reason) : super('Не удалось создать календарь');
}

class EventCreationException extends CalendarException {
  EventCreationException(String reason) : super('Не удалось добавить событие');
}

class ScheduleExporter {
  final DeviceCalendarPlugin _deviceCalendarPlugin = DeviceCalendarPlugin();

  Future<void> exportScheduleToCalendar(SelectedSchedule scheduleState) async {
    try {
      final String calendarName = _getCalendarNameFromScheduleState(scheduleState) ?? 'Расписание Mirea Ninja';

      if (calendarName.isEmpty) {
        throw CalendarException("Не удалось определить название календаря");
      }

      var permissionsGranted = await _deviceCalendarPlugin.hasPermissions();
      if (!(permissionsGranted.data ?? false)) {
        permissionsGranted = await _deviceCalendarPlugin.requestPermissions();
        if (!(permissionsGranted.data ?? false)) {
          throw PermissionDeniedException();
        }
      }

      final createCalendarResult = await createCalendar(calendarName);
      if (!createCalendarResult.isSuccess) {
        throw CalendarCreationException(createCalendarResult.errors.first.errorMessage);
      }

      final calendarId = createCalendarResult.data;

      List<LessonSchedulePart> lessons = scheduleState.schedule.whereType<LessonSchedulePart>().toList();

      for (final lesson in lessons) {
        String lessonTypeEmoji = _getLessonTypeEmoji(lesson.lessonType);

        for (final date in lesson.dates) {
          final startDate = _combineDateAndTime(date, lesson.lessonBells.startTime);
          final endDate = _combineDateAndTime(date, lesson.lessonBells.endTime);

          Event event = Event(
            calendarId,
            title: '$lessonTypeEmoji [${LessonCard.getLessonTypeName(lesson.lessonType)}] ${lesson.subject}',
            description: 'Преподаватели: ${lesson.teachers.map((t) => t.name).join(', ')}\n'
                'Аудитории: ${lesson.classrooms.map((c) => c.name).join(', ')}',
            location: lesson.classrooms.map((c) => c.name).join(', '),
            start: tz.TZDateTime.from(startDate, tz.local),
            end: tz.TZDateTime.from(endDate, tz.local),
            reminders: [
              Reminder(minutes: 10),
              Reminder(minutes: 30),
              Reminder(minutes: 720), // 12 часов
            ],
            url: Uri.parse('ninja.mirea.mireaapp://open'),
            attendees: _getAttendeesForLesson(lesson),
          );

          final createEvent = await _deviceCalendarPlugin.createOrUpdateEvent(event);
          if (createEvent?.isSuccess != true) {
            throw EventCreationException(createEvent?.errors.first.errorMessage ?? 'Неизвестная ошибка');
          }
        }
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<Result<String>> createCalendar(String calendarName) async {
    final result = await _deviceCalendarPlugin.createCalendar(
      calendarName,
      localAccountName: "Университет",
      calendarColor: m.Colors.blue,
    );
    return result;
  }

  List<Attendee> _getAttendeesForLesson(LessonSchedulePart lesson) {
    return lesson.teachers.map((teacher) {
      return Attendee(
        name: teacher.name,
        emailAddress: teacher.email ?? '',
        role: AttendeeRole.Required,
        isOrganiser: false,
        isCurrentUser: false,
      );
    }).toList();
  }

  String? _getCalendarNameFromScheduleState(SelectedSchedule selectedSchedule) {
    switch (selectedSchedule.runtimeType) {
      case SelectedGroupSchedule:
        return (selectedSchedule as SelectedGroupSchedule).group.name;
      case SelectedTeacherSchedule:
        return _formatTeacherName((selectedSchedule as SelectedTeacherSchedule).teacher.name);
      case SelectedClassroomSchedule:
        return (selectedSchedule as SelectedClassroomSchedule).classroom.name;
      default:
        return null;
    }
  }

  String _formatTeacherName(String teacherName) {
    final nameParts = teacherName.split(' ');
    if (nameParts.length < 2) return teacherName;
    return '${nameParts[0]} ${nameParts[1][0]}.';
  }

  String _getLessonTypeEmoji(LessonType lessonType) {
    switch (lessonType) {
      case LessonType.practice:
        return '🎓';
      case LessonType.lecture:
        return '📖';
      case LessonType.laboratoryWork:
        return '🧪';
      case LessonType.individualWork:
        return '👨‍🏫';
      case LessonType.physicalEducation:
        return '🏋️‍♂️';
      case LessonType.consultation:
        return '💬';
      case LessonType.exam:
        return '📝';
      case LessonType.credit:
        return '💼';
      case LessonType.courseWork:
        return '📑';
      case LessonType.courseProject:
        return '📊';
      case LessonType.unknown:
      default:
        return '❓';
    }
  }

  DateTime _combineDateAndTime(DateTime date, TimeOfDay time) {
    return DateTime(date.year, date.month, date.day, time.hour, time.minute);
  }
}
