import 'package:rtu_mirea_app/domain/entities/lesson.dart';

class LessonModel extends Lesson {
  LessonModel({
    required name,
    required room,
    required teacher,
    required timeStart,
    required timeEnd,
    required type,
    required weeks,
  }) : super(
          name: name,
          room: room,
          teacher: teacher,
          timeStart: timeStart,
          timeEnd: timeEnd,
          type: type,
          weeks: weeks,
        );

  factory LessonModel.fromJson(Map<String, dynamic> json) => LessonModel(
        name: json["name"],
        room: json["room"],
        teacher: json["teacher"],
        timeStart: json["time_start"],
        timeEnd: json["time_end"],
        type: json["type"],
        weeks: List<int>.from(json["weeks"].map((x) => x)),
      );
}
