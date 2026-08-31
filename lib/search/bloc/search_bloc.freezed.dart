// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'search_bloc.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$SearchState {

@JsonKey(includeToJson: false, includeFromJson: false) SearchGroupsResponse get groups;@JsonKey(includeToJson: false, includeFromJson: false) SearchTeachersResponse get teachers;@JsonKey(includeToJson: false, includeFromJson: false) SearchClassroomsResponse get classrooms;@JsonKey(includeToJson: false, includeFromJson: false) List<UserSearchResult> get people;@JsonKey(includeToJson: false, includeFromJson: false) List<GroupPostSearchResult> get posts;@JsonKey(includeToJson: false, includeFromJson: false) List<TrendingSearch> get trending; List<String> get searchHisoty;@JsonKey(includeToJson: false, includeFromJson: false) SearchStatus get status;@JsonKey(includeToJson: false, includeFromJson: false) SearchMode get searchMode;
/// Create a copy of SearchState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SearchStateCopyWith<SearchState> get copyWith => _$SearchStateCopyWithImpl<SearchState>(this as SearchState, _$identity);

  /// Serializes this SearchState to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SearchState&&(identical(other.groups, groups) || other.groups == groups)&&(identical(other.teachers, teachers) || other.teachers == teachers)&&(identical(other.classrooms, classrooms) || other.classrooms == classrooms)&&const DeepCollectionEquality().equals(other.people, people)&&const DeepCollectionEquality().equals(other.posts, posts)&&const DeepCollectionEquality().equals(other.trending, trending)&&const DeepCollectionEquality().equals(other.searchHisoty, searchHisoty)&&(identical(other.status, status) || other.status == status)&&(identical(other.searchMode, searchMode) || other.searchMode == searchMode));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,groups,teachers,classrooms,const DeepCollectionEquality().hash(people),const DeepCollectionEquality().hash(posts),const DeepCollectionEquality().hash(trending),const DeepCollectionEquality().hash(searchHisoty),status,searchMode);

@override
String toString() {
  return 'SearchState(groups: $groups, teachers: $teachers, classrooms: $classrooms, people: $people, posts: $posts, trending: $trending, searchHisoty: $searchHisoty, status: $status, searchMode: $searchMode)';
}


}

/// @nodoc
abstract mixin class $SearchStateCopyWith<$Res>  {
  factory $SearchStateCopyWith(SearchState value, $Res Function(SearchState) _then) = _$SearchStateCopyWithImpl;
@useResult
$Res call({
@JsonKey(includeToJson: false, includeFromJson: false) SearchGroupsResponse groups,@JsonKey(includeToJson: false, includeFromJson: false) SearchTeachersResponse teachers,@JsonKey(includeToJson: false, includeFromJson: false) SearchClassroomsResponse classrooms,@JsonKey(includeToJson: false, includeFromJson: false) List<UserSearchResult> people,@JsonKey(includeToJson: false, includeFromJson: false) List<GroupPostSearchResult> posts,@JsonKey(includeToJson: false, includeFromJson: false) List<TrendingSearch> trending, List<String> searchHisoty,@JsonKey(includeToJson: false, includeFromJson: false) SearchStatus status,@JsonKey(includeToJson: false, includeFromJson: false) SearchMode searchMode
});


$SearchGroupsResponseCopyWith<$Res> get groups;$SearchTeachersResponseCopyWith<$Res> get teachers;$SearchClassroomsResponseCopyWith<$Res> get classrooms;

}
/// @nodoc
class _$SearchStateCopyWithImpl<$Res>
    implements $SearchStateCopyWith<$Res> {
  _$SearchStateCopyWithImpl(this._self, this._then);

  final SearchState _self;
  final $Res Function(SearchState) _then;

/// Create a copy of SearchState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? groups = null,Object? teachers = null,Object? classrooms = null,Object? people = null,Object? posts = null,Object? trending = null,Object? searchHisoty = null,Object? status = null,Object? searchMode = null,}) {
  return _then(_self.copyWith(
groups: null == groups ? _self.groups : groups // ignore: cast_nullable_to_non_nullable
as SearchGroupsResponse,teachers: null == teachers ? _self.teachers : teachers // ignore: cast_nullable_to_non_nullable
as SearchTeachersResponse,classrooms: null == classrooms ? _self.classrooms : classrooms // ignore: cast_nullable_to_non_nullable
as SearchClassroomsResponse,people: null == people ? _self.people : people // ignore: cast_nullable_to_non_nullable
as List<UserSearchResult>,posts: null == posts ? _self.posts : posts // ignore: cast_nullable_to_non_nullable
as List<GroupPostSearchResult>,trending: null == trending ? _self.trending : trending // ignore: cast_nullable_to_non_nullable
as List<TrendingSearch>,searchHisoty: null == searchHisoty ? _self.searchHisoty : searchHisoty // ignore: cast_nullable_to_non_nullable
as List<String>,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as SearchStatus,searchMode: null == searchMode ? _self.searchMode : searchMode // ignore: cast_nullable_to_non_nullable
as SearchMode,
  ));
}
/// Create a copy of SearchState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$SearchGroupsResponseCopyWith<$Res> get groups {

  return $SearchGroupsResponseCopyWith<$Res>(_self.groups, (value) {
    return _then(_self.copyWith(groups: value));
  });
}/// Create a copy of SearchState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$SearchTeachersResponseCopyWith<$Res> get teachers {

  return $SearchTeachersResponseCopyWith<$Res>(_self.teachers, (value) {
    return _then(_self.copyWith(teachers: value));
  });
}/// Create a copy of SearchState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$SearchClassroomsResponseCopyWith<$Res> get classrooms {

  return $SearchClassroomsResponseCopyWith<$Res>(_self.classrooms, (value) {
    return _then(_self.copyWith(classrooms: value));
  });
}
}


/// Adds pattern-matching-related methods to [SearchState].
extension SearchStatePatterns on SearchState {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SearchState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SearchState() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SearchState value)  $default,){
final _that = this;
switch (_that) {
case _SearchState():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SearchState value)?  $default,){
final _that = this;
switch (_that) {
case _SearchState() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(includeToJson: false, includeFromJson: false)  SearchGroupsResponse groups, @JsonKey(includeToJson: false, includeFromJson: false)  SearchTeachersResponse teachers, @JsonKey(includeToJson: false, includeFromJson: false)  SearchClassroomsResponse classrooms, @JsonKey(includeToJson: false, includeFromJson: false)  List<UserSearchResult> people, @JsonKey(includeToJson: false, includeFromJson: false)  List<GroupPostSearchResult> posts, @JsonKey(includeToJson: false, includeFromJson: false)  List<TrendingSearch> trending,  List<String> searchHisoty, @JsonKey(includeToJson: false, includeFromJson: false)  SearchStatus status, @JsonKey(includeToJson: false, includeFromJson: false)  SearchMode searchMode)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SearchState() when $default != null:
return $default(_that.groups,_that.teachers,_that.classrooms,_that.people,_that.posts,_that.trending,_that.searchHisoty,_that.status,_that.searchMode);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(includeToJson: false, includeFromJson: false)  SearchGroupsResponse groups, @JsonKey(includeToJson: false, includeFromJson: false)  SearchTeachersResponse teachers, @JsonKey(includeToJson: false, includeFromJson: false)  SearchClassroomsResponse classrooms, @JsonKey(includeToJson: false, includeFromJson: false)  List<UserSearchResult> people, @JsonKey(includeToJson: false, includeFromJson: false)  List<GroupPostSearchResult> posts, @JsonKey(includeToJson: false, includeFromJson: false)  List<TrendingSearch> trending,  List<String> searchHisoty, @JsonKey(includeToJson: false, includeFromJson: false)  SearchStatus status, @JsonKey(includeToJson: false, includeFromJson: false)  SearchMode searchMode)  $default,) {final _that = this;
switch (_that) {
case _SearchState():
return $default(_that.groups,_that.teachers,_that.classrooms,_that.people,_that.posts,_that.trending,_that.searchHisoty,_that.status,_that.searchMode);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(includeToJson: false, includeFromJson: false)  SearchGroupsResponse groups, @JsonKey(includeToJson: false, includeFromJson: false)  SearchTeachersResponse teachers, @JsonKey(includeToJson: false, includeFromJson: false)  SearchClassroomsResponse classrooms, @JsonKey(includeToJson: false, includeFromJson: false)  List<UserSearchResult> people, @JsonKey(includeToJson: false, includeFromJson: false)  List<GroupPostSearchResult> posts, @JsonKey(includeToJson: false, includeFromJson: false)  List<TrendingSearch> trending,  List<String> searchHisoty, @JsonKey(includeToJson: false, includeFromJson: false)  SearchStatus status, @JsonKey(includeToJson: false, includeFromJson: false)  SearchMode searchMode)?  $default,) {final _that = this;
switch (_that) {
case _SearchState() when $default != null:
return $default(_that.groups,_that.teachers,_that.classrooms,_that.people,_that.posts,_that.trending,_that.searchHisoty,_that.status,_that.searchMode);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _SearchState implements SearchState {
  const _SearchState({@JsonKey(includeToJson: false, includeFromJson: false) this.groups = const SearchGroupsResponse(results: []), @JsonKey(includeToJson: false, includeFromJson: false) this.teachers = const SearchTeachersResponse(results: []), @JsonKey(includeToJson: false, includeFromJson: false) this.classrooms = const SearchClassroomsResponse(results: []), @JsonKey(includeToJson: false, includeFromJson: false) final  List<UserSearchResult> people = const <UserSearchResult>[], @JsonKey(includeToJson: false, includeFromJson: false) final  List<GroupPostSearchResult> posts = const <GroupPostSearchResult>[], @JsonKey(includeToJson: false, includeFromJson: false) final  List<TrendingSearch> trending = const <TrendingSearch>[], final  List<String> searchHisoty = const <String>[], @JsonKey(includeToJson: false, includeFromJson: false) this.status = SearchStatus.initial, @JsonKey(includeToJson: false, includeFromJson: false) this.searchMode = SearchMode.all}): _people = people,_posts = posts,_trending = trending,_searchHisoty = searchHisoty;
  factory _SearchState.fromJson(Map<String, dynamic> json) => _$SearchStateFromJson(json);

@override@JsonKey(includeToJson: false, includeFromJson: false) final  SearchGroupsResponse groups;
@override@JsonKey(includeToJson: false, includeFromJson: false) final  SearchTeachersResponse teachers;
@override@JsonKey(includeToJson: false, includeFromJson: false) final  SearchClassroomsResponse classrooms;
 final  List<UserSearchResult> _people;
@override@JsonKey(includeToJson: false, includeFromJson: false) List<UserSearchResult> get people {
  if (_people is EqualUnmodifiableListView) return _people;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_people);
}

 final  List<GroupPostSearchResult> _posts;
@override@JsonKey(includeToJson: false, includeFromJson: false) List<GroupPostSearchResult> get posts {
  if (_posts is EqualUnmodifiableListView) return _posts;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_posts);
}

 final  List<TrendingSearch> _trending;
@override@JsonKey(includeToJson: false, includeFromJson: false) List<TrendingSearch> get trending {
  if (_trending is EqualUnmodifiableListView) return _trending;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_trending);
}

 final  List<String> _searchHisoty;
@override@JsonKey() List<String> get searchHisoty {
  if (_searchHisoty is EqualUnmodifiableListView) return _searchHisoty;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_searchHisoty);
}

@override@JsonKey(includeToJson: false, includeFromJson: false) final  SearchStatus status;
@override@JsonKey(includeToJson: false, includeFromJson: false) final  SearchMode searchMode;

/// Create a copy of SearchState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SearchStateCopyWith<_SearchState> get copyWith => __$SearchStateCopyWithImpl<_SearchState>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$SearchStateToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SearchState&&(identical(other.groups, groups) || other.groups == groups)&&(identical(other.teachers, teachers) || other.teachers == teachers)&&(identical(other.classrooms, classrooms) || other.classrooms == classrooms)&&const DeepCollectionEquality().equals(other._people, _people)&&const DeepCollectionEquality().equals(other._posts, _posts)&&const DeepCollectionEquality().equals(other._trending, _trending)&&const DeepCollectionEquality().equals(other._searchHisoty, _searchHisoty)&&(identical(other.status, status) || other.status == status)&&(identical(other.searchMode, searchMode) || other.searchMode == searchMode));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,groups,teachers,classrooms,const DeepCollectionEquality().hash(_people),const DeepCollectionEquality().hash(_posts),const DeepCollectionEquality().hash(_trending),const DeepCollectionEquality().hash(_searchHisoty),status,searchMode);

@override
String toString() {
  return 'SearchState(groups: $groups, teachers: $teachers, classrooms: $classrooms, people: $people, posts: $posts, trending: $trending, searchHisoty: $searchHisoty, status: $status, searchMode: $searchMode)';
}


}

/// @nodoc
abstract mixin class _$SearchStateCopyWith<$Res> implements $SearchStateCopyWith<$Res> {
  factory _$SearchStateCopyWith(_SearchState value, $Res Function(_SearchState) _then) = __$SearchStateCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(includeToJson: false, includeFromJson: false) SearchGroupsResponse groups,@JsonKey(includeToJson: false, includeFromJson: false) SearchTeachersResponse teachers,@JsonKey(includeToJson: false, includeFromJson: false) SearchClassroomsResponse classrooms,@JsonKey(includeToJson: false, includeFromJson: false) List<UserSearchResult> people,@JsonKey(includeToJson: false, includeFromJson: false) List<GroupPostSearchResult> posts,@JsonKey(includeToJson: false, includeFromJson: false) List<TrendingSearch> trending, List<String> searchHisoty,@JsonKey(includeToJson: false, includeFromJson: false) SearchStatus status,@JsonKey(includeToJson: false, includeFromJson: false) SearchMode searchMode
});


@override $SearchGroupsResponseCopyWith<$Res> get groups;@override $SearchTeachersResponseCopyWith<$Res> get teachers;@override $SearchClassroomsResponseCopyWith<$Res> get classrooms;

}
/// @nodoc
class __$SearchStateCopyWithImpl<$Res>
    implements _$SearchStateCopyWith<$Res> {
  __$SearchStateCopyWithImpl(this._self, this._then);

  final _SearchState _self;
  final $Res Function(_SearchState) _then;

/// Create a copy of SearchState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? groups = null,Object? teachers = null,Object? classrooms = null,Object? people = null,Object? posts = null,Object? trending = null,Object? searchHisoty = null,Object? status = null,Object? searchMode = null,}) {
  return _then(_SearchState(
groups: null == groups ? _self.groups : groups // ignore: cast_nullable_to_non_nullable
as SearchGroupsResponse,teachers: null == teachers ? _self.teachers : teachers // ignore: cast_nullable_to_non_nullable
as SearchTeachersResponse,classrooms: null == classrooms ? _self.classrooms : classrooms // ignore: cast_nullable_to_non_nullable
as SearchClassroomsResponse,people: null == people ? _self._people : people // ignore: cast_nullable_to_non_nullable
as List<UserSearchResult>,posts: null == posts ? _self._posts : posts // ignore: cast_nullable_to_non_nullable
as List<GroupPostSearchResult>,trending: null == trending ? _self._trending : trending // ignore: cast_nullable_to_non_nullable
as List<TrendingSearch>,searchHisoty: null == searchHisoty ? _self._searchHisoty : searchHisoty // ignore: cast_nullable_to_non_nullable
as List<String>,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as SearchStatus,searchMode: null == searchMode ? _self.searchMode : searchMode // ignore: cast_nullable_to_non_nullable
as SearchMode,
  ));
}

/// Create a copy of SearchState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$SearchGroupsResponseCopyWith<$Res> get groups {

  return $SearchGroupsResponseCopyWith<$Res>(_self.groups, (value) {
    return _then(_self.copyWith(groups: value));
  });
}/// Create a copy of SearchState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$SearchTeachersResponseCopyWith<$Res> get teachers {

  return $SearchTeachersResponseCopyWith<$Res>(_self.teachers, (value) {
    return _then(_self.copyWith(teachers: value));
  });
}/// Create a copy of SearchState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$SearchClassroomsResponseCopyWith<$Res> get classrooms {

  return $SearchClassroomsResponseCopyWith<$Res>(_self.classrooms, (value) {
    return _then(_self.copyWith(classrooms: value));
  });
}
}

// dart format on
