// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'teacher_schedule_query.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$TeacherScheduleQuery {

 Teacher get teacher; DateTime get week;
/// Create a copy of TeacherScheduleQuery
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TeacherScheduleQueryCopyWith<TeacherScheduleQuery> get copyWith => _$TeacherScheduleQueryCopyWithImpl<TeacherScheduleQuery>(this as TeacherScheduleQuery, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TeacherScheduleQuery&&(identical(other.teacher, teacher) || other.teacher == teacher)&&(identical(other.week, week) || other.week == week));
}


@override
int get hashCode => Object.hash(runtimeType,teacher,week);

@override
String toString() {
  return 'TeacherScheduleQuery(teacher: $teacher, week: $week)';
}


}

/// @nodoc
abstract mixin class $TeacherScheduleQueryCopyWith<$Res>  {
  factory $TeacherScheduleQueryCopyWith(TeacherScheduleQuery value, $Res Function(TeacherScheduleQuery) _then) = _$TeacherScheduleQueryCopyWithImpl;
@useResult
$Res call({
 Teacher teacher, DateTime week
});


$TeacherCopyWith<$Res> get teacher;

}
/// @nodoc
class _$TeacherScheduleQueryCopyWithImpl<$Res>
    implements $TeacherScheduleQueryCopyWith<$Res> {
  _$TeacherScheduleQueryCopyWithImpl(this._self, this._then);

  final TeacherScheduleQuery _self;
  final $Res Function(TeacherScheduleQuery) _then;

/// Create a copy of TeacherScheduleQuery
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? teacher = null,Object? week = null,}) {
  return _then(_self.copyWith(
teacher: null == teacher ? _self.teacher : teacher // ignore: cast_nullable_to_non_nullable
as Teacher,week: null == week ? _self.week : week // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}
/// Create a copy of TeacherScheduleQuery
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$TeacherCopyWith<$Res> get teacher {

  return $TeacherCopyWith<$Res>(_self.teacher, (value) {
    return _then(_self.copyWith(teacher: value));
  });
}
}


/// Adds pattern-matching-related methods to [TeacherScheduleQuery].
extension TeacherScheduleQueryPatterns on TeacherScheduleQuery {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TeacherScheduleQuery value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TeacherScheduleQuery() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TeacherScheduleQuery value)  $default,){
final _that = this;
switch (_that) {
case _TeacherScheduleQuery():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TeacherScheduleQuery value)?  $default,){
final _that = this;
switch (_that) {
case _TeacherScheduleQuery() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( Teacher teacher,  DateTime week)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _TeacherScheduleQuery() when $default != null:
return $default(_that.teacher,_that.week);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( Teacher teacher,  DateTime week)  $default,) {final _that = this;
switch (_that) {
case _TeacherScheduleQuery():
return $default(_that.teacher,_that.week);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( Teacher teacher,  DateTime week)?  $default,) {final _that = this;
switch (_that) {
case _TeacherScheduleQuery() when $default != null:
return $default(_that.teacher,_that.week);case _:
  return null;

}
}

}

/// @nodoc


class _TeacherScheduleQuery extends TeacherScheduleQuery {
  const _TeacherScheduleQuery({required this.teacher, required this.week}): super._();


@override final  Teacher teacher;
@override final  DateTime week;

/// Create a copy of TeacherScheduleQuery
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TeacherScheduleQueryCopyWith<_TeacherScheduleQuery> get copyWith => __$TeacherScheduleQueryCopyWithImpl<_TeacherScheduleQuery>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _TeacherScheduleQuery&&(identical(other.teacher, teacher) || other.teacher == teacher)&&(identical(other.week, week) || other.week == week));
}


@override
int get hashCode => Object.hash(runtimeType,teacher,week);

@override
String toString() {
  return 'TeacherScheduleQuery(teacher: $teacher, week: $week)';
}


}

/// @nodoc
abstract mixin class _$TeacherScheduleQueryCopyWith<$Res> implements $TeacherScheduleQueryCopyWith<$Res> {
  factory _$TeacherScheduleQueryCopyWith(_TeacherScheduleQuery value, $Res Function(_TeacherScheduleQuery) _then) = __$TeacherScheduleQueryCopyWithImpl;
@override @useResult
$Res call({
 Teacher teacher, DateTime week
});


@override $TeacherCopyWith<$Res> get teacher;

}
/// @nodoc
class __$TeacherScheduleQueryCopyWithImpl<$Res>
    implements _$TeacherScheduleQueryCopyWith<$Res> {
  __$TeacherScheduleQueryCopyWithImpl(this._self, this._then);

  final _TeacherScheduleQuery _self;
  final $Res Function(_TeacherScheduleQuery) _then;

/// Create a copy of TeacherScheduleQuery
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? teacher = null,Object? week = null,}) {
  return _then(_TeacherScheduleQuery(
teacher: null == teacher ? _self.teacher : teacher // ignore: cast_nullable_to_non_nullable
as Teacher,week: null == week ? _self.week : week // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

/// Create a copy of TeacherScheduleQuery
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$TeacherCopyWith<$Res> get teacher {

  return $TeacherCopyWith<$Res>(_self.teacher, (value) {
    return _then(_self.copyWith(teacher: value));
  });
}
}

// dart format on
