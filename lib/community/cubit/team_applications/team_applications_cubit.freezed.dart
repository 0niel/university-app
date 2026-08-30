// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'team_applications_cubit.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$TeamApplicationsState {

 TeamApplicationsStatus get status; List<TeamApplication> get applications; Set<String> get pendingIds; Set<String> get pendingRejectIds;
/// Create a copy of TeamApplicationsState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TeamApplicationsStateCopyWith<TeamApplicationsState> get copyWith => _$TeamApplicationsStateCopyWithImpl<TeamApplicationsState>(this as TeamApplicationsState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TeamApplicationsState&&(identical(other.status, status) || other.status == status)&&const DeepCollectionEquality().equals(other.applications, applications)&&const DeepCollectionEquality().equals(other.pendingIds, pendingIds)&&const DeepCollectionEquality().equals(other.pendingRejectIds, pendingRejectIds));
}


@override
int get hashCode => Object.hash(runtimeType,status,const DeepCollectionEquality().hash(applications),const DeepCollectionEquality().hash(pendingIds),const DeepCollectionEquality().hash(pendingRejectIds));

@override
String toString() {
  return 'TeamApplicationsState(status: $status, applications: $applications, pendingIds: $pendingIds, pendingRejectIds: $pendingRejectIds)';
}


}

/// @nodoc
abstract mixin class $TeamApplicationsStateCopyWith<$Res>  {
  factory $TeamApplicationsStateCopyWith(TeamApplicationsState value, $Res Function(TeamApplicationsState) _then) = _$TeamApplicationsStateCopyWithImpl;
@useResult
$Res call({
 TeamApplicationsStatus status, List<TeamApplication> applications, Set<String> pendingIds, Set<String> pendingRejectIds
});




}
/// @nodoc
class _$TeamApplicationsStateCopyWithImpl<$Res>
    implements $TeamApplicationsStateCopyWith<$Res> {
  _$TeamApplicationsStateCopyWithImpl(this._self, this._then);

  final TeamApplicationsState _self;
  final $Res Function(TeamApplicationsState) _then;

/// Create a copy of TeamApplicationsState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? status = null,Object? applications = null,Object? pendingIds = null,Object? pendingRejectIds = null,}) {
  return _then(_self.copyWith(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as TeamApplicationsStatus,applications: null == applications ? _self.applications : applications // ignore: cast_nullable_to_non_nullable
as List<TeamApplication>,pendingIds: null == pendingIds ? _self.pendingIds : pendingIds // ignore: cast_nullable_to_non_nullable
as Set<String>,pendingRejectIds: null == pendingRejectIds ? _self.pendingRejectIds : pendingRejectIds // ignore: cast_nullable_to_non_nullable
as Set<String>,
  ));
}

}


/// Adds pattern-matching-related methods to [TeamApplicationsState].
extension TeamApplicationsStatePatterns on TeamApplicationsState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TeamApplicationsState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TeamApplicationsState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TeamApplicationsState value)  $default,){
final _that = this;
switch (_that) {
case _TeamApplicationsState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TeamApplicationsState value)?  $default,){
final _that = this;
switch (_that) {
case _TeamApplicationsState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( TeamApplicationsStatus status,  List<TeamApplication> applications,  Set<String> pendingIds,  Set<String> pendingRejectIds)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _TeamApplicationsState() when $default != null:
return $default(_that.status,_that.applications,_that.pendingIds,_that.pendingRejectIds);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( TeamApplicationsStatus status,  List<TeamApplication> applications,  Set<String> pendingIds,  Set<String> pendingRejectIds)  $default,) {final _that = this;
switch (_that) {
case _TeamApplicationsState():
return $default(_that.status,_that.applications,_that.pendingIds,_that.pendingRejectIds);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( TeamApplicationsStatus status,  List<TeamApplication> applications,  Set<String> pendingIds,  Set<String> pendingRejectIds)?  $default,) {final _that = this;
switch (_that) {
case _TeamApplicationsState() when $default != null:
return $default(_that.status,_that.applications,_that.pendingIds,_that.pendingRejectIds);case _:
  return null;

}
}

}

/// @nodoc


class _TeamApplicationsState implements TeamApplicationsState {
  const _TeamApplicationsState({this.status = TeamApplicationsStatus.initial, final  List<TeamApplication> applications = const <TeamApplication>[], final  Set<String> pendingIds = const <String>{}, final  Set<String> pendingRejectIds = const <String>{}}): _applications = applications,_pendingIds = pendingIds,_pendingRejectIds = pendingRejectIds;


@override@JsonKey() final  TeamApplicationsStatus status;
 final  List<TeamApplication> _applications;
@override@JsonKey() List<TeamApplication> get applications {
  if (_applications is EqualUnmodifiableListView) return _applications;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_applications);
}

 final  Set<String> _pendingIds;
@override@JsonKey() Set<String> get pendingIds {
  if (_pendingIds is EqualUnmodifiableSetView) return _pendingIds;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableSetView(_pendingIds);
}

 final  Set<String> _pendingRejectIds;
@override@JsonKey() Set<String> get pendingRejectIds {
  if (_pendingRejectIds is EqualUnmodifiableSetView) return _pendingRejectIds;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableSetView(_pendingRejectIds);
}


/// Create a copy of TeamApplicationsState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TeamApplicationsStateCopyWith<_TeamApplicationsState> get copyWith => __$TeamApplicationsStateCopyWithImpl<_TeamApplicationsState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _TeamApplicationsState&&(identical(other.status, status) || other.status == status)&&const DeepCollectionEquality().equals(other._applications, _applications)&&const DeepCollectionEquality().equals(other._pendingIds, _pendingIds)&&const DeepCollectionEquality().equals(other._pendingRejectIds, _pendingRejectIds));
}


@override
int get hashCode => Object.hash(runtimeType,status,const DeepCollectionEquality().hash(_applications),const DeepCollectionEquality().hash(_pendingIds),const DeepCollectionEquality().hash(_pendingRejectIds));

@override
String toString() {
  return 'TeamApplicationsState(status: $status, applications: $applications, pendingIds: $pendingIds, pendingRejectIds: $pendingRejectIds)';
}


}

/// @nodoc
abstract mixin class _$TeamApplicationsStateCopyWith<$Res> implements $TeamApplicationsStateCopyWith<$Res> {
  factory _$TeamApplicationsStateCopyWith(_TeamApplicationsState value, $Res Function(_TeamApplicationsState) _then) = __$TeamApplicationsStateCopyWithImpl;
@override @useResult
$Res call({
 TeamApplicationsStatus status, List<TeamApplication> applications, Set<String> pendingIds, Set<String> pendingRejectIds
});




}
/// @nodoc
class __$TeamApplicationsStateCopyWithImpl<$Res>
    implements _$TeamApplicationsStateCopyWith<$Res> {
  __$TeamApplicationsStateCopyWithImpl(this._self, this._then);

  final _TeamApplicationsState _self;
  final $Res Function(_TeamApplicationsState) _then;

/// Create a copy of TeamApplicationsState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? status = null,Object? applications = null,Object? pendingIds = null,Object? pendingRejectIds = null,}) {
  return _then(_TeamApplicationsState(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as TeamApplicationsStatus,applications: null == applications ? _self._applications : applications // ignore: cast_nullable_to_non_nullable
as List<TeamApplication>,pendingIds: null == pendingIds ? _self._pendingIds : pendingIds // ignore: cast_nullable_to_non_nullable
as Set<String>,pendingRejectIds: null == pendingRejectIds ? _self._pendingRejectIds : pendingRejectIds // ignore: cast_nullable_to_non_nullable
as Set<String>,
  ));
}


}

// dart format on
