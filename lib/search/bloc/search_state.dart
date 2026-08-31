part of 'search_bloc.dart';

@freezed
abstract class SearchState with _$SearchState {
  const factory SearchState({
    @JsonKey(includeToJson: false, includeFromJson: false)
    @Default(SearchGroupsResponse(results: []))
    SearchGroupsResponse groups,
    @JsonKey(includeToJson: false, includeFromJson: false)
    @Default(SearchTeachersResponse(results: []))
    SearchTeachersResponse teachers,
    @JsonKey(includeToJson: false, includeFromJson: false)
    @Default(SearchClassroomsResponse(results: []))
    SearchClassroomsResponse classrooms,
    @JsonKey(includeToJson: false, includeFromJson: false)
    @Default(<UserSearchResult>[])
    List<UserSearchResult> people,
    @JsonKey(includeToJson: false, includeFromJson: false)
    @Default(<GroupPostSearchResult>[])
    List<GroupPostSearchResult> posts,
    @JsonKey(includeToJson: false, includeFromJson: false)
    @Default(<TrendingSearch>[])
    List<TrendingSearch> trending,
    @Default(<String>[]) List<String> searchHisoty,
    @JsonKey(includeToJson: false, includeFromJson: false)
    @Default(SearchStatus.initial)
    SearchStatus status,
    @JsonKey(includeToJson: false, includeFromJson: false)
    @Default(SearchMode.all)
    SearchMode searchMode,
  }) = _SearchState;

  factory SearchState.fromJson(Map<String, dynamic> json) =>
      _$SearchStateFromJson(json);
}
