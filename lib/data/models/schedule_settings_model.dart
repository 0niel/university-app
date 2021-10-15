import 'dart:convert';
import 'package:rtu_mirea_app/domain/entities/schedule_settings.dart';

class ScheduleSettingsModel extends ScheduleSettings {
  const ScheduleSettingsModel({
    required showEmptyLessons,
    required showLessonsNumbers,
    //required showLessonsWithNotesInDifferentColor,
    required calendarFormat,
  }) : super(
          showEmptyLessons: showEmptyLessons,
          showLessonsNumbers: showLessonsNumbers,
          //showLessonsWithNoteInDifferentColor: showLessonsWithNotesInDifferentColor ?? true,
          calendarFormat: calendarFormat,
        );

  factory ScheduleSettingsModel.fromRawJson(String str) =>
      ScheduleSettingsModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory ScheduleSettingsModel.fromJson(Map<String, dynamic> json) =>
      ScheduleSettingsModel(
        showEmptyLessons: json["show_empty_lessons"],
        showLessonsNumbers: json["show_lessons_numbers"],
        //showLessonsWithNotesInDifferentColor: json["show_lessons_with_notes_in_different_color"],
        calendarFormat: json["calendar_format"],
      );

  Map<String, dynamic> toJson() => {
        "show_empty_lessons": showEmptyLessons,
        "show_lessons_numbers": showLessonsNumbers,
        //"show_lessons_with_notes_in_different_color": showLessonsWithNoteInDifferentColor,
        "calendar_format": calendarFormat,
      };
}
