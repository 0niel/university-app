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

enum SearchMode {
  all,
  groups,
  teachers,
  classrooms,
}

@JsonSerializable()
class SearchState extends Equatable {
  const SearchState({
    SearchGroupsResponse? groups,
    SearchTeachersResponse? teachers,
    SearchClassroomsResponse? classrooms,
    List<String>? searchHisoty,
    SearchStatus? status,
    SearchMode? searchMode,
  })  : groups = groups ?? const SearchGroupsResponse(results: []),
        teachers = teachers ?? const SearchTeachersResponse(results: []),
        classrooms = classrooms ?? const SearchClassroomsResponse(results: []),
        searchHisoty = searchHisoty ?? const [],
        status = status ?? SearchStatus.initial,
        searchMode = searchMode ?? SearchMode.all;

  const SearchState.initial() : this();

  @JsonKey(includeToJson: false, includeFromJson: false)
  final SearchGroupsResponse groups;
  @JsonKey(includeToJson: false, includeFromJson: false)
  final SearchTeachersResponse teachers;
  @JsonKey(includeToJson: false, includeFromJson: false)
  final SearchClassroomsResponse classrooms;
  @JsonKey(includeToJson: false, includeFromJson: false)
  final SearchStatus status;

  final List<String> searchHisoty;

  @JsonKey(includeToJson: false, includeFromJson: false)
  final SearchMode searchMode;

  factory SearchState.fromJson(Map<String, dynamic> json) => _$SearchStateFromJson(json);

  Map<String, dynamic> toJson() => _$SearchStateToJson(this);

  SearchState copyWith({
    SearchGroupsResponse? groups,
    SearchTeachersResponse? teachers,
    SearchClassroomsResponse? classrooms,
    List<String>? searchHisoty,
    SearchStatus? status,
    SearchMode? searchMode,
  }) {
    return SearchState(
      groups: groups ?? this.groups,
      teachers: teachers ?? this.teachers,
      classrooms: classrooms ?? this.classrooms,
      status: status ?? this.status,
      searchHisoty: searchHisoty ?? this.searchHisoty,
      searchMode: searchMode ?? this.searchMode,
    );
  }

  @override
  List<Object?> get props => [groups, teachers, classrooms, status, searchHisoty, searchMode];
}
