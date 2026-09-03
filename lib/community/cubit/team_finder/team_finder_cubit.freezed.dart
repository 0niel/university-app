// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'team_finder_cubit.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$TeamFinderState {

 TeamFinderStatus get status; List<Team> get teams; String get filterKey; Set<String> get pendingApplyIds; Set<String> get pendingDeleteIds; Set<String> get pendingLeaveIds; Set<String> get pendingUpdateIds; bool get isCreating;
/// Create a copy of TeamFinderState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TeamFinderStateCopyWith<TeamFinderState> get copyWith => _$TeamFinderStateCopyWithImpl<TeamFinderState>(this as TeamFinderState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TeamFinderState&&(identical(other.status, status) || other.status == status)&&const DeepCollectionEquality().equals(other.teams, teams)&&(identical(other.filterKey, filterKey) || other.filterKey == filterKey)&&const DeepCollectionEquality().equals(other.pendingApplyIds, pendingApplyIds)&&const DeepCollectionEquality().equals(other.pendingDeleteIds, pendingDeleteIds)&&const DeepCollectionEquality().equals(other.pendingLeaveIds, pendingLeaveIds)&&const DeepCollectionEquality().equals(other.pendingUpdateIds, pendingUpdateIds)&&(identical(other.isCreating, isCreating) || other.isCreating == isCreating));
}


@override
int get hashCode => Object.hash(runtimeType,status,const DeepCollectionEquality().hash(teams),filterKey,const DeepCollectionEquality().hash(pendingApplyIds),const DeepCollectionEquality().hash(pendingDeleteIds),const DeepCollectionEquality().hash(pendingLeaveIds),const DeepCollectionEquality().hash(pendingUpdateIds),isCreating);

@override
String toString() {
  return 'TeamFinderState(status: $status, teams: $teams, filterKey: $filterKey, pendingApplyIds: $pendingApplyIds, pendingDeleteIds: $pendingDeleteIds, pendingLeaveIds: $pendingLeaveIds, pendingUpdateIds: $pendingUpdateIds, isCreating: $isCreating)';
}


}

/// @nodoc
abstract mixin class $TeamFinderStateCopyWith<$Res>  {
  factory $TeamFinderStateCopyWith(TeamFinderState value, $Res Function(TeamFinderState) _then) = _$TeamFinderStateCopyWithImpl;
@useResult
$Res call({
 TeamFinderStatus status, List<Team> teams, String filterKey, Set<String> pendingApplyIds, Set<String> pendingDeleteIds, Set<String> pendingLeaveIds, Set<String> pendingUpdateIds, bool isCreating
});




}
/// @nodoc
class _$TeamFinderStateCopyWithImpl<$Res>
    implements $TeamFinderStateCopyWith<$Res> {
  _$TeamFinderStateCopyWithImpl(this._self, this._then);

  final TeamFinderState _self;
  final $Res Function(TeamFinderState) _then;

/// Create a copy of TeamFinderState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? status = null,Object? teams = null,Object? filterKey = null,Object? pendingApplyIds = null,Object? pendingDeleteIds = null,Object? pendingLeaveIds = null,Object? pendingUpdateIds = null,Object? isCreating = null,}) {
  return _then(_self.copyWith(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as TeamFinderStatus,teams: null == teams ? _self.teams : teams // ignore: cast_nullable_to_non_nullable
as List<Team>,filterKey: null == filterKey ? _self.filterKey : filterKey // ignore: cast_nullable_to_non_nullable
as String,pendingApplyIds: null == pendingApplyIds ? _self.pendingApplyIds : pendingApplyIds // ignore: cast_nullable_to_non_nullable
as Set<String>,pendingDeleteIds: null == pendingDeleteIds ? _self.pendingDeleteIds : pendingDeleteIds // ignore: cast_nullable_to_non_nullable
as Set<String>,pendingLeaveIds: null == pendingLeaveIds ? _self.pendingLeaveIds : pendingLeaveIds // ignore: cast_nullable_to_non_nullable
as Set<String>,pendingUpdateIds: null == pendingUpdateIds ? _self.pendingUpdateIds : pendingUpdateIds // ignore: cast_nullable_to_non_nullable
as Set<String>,isCreating: null == isCreating ? _self.isCreating : isCreating // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [TeamFinderState].
extension TeamFinderStatePatterns on TeamFinderState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TeamFinderState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TeamFinderState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TeamFinderState value)  $default,){
final _that = this;
switch (_that) {
case _TeamFinderState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TeamFinderState value)?  $default,){
final _that = this;
switch (_that) {
case _TeamFinderState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( TeamFinderStatus status,  List<Team> teams,  String filterKey,  Set<String> pendingApplyIds,  Set<String> pendingDeleteIds,  Set<String> pendingLeaveIds,  Set<String> pendingUpdateIds,  bool isCreating)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _TeamFinderState() when $default != null:
return $default(_that.status,_that.teams,_that.filterKey,_that.pendingApplyIds,_that.pendingDeleteIds,_that.pendingLeaveIds,_that.pendingUpdateIds,_that.isCreating);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( TeamFinderStatus status,  List<Team> teams,  String filterKey,  Set<String> pendingApplyIds,  Set<String> pendingDeleteIds,  Set<String> pendingLeaveIds,  Set<String> pendingUpdateIds,  bool isCreating)  $default,) {final _that = this;
switch (_that) {
case _TeamFinderState():
return $default(_that.status,_that.teams,_that.filterKey,_that.pendingApplyIds,_that.pendingDeleteIds,_that.pendingLeaveIds,_that.pendingUpdateIds,_that.isCreating);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( TeamFinderStatus status,  List<Team> teams,  String filterKey,  Set<String> pendingApplyIds,  Set<String> pendingDeleteIds,  Set<String> pendingLeaveIds,  Set<String> pendingUpdateIds,  bool isCreating)?  $default,) {final _that = this;
switch (_that) {
case _TeamFinderState() when $default != null:
return $default(_that.status,_that.teams,_that.filterKey,_that.pendingApplyIds,_that.pendingDeleteIds,_that.pendingLeaveIds,_that.pendingUpdateIds,_that.isCreating);case _:
  return null;

}
}

}

/// @nodoc


class _TeamFinderState extends TeamFinderState {
  const _TeamFinderState({this.status = TeamFinderStatus.initial, final  List<Team> teams = const <Team>[], this.filterKey = 'all', final  Set<String> pendingApplyIds = const <String>{}, final  Set<String> pendingDeleteIds = const <String>{}, final  Set<String> pendingLeaveIds = const <String>{}, final  Set<String> pendingUpdateIds = const <String>{}, this.isCreating = false}): _teams = teams,_pendingApplyIds = pendingApplyIds,_pendingDeleteIds = pendingDeleteIds,_pendingLeaveIds = pendingLeaveIds,_pendingUpdateIds = pendingUpdateIds,super._();


@override@JsonKey() final  TeamFinderStatus status;
 final  List<Team> _teams;
@override@JsonKey() List<Team> get teams {
  if (_teams is EqualUnmodifiableListView) return _teams;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_teams);
}

@override@JsonKey() final  String filterKey;
 final  Set<String> _pendingApplyIds;
@override@JsonKey() Set<String> get pendingApplyIds {
  if (_pendingApplyIds is EqualUnmodifiableSetView) return _pendingApplyIds;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableSetView(_pendingApplyIds);
}

 final  Set<String> _pendingDeleteIds;
@override@JsonKey() Set<String> get pendingDeleteIds {
  if (_pendingDeleteIds is EqualUnmodifiableSetView) return _pendingDeleteIds;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableSetView(_pendingDeleteIds);
}

 final  Set<String> _pendingLeaveIds;
@override@JsonKey() Set<String> get pendingLeaveIds {
  if (_pendingLeaveIds is EqualUnmodifiableSetView) return _pendingLeaveIds;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableSetView(_pendingLeaveIds);
}

 final  Set<String> _pendingUpdateIds;
@override@JsonKey() Set<String> get pendingUpdateIds {
  if (_pendingUpdateIds is EqualUnmodifiableSetView) return _pendingUpdateIds;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableSetView(_pendingUpdateIds);
}

@override@JsonKey() final  bool isCreating;

/// Create a copy of TeamFinderState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TeamFinderStateCopyWith<_TeamFinderState> get copyWith => __$TeamFinderStateCopyWithImpl<_TeamFinderState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _TeamFinderState&&(identical(other.status, status) || other.status == status)&&const DeepCollectionEquality().equals(other._teams, _teams)&&(identical(other.filterKey, filterKey) || other.filterKey == filterKey)&&const DeepCollectionEquality().equals(other._pendingApplyIds, _pendingApplyIds)&&const DeepCollectionEquality().equals(other._pendingDeleteIds, _pendingDeleteIds)&&const DeepCollectionEquality().equals(other._pendingLeaveIds, _pendingLeaveIds)&&const DeepCollectionEquality().equals(other._pendingUpdateIds, _pendingUpdateIds)&&(identical(other.isCreating, isCreating) || other.isCreating == isCreating));
}


@override
int get hashCode => Object.hash(runtimeType,status,const DeepCollectionEquality().hash(_teams),filterKey,const DeepCollectionEquality().hash(_pendingApplyIds),const DeepCollectionEquality().hash(_pendingDeleteIds),const DeepCollectionEquality().hash(_pendingLeaveIds),const DeepCollectionEquality().hash(_pendingUpdateIds),isCreating);

@override
String toString() {
  return 'TeamFinderState(status: $status, teams: $teams, filterKey: $filterKey, pendingApplyIds: $pendingApplyIds, pendingDeleteIds: $pendingDeleteIds, pendingLeaveIds: $pendingLeaveIds, pendingUpdateIds: $pendingUpdateIds, isCreating: $isCreating)';
}


}

/// @nodoc
abstract mixin class _$TeamFinderStateCopyWith<$Res> implements $TeamFinderStateCopyWith<$Res> {
  factory _$TeamFinderStateCopyWith(_TeamFinderState value, $Res Function(_TeamFinderState) _then) = __$TeamFinderStateCopyWithImpl;
@override @useResult
$Res call({
 TeamFinderStatus status, List<Team> teams, String filterKey, Set<String> pendingApplyIds, Set<String> pendingDeleteIds, Set<String> pendingLeaveIds, Set<String> pendingUpdateIds, bool isCreating
});




}
/// @nodoc
class __$TeamFinderStateCopyWithImpl<$Res>
    implements _$TeamFinderStateCopyWith<$Res> {
  __$TeamFinderStateCopyWithImpl(this._self, this._then);

  final _TeamFinderState _self;
  final $Res Function(_TeamFinderState) _then;

/// Create a copy of TeamFinderState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? status = null,Object? teams = null,Object? filterKey = null,Object? pendingApplyIds = null,Object? pendingDeleteIds = null,Object? pendingLeaveIds = null,Object? pendingUpdateIds = null,Object? isCreating = null,}) {
  return _then(_TeamFinderState(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as TeamFinderStatus,teams: null == teams ? _self._teams : teams // ignore: cast_nullable_to_non_nullable
as List<Team>,filterKey: null == filterKey ? _self.filterKey : filterKey // ignore: cast_nullable_to_non_nullable
as String,pendingApplyIds: null == pendingApplyIds ? _self._pendingApplyIds : pendingApplyIds // ignore: cast_nullable_to_non_nullable
as Set<String>,pendingDeleteIds: null == pendingDeleteIds ? _self._pendingDeleteIds : pendingDeleteIds // ignore: cast_nullable_to_non_nullable
as Set<String>,pendingLeaveIds: null == pendingLeaveIds ? _self._pendingLeaveIds : pendingLeaveIds // ignore: cast_nullable_to_non_nullable
as Set<String>,pendingUpdateIds: null == pendingUpdateIds ? _self._pendingUpdateIds : pendingUpdateIds // ignore: cast_nullable_to_non_nullable
as Set<String>,isCreating: null == isCreating ? _self.isCreating : isCreating // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
