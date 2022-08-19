import 'dart:convert';

import 'package:rtu_mirea_app/domain/entities/attendance.dart';

class AttendanceModel extends Attendance {
  const AttendanceModel({
    required date,
    required time,
    required eventType,
  }) : super(date: date, time: time, eventType: eventType);

  factory AttendanceModel.fromRawJson(String str) =>
      AttendanceModel.fromJson(json.decode(str));

  factory AttendanceModel.fromJson(Map<String, dynamic> json) {
    return AttendanceModel(
      date: json["UF_EVENT_DATE"] is String ? json["UF_EVENT_DATE"] : "",
      eventType: json["UF_EVENT_TYPE"],
      time: json["UF_EVENT_DATE_FORMATED"],
    );
  }

  AttendanceModel copyWith({
    String? date,
    String? time,
    String? eventType,
  }) {
    return AttendanceModel(
      date: date ?? this.date,
      time: time ?? this.time,
      eventType: eventType ?? this.eventType,
    );
  }
}
