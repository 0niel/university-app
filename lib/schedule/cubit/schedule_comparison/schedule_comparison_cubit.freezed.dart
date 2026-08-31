// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'schedule_comparison_cubit.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$ScheduleComparisonState {

 Set<SelectedSchedule> get schedules; bool get isEnabled;
/// Create a copy of ScheduleComparisonState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ScheduleComparisonStateCopyWith<ScheduleComparisonState> get copyWith => _$ScheduleComparisonStateCopyWithImpl<ScheduleComparisonState>(this as ScheduleComparisonState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ScheduleComparisonState&&const DeepCollectionEquality().equals(other.schedules, schedules)&&(identical(other.isEnabled, isEnabled) || other.isEnabled == isEnabled));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(schedules),isEnabled);

@override
String toString() {
  return 'ScheduleComparisonState(schedules: $schedules, isEnabled: $isEnabled)';
}


}

/// @nodoc
abstract mixin class $ScheduleComparisonStateCopyWith<$Res>  {
  factory $ScheduleComparisonStateCopyWith(ScheduleComparisonState value, $Res Function(ScheduleComparisonState) _then) = _$ScheduleComparisonStateCopyWithImpl;
@useResult
$Res call({
 Set<SelectedSchedule> schedules, bool isEnabled
});




}
/// @nodoc
class _$ScheduleComparisonStateCopyWithImpl<$Res>
    implements $ScheduleComparisonStateCopyWith<$Res> {
  _$ScheduleComparisonStateCopyWithImpl(this._self, this._then);

  final ScheduleComparisonState _self;
  final $Res Function(ScheduleComparisonState) _then;

/// Create a copy of ScheduleComparisonState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? schedules = null,Object? isEnabled = null,}) {
  return _then(_self.copyWith(
schedules: null == schedules ? _self.schedules : schedules // ignore: cast_nullable_to_non_nullable
as Set<SelectedSchedule>,isEnabled: null == isEnabled ? _self.isEnabled : isEnabled // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [ScheduleComparisonState].
extension ScheduleComparisonStatePatterns on ScheduleComparisonState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ScheduleComparisonState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ScheduleComparisonState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ScheduleComparisonState value)  $default,){
final _that = this;
switch (_that) {
case _ScheduleComparisonState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ScheduleComparisonState value)?  $default,){
final _that = this;
switch (_that) {
case _ScheduleComparisonState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( Set<SelectedSchedule> schedules,  bool isEnabled)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ScheduleComparisonState() when $default != null:
return $default(_that.schedules,_that.isEnabled);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( Set<SelectedSchedule> schedules,  bool isEnabled)  $default,) {final _that = this;
switch (_that) {
case _ScheduleComparisonState():
return $default(_that.schedules,_that.isEnabled);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( Set<SelectedSchedule> schedules,  bool isEnabled)?  $default,) {final _that = this;
switch (_that) {
case _ScheduleComparisonState() when $default != null:
return $default(_that.schedules,_that.isEnabled);case _:
  return null;

}
}

}

/// @nodoc


class _ScheduleComparisonState implements ScheduleComparisonState {
  const _ScheduleComparisonState({final  Set<SelectedSchedule> schedules = const <SelectedSchedule>{}, this.isEnabled = false}): _schedules = schedules;


 final  Set<SelectedSchedule> _schedules;
@override@JsonKey() Set<SelectedSchedule> get schedules {
  if (_schedules is EqualUnmodifiableSetView) return _schedules;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableSetView(_schedules);
}

@override@JsonKey() final  bool isEnabled;

/// Create a copy of ScheduleComparisonState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ScheduleComparisonStateCopyWith<_ScheduleComparisonState> get copyWith => __$ScheduleComparisonStateCopyWithImpl<_ScheduleComparisonState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ScheduleComparisonState&&const DeepCollectionEquality().equals(other._schedules, _schedules)&&(identical(other.isEnabled, isEnabled) || other.isEnabled == isEnabled));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_schedules),isEnabled);

@override
String toString() {
  return 'ScheduleComparisonState(schedules: $schedules, isEnabled: $isEnabled)';
}


}

/// @nodoc
abstract mixin class _$ScheduleComparisonStateCopyWith<$Res> implements $ScheduleComparisonStateCopyWith<$Res> {
  factory _$ScheduleComparisonStateCopyWith(_ScheduleComparisonState value, $Res Function(_ScheduleComparisonState) _then) = __$ScheduleComparisonStateCopyWithImpl;
@override @useResult
$Res call({
 Set<SelectedSchedule> schedules, bool isEnabled
});




}
/// @nodoc
class __$ScheduleComparisonStateCopyWithImpl<$Res>
    implements _$ScheduleComparisonStateCopyWith<$Res> {
  __$ScheduleComparisonStateCopyWithImpl(this._self, this._then);

  final _ScheduleComparisonState _self;
  final $Res Function(_ScheduleComparisonState) _then;

/// Create a copy of ScheduleComparisonState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? schedules = null,Object? isEnabled = null,}) {
  return _then(_ScheduleComparisonState(
schedules: null == schedules ? _self._schedules : schedules // ignore: cast_nullable_to_non_nullable
as Set<SelectedSchedule>,isEnabled: null == isEnabled ? _self.isEnabled : isEnabled // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
