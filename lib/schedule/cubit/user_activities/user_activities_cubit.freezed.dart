// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'user_activities_cubit.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$UserActivitiesState {

 List<UserActivity> get activities; UserActivitiesStatus get status;
/// Create a copy of UserActivitiesState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$UserActivitiesStateCopyWith<UserActivitiesState> get copyWith => _$UserActivitiesStateCopyWithImpl<UserActivitiesState>(this as UserActivitiesState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is UserActivitiesState&&const DeepCollectionEquality().equals(other.activities, activities)&&(identical(other.status, status) || other.status == status));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(activities),status);

@override
String toString() {
  return 'UserActivitiesState(activities: $activities, status: $status)';
}


}

/// @nodoc
abstract mixin class $UserActivitiesStateCopyWith<$Res>  {
  factory $UserActivitiesStateCopyWith(UserActivitiesState value, $Res Function(UserActivitiesState) _then) = _$UserActivitiesStateCopyWithImpl;
@useResult
$Res call({
 List<UserActivity> activities, UserActivitiesStatus status
});




}
/// @nodoc
class _$UserActivitiesStateCopyWithImpl<$Res>
    implements $UserActivitiesStateCopyWith<$Res> {
  _$UserActivitiesStateCopyWithImpl(this._self, this._then);

  final UserActivitiesState _self;
  final $Res Function(UserActivitiesState) _then;

/// Create a copy of UserActivitiesState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? activities = null,Object? status = null,}) {
  return _then(_self.copyWith(
activities: null == activities ? _self.activities : activities // ignore: cast_nullable_to_non_nullable
as List<UserActivity>,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as UserActivitiesStatus,
  ));
}

}


/// Adds pattern-matching-related methods to [UserActivitiesState].
extension UserActivitiesStatePatterns on UserActivitiesState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _UserActivitiesState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _UserActivitiesState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _UserActivitiesState value)  $default,){
final _that = this;
switch (_that) {
case _UserActivitiesState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _UserActivitiesState value)?  $default,){
final _that = this;
switch (_that) {
case _UserActivitiesState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<UserActivity> activities,  UserActivitiesStatus status)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _UserActivitiesState() when $default != null:
return $default(_that.activities,_that.status);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<UserActivity> activities,  UserActivitiesStatus status)  $default,) {final _that = this;
switch (_that) {
case _UserActivitiesState():
return $default(_that.activities,_that.status);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<UserActivity> activities,  UserActivitiesStatus status)?  $default,) {final _that = this;
switch (_that) {
case _UserActivitiesState() when $default != null:
return $default(_that.activities,_that.status);case _:
  return null;

}
}

}

/// @nodoc


class _UserActivitiesState extends UserActivitiesState {
  const _UserActivitiesState({final  List<UserActivity> activities = const <UserActivity>[], this.status = UserActivitiesStatus.initial}): _activities = activities,super._();


 final  List<UserActivity> _activities;
@override@JsonKey() List<UserActivity> get activities {
  if (_activities is EqualUnmodifiableListView) return _activities;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_activities);
}

@override@JsonKey() final  UserActivitiesStatus status;

/// Create a copy of UserActivitiesState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$UserActivitiesStateCopyWith<_UserActivitiesState> get copyWith => __$UserActivitiesStateCopyWithImpl<_UserActivitiesState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _UserActivitiesState&&const DeepCollectionEquality().equals(other._activities, _activities)&&(identical(other.status, status) || other.status == status));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_activities),status);

@override
String toString() {
  return 'UserActivitiesState(activities: $activities, status: $status)';
}


}

/// @nodoc
abstract mixin class _$UserActivitiesStateCopyWith<$Res> implements $UserActivitiesStateCopyWith<$Res> {
  factory _$UserActivitiesStateCopyWith(_UserActivitiesState value, $Res Function(_UserActivitiesState) _then) = __$UserActivitiesStateCopyWithImpl;
@override @useResult
$Res call({
 List<UserActivity> activities, UserActivitiesStatus status
});




}
/// @nodoc
class __$UserActivitiesStateCopyWithImpl<$Res>
    implements _$UserActivitiesStateCopyWith<$Res> {
  __$UserActivitiesStateCopyWithImpl(this._self, this._then);

  final _UserActivitiesState _self;
  final $Res Function(_UserActivitiesState) _then;

/// Create a copy of UserActivitiesState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? activities = null,Object? status = null,}) {
  return _then(_UserActivitiesState(
activities: null == activities ? _self._activities : activities // ignore: cast_nullable_to_non_nullable
as List<UserActivity>,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as UserActivitiesStatus,
  ));
}


}

// dart format on
