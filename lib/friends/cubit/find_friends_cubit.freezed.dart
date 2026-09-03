// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'find_friends_cubit.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$FindFriendsState {

 FindFriendsStatus get status; GroupRoster get roster; List<SuggestedFriend> get suggestions; List<UserSearchResult> get results; String get query; bool get searching; bool get searchFailed; Set<String> get sentTo; Set<String> get sendingTo; bool get isAddingGroup;
/// Create a copy of FindFriendsState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$FindFriendsStateCopyWith<FindFriendsState> get copyWith => _$FindFriendsStateCopyWithImpl<FindFriendsState>(this as FindFriendsState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is FindFriendsState&&(identical(other.status, status) || other.status == status)&&(identical(other.roster, roster) || other.roster == roster)&&const DeepCollectionEquality().equals(other.suggestions, suggestions)&&const DeepCollectionEquality().equals(other.results, results)&&(identical(other.query, query) || other.query == query)&&(identical(other.searching, searching) || other.searching == searching)&&(identical(other.searchFailed, searchFailed) || other.searchFailed == searchFailed)&&const DeepCollectionEquality().equals(other.sentTo, sentTo)&&const DeepCollectionEquality().equals(other.sendingTo, sendingTo)&&(identical(other.isAddingGroup, isAddingGroup) || other.isAddingGroup == isAddingGroup));
}


@override
int get hashCode => Object.hash(runtimeType,status,roster,const DeepCollectionEquality().hash(suggestions),const DeepCollectionEquality().hash(results),query,searching,searchFailed,const DeepCollectionEquality().hash(sentTo),const DeepCollectionEquality().hash(sendingTo),isAddingGroup);

@override
String toString() {
  return 'FindFriendsState(status: $status, roster: $roster, suggestions: $suggestions, results: $results, query: $query, searching: $searching, searchFailed: $searchFailed, sentTo: $sentTo, sendingTo: $sendingTo, isAddingGroup: $isAddingGroup)';
}


}

/// @nodoc
abstract mixin class $FindFriendsStateCopyWith<$Res>  {
  factory $FindFriendsStateCopyWith(FindFriendsState value, $Res Function(FindFriendsState) _then) = _$FindFriendsStateCopyWithImpl;
@useResult
$Res call({
 FindFriendsStatus status, GroupRoster roster, List<SuggestedFriend> suggestions, List<UserSearchResult> results, String query, bool searching, bool searchFailed, Set<String> sentTo, Set<String> sendingTo, bool isAddingGroup
});


$GroupRosterCopyWith<$Res> get roster;

}
/// @nodoc
class _$FindFriendsStateCopyWithImpl<$Res>
    implements $FindFriendsStateCopyWith<$Res> {
  _$FindFriendsStateCopyWithImpl(this._self, this._then);

  final FindFriendsState _self;
  final $Res Function(FindFriendsState) _then;

/// Create a copy of FindFriendsState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? status = null,Object? roster = null,Object? suggestions = null,Object? results = null,Object? query = null,Object? searching = null,Object? searchFailed = null,Object? sentTo = null,Object? sendingTo = null,Object? isAddingGroup = null,}) {
  return _then(_self.copyWith(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as FindFriendsStatus,roster: null == roster ? _self.roster : roster // ignore: cast_nullable_to_non_nullable
as GroupRoster,suggestions: null == suggestions ? _self.suggestions : suggestions // ignore: cast_nullable_to_non_nullable
as List<SuggestedFriend>,results: null == results ? _self.results : results // ignore: cast_nullable_to_non_nullable
as List<UserSearchResult>,query: null == query ? _self.query : query // ignore: cast_nullable_to_non_nullable
as String,searching: null == searching ? _self.searching : searching // ignore: cast_nullable_to_non_nullable
as bool,searchFailed: null == searchFailed ? _self.searchFailed : searchFailed // ignore: cast_nullable_to_non_nullable
as bool,sentTo: null == sentTo ? _self.sentTo : sentTo // ignore: cast_nullable_to_non_nullable
as Set<String>,sendingTo: null == sendingTo ? _self.sendingTo : sendingTo // ignore: cast_nullable_to_non_nullable
as Set<String>,isAddingGroup: null == isAddingGroup ? _self.isAddingGroup : isAddingGroup // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}
/// Create a copy of FindFriendsState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$GroupRosterCopyWith<$Res> get roster {

  return $GroupRosterCopyWith<$Res>(_self.roster, (value) {
    return _then(_self.copyWith(roster: value));
  });
}
}


/// Adds pattern-matching-related methods to [FindFriendsState].
extension FindFriendsStatePatterns on FindFriendsState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _FindFriendsState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _FindFriendsState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _FindFriendsState value)  $default,){
final _that = this;
switch (_that) {
case _FindFriendsState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _FindFriendsState value)?  $default,){
final _that = this;
switch (_that) {
case _FindFriendsState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( FindFriendsStatus status,  GroupRoster roster,  List<SuggestedFriend> suggestions,  List<UserSearchResult> results,  String query,  bool searching,  bool searchFailed,  Set<String> sentTo,  Set<String> sendingTo,  bool isAddingGroup)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _FindFriendsState() when $default != null:
return $default(_that.status,_that.roster,_that.suggestions,_that.results,_that.query,_that.searching,_that.searchFailed,_that.sentTo,_that.sendingTo,_that.isAddingGroup);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( FindFriendsStatus status,  GroupRoster roster,  List<SuggestedFriend> suggestions,  List<UserSearchResult> results,  String query,  bool searching,  bool searchFailed,  Set<String> sentTo,  Set<String> sendingTo,  bool isAddingGroup)  $default,) {final _that = this;
switch (_that) {
case _FindFriendsState():
return $default(_that.status,_that.roster,_that.suggestions,_that.results,_that.query,_that.searching,_that.searchFailed,_that.sentTo,_that.sendingTo,_that.isAddingGroup);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( FindFriendsStatus status,  GroupRoster roster,  List<SuggestedFriend> suggestions,  List<UserSearchResult> results,  String query,  bool searching,  bool searchFailed,  Set<String> sentTo,  Set<String> sendingTo,  bool isAddingGroup)?  $default,) {final _that = this;
switch (_that) {
case _FindFriendsState() when $default != null:
return $default(_that.status,_that.roster,_that.suggestions,_that.results,_that.query,_that.searching,_that.searchFailed,_that.sentTo,_that.sendingTo,_that.isAddingGroup);case _:
  return null;

}
}

}

/// @nodoc


class _FindFriendsState extends FindFriendsState {
  const _FindFriendsState({this.status = FindFriendsStatus.initial, this.roster = GroupRoster.empty, final  List<SuggestedFriend> suggestions = const <SuggestedFriend>[], final  List<UserSearchResult> results = const <UserSearchResult>[], this.query = '', this.searching = false, this.searchFailed = false, final  Set<String> sentTo = const <String>{}, final  Set<String> sendingTo = const <String>{}, this.isAddingGroup = false}): _suggestions = suggestions,_results = results,_sentTo = sentTo,_sendingTo = sendingTo,super._();


@override@JsonKey() final  FindFriendsStatus status;
@override@JsonKey() final  GroupRoster roster;
 final  List<SuggestedFriend> _suggestions;
@override@JsonKey() List<SuggestedFriend> get suggestions {
  if (_suggestions is EqualUnmodifiableListView) return _suggestions;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_suggestions);
}

 final  List<UserSearchResult> _results;
@override@JsonKey() List<UserSearchResult> get results {
  if (_results is EqualUnmodifiableListView) return _results;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_results);
}

@override@JsonKey() final  String query;
@override@JsonKey() final  bool searching;
@override@JsonKey() final  bool searchFailed;
 final  Set<String> _sentTo;
@override@JsonKey() Set<String> get sentTo {
  if (_sentTo is EqualUnmodifiableSetView) return _sentTo;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableSetView(_sentTo);
}

 final  Set<String> _sendingTo;
@override@JsonKey() Set<String> get sendingTo {
  if (_sendingTo is EqualUnmodifiableSetView) return _sendingTo;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableSetView(_sendingTo);
}

@override@JsonKey() final  bool isAddingGroup;

/// Create a copy of FindFriendsState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$FindFriendsStateCopyWith<_FindFriendsState> get copyWith => __$FindFriendsStateCopyWithImpl<_FindFriendsState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _FindFriendsState&&(identical(other.status, status) || other.status == status)&&(identical(other.roster, roster) || other.roster == roster)&&const DeepCollectionEquality().equals(other._suggestions, _suggestions)&&const DeepCollectionEquality().equals(other._results, _results)&&(identical(other.query, query) || other.query == query)&&(identical(other.searching, searching) || other.searching == searching)&&(identical(other.searchFailed, searchFailed) || other.searchFailed == searchFailed)&&const DeepCollectionEquality().equals(other._sentTo, _sentTo)&&const DeepCollectionEquality().equals(other._sendingTo, _sendingTo)&&(identical(other.isAddingGroup, isAddingGroup) || other.isAddingGroup == isAddingGroup));
}


@override
int get hashCode => Object.hash(runtimeType,status,roster,const DeepCollectionEquality().hash(_suggestions),const DeepCollectionEquality().hash(_results),query,searching,searchFailed,const DeepCollectionEquality().hash(_sentTo),const DeepCollectionEquality().hash(_sendingTo),isAddingGroup);

@override
String toString() {
  return 'FindFriendsState(status: $status, roster: $roster, suggestions: $suggestions, results: $results, query: $query, searching: $searching, searchFailed: $searchFailed, sentTo: $sentTo, sendingTo: $sendingTo, isAddingGroup: $isAddingGroup)';
}


}

/// @nodoc
abstract mixin class _$FindFriendsStateCopyWith<$Res> implements $FindFriendsStateCopyWith<$Res> {
  factory _$FindFriendsStateCopyWith(_FindFriendsState value, $Res Function(_FindFriendsState) _then) = __$FindFriendsStateCopyWithImpl;
@override @useResult
$Res call({
 FindFriendsStatus status, GroupRoster roster, List<SuggestedFriend> suggestions, List<UserSearchResult> results, String query, bool searching, bool searchFailed, Set<String> sentTo, Set<String> sendingTo, bool isAddingGroup
});


@override $GroupRosterCopyWith<$Res> get roster;

}
/// @nodoc
class __$FindFriendsStateCopyWithImpl<$Res>
    implements _$FindFriendsStateCopyWith<$Res> {
  __$FindFriendsStateCopyWithImpl(this._self, this._then);

  final _FindFriendsState _self;
  final $Res Function(_FindFriendsState) _then;

/// Create a copy of FindFriendsState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? status = null,Object? roster = null,Object? suggestions = null,Object? results = null,Object? query = null,Object? searching = null,Object? searchFailed = null,Object? sentTo = null,Object? sendingTo = null,Object? isAddingGroup = null,}) {
  return _then(_FindFriendsState(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as FindFriendsStatus,roster: null == roster ? _self.roster : roster // ignore: cast_nullable_to_non_nullable
as GroupRoster,suggestions: null == suggestions ? _self._suggestions : suggestions // ignore: cast_nullable_to_non_nullable
as List<SuggestedFriend>,results: null == results ? _self._results : results // ignore: cast_nullable_to_non_nullable
as List<UserSearchResult>,query: null == query ? _self.query : query // ignore: cast_nullable_to_non_nullable
as String,searching: null == searching ? _self.searching : searching // ignore: cast_nullable_to_non_nullable
as bool,searchFailed: null == searchFailed ? _self.searchFailed : searchFailed // ignore: cast_nullable_to_non_nullable
as bool,sentTo: null == sentTo ? _self._sentTo : sentTo // ignore: cast_nullable_to_non_nullable
as Set<String>,sendingTo: null == sendingTo ? _self._sendingTo : sendingTo // ignore: cast_nullable_to_non_nullable
as Set<String>,isAddingGroup: null == isAddingGroup ? _self.isAddingGroup : isAddingGroup // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

/// Create a copy of FindFriendsState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$GroupRosterCopyWith<$Res> get roster {

  return $GroupRosterCopyWith<$Res>(_self.roster, (value) {
    return _then(_self.copyWith(roster: value));
  });
}
}

// dart format on
