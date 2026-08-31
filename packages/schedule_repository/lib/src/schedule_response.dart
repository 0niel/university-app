import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:schedule/schedule.dart' as domain;

part 'schedule_response.freezed.dart';

@freezed
abstract class ScheduleResponse with _$ScheduleResponse {
  const factory ScheduleResponse({required List<domain.SchedulePart> data}) =
      _ScheduleResponse;
}
