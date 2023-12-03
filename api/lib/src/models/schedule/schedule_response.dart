import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:schedule/schedule_parts.dart';

part 'schedule_response.g.dart';

@JsonSerializable()
class ScheduleResponse extends Equatable {
  const ScheduleResponse({
    required this.group,
    required this.scheduleParts,
  });

  factory ScheduleResponse.fromJson(Map<String, dynamic> json) =>
      _$ScheduleResponseFromJson(json);

  /// The name of the group to which the schedule belongs.
  final String group;

  final List<SchedulePart> scheduleParts;

  Map<String, dynamic> toJson() => _$ScheduleResponseToJson(this);

  @override
  List<Object> get props => [];
}
