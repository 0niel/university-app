import 'dart:convert';
import 'package:rtu_mirea_app/domain/entities/schedule_settings.dart';

class ScheduleSettingsModel extends ScheduleSettings {
  ScheduleSettingsModel(
      {required showEmptyLessons, required showLessonsNumbers})
      : super(
          showEmptyLessons: showEmptyLessons,
          showLessonsNumbers: showLessonsNumbers,
        );

  factory ScheduleSettingsModel.fromRawJson(String str) =>
      ScheduleSettingsModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory ScheduleSettingsModel.fromJson(Map<String, dynamic> json) =>
      ScheduleSettingsModel(
        showEmptyLessons: json["show_empty_lessons"],
        showLessonsNumbers: json["show_lessons_numbers"],
      );

  Map<String, dynamic> toJson() => {
        "show_empty_lessons": showEmptyLessons,
        "show_lessons_numbers": showLessonsNumbers,
      };
}
