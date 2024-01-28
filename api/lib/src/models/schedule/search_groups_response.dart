import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:schedule/schedule.dart';

part 'search_groups_response.g.dart';

@JsonSerializable()
class SearchGroupsResponse extends Equatable {
  const SearchGroupsResponse({required this.results});

  factory SearchGroupsResponse.fromJson(Map<String, dynamic> json) => _$SearchGroupsResponseFromJson(json);

  /// The schedule parts which are used to build the schedule. Each schedule
  /// part represents a content-based component. For example, a lesson or a
  /// holiday, or booking.
  final List<Group> results;

  Map<String, dynamic> toJson() => _$SearchGroupsResponseToJson(this);

  @override
  List<Object> get props => [results];
}
