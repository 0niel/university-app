// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'custom_schedule_cubit.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$CustomScheduleState {

 List<CustomSchedule> get customSchedules;@JsonKey(includeFromJson: false, includeToJson: false) bool get isCustomScheduleModeEnabled;@JsonKey(includeFromJson: false, includeToJson: false) RemotePreferenceSyncStatus get syncStatus;
/// Create a copy of CustomScheduleState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CustomScheduleStateCopyWith<CustomScheduleState> get copyWith => _$CustomScheduleStateCopyWithImpl<CustomScheduleState>(this as CustomScheduleState, _$identity);

  /// Serializes this CustomScheduleState to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CustomScheduleState&&const DeepCollectionEquality().equals(other.customSchedules, customSchedules)&&(identical(other.isCustomScheduleModeEnabled, isCustomScheduleModeEnabled) || other.isCustomScheduleModeEnabled == isCustomScheduleModeEnabled)&&(identical(other.syncStatus, syncStatus) || other.syncStatus == syncStatus));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(customSchedules),isCustomScheduleModeEnabled,syncStatus);

@override
String toString() {
  return 'CustomScheduleState(customSchedules: $customSchedules, isCustomScheduleModeEnabled: $isCustomScheduleModeEnabled, syncStatus: $syncStatus)';
}


}

/// @nodoc
abstract mixin class $CustomScheduleStateCopyWith<$Res>  {
  factory $CustomScheduleStateCopyWith(CustomScheduleState value, $Res Function(CustomScheduleState) _then) = _$CustomScheduleStateCopyWithImpl;
@useResult
$Res call({
 List<CustomSchedule> customSchedules,@JsonKey(includeFromJson: false, includeToJson: false) bool isCustomScheduleModeEnabled,@JsonKey(includeFromJson: false, includeToJson: false) RemotePreferenceSyncStatus syncStatus
});




}
/// @nodoc
class _$CustomScheduleStateCopyWithImpl<$Res>
    implements $CustomScheduleStateCopyWith<$Res> {
  _$CustomScheduleStateCopyWithImpl(this._self, this._then);

  final CustomScheduleState _self;
  final $Res Function(CustomScheduleState) _then;

/// Create a copy of CustomScheduleState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? customSchedules = null,Object? isCustomScheduleModeEnabled = null,Object? syncStatus = null,}) {
  return _then(_self.copyWith(
customSchedules: null == customSchedules ? _self.customSchedules : customSchedules // ignore: cast_nullable_to_non_nullable
as List<CustomSchedule>,isCustomScheduleModeEnabled: null == isCustomScheduleModeEnabled ? _self.isCustomScheduleModeEnabled : isCustomScheduleModeEnabled // ignore: cast_nullable_to_non_nullable
as bool,syncStatus: null == syncStatus ? _self.syncStatus : syncStatus // ignore: cast_nullable_to_non_nullable
as RemotePreferenceSyncStatus,
  ));
}

}


/// Adds pattern-matching-related methods to [CustomScheduleState].
extension CustomScheduleStatePatterns on CustomScheduleState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CustomScheduleState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CustomScheduleState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CustomScheduleState value)  $default,){
final _that = this;
switch (_that) {
case _CustomScheduleState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CustomScheduleState value)?  $default,){
final _that = this;
switch (_that) {
case _CustomScheduleState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<CustomSchedule> customSchedules, @JsonKey(includeFromJson: false, includeToJson: false)  bool isCustomScheduleModeEnabled, @JsonKey(includeFromJson: false, includeToJson: false)  RemotePreferenceSyncStatus syncStatus)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CustomScheduleState() when $default != null:
return $default(_that.customSchedules,_that.isCustomScheduleModeEnabled,_that.syncStatus);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<CustomSchedule> customSchedules, @JsonKey(includeFromJson: false, includeToJson: false)  bool isCustomScheduleModeEnabled, @JsonKey(includeFromJson: false, includeToJson: false)  RemotePreferenceSyncStatus syncStatus)  $default,) {final _that = this;
switch (_that) {
case _CustomScheduleState():
return $default(_that.customSchedules,_that.isCustomScheduleModeEnabled,_that.syncStatus);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<CustomSchedule> customSchedules, @JsonKey(includeFromJson: false, includeToJson: false)  bool isCustomScheduleModeEnabled, @JsonKey(includeFromJson: false, includeToJson: false)  RemotePreferenceSyncStatus syncStatus)?  $default,) {final _that = this;
switch (_that) {
case _CustomScheduleState() when $default != null:
return $default(_that.customSchedules,_that.isCustomScheduleModeEnabled,_that.syncStatus);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _CustomScheduleState implements CustomScheduleState {
  const _CustomScheduleState({final  List<CustomSchedule> customSchedules = const [], @JsonKey(includeFromJson: false, includeToJson: false) this.isCustomScheduleModeEnabled = false, @JsonKey(includeFromJson: false, includeToJson: false) this.syncStatus = RemotePreferenceSyncStatus.initial}): _customSchedules = customSchedules;
  factory _CustomScheduleState.fromJson(Map<String, dynamic> json) => _$CustomScheduleStateFromJson(json);

 final  List<CustomSchedule> _customSchedules;
@override@JsonKey() List<CustomSchedule> get customSchedules {
  if (_customSchedules is EqualUnmodifiableListView) return _customSchedules;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_customSchedules);
}

@override@JsonKey(includeFromJson: false, includeToJson: false) final  bool isCustomScheduleModeEnabled;
@override@JsonKey(includeFromJson: false, includeToJson: false) final  RemotePreferenceSyncStatus syncStatus;

/// Create a copy of CustomScheduleState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CustomScheduleStateCopyWith<_CustomScheduleState> get copyWith => __$CustomScheduleStateCopyWithImpl<_CustomScheduleState>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$CustomScheduleStateToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CustomScheduleState&&const DeepCollectionEquality().equals(other._customSchedules, _customSchedules)&&(identical(other.isCustomScheduleModeEnabled, isCustomScheduleModeEnabled) || other.isCustomScheduleModeEnabled == isCustomScheduleModeEnabled)&&(identical(other.syncStatus, syncStatus) || other.syncStatus == syncStatus));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_customSchedules),isCustomScheduleModeEnabled,syncStatus);

@override
String toString() {
  return 'CustomScheduleState(customSchedules: $customSchedules, isCustomScheduleModeEnabled: $isCustomScheduleModeEnabled, syncStatus: $syncStatus)';
}


}

/// @nodoc
abstract mixin class _$CustomScheduleStateCopyWith<$Res> implements $CustomScheduleStateCopyWith<$Res> {
  factory _$CustomScheduleStateCopyWith(_CustomScheduleState value, $Res Function(_CustomScheduleState) _then) = __$CustomScheduleStateCopyWithImpl;
@override @useResult
$Res call({
 List<CustomSchedule> customSchedules,@JsonKey(includeFromJson: false, includeToJson: false) bool isCustomScheduleModeEnabled,@JsonKey(includeFromJson: false, includeToJson: false) RemotePreferenceSyncStatus syncStatus
});




}
/// @nodoc
class __$CustomScheduleStateCopyWithImpl<$Res>
    implements _$CustomScheduleStateCopyWith<$Res> {
  __$CustomScheduleStateCopyWithImpl(this._self, this._then);

  final _CustomScheduleState _self;
  final $Res Function(_CustomScheduleState) _then;

/// Create a copy of CustomScheduleState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? customSchedules = null,Object? isCustomScheduleModeEnabled = null,Object? syncStatus = null,}) {
  return _then(_CustomScheduleState(
customSchedules: null == customSchedules ? _self._customSchedules : customSchedules // ignore: cast_nullable_to_non_nullable
as List<CustomSchedule>,isCustomScheduleModeEnabled: null == isCustomScheduleModeEnabled ? _self.isCustomScheduleModeEnabled : isCustomScheduleModeEnabled // ignore: cast_nullable_to_non_nullable
as bool,syncStatus: null == syncStatus ? _self.syncStatus : syncStatus // ignore: cast_nullable_to_non_nullable
as RemotePreferenceSyncStatus,
  ));
}


}

// dart format on
