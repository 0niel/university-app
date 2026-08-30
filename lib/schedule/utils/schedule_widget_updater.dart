import 'dart:convert';
import 'dart:developer';

import 'package:academic_calendar/academic_calendar.dart';
import 'package:flutter/foundation.dart';
import 'package:rtu_mirea_app/data/datasources/home_screen_widget_service.dart';
import 'package:rtu_mirea_app/schedule/models/models.dart';
import 'package:schedule_repository/schedule_repository.dart';

class ScheduleWidgetUpdater {
  const ScheduleWidgetUpdater(this._widgetService);

  final HomeScreenWidgetService _widgetService;

  int _getCurrentWeekNumber() {
    try {
      return getWeek();
    } on Exception catch (e, st) {
      log(
        'Error calculating week number',
        error: e,
        stackTrace: st,
        name: 'ScheduleWidgetUpdater',
      );
      return 1;
    }
  }

  Future<void> updateWidgetsFromSelectedSchedule(
    SelectedSchedule schedule,
  ) async {
    if (kIsWeb) return;

    try {
      final scheduleName = switch (schedule) {
        SelectedGroupSchedule(:final group) => group.name,
        SelectedTeacherSchedule(:final teacher) => teacher.name,
        SelectedClassroomSchedule(:final classroom) => classroom.name,
        SelectedCustomSchedule(:final name) => name,
      };

      final currentWeek = _getCurrentWeekNumber();

      final widgetData = <String, Object?>{
        'group': scheduleName,
        'schedule': _prepareOptimizedScheduleData(schedule.schedule),
        'weekNumber': currentWeek,
        'lastUpdated': DateTime.now().toIso8601String(),
      };

      final jsonData = jsonEncode(widgetData);
      log(
        'Updating widget with optimized data: ${jsonData.length} bytes',
        name: 'ScheduleWidgetUpdater',
      );
      await _widgetService.setSchedule(jsonData);
    } on Exception catch (e, st) {
      log(
        'Error updating widget from SelectedSchedule',
        error: e,
        stackTrace: st,
        name: 'ScheduleWidgetUpdater',
      );
    }
  }

  List<Map<String, Object?>> _prepareOptimizedScheduleData(
    List<SchedulePart> scheduleParts,
  ) {
    final result = <Map<String, Object?>>[];

    for (final part in scheduleParts) {
      if (part is LessonSchedulePart) {
        var classroom = 'Неизвестно';
        if (part.classrooms.isNotEmpty) {
          final firstClassroom = part.classrooms.first;
          classroom = firstClassroom.name;
          if (firstClassroom.campus case final campus?) {
            final campusShortName = campus.shortName ?? '';
            final campusName = campus.name;
            final campusInfo = campusShortName.isNotEmpty
                ? campusShortName
                : campusName;
            if (campusInfo.isNotEmpty) classroom += ' ($campusInfo)';
          }
        }

        final teachers = part.teachers.isNotEmpty
            ? part.teachers.map((t) => t.name).join(', ')
            : '';

        result.add({
          'subject': part.subject,
          'lessonType': part.lessonType.index,
          'startTime': part.lessonBells.startTime.toString(),
          'endTime': part.lessonBells.endTime.toString(),
          'classroom': classroom,
          'teachers': teachers,
          'number': part.lessonBells.number,
          'dates': part.dates.map((date) => date.toIso8601String()).toList(),
        });
      }
    }

    return result;
  }
}
