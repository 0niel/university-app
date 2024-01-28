part of 'search_bloc.dart';

enum SearchStatus {
  initial,
  loading,
  populated,
  failure,
}

enum SearchType {
  popular,
  relevant,
}

@JsonSerializable()
class SearchState extends Equatable {
  const SearchState({
    required this.groups,
    required this.teachers,
    required this.classrooms,
    required this.status,
    required this.searchHisoty,
  });

  const SearchState.initial()
      : this(
          groups: const SearchGroupsResponse(results: []),
          teachers: const SearchTeachersResponse(results: []),
          classrooms: const SearchClassroomsResponse(results: []),
          searchHisoty: const [],
          status: SearchStatus.initial,
        );

  final SearchGroupsResponse groups;
  final SearchTeachersResponse teachers;
  final SearchClassroomsResponse classrooms;
  final List<String> searchHisoty;
  final SearchStatus status;

  factory SearchState.fromJson(Map<String, dynamic> json) => _$SearchStateFromJson(json);

  Map<String, dynamic> toJson() => _$SearchStateToJson(this);

  SearchState copyWith({
    SearchGroupsResponse? groups,
    SearchTeachersResponse? teachers,
    SearchClassroomsResponse? classrooms,
    List<String>? searchHisoty,
    SearchStatus? status,
  }) {
    return SearchState(
      groups: groups ?? this.groups,
      teachers: teachers ?? this.teachers,
      classrooms: classrooms ?? this.classrooms,
      status: status ?? this.status,
      searchHisoty: searchHisoty ?? this.searchHisoty,
    );
  }

  @override
  List<Object?> get props => [groups, teachers, classrooms, status, searchHisoty];
}
