import 'package:equatable/equatable.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:university_app_server_api/client.dart';

import 'selected_schedule.dart';

part 'selected_group_schedule.g.dart';

@JsonSerializable()
@immutable
class SelectedGroupSchedule with EquatableMixin implements SelectedSchedule {
  factory SelectedGroupSchedule.fromJson(Map<String, dynamic> json) => _$SelectedGroupScheduleFromJson(json);

  const SelectedGroupSchedule({
    required this.group,
    required this.schedule,
    this.type = 'group',
  });

  final Group group;

  @override
  final String type;

  @override
  final List<SchedulePart> schedule;

  @override
  Map<String, dynamic> toJson() => _$SelectedGroupScheduleToJson(this);

  @override
  List<Object> get props => [type, group, schedule];
}
