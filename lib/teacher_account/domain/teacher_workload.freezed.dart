// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'teacher_workload.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$TeacherWorkload {

 DateTime get weekStart; List<TeacherLessonOccurrence> get occurrences; Duration get totalDuration; List<Group> get groups; List<String> get subjects; List<Classroom> get classrooms; List<TeacherScheduleGap> get gaps;
/// Create a copy of TeacherWorkload
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TeacherWorkloadCopyWith<TeacherWorkload> get copyWith => _$TeacherWorkloadCopyWithImpl<TeacherWorkload>(this as TeacherWorkload, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TeacherWorkload&&(identical(other.weekStart, weekStart) || other.weekStart == weekStart)&&const DeepCollectionEquality().equals(other.occurrences, occurrences)&&(identical(other.totalDuration, totalDuration) || other.totalDuration == totalDuration)&&const DeepCollectionEquality().equals(other.groups, groups)&&const DeepCollectionEquality().equals(other.subjects, subjects)&&const DeepCollectionEquality().equals(other.classrooms, classrooms)&&const DeepCollectionEquality().equals(other.gaps, gaps));
}


@override
int get hashCode => Object.hash(runtimeType,weekStart,const DeepCollectionEquality().hash(occurrences),totalDuration,const DeepCollectionEquality().hash(groups),const DeepCollectionEquality().hash(subjects),const DeepCollectionEquality().hash(classrooms),const DeepCollectionEquality().hash(gaps));

@override
String toString() {
  return 'TeacherWorkload(weekStart: $weekStart, occurrences: $occurrences, totalDuration: $totalDuration, groups: $groups, subjects: $subjects, classrooms: $classrooms, gaps: $gaps)';
}


}

/// @nodoc
abstract mixin class $TeacherWorkloadCopyWith<$Res>  {
  factory $TeacherWorkloadCopyWith(TeacherWorkload value, $Res Function(TeacherWorkload) _then) = _$TeacherWorkloadCopyWithImpl;
@useResult
$Res call({
 DateTime weekStart, List<TeacherLessonOccurrence> occurrences, Duration totalDuration, List<Group> groups, List<String> subjects, List<Classroom> classrooms, List<TeacherScheduleGap> gaps
});




}
/// @nodoc
class _$TeacherWorkloadCopyWithImpl<$Res>
    implements $TeacherWorkloadCopyWith<$Res> {
  _$TeacherWorkloadCopyWithImpl(this._self, this._then);

  final TeacherWorkload _self;
  final $Res Function(TeacherWorkload) _then;

/// Create a copy of TeacherWorkload
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? weekStart = null,Object? occurrences = null,Object? totalDuration = null,Object? groups = null,Object? subjects = null,Object? classrooms = null,Object? gaps = null,}) {
  return _then(_self.copyWith(
weekStart: null == weekStart ? _self.weekStart : weekStart // ignore: cast_nullable_to_non_nullable
as DateTime,occurrences: null == occurrences ? _self.occurrences : occurrences // ignore: cast_nullable_to_non_nullable
as List<TeacherLessonOccurrence>,totalDuration: null == totalDuration ? _self.totalDuration : totalDuration // ignore: cast_nullable_to_non_nullable
as Duration,groups: null == groups ? _self.groups : groups // ignore: cast_nullable_to_non_nullable
as List<Group>,subjects: null == subjects ? _self.subjects : subjects // ignore: cast_nullable_to_non_nullable
as List<String>,classrooms: null == classrooms ? _self.classrooms : classrooms // ignore: cast_nullable_to_non_nullable
as List<Classroom>,gaps: null == gaps ? _self.gaps : gaps // ignore: cast_nullable_to_non_nullable
as List<TeacherScheduleGap>,
  ));
}

}


/// Adds pattern-matching-related methods to [TeacherWorkload].
extension TeacherWorkloadPatterns on TeacherWorkload {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TeacherWorkload value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TeacherWorkload() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TeacherWorkload value)  $default,){
final _that = this;
switch (_that) {
case _TeacherWorkload():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TeacherWorkload value)?  $default,){
final _that = this;
switch (_that) {
case _TeacherWorkload() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( DateTime weekStart,  List<TeacherLessonOccurrence> occurrences,  Duration totalDuration,  List<Group> groups,  List<String> subjects,  List<Classroom> classrooms,  List<TeacherScheduleGap> gaps)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _TeacherWorkload() when $default != null:
return $default(_that.weekStart,_that.occurrences,_that.totalDuration,_that.groups,_that.subjects,_that.classrooms,_that.gaps);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( DateTime weekStart,  List<TeacherLessonOccurrence> occurrences,  Duration totalDuration,  List<Group> groups,  List<String> subjects,  List<Classroom> classrooms,  List<TeacherScheduleGap> gaps)  $default,) {final _that = this;
switch (_that) {
case _TeacherWorkload():
return $default(_that.weekStart,_that.occurrences,_that.totalDuration,_that.groups,_that.subjects,_that.classrooms,_that.gaps);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( DateTime weekStart,  List<TeacherLessonOccurrence> occurrences,  Duration totalDuration,  List<Group> groups,  List<String> subjects,  List<Classroom> classrooms,  List<TeacherScheduleGap> gaps)?  $default,) {final _that = this;
switch (_that) {
case _TeacherWorkload() when $default != null:
return $default(_that.weekStart,_that.occurrences,_that.totalDuration,_that.groups,_that.subjects,_that.classrooms,_that.gaps);case _:
  return null;

}
}

}

/// @nodoc


class _TeacherWorkload extends TeacherWorkload {
  const _TeacherWorkload({required this.weekStart, required final  List<TeacherLessonOccurrence> occurrences, required this.totalDuration, required final  List<Group> groups, required final  List<String> subjects, required final  List<Classroom> classrooms, required final  List<TeacherScheduleGap> gaps}): _occurrences = occurrences,_groups = groups,_subjects = subjects,_classrooms = classrooms,_gaps = gaps,super._();


@override final  DateTime weekStart;
 final  List<TeacherLessonOccurrence> _occurrences;
@override List<TeacherLessonOccurrence> get occurrences {
  if (_occurrences is EqualUnmodifiableListView) return _occurrences;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_occurrences);
}

@override final  Duration totalDuration;
 final  List<Group> _groups;
@override List<Group> get groups {
  if (_groups is EqualUnmodifiableListView) return _groups;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_groups);
}

 final  List<String> _subjects;
@override List<String> get subjects {
  if (_subjects is EqualUnmodifiableListView) return _subjects;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_subjects);
}

 final  List<Classroom> _classrooms;
@override List<Classroom> get classrooms {
  if (_classrooms is EqualUnmodifiableListView) return _classrooms;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_classrooms);
}

 final  List<TeacherScheduleGap> _gaps;
@override List<TeacherScheduleGap> get gaps {
  if (_gaps is EqualUnmodifiableListView) return _gaps;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_gaps);
}


/// Create a copy of TeacherWorkload
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TeacherWorkloadCopyWith<_TeacherWorkload> get copyWith => __$TeacherWorkloadCopyWithImpl<_TeacherWorkload>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _TeacherWorkload&&(identical(other.weekStart, weekStart) || other.weekStart == weekStart)&&const DeepCollectionEquality().equals(other._occurrences, _occurrences)&&(identical(other.totalDuration, totalDuration) || other.totalDuration == totalDuration)&&const DeepCollectionEquality().equals(other._groups, _groups)&&const DeepCollectionEquality().equals(other._subjects, _subjects)&&const DeepCollectionEquality().equals(other._classrooms, _classrooms)&&const DeepCollectionEquality().equals(other._gaps, _gaps));
}


@override
int get hashCode => Object.hash(runtimeType,weekStart,const DeepCollectionEquality().hash(_occurrences),totalDuration,const DeepCollectionEquality().hash(_groups),const DeepCollectionEquality().hash(_subjects),const DeepCollectionEquality().hash(_classrooms),const DeepCollectionEquality().hash(_gaps));

@override
String toString() {
  return 'TeacherWorkload(weekStart: $weekStart, occurrences: $occurrences, totalDuration: $totalDuration, groups: $groups, subjects: $subjects, classrooms: $classrooms, gaps: $gaps)';
}


}

/// @nodoc
abstract mixin class _$TeacherWorkloadCopyWith<$Res> implements $TeacherWorkloadCopyWith<$Res> {
  factory _$TeacherWorkloadCopyWith(_TeacherWorkload value, $Res Function(_TeacherWorkload) _then) = __$TeacherWorkloadCopyWithImpl;
@override @useResult
$Res call({
 DateTime weekStart, List<TeacherLessonOccurrence> occurrences, Duration totalDuration, List<Group> groups, List<String> subjects, List<Classroom> classrooms, List<TeacherScheduleGap> gaps
});




}
/// @nodoc
class __$TeacherWorkloadCopyWithImpl<$Res>
    implements _$TeacherWorkloadCopyWith<$Res> {
  __$TeacherWorkloadCopyWithImpl(this._self, this._then);

  final _TeacherWorkload _self;
  final $Res Function(_TeacherWorkload) _then;

/// Create a copy of TeacherWorkload
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? weekStart = null,Object? occurrences = null,Object? totalDuration = null,Object? groups = null,Object? subjects = null,Object? classrooms = null,Object? gaps = null,}) {
  return _then(_TeacherWorkload(
weekStart: null == weekStart ? _self.weekStart : weekStart // ignore: cast_nullable_to_non_nullable
as DateTime,occurrences: null == occurrences ? _self._occurrences : occurrences // ignore: cast_nullable_to_non_nullable
as List<TeacherLessonOccurrence>,totalDuration: null == totalDuration ? _self.totalDuration : totalDuration // ignore: cast_nullable_to_non_nullable
as Duration,groups: null == groups ? _self._groups : groups // ignore: cast_nullable_to_non_nullable
as List<Group>,subjects: null == subjects ? _self._subjects : subjects // ignore: cast_nullable_to_non_nullable
as List<String>,classrooms: null == classrooms ? _self._classrooms : classrooms // ignore: cast_nullable_to_non_nullable
as List<Classroom>,gaps: null == gaps ? _self._gaps : gaps // ignore: cast_nullable_to_non_nullable
as List<TeacherScheduleGap>,
  ));
}


}

// dart format on
