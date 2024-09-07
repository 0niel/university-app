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

  static SelectedSchedule createSelectedSchedule<T>(T scheduleEntity, List<SchedulePart> scheduleParts) {
    if (T == Group) {
      return SelectedGroupSchedule(group: scheduleEntity as Group, schedule: scheduleParts);
    } else if (T == Teacher) {
      return SelectedTeacherSchedule(teacher: scheduleEntity as Teacher, schedule: scheduleParts);
    } else if (T == Classroom) {
      return SelectedClassroomSchedule(classroom: scheduleEntity as Classroom, schedule: scheduleParts);
    }
    throw Exception('Unknown schedule type');
  }

  static bool isScheduleSelected<T>(SelectedSchedule? selectedSchedule, T scheduleEntity) {
    if (selectedSchedule == null) return false;
    if (T == Group && selectedSchedule is SelectedGroupSchedule) {
      return (scheduleEntity as Group).name == selectedSchedule.group.name;
    } else if (T == Teacher && selectedSchedule is SelectedTeacherSchedule) {
      return (scheduleEntity as Teacher).name == selectedSchedule.teacher.name;
    } else if (T == Classroom && selectedSchedule is SelectedClassroomSchedule) {
      return (scheduleEntity as Classroom).name == selectedSchedule.classroom.name;
    }
    return false;
  }

  static String getScheduleName<T>(T scheduleEntity) {
    if (scheduleEntity is Group) return scheduleEntity.name;
    if (scheduleEntity is Teacher) return scheduleEntity.name;
    if (scheduleEntity is Classroom) return scheduleEntity.name;
    return '';
  }

  final String type;

  final List<SchedulePart> schedule;

  Map<String, dynamic> toJson();

  @override
  List<Object?> get props => [type, schedule];
}
