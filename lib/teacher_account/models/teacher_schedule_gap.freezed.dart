// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'teacher_schedule_gap.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$TeacherScheduleGap {

 DateTime get date; DateTime get start; DateTime get end;
/// Create a copy of TeacherScheduleGap
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TeacherScheduleGapCopyWith<TeacherScheduleGap> get copyWith => _$TeacherScheduleGapCopyWithImpl<TeacherScheduleGap>(this as TeacherScheduleGap, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TeacherScheduleGap&&(identical(other.date, date) || other.date == date)&&(identical(other.start, start) || other.start == start)&&(identical(other.end, end) || other.end == end));
}


@override
int get hashCode => Object.hash(runtimeType,date,start,end);

@override
String toString() {
  return 'TeacherScheduleGap(date: $date, start: $start, end: $end)';
}


}

/// @nodoc
abstract mixin class $TeacherScheduleGapCopyWith<$Res>  {
  factory $TeacherScheduleGapCopyWith(TeacherScheduleGap value, $Res Function(TeacherScheduleGap) _then) = _$TeacherScheduleGapCopyWithImpl;
@useResult
$Res call({
 DateTime date, DateTime start, DateTime end
});




}
/// @nodoc
class _$TeacherScheduleGapCopyWithImpl<$Res>
    implements $TeacherScheduleGapCopyWith<$Res> {
  _$TeacherScheduleGapCopyWithImpl(this._self, this._then);

  final TeacherScheduleGap _self;
  final $Res Function(TeacherScheduleGap) _then;

/// Create a copy of TeacherScheduleGap
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? date = null,Object? start = null,Object? end = null,}) {
  return _then(_self.copyWith(
date: null == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as DateTime,start: null == start ? _self.start : start // ignore: cast_nullable_to_non_nullable
as DateTime,end: null == end ? _self.end : end // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [TeacherScheduleGap].
extension TeacherScheduleGapPatterns on TeacherScheduleGap {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TeacherScheduleGap value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TeacherScheduleGap() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TeacherScheduleGap value)  $default,){
final _that = this;
switch (_that) {
case _TeacherScheduleGap():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TeacherScheduleGap value)?  $default,){
final _that = this;
switch (_that) {
case _TeacherScheduleGap() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( DateTime date,  DateTime start,  DateTime end)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _TeacherScheduleGap() when $default != null:
return $default(_that.date,_that.start,_that.end);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( DateTime date,  DateTime start,  DateTime end)  $default,) {final _that = this;
switch (_that) {
case _TeacherScheduleGap():
return $default(_that.date,_that.start,_that.end);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( DateTime date,  DateTime start,  DateTime end)?  $default,) {final _that = this;
switch (_that) {
case _TeacherScheduleGap() when $default != null:
return $default(_that.date,_that.start,_that.end);case _:
  return null;

}
}

}

/// @nodoc


class _TeacherScheduleGap extends TeacherScheduleGap {
  const _TeacherScheduleGap({required this.date, required this.start, required this.end}): super._();


@override final  DateTime date;
@override final  DateTime start;
@override final  DateTime end;

/// Create a copy of TeacherScheduleGap
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TeacherScheduleGapCopyWith<_TeacherScheduleGap> get copyWith => __$TeacherScheduleGapCopyWithImpl<_TeacherScheduleGap>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _TeacherScheduleGap&&(identical(other.date, date) || other.date == date)&&(identical(other.start, start) || other.start == start)&&(identical(other.end, end) || other.end == end));
}


@override
int get hashCode => Object.hash(runtimeType,date,start,end);

@override
String toString() {
  return 'TeacherScheduleGap(date: $date, start: $start, end: $end)';
}


}

/// @nodoc
abstract mixin class _$TeacherScheduleGapCopyWith<$Res> implements $TeacherScheduleGapCopyWith<$Res> {
  factory _$TeacherScheduleGapCopyWith(_TeacherScheduleGap value, $Res Function(_TeacherScheduleGap) _then) = __$TeacherScheduleGapCopyWithImpl;
@override @useResult
$Res call({
 DateTime date, DateTime start, DateTime end
});




}
/// @nodoc
class __$TeacherScheduleGapCopyWithImpl<$Res>
    implements _$TeacherScheduleGapCopyWith<$Res> {
  __$TeacherScheduleGapCopyWithImpl(this._self, this._then);

  final _TeacherScheduleGap _self;
  final $Res Function(_TeacherScheduleGap) _then;

/// Create a copy of TeacherScheduleGap
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? date = null,Object? start = null,Object? end = null,}) {
  return _then(_TeacherScheduleGap(
date: null == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as DateTime,start: null == start ? _self.start : start // ignore: cast_nullable_to_non_nullable
as DateTime,end: null == end ? _self.end : end // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}

// dart format on
