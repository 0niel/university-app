import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:schedule/schedule.dart';

part 'search_classrooms_response.g.dart';

@JsonSerializable()
class SearchClassroomsResponse extends Equatable {
  const SearchClassroomsResponse({required this.results});

  factory SearchClassroomsResponse.fromJson(Map<String, dynamic> json) => _$SearchClassroomsResponseFromJson(json);

  /// The schedule parts which are used to build the schedule. Each schedule
  /// part represents a content-based component. For example, a lesson or a
  /// holiday, or booking.
  final List<Classroom> results;

  Map<String, dynamic> toJson() => _$SearchClassroomsResponseToJson(this);

  @override
  List<Object> get props => [results];
}
