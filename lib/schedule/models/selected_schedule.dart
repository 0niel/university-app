import 'package:equatable/equatable.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:university_app_server_api/client.dart';

import 'selected_classroom_schedule.dart';
import 'selected_group_schedule.dart';
import 'selected_teacher_schedule.dart';

@immutable
@JsonSerializable()
abstract class SelectedSchedule extends Equatable {
  const SelectedSchedule({required this.schedule, required this.type});

  static SelectedSchedule fromJson(Map<String, dynamic> json) {
    switch (json['type']) {
      case 'classroom':
        return SelectedClassroomSchedule.fromJson(json);
      case 'group':
        return SelectedGroupSchedule.fromJson(json);
      case 'teacher':
        return SelectedTeacherSchedule.fromJson(json);
      default:
        throw Exception('Unknown type: ${json['type']}');
    }
  }

  static ScheduleTarget toScheduleTarget(String type) {
    switch (type) {
      case 'classroom':
        return ScheduleTarget.classroom;
      case 'group':
        return ScheduleTarget.group;
      case 'teacher':
        return ScheduleTarget.teacher;
      default:
        throw Exception('Unknown type: $type');
    }
  }

  final String type;

  final List<SchedulePart> schedule;

  Map<String, dynamic> toJson();

  @override
  List<Object?> get props => [type, schedule];
}
