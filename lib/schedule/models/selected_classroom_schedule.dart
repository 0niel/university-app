import 'package:equatable/equatable.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:university_app_server_api/client.dart';

import 'selected_schedule.dart';

part 'selected_classroom_schedule.g.dart';

@JsonSerializable()
@immutable
class SelectedClassroomSchedule with EquatableMixin implements SelectedSchedule {
  factory SelectedClassroomSchedule.fromJson(Map<String, dynamic> json) => _$SelectedClassroomScheduleFromJson(json);

  const SelectedClassroomSchedule({
    required this.classroom,
    required this.schedule,
    this.type = 'classroom',
  });

  final Classroom classroom;

  @override
  final String type;

  @override
  final List<SchedulePart> schedule;

  @override
  Map<String, dynamic> toJson() => _$SelectedClassroomScheduleToJson(this);

  @override
  List<Object> get props => [type, classroom, schedule];
}
