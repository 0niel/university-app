// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'custom_lesson.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$CustomLesson {

 String get id; String get subject; LessonType get lessonType; List<Teacher> get teachers; List<Classroom> get classrooms; LessonBells get lessonBells; CustomLessonRecurrence get recurrence; int? get color; int? get reminderMinutes; DateTime? get createdAt; DateTime? get updatedAt;
/// Create a copy of CustomLesson
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CustomLessonCopyWith<CustomLesson> get copyWith => _$CustomLessonCopyWithImpl<CustomLesson>(this as CustomLesson, _$identity);

  /// Serializes this CustomLesson to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CustomLesson&&(identical(other.id, id) || other.id == id)&&(identical(other.subject, subject) || other.subject == subject)&&(identical(other.lessonType, lessonType) || other.lessonType == lessonType)&&const DeepCollectionEquality().equals(other.teachers, teachers)&&const DeepCollectionEquality().equals(other.classrooms, classrooms)&&(identical(other.lessonBells, lessonBells) || other.lessonBells == lessonBells)&&(identical(other.recurrence, recurrence) || other.recurrence == recurrence)&&(identical(other.color, color) || other.color == color)&&(identical(other.reminderMinutes, reminderMinutes) || other.reminderMinutes == reminderMinutes)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,subject,lessonType,const DeepCollectionEquality().hash(teachers),const DeepCollectionEquality().hash(classrooms),lessonBells,recurrence,color,reminderMinutes,createdAt,updatedAt);

@override
String toString() {
  return 'CustomLesson(id: $id, subject: $subject, lessonType: $lessonType, teachers: $teachers, classrooms: $classrooms, lessonBells: $lessonBells, recurrence: $recurrence, color: $color, reminderMinutes: $reminderMinutes, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class $CustomLessonCopyWith<$Res>  {
  factory $CustomLessonCopyWith(CustomLesson value, $Res Function(CustomLesson) _then) = _$CustomLessonCopyWithImpl;
@useResult
$Res call({
 String id, String subject, LessonType lessonType, List<Teacher> teachers, List<Classroom> classrooms, LessonBells lessonBells, CustomLessonRecurrence recurrence, int? color, int? reminderMinutes, DateTime? createdAt, DateTime? updatedAt
});


$LessonBellsCopyWith<$Res> get lessonBells;$CustomLessonRecurrenceCopyWith<$Res> get recurrence;

}
/// @nodoc
class _$CustomLessonCopyWithImpl<$Res>
    implements $CustomLessonCopyWith<$Res> {
  _$CustomLessonCopyWithImpl(this._self, this._then);

  final CustomLesson _self;
  final $Res Function(CustomLesson) _then;

/// Create a copy of CustomLesson
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? subject = null,Object? lessonType = null,Object? teachers = null,Object? classrooms = null,Object? lessonBells = null,Object? recurrence = null,Object? color = freezed,Object? reminderMinutes = freezed,Object? createdAt = freezed,Object? updatedAt = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,subject: null == subject ? _self.subject : subject // ignore: cast_nullable_to_non_nullable
as String,lessonType: null == lessonType ? _self.lessonType : lessonType // ignore: cast_nullable_to_non_nullable
as LessonType,teachers: null == teachers ? _self.teachers : teachers // ignore: cast_nullable_to_non_nullable
as List<Teacher>,classrooms: null == classrooms ? _self.classrooms : classrooms // ignore: cast_nullable_to_non_nullable
as List<Classroom>,lessonBells: null == lessonBells ? _self.lessonBells : lessonBells // ignore: cast_nullable_to_non_nullable
as LessonBells,recurrence: null == recurrence ? _self.recurrence : recurrence // ignore: cast_nullable_to_non_nullable
as CustomLessonRecurrence,color: freezed == color ? _self.color : color // ignore: cast_nullable_to_non_nullable
as int?,reminderMinutes: freezed == reminderMinutes ? _self.reminderMinutes : reminderMinutes // ignore: cast_nullable_to_non_nullable
as int?,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}
/// Create a copy of CustomLesson
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$LessonBellsCopyWith<$Res> get lessonBells {

  return $LessonBellsCopyWith<$Res>(_self.lessonBells, (value) {
    return _then(_self.copyWith(lessonBells: value));
  });
}/// Create a copy of CustomLesson
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$CustomLessonRecurrenceCopyWith<$Res> get recurrence {

  return $CustomLessonRecurrenceCopyWith<$Res>(_self.recurrence, (value) {
    return _then(_self.copyWith(recurrence: value));
  });
}
}


/// Adds pattern-matching-related methods to [CustomLesson].
extension CustomLessonPatterns on CustomLesson {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CustomLesson value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CustomLesson() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CustomLesson value)  $default,){
final _that = this;
switch (_that) {
case _CustomLesson():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CustomLesson value)?  $default,){
final _that = this;
switch (_that) {
case _CustomLesson() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String subject,  LessonType lessonType,  List<Teacher> teachers,  List<Classroom> classrooms,  LessonBells lessonBells,  CustomLessonRecurrence recurrence,  int? color,  int? reminderMinutes,  DateTime? createdAt,  DateTime? updatedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CustomLesson() when $default != null:
return $default(_that.id,_that.subject,_that.lessonType,_that.teachers,_that.classrooms,_that.lessonBells,_that.recurrence,_that.color,_that.reminderMinutes,_that.createdAt,_that.updatedAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String subject,  LessonType lessonType,  List<Teacher> teachers,  List<Classroom> classrooms,  LessonBells lessonBells,  CustomLessonRecurrence recurrence,  int? color,  int? reminderMinutes,  DateTime? createdAt,  DateTime? updatedAt)  $default,) {final _that = this;
switch (_that) {
case _CustomLesson():
return $default(_that.id,_that.subject,_that.lessonType,_that.teachers,_that.classrooms,_that.lessonBells,_that.recurrence,_that.color,_that.reminderMinutes,_that.createdAt,_that.updatedAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String subject,  LessonType lessonType,  List<Teacher> teachers,  List<Classroom> classrooms,  LessonBells lessonBells,  CustomLessonRecurrence recurrence,  int? color,  int? reminderMinutes,  DateTime? createdAt,  DateTime? updatedAt)?  $default,) {final _that = this;
switch (_that) {
case _CustomLesson() when $default != null:
return $default(_that.id,_that.subject,_that.lessonType,_that.teachers,_that.classrooms,_that.lessonBells,_that.recurrence,_that.color,_that.reminderMinutes,_that.createdAt,_that.updatedAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _CustomLesson extends CustomLesson {
  const _CustomLesson({required this.id, required this.subject, required this.lessonType, required final  List<Teacher> teachers, required final  List<Classroom> classrooms, required this.lessonBells, required this.recurrence, this.color, this.reminderMinutes, this.createdAt, this.updatedAt}): _teachers = teachers,_classrooms = classrooms,super._();
  factory _CustomLesson.fromJson(Map<String, dynamic> json) => _$CustomLessonFromJson(json);

@override final  String id;
@override final  String subject;
@override final  LessonType lessonType;
 final  List<Teacher> _teachers;
@override List<Teacher> get teachers {
  if (_teachers is EqualUnmodifiableListView) return _teachers;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_teachers);
}

 final  List<Classroom> _classrooms;
@override List<Classroom> get classrooms {
  if (_classrooms is EqualUnmodifiableListView) return _classrooms;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_classrooms);
}

@override final  LessonBells lessonBells;
@override final  CustomLessonRecurrence recurrence;
@override final  int? color;
@override final  int? reminderMinutes;
@override final  DateTime? createdAt;
@override final  DateTime? updatedAt;

/// Create a copy of CustomLesson
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CustomLessonCopyWith<_CustomLesson> get copyWith => __$CustomLessonCopyWithImpl<_CustomLesson>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$CustomLessonToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CustomLesson&&(identical(other.id, id) || other.id == id)&&(identical(other.subject, subject) || other.subject == subject)&&(identical(other.lessonType, lessonType) || other.lessonType == lessonType)&&const DeepCollectionEquality().equals(other._teachers, _teachers)&&const DeepCollectionEquality().equals(other._classrooms, _classrooms)&&(identical(other.lessonBells, lessonBells) || other.lessonBells == lessonBells)&&(identical(other.recurrence, recurrence) || other.recurrence == recurrence)&&(identical(other.color, color) || other.color == color)&&(identical(other.reminderMinutes, reminderMinutes) || other.reminderMinutes == reminderMinutes)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,subject,lessonType,const DeepCollectionEquality().hash(_teachers),const DeepCollectionEquality().hash(_classrooms),lessonBells,recurrence,color,reminderMinutes,createdAt,updatedAt);

@override
String toString() {
  return 'CustomLesson(id: $id, subject: $subject, lessonType: $lessonType, teachers: $teachers, classrooms: $classrooms, lessonBells: $lessonBells, recurrence: $recurrence, color: $color, reminderMinutes: $reminderMinutes, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class _$CustomLessonCopyWith<$Res> implements $CustomLessonCopyWith<$Res> {
  factory _$CustomLessonCopyWith(_CustomLesson value, $Res Function(_CustomLesson) _then) = __$CustomLessonCopyWithImpl;
@override @useResult
$Res call({
 String id, String subject, LessonType lessonType, List<Teacher> teachers, List<Classroom> classrooms, LessonBells lessonBells, CustomLessonRecurrence recurrence, int? color, int? reminderMinutes, DateTime? createdAt, DateTime? updatedAt
});


@override $LessonBellsCopyWith<$Res> get lessonBells;@override $CustomLessonRecurrenceCopyWith<$Res> get recurrence;

}
/// @nodoc
class __$CustomLessonCopyWithImpl<$Res>
    implements _$CustomLessonCopyWith<$Res> {
  __$CustomLessonCopyWithImpl(this._self, this._then);

  final _CustomLesson _self;
  final $Res Function(_CustomLesson) _then;

/// Create a copy of CustomLesson
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? subject = null,Object? lessonType = null,Object? teachers = null,Object? classrooms = null,Object? lessonBells = null,Object? recurrence = null,Object? color = freezed,Object? reminderMinutes = freezed,Object? createdAt = freezed,Object? updatedAt = freezed,}) {
  return _then(_CustomLesson(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,subject: null == subject ? _self.subject : subject // ignore: cast_nullable_to_non_nullable
as String,lessonType: null == lessonType ? _self.lessonType : lessonType // ignore: cast_nullable_to_non_nullable
as LessonType,teachers: null == teachers ? _self._teachers : teachers // ignore: cast_nullable_to_non_nullable
as List<Teacher>,classrooms: null == classrooms ? _self._classrooms : classrooms // ignore: cast_nullable_to_non_nullable
as List<Classroom>,lessonBells: null == lessonBells ? _self.lessonBells : lessonBells // ignore: cast_nullable_to_non_nullable
as LessonBells,recurrence: null == recurrence ? _self.recurrence : recurrence // ignore: cast_nullable_to_non_nullable
as CustomLessonRecurrence,color: freezed == color ? _self.color : color // ignore: cast_nullable_to_non_nullable
as int?,reminderMinutes: freezed == reminderMinutes ? _self.reminderMinutes : reminderMinutes // ignore: cast_nullable_to_non_nullable
as int?,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

/// Create a copy of CustomLesson
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$LessonBellsCopyWith<$Res> get lessonBells {

  return $LessonBellsCopyWith<$Res>(_self.lessonBells, (value) {
    return _then(_self.copyWith(lessonBells: value));
  });
}/// Create a copy of CustomLesson
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$CustomLessonRecurrenceCopyWith<$Res> get recurrence {

  return $CustomLessonRecurrenceCopyWith<$Res>(_self.recurrence, (value) {
    return _then(_self.copyWith(recurrence: value));
  });
}
}

// dart format on
