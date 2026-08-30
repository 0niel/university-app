// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'people_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$PeopleState {

 PeopleStatus get status; PeopleTab get tab; List<Friend> get friends; List<FriendRequest> get requests; MyStudyGroup get studyGroup; Set<PeopleSource> get failedSources; Set<String> get pendingFriendIds; Set<String> get pendingResponseIds; Set<String> get pendingInviteIds; bool get isJoiningGroup;
/// Create a copy of PeopleState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PeopleStateCopyWith<PeopleState> get copyWith => _$PeopleStateCopyWithImpl<PeopleState>(this as PeopleState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PeopleState&&(identical(other.status, status) || other.status == status)&&(identical(other.tab, tab) || other.tab == tab)&&const DeepCollectionEquality().equals(other.friends, friends)&&const DeepCollectionEquality().equals(other.requests, requests)&&(identical(other.studyGroup, studyGroup) || other.studyGroup == studyGroup)&&const DeepCollectionEquality().equals(other.failedSources, failedSources)&&const DeepCollectionEquality().equals(other.pendingFriendIds, pendingFriendIds)&&const DeepCollectionEquality().equals(other.pendingResponseIds, pendingResponseIds)&&const DeepCollectionEquality().equals(other.pendingInviteIds, pendingInviteIds)&&(identical(other.isJoiningGroup, isJoiningGroup) || other.isJoiningGroup == isJoiningGroup));
}


@override
int get hashCode => Object.hash(runtimeType,status,tab,const DeepCollectionEquality().hash(friends),const DeepCollectionEquality().hash(requests),studyGroup,const DeepCollectionEquality().hash(failedSources),const DeepCollectionEquality().hash(pendingFriendIds),const DeepCollectionEquality().hash(pendingResponseIds),const DeepCollectionEquality().hash(pendingInviteIds),isJoiningGroup);

@override
String toString() {
  return 'PeopleState(status: $status, tab: $tab, friends: $friends, requests: $requests, studyGroup: $studyGroup, failedSources: $failedSources, pendingFriendIds: $pendingFriendIds, pendingResponseIds: $pendingResponseIds, pendingInviteIds: $pendingInviteIds, isJoiningGroup: $isJoiningGroup)';
}


}

/// @nodoc
abstract mixin class $PeopleStateCopyWith<$Res>  {
  factory $PeopleStateCopyWith(PeopleState value, $Res Function(PeopleState) _then) = _$PeopleStateCopyWithImpl;
@useResult
$Res call({
 PeopleStatus status, PeopleTab tab, List<Friend> friends, List<FriendRequest> requests, MyStudyGroup studyGroup, Set<PeopleSource> failedSources, Set<String> pendingFriendIds, Set<String> pendingResponseIds, Set<String> pendingInviteIds, bool isJoiningGroup
});


$MyStudyGroupCopyWith<$Res> get studyGroup;

}
/// @nodoc
class _$PeopleStateCopyWithImpl<$Res>
    implements $PeopleStateCopyWith<$Res> {
  _$PeopleStateCopyWithImpl(this._self, this._then);

  final PeopleState _self;
  final $Res Function(PeopleState) _then;

/// Create a copy of PeopleState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? status = null,Object? tab = null,Object? friends = null,Object? requests = null,Object? studyGroup = null,Object? failedSources = null,Object? pendingFriendIds = null,Object? pendingResponseIds = null,Object? pendingInviteIds = null,Object? isJoiningGroup = null,}) {
  return _then(_self.copyWith(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as PeopleStatus,tab: null == tab ? _self.tab : tab // ignore: cast_nullable_to_non_nullable
as PeopleTab,friends: null == friends ? _self.friends : friends // ignore: cast_nullable_to_non_nullable
as List<Friend>,requests: null == requests ? _self.requests : requests // ignore: cast_nullable_to_non_nullable
as List<FriendRequest>,studyGroup: null == studyGroup ? _self.studyGroup : studyGroup // ignore: cast_nullable_to_non_nullable
as MyStudyGroup,failedSources: null == failedSources ? _self.failedSources : failedSources // ignore: cast_nullable_to_non_nullable
as Set<PeopleSource>,pendingFriendIds: null == pendingFriendIds ? _self.pendingFriendIds : pendingFriendIds // ignore: cast_nullable_to_non_nullable
as Set<String>,pendingResponseIds: null == pendingResponseIds ? _self.pendingResponseIds : pendingResponseIds // ignore: cast_nullable_to_non_nullable
as Set<String>,pendingInviteIds: null == pendingInviteIds ? _self.pendingInviteIds : pendingInviteIds // ignore: cast_nullable_to_non_nullable
as Set<String>,isJoiningGroup: null == isJoiningGroup ? _self.isJoiningGroup : isJoiningGroup // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}
/// Create a copy of PeopleState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$MyStudyGroupCopyWith<$Res> get studyGroup {

  return $MyStudyGroupCopyWith<$Res>(_self.studyGroup, (value) {
    return _then(_self.copyWith(studyGroup: value));
  });
}
}


/// Adds pattern-matching-related methods to [PeopleState].
extension PeopleStatePatterns on PeopleState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PeopleState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PeopleState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PeopleState value)  $default,){
final _that = this;
switch (_that) {
case _PeopleState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PeopleState value)?  $default,){
final _that = this;
switch (_that) {
case _PeopleState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( PeopleStatus status,  PeopleTab tab,  List<Friend> friends,  List<FriendRequest> requests,  MyStudyGroup studyGroup,  Set<PeopleSource> failedSources,  Set<String> pendingFriendIds,  Set<String> pendingResponseIds,  Set<String> pendingInviteIds,  bool isJoiningGroup)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PeopleState() when $default != null:
return $default(_that.status,_that.tab,_that.friends,_that.requests,_that.studyGroup,_that.failedSources,_that.pendingFriendIds,_that.pendingResponseIds,_that.pendingInviteIds,_that.isJoiningGroup);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( PeopleStatus status,  PeopleTab tab,  List<Friend> friends,  List<FriendRequest> requests,  MyStudyGroup studyGroup,  Set<PeopleSource> failedSources,  Set<String> pendingFriendIds,  Set<String> pendingResponseIds,  Set<String> pendingInviteIds,  bool isJoiningGroup)  $default,) {final _that = this;
switch (_that) {
case _PeopleState():
return $default(_that.status,_that.tab,_that.friends,_that.requests,_that.studyGroup,_that.failedSources,_that.pendingFriendIds,_that.pendingResponseIds,_that.pendingInviteIds,_that.isJoiningGroup);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( PeopleStatus status,  PeopleTab tab,  List<Friend> friends,  List<FriendRequest> requests,  MyStudyGroup studyGroup,  Set<PeopleSource> failedSources,  Set<String> pendingFriendIds,  Set<String> pendingResponseIds,  Set<String> pendingInviteIds,  bool isJoiningGroup)?  $default,) {final _that = this;
switch (_that) {
case _PeopleState() when $default != null:
return $default(_that.status,_that.tab,_that.friends,_that.requests,_that.studyGroup,_that.failedSources,_that.pendingFriendIds,_that.pendingResponseIds,_that.pendingInviteIds,_that.isJoiningGroup);case _:
  return null;

}
}

}

/// @nodoc


class _PeopleState extends PeopleState {
  const _PeopleState({this.status = PeopleStatus.initial, this.tab = PeopleTab.friends, final  List<Friend> friends = const <Friend>[], final  List<FriendRequest> requests = const <FriendRequest>[], this.studyGroup = MyStudyGroup.empty, final  Set<PeopleSource> failedSources = const <PeopleSource>{}, final  Set<String> pendingFriendIds = const <String>{}, final  Set<String> pendingResponseIds = const <String>{}, final  Set<String> pendingInviteIds = const <String>{}, this.isJoiningGroup = false}): _friends = friends,_requests = requests,_failedSources = failedSources,_pendingFriendIds = pendingFriendIds,_pendingResponseIds = pendingResponseIds,_pendingInviteIds = pendingInviteIds,super._();


@override@JsonKey() final  PeopleStatus status;
@override@JsonKey() final  PeopleTab tab;
 final  List<Friend> _friends;
@override@JsonKey() List<Friend> get friends {
  if (_friends is EqualUnmodifiableListView) return _friends;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_friends);
}

 final  List<FriendRequest> _requests;
@override@JsonKey() List<FriendRequest> get requests {
  if (_requests is EqualUnmodifiableListView) return _requests;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_requests);
}

@override@JsonKey() final  MyStudyGroup studyGroup;
 final  Set<PeopleSource> _failedSources;
@override@JsonKey() Set<PeopleSource> get failedSources {
  if (_failedSources is EqualUnmodifiableSetView) return _failedSources;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableSetView(_failedSources);
}

 final  Set<String> _pendingFriendIds;
@override@JsonKey() Set<String> get pendingFriendIds {
  if (_pendingFriendIds is EqualUnmodifiableSetView) return _pendingFriendIds;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableSetView(_pendingFriendIds);
}

 final  Set<String> _pendingResponseIds;
@override@JsonKey() Set<String> get pendingResponseIds {
  if (_pendingResponseIds is EqualUnmodifiableSetView) return _pendingResponseIds;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableSetView(_pendingResponseIds);
}

 final  Set<String> _pendingInviteIds;
@override@JsonKey() Set<String> get pendingInviteIds {
  if (_pendingInviteIds is EqualUnmodifiableSetView) return _pendingInviteIds;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableSetView(_pendingInviteIds);
}

@override@JsonKey() final  bool isJoiningGroup;

/// Create a copy of PeopleState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PeopleStateCopyWith<_PeopleState> get copyWith => __$PeopleStateCopyWithImpl<_PeopleState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PeopleState&&(identical(other.status, status) || other.status == status)&&(identical(other.tab, tab) || other.tab == tab)&&const DeepCollectionEquality().equals(other._friends, _friends)&&const DeepCollectionEquality().equals(other._requests, _requests)&&(identical(other.studyGroup, studyGroup) || other.studyGroup == studyGroup)&&const DeepCollectionEquality().equals(other._failedSources, _failedSources)&&const DeepCollectionEquality().equals(other._pendingFriendIds, _pendingFriendIds)&&const DeepCollectionEquality().equals(other._pendingResponseIds, _pendingResponseIds)&&const DeepCollectionEquality().equals(other._pendingInviteIds, _pendingInviteIds)&&(identical(other.isJoiningGroup, isJoiningGroup) || other.isJoiningGroup == isJoiningGroup));
}


@override
int get hashCode => Object.hash(runtimeType,status,tab,const DeepCollectionEquality().hash(_friends),const DeepCollectionEquality().hash(_requests),studyGroup,const DeepCollectionEquality().hash(_failedSources),const DeepCollectionEquality().hash(_pendingFriendIds),const DeepCollectionEquality().hash(_pendingResponseIds),const DeepCollectionEquality().hash(_pendingInviteIds),isJoiningGroup);

@override
String toString() {
  return 'PeopleState(status: $status, tab: $tab, friends: $friends, requests: $requests, studyGroup: $studyGroup, failedSources: $failedSources, pendingFriendIds: $pendingFriendIds, pendingResponseIds: $pendingResponseIds, pendingInviteIds: $pendingInviteIds, isJoiningGroup: $isJoiningGroup)';
}


}

/// @nodoc
abstract mixin class _$PeopleStateCopyWith<$Res> implements $PeopleStateCopyWith<$Res> {
  factory _$PeopleStateCopyWith(_PeopleState value, $Res Function(_PeopleState) _then) = __$PeopleStateCopyWithImpl;
@override @useResult
$Res call({
 PeopleStatus status, PeopleTab tab, List<Friend> friends, List<FriendRequest> requests, MyStudyGroup studyGroup, Set<PeopleSource> failedSources, Set<String> pendingFriendIds, Set<String> pendingResponseIds, Set<String> pendingInviteIds, bool isJoiningGroup
});


@override $MyStudyGroupCopyWith<$Res> get studyGroup;

}
/// @nodoc
class __$PeopleStateCopyWithImpl<$Res>
    implements _$PeopleStateCopyWith<$Res> {
  __$PeopleStateCopyWithImpl(this._self, this._then);

  final _PeopleState _self;
  final $Res Function(_PeopleState) _then;

/// Create a copy of PeopleState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? status = null,Object? tab = null,Object? friends = null,Object? requests = null,Object? studyGroup = null,Object? failedSources = null,Object? pendingFriendIds = null,Object? pendingResponseIds = null,Object? pendingInviteIds = null,Object? isJoiningGroup = null,}) {
  return _then(_PeopleState(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as PeopleStatus,tab: null == tab ? _self.tab : tab // ignore: cast_nullable_to_non_nullable
as PeopleTab,friends: null == friends ? _self._friends : friends // ignore: cast_nullable_to_non_nullable
as List<Friend>,requests: null == requests ? _self._requests : requests // ignore: cast_nullable_to_non_nullable
as List<FriendRequest>,studyGroup: null == studyGroup ? _self.studyGroup : studyGroup // ignore: cast_nullable_to_non_nullable
as MyStudyGroup,failedSources: null == failedSources ? _self._failedSources : failedSources // ignore: cast_nullable_to_non_nullable
as Set<PeopleSource>,pendingFriendIds: null == pendingFriendIds ? _self._pendingFriendIds : pendingFriendIds // ignore: cast_nullable_to_non_nullable
as Set<String>,pendingResponseIds: null == pendingResponseIds ? _self._pendingResponseIds : pendingResponseIds // ignore: cast_nullable_to_non_nullable
as Set<String>,pendingInviteIds: null == pendingInviteIds ? _self._pendingInviteIds : pendingInviteIds // ignore: cast_nullable_to_non_nullable
as Set<String>,isJoiningGroup: null == isJoiningGroup ? _self.isJoiningGroup : isJoiningGroup // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

/// Create a copy of PeopleState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$MyStudyGroupCopyWith<$Res> get studyGroup {

  return $MyStudyGroupCopyWith<$Res>(_self.studyGroup, (value) {
    return _then(_self.copyWith(studyGroup: value));
  });
}
}

// dart format on
