import 'package:equatable/equatable.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:university_app_server_api/client.dart';

import 'selected_schedule.dart';

part 'selected_teacher_schedule.g.dart';

@JsonSerializable()
@immutable
class SelectedTeacherSchedule with EquatableMixin implements SelectedSchedule {
  @override
  Map<String, dynamic> toJson() => _$SelectedTeacherScheduleToJson(this);

  const SelectedTeacherSchedule({
    required this.teacher,
    required this.schedule,
    this.type = 'teacher',
  });

  @override
  final String type;

  @override
  final List<SchedulePart> schedule;

  final Teacher teacher;

  factory SelectedTeacherSchedule.fromJson(Map<String, dynamic> json) => _$SelectedTeacherScheduleFromJson(json);

  @override
  List<Object> get props => [type, teacher, schedule];
}
