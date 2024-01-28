import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:schedule/schedule.dart';

part 'search_teachers_response.g.dart';

@JsonSerializable()
class SearchTeachersResponse extends Equatable {
  const SearchTeachersResponse({required this.results});

  factory SearchTeachersResponse.fromJson(Map<String, dynamic> json) => _$SearchTeachersResponseFromJson(json);

  /// The schedule parts which are used to build the schedule. Each schedule
  /// part represents a content-based component. For example, a lesson or a
  /// holiday, or booking.
  final List<Teacher> results;

  Map<String, dynamic> toJson() => _$SearchTeachersResponseToJson(this);

  @override
  List<Object> get props => [results];
}
