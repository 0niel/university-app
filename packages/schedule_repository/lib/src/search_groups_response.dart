import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:schedule/schedule.dart' as domain;

part 'search_groups_response.freezed.dart';

@freezed
abstract class SearchGroupsResponse with _$SearchGroupsResponse {
  const factory SearchGroupsResponse({required List<domain.Group> results}) =
      _SearchGroupsResponse;
}
