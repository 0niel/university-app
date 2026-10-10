// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'teacher_lesson_occurrence.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$TeacherLessonOccurrence {

 LessonSchedulePart get lesson; DateTime get date; DateTime get start; DateTime get end; List<Group> get groups; bool get isCancelled;
/// Create a copy of TeacherLessonOccurrence
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TeacherLessonOccurrenceCopyWith<TeacherLessonOccurrence> get copyWith => _$TeacherLessonOccurrenceCopyWithImpl<TeacherLessonOccurrence>(this as TeacherLessonOccurrence, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TeacherLessonOccurrence&&(identical(other.lesson, lesson) || other.lesson == lesson)&&(identical(other.date, date) || other.date == date)&&(identical(other.start, start) || other.start == start)&&(identical(other.end, end) || other.end == end)&&const DeepCollectionEquality().equals(other.groups, groups)&&(identical(other.isCancelled, isCancelled) || other.isCancelled == isCancelled));
}


@override
int get hashCode => Object.hash(runtimeType,lesson,date,start,end,const DeepCollectionEquality().hash(groups),isCancelled);

@override
String toString() {
  return 'TeacherLessonOccurrence(lesson: $lesson, date: $date, start: $start, end: $end, groups: $groups, isCancelled: $isCancelled)';
}


}

/// @nodoc
abstract mixin class $TeacherLessonOccurrenceCopyWith<$Res>  {
  factory $TeacherLessonOccurrenceCopyWith(TeacherLessonOccurrence value, $Res Function(TeacherLessonOccurrence) _then) = _$TeacherLessonOccurrenceCopyWithImpl;
@useResult
$Res call({
 LessonSchedulePart lesson, DateTime date, DateTime start, DateTime end, List<Group> groups, bool isCancelled
});


$LessonSchedulePartCopyWith<$Res> get lesson;

}
/// @nodoc
class _$TeacherLessonOccurrenceCopyWithImpl<$Res>
    implements $TeacherLessonOccurrenceCopyWith<$Res> {
  _$TeacherLessonOccurrenceCopyWithImpl(this._self, this._then);

  final TeacherLessonOccurrence _self;
  final $Res Function(TeacherLessonOccurrence) _then;

/// Create a copy of TeacherLessonOccurrence
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? lesson = null,Object? date = null,Object? start = null,Object? end = null,Object? groups = null,Object? isCancelled = null,}) {
  return _then(_self.copyWith(
lesson: null == lesson ? _self.lesson : lesson // ignore: cast_nullable_to_non_nullable
as LessonSchedulePart,date: null == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as DateTime,start: null == start ? _self.start : start // ignore: cast_nullable_to_non_nullable
as DateTime,end: null == end ? _self.end : end // ignore: cast_nullable_to_non_nullable
as DateTime,groups: null == groups ? _self.groups : groups // ignore: cast_nullable_to_non_nullable
as List<Group>,isCancelled: null == isCancelled ? _self.isCancelled : isCancelled // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}
/// Create a copy of TeacherLessonOccurrence
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$LessonSchedulePartCopyWith<$Res> get lesson {

  return $LessonSchedulePartCopyWith<$Res>(_self.lesson, (value) {
    return _then(_self.copyWith(lesson: value));
  });
}
}


/// Adds pattern-matching-related methods to [TeacherLessonOccurrence].
extension TeacherLessonOccurrencePatterns on TeacherLessonOccurrence {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TeacherLessonOccurrence value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TeacherLessonOccurrence() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TeacherLessonOccurrence value)  $default,){
final _that = this;
switch (_that) {
case _TeacherLessonOccurrence():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TeacherLessonOccurrence value)?  $default,){
final _that = this;
switch (_that) {
case _TeacherLessonOccurrence() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( LessonSchedulePart lesson,  DateTime date,  DateTime start,  DateTime end,  List<Group> groups,  bool isCancelled)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _TeacherLessonOccurrence() when $default != null:
return $default(_that.lesson,_that.date,_that.start,_that.end,_that.groups,_that.isCancelled);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( LessonSchedulePart lesson,  DateTime date,  DateTime start,  DateTime end,  List<Group> groups,  bool isCancelled)  $default,) {final _that = this;
switch (_that) {
case _TeacherLessonOccurrence():
return $default(_that.lesson,_that.date,_that.start,_that.end,_that.groups,_that.isCancelled);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( LessonSchedulePart lesson,  DateTime date,  DateTime start,  DateTime end,  List<Group> groups,  bool isCancelled)?  $default,) {final _that = this;
switch (_that) {
case _TeacherLessonOccurrence() when $default != null:
return $default(_that.lesson,_that.date,_that.start,_that.end,_that.groups,_that.isCancelled);case _:
  return null;

}
}

}

/// @nodoc


class _TeacherLessonOccurrence extends TeacherLessonOccurrence {
  const _TeacherLessonOccurrence({required this.lesson, required this.date, required this.start, required this.end, required final  List<Group> groups, this.isCancelled = false}): _groups = groups,super._();


@override final  LessonSchedulePart lesson;
@override final  DateTime date;
@override final  DateTime start;
@override final  DateTime end;
 final  List<Group> _groups;
@override List<Group> get groups {
  if (_groups is EqualUnmodifiableListView) return _groups;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_groups);
}

@override@JsonKey() final  bool isCancelled;

/// Create a copy of TeacherLessonOccurrence
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TeacherLessonOccurrenceCopyWith<_TeacherLessonOccurrence> get copyWith => __$TeacherLessonOccurrenceCopyWithImpl<_TeacherLessonOccurrence>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _TeacherLessonOccurrence&&(identical(other.lesson, lesson) || other.lesson == lesson)&&(identical(other.date, date) || other.date == date)&&(identical(other.start, start) || other.start == start)&&(identical(other.end, end) || other.end == end)&&const DeepCollectionEquality().equals(other._groups, _groups)&&(identical(other.isCancelled, isCancelled) || other.isCancelled == isCancelled));
}


@override
int get hashCode => Object.hash(runtimeType,lesson,date,start,end,const DeepCollectionEquality().hash(_groups),isCancelled);

@override
String toString() {
  return 'TeacherLessonOccurrence(lesson: $lesson, date: $date, start: $start, end: $end, groups: $groups, isCancelled: $isCancelled)';
}


}

/// @nodoc
abstract mixin class _$TeacherLessonOccurrenceCopyWith<$Res> implements $TeacherLessonOccurrenceCopyWith<$Res> {
  factory _$TeacherLessonOccurrenceCopyWith(_TeacherLessonOccurrence value, $Res Function(_TeacherLessonOccurrence) _then) = __$TeacherLessonOccurrenceCopyWithImpl;
@override @useResult
$Res call({
 LessonSchedulePart lesson, DateTime date, DateTime start, DateTime end, List<Group> groups, bool isCancelled
});


@override $LessonSchedulePartCopyWith<$Res> get lesson;

}
/// @nodoc
class __$TeacherLessonOccurrenceCopyWithImpl<$Res>
    implements _$TeacherLessonOccurrenceCopyWith<$Res> {
  __$TeacherLessonOccurrenceCopyWithImpl(this._self, this._then);

  final _TeacherLessonOccurrence _self;
  final $Res Function(_TeacherLessonOccurrence) _then;

/// Create a copy of TeacherLessonOccurrence
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? lesson = null,Object? date = null,Object? start = null,Object? end = null,Object? groups = null,Object? isCancelled = null,}) {
  return _then(_TeacherLessonOccurrence(
lesson: null == lesson ? _self.lesson : lesson // ignore: cast_nullable_to_non_nullable
as LessonSchedulePart,date: null == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as DateTime,start: null == start ? _self.start : start // ignore: cast_nullable_to_non_nullable
as DateTime,end: null == end ? _self.end : end // ignore: cast_nullable_to_non_nullable
as DateTime,groups: null == groups ? _self._groups : groups // ignore: cast_nullable_to_non_nullable
as List<Group>,isCancelled: null == isCancelled ? _self.isCancelled : isCancelled // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

/// Create a copy of TeacherLessonOccurrence
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$LessonSchedulePartCopyWith<$Res> get lesson {

  return $LessonSchedulePartCopyWith<$Res>(_self.lesson, (value) {
    return _then(_self.copyWith(lesson: value));
  });
}
}

// dart format on
