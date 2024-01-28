import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:schedule/schedule.dart';

part 'schedule_response.g.dart';

@JsonSerializable()
class ScheduleResponse extends Equatable {
  const ScheduleResponse({required this.data});

  factory ScheduleResponse.fromJson(Map<String, dynamic> json) => _$ScheduleResponseFromJson(json);

  /// The schedule parts which are used to build the schedule. Each schedule
  /// part represents a content-based component. For example, a lesson or a
  /// holiday, or booking.
  final List<SchedulePart> data;

  Map<String, dynamic> toJson() => _$ScheduleResponseToJson(this);

  @override
  List<Object> get props => [data];
}
