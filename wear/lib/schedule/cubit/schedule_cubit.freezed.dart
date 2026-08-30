// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'schedule_cubit.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$ScheduleState implements DiagnosticableTreeMixin {

 String? get scheduleName; List<SchedulePart>? get scheduleParts; ScheduleStatus get status; int get currentDayIndex; bool get isPaired; bool get isReachable;
/// Create a copy of ScheduleState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ScheduleStateCopyWith<ScheduleState> get copyWith => _$ScheduleStateCopyWithImpl<ScheduleState>(this as ScheduleState, _$identity);


@override
void debugFillProperties(DiagnosticPropertiesBuilder properties) {
  properties
    ..add(DiagnosticsProperty('type', 'ScheduleState'))
    ..add(DiagnosticsProperty('scheduleName', scheduleName))..add(DiagnosticsProperty('scheduleParts', scheduleParts))..add(DiagnosticsProperty('status', status))..add(DiagnosticsProperty('currentDayIndex', currentDayIndex))..add(DiagnosticsProperty('isPaired', isPaired))..add(DiagnosticsProperty('isReachable', isReachable));
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ScheduleState&&(identical(other.scheduleName, scheduleName) || other.scheduleName == scheduleName)&&const DeepCollectionEquality().equals(other.scheduleParts, scheduleParts)&&(identical(other.status, status) || other.status == status)&&(identical(other.currentDayIndex, currentDayIndex) || other.currentDayIndex == currentDayIndex)&&(identical(other.isPaired, isPaired) || other.isPaired == isPaired)&&(identical(other.isReachable, isReachable) || other.isReachable == isReachable));
}


@override
int get hashCode => Object.hash(runtimeType,scheduleName,const DeepCollectionEquality().hash(scheduleParts),status,currentDayIndex,isPaired,isReachable);

@override
String toString({ DiagnosticLevel minLevel = DiagnosticLevel.info }) {
  return 'ScheduleState(scheduleName: $scheduleName, scheduleParts: $scheduleParts, status: $status, currentDayIndex: $currentDayIndex, isPaired: $isPaired, isReachable: $isReachable)';
}


}

/// @nodoc
abstract mixin class $ScheduleStateCopyWith<$Res>  {
  factory $ScheduleStateCopyWith(ScheduleState value, $Res Function(ScheduleState) _then) = _$ScheduleStateCopyWithImpl;
@useResult
$Res call({
 String? scheduleName, List<SchedulePart>? scheduleParts, ScheduleStatus status, int currentDayIndex, bool isPaired, bool isReachable
});




}
/// @nodoc
class _$ScheduleStateCopyWithImpl<$Res>
    implements $ScheduleStateCopyWith<$Res> {
  _$ScheduleStateCopyWithImpl(this._self, this._then);

  final ScheduleState _self;
  final $Res Function(ScheduleState) _then;

/// Create a copy of ScheduleState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? scheduleName = freezed,Object? scheduleParts = freezed,Object? status = null,Object? currentDayIndex = null,Object? isPaired = null,Object? isReachable = null,}) {
  return _then(_self.copyWith(
scheduleName: freezed == scheduleName ? _self.scheduleName : scheduleName // ignore: cast_nullable_to_non_nullable
as String?,scheduleParts: freezed == scheduleParts ? _self.scheduleParts : scheduleParts // ignore: cast_nullable_to_non_nullable
as List<SchedulePart>?,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as ScheduleStatus,currentDayIndex: null == currentDayIndex ? _self.currentDayIndex : currentDayIndex // ignore: cast_nullable_to_non_nullable
as int,isPaired: null == isPaired ? _self.isPaired : isPaired // ignore: cast_nullable_to_non_nullable
as bool,isReachable: null == isReachable ? _self.isReachable : isReachable // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [ScheduleState].
extension ScheduleStatePatterns on ScheduleState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ScheduleState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ScheduleState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ScheduleState value)  $default,){
final _that = this;
switch (_that) {
case _ScheduleState():
return $default(_that);}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ScheduleState value)?  $default,){
final _that = this;
switch (_that) {
case _ScheduleState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String? scheduleName,  List<SchedulePart>? scheduleParts,  ScheduleStatus status,  int currentDayIndex,  bool isPaired,  bool isReachable)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ScheduleState() when $default != null:
return $default(_that.scheduleName,_that.scheduleParts,_that.status,_that.currentDayIndex,_that.isPaired,_that.isReachable);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String? scheduleName,  List<SchedulePart>? scheduleParts,  ScheduleStatus status,  int currentDayIndex,  bool isPaired,  bool isReachable)  $default,) {final _that = this;
switch (_that) {
case _ScheduleState():
return $default(_that.scheduleName,_that.scheduleParts,_that.status,_that.currentDayIndex,_that.isPaired,_that.isReachable);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String? scheduleName,  List<SchedulePart>? scheduleParts,  ScheduleStatus status,  int currentDayIndex,  bool isPaired,  bool isReachable)?  $default,) {final _that = this;
switch (_that) {
case _ScheduleState() when $default != null:
return $default(_that.scheduleName,_that.scheduleParts,_that.status,_that.currentDayIndex,_that.isPaired,_that.isReachable);case _:
  return null;

}
}

}

/// @nodoc


class _ScheduleState extends ScheduleState with DiagnosticableTreeMixin {
  const _ScheduleState({this.scheduleName, final  List<SchedulePart>? scheduleParts, this.status = ScheduleStatus.initial, this.currentDayIndex = 0, this.isPaired = false, this.isReachable = false}): _scheduleParts = scheduleParts,super._();


@override final  String? scheduleName;
 final  List<SchedulePart>? _scheduleParts;
@override List<SchedulePart>? get scheduleParts {
  final value = _scheduleParts;
  if (value == null) return null;
  if (_scheduleParts is EqualUnmodifiableListView) return _scheduleParts;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(value);
}

@override@JsonKey() final  ScheduleStatus status;
@override@JsonKey() final  int currentDayIndex;
@override@JsonKey() final  bool isPaired;
@override@JsonKey() final  bool isReachable;

/// Create a copy of ScheduleState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ScheduleStateCopyWith<_ScheduleState> get copyWith => __$ScheduleStateCopyWithImpl<_ScheduleState>(this, _$identity);


@override
void debugFillProperties(DiagnosticPropertiesBuilder properties) {
  properties
    ..add(DiagnosticsProperty('type', 'ScheduleState'))
    ..add(DiagnosticsProperty('scheduleName', scheduleName))..add(DiagnosticsProperty('scheduleParts', scheduleParts))..add(DiagnosticsProperty('status', status))..add(DiagnosticsProperty('currentDayIndex', currentDayIndex))..add(DiagnosticsProperty('isPaired', isPaired))..add(DiagnosticsProperty('isReachable', isReachable));
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ScheduleState&&(identical(other.scheduleName, scheduleName) || other.scheduleName == scheduleName)&&const DeepCollectionEquality().equals(other._scheduleParts, _scheduleParts)&&(identical(other.status, status) || other.status == status)&&(identical(other.currentDayIndex, currentDayIndex) || other.currentDayIndex == currentDayIndex)&&(identical(other.isPaired, isPaired) || other.isPaired == isPaired)&&(identical(other.isReachable, isReachable) || other.isReachable == isReachable));
}


@override
int get hashCode => Object.hash(runtimeType,scheduleName,const DeepCollectionEquality().hash(_scheduleParts),status,currentDayIndex,isPaired,isReachable);

@override
String toString({ DiagnosticLevel minLevel = DiagnosticLevel.info }) {
  return 'ScheduleState(scheduleName: $scheduleName, scheduleParts: $scheduleParts, status: $status, currentDayIndex: $currentDayIndex, isPaired: $isPaired, isReachable: $isReachable)';
}


}

/// @nodoc
abstract mixin class _$ScheduleStateCopyWith<$Res> implements $ScheduleStateCopyWith<$Res> {
  factory _$ScheduleStateCopyWith(_ScheduleState value, $Res Function(_ScheduleState) _then) = __$ScheduleStateCopyWithImpl;
@override @useResult
$Res call({
 String? scheduleName, List<SchedulePart>? scheduleParts, ScheduleStatus status, int currentDayIndex, bool isPaired, bool isReachable
});




}
/// @nodoc
class __$ScheduleStateCopyWithImpl<$Res>
    implements _$ScheduleStateCopyWith<$Res> {
  __$ScheduleStateCopyWithImpl(this._self, this._then);

  final _ScheduleState _self;
  final $Res Function(_ScheduleState) _then;

/// Create a copy of ScheduleState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? scheduleName = freezed,Object? scheduleParts = freezed,Object? status = null,Object? currentDayIndex = null,Object? isPaired = null,Object? isReachable = null,}) {
  return _then(_ScheduleState(
scheduleName: freezed == scheduleName ? _self.scheduleName : scheduleName // ignore: cast_nullable_to_non_nullable
as String?,scheduleParts: freezed == scheduleParts ? _self._scheduleParts : scheduleParts // ignore: cast_nullable_to_non_nullable
as List<SchedulePart>?,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as ScheduleStatus,currentDayIndex: null == currentDayIndex ? _self.currentDayIndex : currentDayIndex // ignore: cast_nullable_to_non_nullable
as int,isPaired: null == isPaired ? _self.isPaired : isPaired // ignore: cast_nullable_to_non_nullable
as bool,isReachable: null == isReachable ? _self.isReachable : isReachable // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
