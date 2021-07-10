import 'package:rtu_mirea_app/data/models/lesson_model.dart';
import 'package:rtu_mirea_app/domain/entities/schedule.dart';

class ScheduleModel extends Schedule {
  ScheduleModel({required group, required schedule})
      : super(group: group, schedule: schedule);

  factory ScheduleModel.fromJson(Map<String, dynamic> json) => ScheduleModel(
        group: json["group"],
        schedule: Map.from(json["schedule"]).map((k, v) =>
            MapEntry<String, ScheduleWeekdayValueModel>(
                k, ScheduleWeekdayValueModel.fromJson(v))),
      );
}

class ScheduleWeekdayValueModel extends ScheduleWeekdayValue {
  ScheduleWeekdayValueModel({required lessons}) : super(lessons: lessons);

  factory ScheduleWeekdayValueModel.fromJson(Map<String, dynamic> json) =>
      ScheduleWeekdayValueModel(
        lessons: List<List<LessonModel>>.from(json["lessons"].map((x) =>
            List<LessonModel>.from(x.map((x) => LessonModel.fromJson(x))))),
      );
}
