import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:schedule/schedule.dart' as domain;

part 'search_classrooms_response.freezed.dart';

@freezed
abstract class SearchClassroomsResponse with _$SearchClassroomsResponse {
  const factory SearchClassroomsResponse({
    required List<domain.Classroom> results,
  }) = _SearchClassroomsResponse;
}
