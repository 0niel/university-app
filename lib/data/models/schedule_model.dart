import 'dart:convert';
import 'package:rtu_mirea_app/data/models/lesson_model.dart';
import 'package:rtu_mirea_app/domain/entities/schedule.dart';

class ScheduleModel extends Schedule {
  const ScheduleModel({required isRemote, required group, required schedule})
      : super(isRemote: isRemote, group: group, schedule: schedule);

  factory ScheduleModel.fromRawJson(String str) =>
      ScheduleModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory ScheduleModel.fromJson(Map<String, dynamic> json) => ScheduleModel(
        isRemote: json.containsKey("remote") ? json["remote"] : false,
        group: json["group"],
        schedule: Map.from(json["schedule"]).map((k, v) =>
            MapEntry<String, ScheduleWeekdayValueModel>(
                k, ScheduleWeekdayValueModel.fromJson(v))),
      );

  Map<String, dynamic> toJson() => {
        "group": group,
        "schedule": Map.from(schedule)
            .map((k, v) => MapEntry<String, dynamic>(k, v.toJson())),
      };
}

class ScheduleWeekdayValueModel extends ScheduleWeekdayValue {
  const ScheduleWeekdayValueModel({required this.lessons})
      : super(lessons: lessons);

  // ignore: annotate_overrides, overridden_fields
  final List<List<LessonModel>> lessons;

  factory ScheduleWeekdayValueModel.fromRawJson(String str) =>
      ScheduleWeekdayValueModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory ScheduleWeekdayValueModel.fromJson(Map<String, dynamic> json) =>
      ScheduleWeekdayValueModel(
        lessons: List<List<LessonModel>>.from(json["lessons"].map((x) =>
            List<LessonModel>.from(x.map((x) => LessonModel.fromJson(x))))),
      );

  Map<String, dynamic> toJson() => {
        "lessons": List<dynamic>.from(
            lessons.map((x) => List<dynamic>.from(x.map((x) => x.toJson())))),
      };
}
