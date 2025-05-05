import 'dart:convert';

import 'package:academic_calendar/academic_calendar.dart';
import 'package:flutter/foundation.dart';
import 'package:rtu_mirea_app/data/datasources/widget_data.dart';
import 'package:rtu_mirea_app/schedule/models/models.dart';
import 'package:university_app_server_api/client.dart';

/// Utility class for updating home screen widgets with schedule data
class ScheduleWidgetUpdater {
  final HomeScreenWidgetService _widgetService;

  ScheduleWidgetUpdater(this._widgetService);

  /// Updates the schedule widgets with the latest data
  Future<void> updateWidgets(List<SchedulePart> scheduleParts, String scheduleName) async {
    // Skip widget update on web platform
    if (kIsWeb) return;

    try {
      // Get the current week number
      final currentWeek = _getCurrentWeekNumber();

      // Convert schedule parts to a format suitable for widgets
      final Map<String, dynamic> widgetData = {
        'schedule': _prepareScheduleData(scheduleParts),
        'group': scheduleName, // This field is used as generic schedule name
        'weekNumber': currentWeek, // Add current week number for display
        'lastUpdated': DateTime.now().toIso8601String(), // Add timestamp for freshness check
      };

      // Save schedule data to widget storage
      final jsonData = jsonEncode(widgetData);
      debugPrint('Updating widget with schedule data: ${jsonData.length} bytes');
      await _widgetService.setSchedule(jsonData);
    } catch (e) {
      debugPrint('Error updating schedule widgets: $e');
    }
  }

  /// Calculates the current academic week number (1-based)
  int _getCurrentWeekNumber() {
    try {
      return getWeek();
    } catch (e) {
      debugPrint('Error calculating week number: $e');
      return 1;
    }
  }

  /// Prepares schedule data for widgets by converting SchedulePart objects
  /// to a simpler format that widgets can render efficiently
  List<Map<String, dynamic>> _prepareScheduleData(List<SchedulePart> scheduleParts) {
    final result = <Map<String, dynamic>>[];

    // Process only LessonSchedulePart instances from the schedule parts
    for (final part in scheduleParts) {
      if (part is LessonSchedulePart) {
        // Format classroom information
        String classroom = 'Неизвестно';
        if (part.classrooms.isNotEmpty) {
          final firstClassroom = part.classrooms.first;
          classroom = firstClassroom.name;
          if (firstClassroom.campus != null) {
            final campusShortName = firstClassroom.campus?.shortName ?? '';
            final campusName = firstClassroom.campus?.name ?? '';
            final campusInfo = campusShortName.isNotEmpty ? campusShortName : campusName;

            if (campusInfo.isNotEmpty) {
              classroom += ' ($campusInfo)';
            }
          }
        }

        // Format additional info that might be useful in the widget
        final teachers = part.teachers.isNotEmpty ? part.teachers.map((t) => t.name).join(', ') : '';

        // Return formatted data for lesson part
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

  /// Updates widgets using a SelectedSchedule object
  Future<void> updateWidgetsFromSelectedSchedule(SelectedSchedule schedule) async {
    // Skip widget update on web platform
    if (kIsWeb) return;

    try {
      String scheduleName = '';

      // Extract name based on schedule type
      if (schedule is SelectedGroupSchedule) {
        scheduleName = schedule.group.name;
      } else if (schedule is SelectedTeacherSchedule) {
        scheduleName = schedule.teacher.name;
      } else if (schedule is SelectedClassroomSchedule) {
        scheduleName = schedule.classroom.name;
      } else if (schedule is SelectedCustomSchedule) {
        scheduleName = schedule.name;
      }

      // Get current week number
      final currentWeek = _getCurrentWeekNumber();

      // Create simplified widget data with only essential information
      final Map<String, dynamic> widgetData = {
        'group': scheduleName, // Keep for backward compatibility
        'schedule': _prepareOptimizedScheduleData(schedule.schedule), // Simplified format for widget
        'weekNumber': currentWeek, // Add week number
        'lastUpdated': DateTime.now().toIso8601String(),
      };

      // Save to widget storage
      final jsonData = jsonEncode(widgetData);
      debugPrint('Updating widget with optimized data: ${jsonData.length} bytes');
      await _widgetService.setSchedule(jsonData);
    } catch (e) {
      debugPrint('Error updating widget from SelectedSchedule: $e');
    }
  }

  /// Prepares a more optimized schedule data format for widgets
  List<Map<String, dynamic>> _prepareOptimizedScheduleData(List<SchedulePart> scheduleParts) {
    final result = <Map<String, dynamic>>[];

    // Process only LessonSchedulePart instances from the schedule parts
    for (final part in scheduleParts) {
      if (part is LessonSchedulePart) {
        // Format classroom information
        String classroom = 'Неизвестно';
        if (part.classrooms.isNotEmpty) {
          final firstClassroom = part.classrooms.first;
          classroom = firstClassroom.name;
          if (firstClassroom.campus != null &&
              (firstClassroom.campus?.shortName?.isNotEmpty == true ||
                  firstClassroom.campus?.name.isNotEmpty == true)) {
            final campusShortName = firstClassroom.campus?.shortName ?? '';
            final campusName = firstClassroom.campus?.name ?? '';
            final campusInfo = campusShortName.isNotEmpty ? campusShortName : campusName;
            classroom += ' ($campusInfo)';
          }
        }

        // Format teachers (only names, no other details)
        final teachers = part.teachers.isNotEmpty ? part.teachers.map((t) => t.name).join(', ') : '';

        // Return only essential data for lesson part
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
