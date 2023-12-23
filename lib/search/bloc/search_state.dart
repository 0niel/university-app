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

class SearchState extends Equatable {
  const SearchState({
    required this.groups,
    required this.teachers,
    required this.classrooms,
    required this.status,
  });

  const SearchState.initial()
      : this(
          groups: const SearchGroupsResponse(results: []),
          teachers: const SearchTeachersResponse(results: []),
          classrooms: const SearchClassroomsResponse(results: []),
          status: SearchStatus.initial,
        );

  final SearchGroupsResponse groups;
  final SearchTeachersResponse teachers;
  final SearchClassroomsResponse classrooms;

  final SearchStatus status;

  @override
  List<Object?> get props => [groups, teachers, classrooms, status];

  SearchState copyWith({
    SearchGroupsResponse? groups,
    SearchTeachersResponse? teachers,
    SearchClassroomsResponse? classrooms,
    SearchStatus? status,
  }) {
    return SearchState(
      groups: groups ?? this.groups,
      teachers: teachers ?? this.teachers,
      classrooms: classrooms ?? this.classrooms,
      status: status ?? this.status,
    );
  }
}
