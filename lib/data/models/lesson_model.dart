import 'dart:convert';

import 'package:rtu_mirea_app/domain/entities/lesson.dart';

class LessonModel extends Lesson {
  const LessonModel({
    required name,
    required weeks,
    required timeStart,
    required timeEnd,
    required types,
    required teachers,
    required rooms,
  }) : super(
          name: name,
          weeks: weeks,
          timeStart: timeStart,
          timeEnd: timeEnd,
          types: types,
          teachers: teachers,
          rooms: rooms,
        );

  factory LessonModel.fromRawJson(String str) =>
      LessonModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory LessonModel.fromJson(Map<String, dynamic> json) => LessonModel(
        name: json["name"],
        weeks: List<int>.from(json["weeks"].map((x) => x)),
        timeStart: json["time_start"],
        timeEnd: json["time_end"],
        types: json["types"],
        teachers: List<String>.from(json["teachers"].map((x) => x)),
        rooms: List<String>.from(json["rooms"].map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "weeks": List<dynamic>.from(weeks.map((x) => x)),
        "time_start": timeStart,
        "time_end": timeEnd,
        "types": types,
        "teachers": List<dynamic>.from(teachers.map((x) => x)),
        "rooms": List<dynamic>.from(rooms.map((x) => x)),
      };
}
