// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'custom_lesson_editor_cubit.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$CustomLessonEditorState {

 String get subject; LessonType get lessonType; TimeOfDay get startTime; TimeOfDay get endTime; int? get lessonNumber; int get color; int? get reminderMinutes; int get weekday; LessonRepeat get repeat; List<DateTime> get selectedDates; List<Classroom> get selectedClassrooms; List<Teacher> get selectedTeachers;
/// Create a copy of CustomLessonEditorState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CustomLessonEditorStateCopyWith<CustomLessonEditorState> get copyWith => _$CustomLessonEditorStateCopyWithImpl<CustomLessonEditorState>(this as CustomLessonEditorState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CustomLessonEditorState&&(identical(other.subject, subject) || other.subject == subject)&&(identical(other.lessonType, lessonType) || other.lessonType == lessonType)&&(identical(other.startTime, startTime) || other.startTime == startTime)&&(identical(other.endTime, endTime) || other.endTime == endTime)&&(identical(other.lessonNumber, lessonNumber) || other.lessonNumber == lessonNumber)&&(identical(other.color, color) || other.color == color)&&(identical(other.reminderMinutes, reminderMinutes) || other.reminderMinutes == reminderMinutes)&&(identical(other.weekday, weekday) || other.weekday == weekday)&&(identical(other.repeat, repeat) || other.repeat == repeat)&&const DeepCollectionEquality().equals(other.selectedDates, selectedDates)&&const DeepCollectionEquality().equals(other.selectedClassrooms, selectedClassrooms)&&const DeepCollectionEquality().equals(other.selectedTeachers, selectedTeachers));
}


@override
int get hashCode => Object.hash(runtimeType,subject,lessonType,startTime,endTime,lessonNumber,color,reminderMinutes,weekday,repeat,const DeepCollectionEquality().hash(selectedDates),const DeepCollectionEquality().hash(selectedClassrooms),const DeepCollectionEquality().hash(selectedTeachers));

@override
String toString() {
  return 'CustomLessonEditorState(subject: $subject, lessonType: $lessonType, startTime: $startTime, endTime: $endTime, lessonNumber: $lessonNumber, color: $color, reminderMinutes: $reminderMinutes, weekday: $weekday, repeat: $repeat, selectedDates: $selectedDates, selectedClassrooms: $selectedClassrooms, selectedTeachers: $selectedTeachers)';
}


}

/// @nodoc
abstract mixin class $CustomLessonEditorStateCopyWith<$Res>  {
  factory $CustomLessonEditorStateCopyWith(CustomLessonEditorState value, $Res Function(CustomLessonEditorState) _then) = _$CustomLessonEditorStateCopyWithImpl;
@useResult
$Res call({
 String subject, LessonType lessonType, TimeOfDay startTime, TimeOfDay endTime, int? lessonNumber, int color, int? reminderMinutes, int weekday, LessonRepeat repeat, List<DateTime> selectedDates, List<Classroom> selectedClassrooms, List<Teacher> selectedTeachers
});




}
/// @nodoc
class _$CustomLessonEditorStateCopyWithImpl<$Res>
    implements $CustomLessonEditorStateCopyWith<$Res> {
  _$CustomLessonEditorStateCopyWithImpl(this._self, this._then);

  final CustomLessonEditorState _self;
  final $Res Function(CustomLessonEditorState) _then;

/// Create a copy of CustomLessonEditorState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? subject = null,Object? lessonType = null,Object? startTime = null,Object? endTime = null,Object? lessonNumber = freezed,Object? color = null,Object? reminderMinutes = freezed,Object? weekday = null,Object? repeat = null,Object? selectedDates = null,Object? selectedClassrooms = null,Object? selectedTeachers = null,}) {
  return _then(_self.copyWith(
subject: null == subject ? _self.subject : subject // ignore: cast_nullable_to_non_nullable
as String,lessonType: null == lessonType ? _self.lessonType : lessonType // ignore: cast_nullable_to_non_nullable
as LessonType,startTime: null == startTime ? _self.startTime : startTime // ignore: cast_nullable_to_non_nullable
as TimeOfDay,endTime: null == endTime ? _self.endTime : endTime // ignore: cast_nullable_to_non_nullable
as TimeOfDay,lessonNumber: freezed == lessonNumber ? _self.lessonNumber : lessonNumber // ignore: cast_nullable_to_non_nullable
as int?,color: null == color ? _self.color : color // ignore: cast_nullable_to_non_nullable
as int,reminderMinutes: freezed == reminderMinutes ? _self.reminderMinutes : reminderMinutes // ignore: cast_nullable_to_non_nullable
as int?,weekday: null == weekday ? _self.weekday : weekday // ignore: cast_nullable_to_non_nullable
as int,repeat: null == repeat ? _self.repeat : repeat // ignore: cast_nullable_to_non_nullable
as LessonRepeat,selectedDates: null == selectedDates ? _self.selectedDates : selectedDates // ignore: cast_nullable_to_non_nullable
as List<DateTime>,selectedClassrooms: null == selectedClassrooms ? _self.selectedClassrooms : selectedClassrooms // ignore: cast_nullable_to_non_nullable
as List<Classroom>,selectedTeachers: null == selectedTeachers ? _self.selectedTeachers : selectedTeachers // ignore: cast_nullable_to_non_nullable
as List<Teacher>,
  ));
}

}


/// Adds pattern-matching-related methods to [CustomLessonEditorState].
extension CustomLessonEditorStatePatterns on CustomLessonEditorState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CustomLessonEditorState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CustomLessonEditorState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CustomLessonEditorState value)  $default,){
final _that = this;
switch (_that) {
case _CustomLessonEditorState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CustomLessonEditorState value)?  $default,){
final _that = this;
switch (_that) {
case _CustomLessonEditorState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String subject,  LessonType lessonType,  TimeOfDay startTime,  TimeOfDay endTime,  int? lessonNumber,  int color,  int? reminderMinutes,  int weekday,  LessonRepeat repeat,  List<DateTime> selectedDates,  List<Classroom> selectedClassrooms,  List<Teacher> selectedTeachers)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CustomLessonEditorState() when $default != null:
return $default(_that.subject,_that.lessonType,_that.startTime,_that.endTime,_that.lessonNumber,_that.color,_that.reminderMinutes,_that.weekday,_that.repeat,_that.selectedDates,_that.selectedClassrooms,_that.selectedTeachers);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String subject,  LessonType lessonType,  TimeOfDay startTime,  TimeOfDay endTime,  int? lessonNumber,  int color,  int? reminderMinutes,  int weekday,  LessonRepeat repeat,  List<DateTime> selectedDates,  List<Classroom> selectedClassrooms,  List<Teacher> selectedTeachers)  $default,) {final _that = this;
switch (_that) {
case _CustomLessonEditorState():
return $default(_that.subject,_that.lessonType,_that.startTime,_that.endTime,_that.lessonNumber,_that.color,_that.reminderMinutes,_that.weekday,_that.repeat,_that.selectedDates,_that.selectedClassrooms,_that.selectedTeachers);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String subject,  LessonType lessonType,  TimeOfDay startTime,  TimeOfDay endTime,  int? lessonNumber,  int color,  int? reminderMinutes,  int weekday,  LessonRepeat repeat,  List<DateTime> selectedDates,  List<Classroom> selectedClassrooms,  List<Teacher> selectedTeachers)?  $default,) {final _that = this;
switch (_that) {
case _CustomLessonEditorState() when $default != null:
return $default(_that.subject,_that.lessonType,_that.startTime,_that.endTime,_that.lessonNumber,_that.color,_that.reminderMinutes,_that.weekday,_that.repeat,_that.selectedDates,_that.selectedClassrooms,_that.selectedTeachers);case _:
  return null;

}
}

}

/// @nodoc


class _CustomLessonEditorState implements CustomLessonEditorState {
  const _CustomLessonEditorState({this.subject = '', this.lessonType = LessonType.lecture, this.startTime = const TimeOfDay(hour: 10, minute: 40), this.endTime = const TimeOfDay(hour: 12, minute: 10), this.lessonNumber = 1, this.color = 0xFF2F7AFF, this.reminderMinutes, this.weekday = 1, this.repeat = LessonRepeat.everyWeek, final  List<DateTime> selectedDates = const <DateTime>[], final  List<Classroom> selectedClassrooms = const <Classroom>[], final  List<Teacher> selectedTeachers = const <Teacher>[]}): _selectedDates = selectedDates,_selectedClassrooms = selectedClassrooms,_selectedTeachers = selectedTeachers;


@override@JsonKey() final  String subject;
@override@JsonKey() final  LessonType lessonType;
@override@JsonKey() final  TimeOfDay startTime;
@override@JsonKey() final  TimeOfDay endTime;
@override@JsonKey() final  int? lessonNumber;
@override@JsonKey() final  int color;
@override final  int? reminderMinutes;
@override@JsonKey() final  int weekday;
@override@JsonKey() final  LessonRepeat repeat;
 final  List<DateTime> _selectedDates;
@override@JsonKey() List<DateTime> get selectedDates {
  if (_selectedDates is EqualUnmodifiableListView) return _selectedDates;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_selectedDates);
}

 final  List<Classroom> _selectedClassrooms;
@override@JsonKey() List<Classroom> get selectedClassrooms {
  if (_selectedClassrooms is EqualUnmodifiableListView) return _selectedClassrooms;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_selectedClassrooms);
}

 final  List<Teacher> _selectedTeachers;
@override@JsonKey() List<Teacher> get selectedTeachers {
  if (_selectedTeachers is EqualUnmodifiableListView) return _selectedTeachers;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_selectedTeachers);
}


/// Create a copy of CustomLessonEditorState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CustomLessonEditorStateCopyWith<_CustomLessonEditorState> get copyWith => __$CustomLessonEditorStateCopyWithImpl<_CustomLessonEditorState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CustomLessonEditorState&&(identical(other.subject, subject) || other.subject == subject)&&(identical(other.lessonType, lessonType) || other.lessonType == lessonType)&&(identical(other.startTime, startTime) || other.startTime == startTime)&&(identical(other.endTime, endTime) || other.endTime == endTime)&&(identical(other.lessonNumber, lessonNumber) || other.lessonNumber == lessonNumber)&&(identical(other.color, color) || other.color == color)&&(identical(other.reminderMinutes, reminderMinutes) || other.reminderMinutes == reminderMinutes)&&(identical(other.weekday, weekday) || other.weekday == weekday)&&(identical(other.repeat, repeat) || other.repeat == repeat)&&const DeepCollectionEquality().equals(other._selectedDates, _selectedDates)&&const DeepCollectionEquality().equals(other._selectedClassrooms, _selectedClassrooms)&&const DeepCollectionEquality().equals(other._selectedTeachers, _selectedTeachers));
}


@override
int get hashCode => Object.hash(runtimeType,subject,lessonType,startTime,endTime,lessonNumber,color,reminderMinutes,weekday,repeat,const DeepCollectionEquality().hash(_selectedDates),const DeepCollectionEquality().hash(_selectedClassrooms),const DeepCollectionEquality().hash(_selectedTeachers));

@override
String toString() {
  return 'CustomLessonEditorState(subject: $subject, lessonType: $lessonType, startTime: $startTime, endTime: $endTime, lessonNumber: $lessonNumber, color: $color, reminderMinutes: $reminderMinutes, weekday: $weekday, repeat: $repeat, selectedDates: $selectedDates, selectedClassrooms: $selectedClassrooms, selectedTeachers: $selectedTeachers)';
}


}

/// @nodoc
abstract mixin class _$CustomLessonEditorStateCopyWith<$Res> implements $CustomLessonEditorStateCopyWith<$Res> {
  factory _$CustomLessonEditorStateCopyWith(_CustomLessonEditorState value, $Res Function(_CustomLessonEditorState) _then) = __$CustomLessonEditorStateCopyWithImpl;
@override @useResult
$Res call({
 String subject, LessonType lessonType, TimeOfDay startTime, TimeOfDay endTime, int? lessonNumber, int color, int? reminderMinutes, int weekday, LessonRepeat repeat, List<DateTime> selectedDates, List<Classroom> selectedClassrooms, List<Teacher> selectedTeachers
});




}
/// @nodoc
class __$CustomLessonEditorStateCopyWithImpl<$Res>
    implements _$CustomLessonEditorStateCopyWith<$Res> {
  __$CustomLessonEditorStateCopyWithImpl(this._self, this._then);

  final _CustomLessonEditorState _self;
  final $Res Function(_CustomLessonEditorState) _then;

/// Create a copy of CustomLessonEditorState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? subject = null,Object? lessonType = null,Object? startTime = null,Object? endTime = null,Object? lessonNumber = freezed,Object? color = null,Object? reminderMinutes = freezed,Object? weekday = null,Object? repeat = null,Object? selectedDates = null,Object? selectedClassrooms = null,Object? selectedTeachers = null,}) {
  return _then(_CustomLessonEditorState(
subject: null == subject ? _self.subject : subject // ignore: cast_nullable_to_non_nullable
as String,lessonType: null == lessonType ? _self.lessonType : lessonType // ignore: cast_nullable_to_non_nullable
as LessonType,startTime: null == startTime ? _self.startTime : startTime // ignore: cast_nullable_to_non_nullable
as TimeOfDay,endTime: null == endTime ? _self.endTime : endTime // ignore: cast_nullable_to_non_nullable
as TimeOfDay,lessonNumber: freezed == lessonNumber ? _self.lessonNumber : lessonNumber // ignore: cast_nullable_to_non_nullable
as int?,color: null == color ? _self.color : color // ignore: cast_nullable_to_non_nullable
as int,reminderMinutes: freezed == reminderMinutes ? _self.reminderMinutes : reminderMinutes // ignore: cast_nullable_to_non_nullable
as int?,weekday: null == weekday ? _self.weekday : weekday // ignore: cast_nullable_to_non_nullable
as int,repeat: null == repeat ? _self.repeat : repeat // ignore: cast_nullable_to_non_nullable
as LessonRepeat,selectedDates: null == selectedDates ? _self._selectedDates : selectedDates // ignore: cast_nullable_to_non_nullable
as List<DateTime>,selectedClassrooms: null == selectedClassrooms ? _self._selectedClassrooms : selectedClassrooms // ignore: cast_nullable_to_non_nullable
as List<Classroom>,selectedTeachers: null == selectedTeachers ? _self._selectedTeachers : selectedTeachers // ignore: cast_nullable_to_non_nullable
as List<Teacher>,
  ));
}


}

// dart format on
