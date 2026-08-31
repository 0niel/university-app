import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:schedule/schedule.dart' as domain;

part 'search_teachers_response.freezed.dart';

@freezed
abstract class SearchTeachersResponse with _$SearchTeachersResponse {
  const factory SearchTeachersResponse({
    required List<domain.Teacher> results,
  }) = _SearchTeachersResponse;
}
