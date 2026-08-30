// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'lesson_schedule_part.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$LessonSchedulePart {

 String get subject; LessonType get lessonType; List<Teacher> get teachers; List<Classroom> get classrooms; LessonBells get lessonBells;@DatesConverter() List<DateTime> get dates; List<String>? get groups; List<Group>? get groupEntities; String? get uid; int? get color; int? get reminderMinutes; String get type;
/// Create a copy of LessonSchedulePart
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$LessonSchedulePartCopyWith<LessonSchedulePart> get copyWith => _$LessonSchedulePartCopyWithImpl<LessonSchedulePart>(this as LessonSchedulePart, _$identity);

  /// Serializes this LessonSchedulePart to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is LessonSchedulePart&&(identical(other.subject, subject) || other.subject == subject)&&(identical(other.lessonType, lessonType) || other.lessonType == lessonType)&&const DeepCollectionEquality().equals(other.teachers, teachers)&&const DeepCollectionEquality().equals(other.classrooms, classrooms)&&(identical(other.lessonBells, lessonBells) || other.lessonBells == lessonBells)&&const DeepCollectionEquality().equals(other.dates, dates)&&const DeepCollectionEquality().equals(other.groups, groups)&&const DeepCollectionEquality().equals(other.groupEntities, groupEntities)&&(identical(other.uid, uid) || other.uid == uid)&&(identical(other.color, color) || other.color == color)&&(identical(other.reminderMinutes, reminderMinutes) || other.reminderMinutes == reminderMinutes)&&(identical(other.type, type) || other.type == type));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,subject,lessonType,const DeepCollectionEquality().hash(teachers),const DeepCollectionEquality().hash(classrooms),lessonBells,const DeepCollectionEquality().hash(dates),const DeepCollectionEquality().hash(groups),const DeepCollectionEquality().hash(groupEntities),uid,color,reminderMinutes,type);

@override
String toString() {
  return 'LessonSchedulePart(subject: $subject, lessonType: $lessonType, teachers: $teachers, classrooms: $classrooms, lessonBells: $lessonBells, dates: $dates, groups: $groups, groupEntities: $groupEntities, uid: $uid, color: $color, reminderMinutes: $reminderMinutes, type: $type)';
}


}

/// @nodoc
abstract mixin class $LessonSchedulePartCopyWith<$Res>  {
  factory $LessonSchedulePartCopyWith(LessonSchedulePart value, $Res Function(LessonSchedulePart) _then) = _$LessonSchedulePartCopyWithImpl;
@useResult
$Res call({
 String subject, LessonType lessonType, List<Teacher> teachers, List<Classroom> classrooms, LessonBells lessonBells,@DatesConverter() List<DateTime> dates, List<String>? groups, List<Group>? groupEntities, String? uid, int? color, int? reminderMinutes, String type
});


$LessonBellsCopyWith<$Res> get lessonBells;

}
/// @nodoc
class _$LessonSchedulePartCopyWithImpl<$Res>
    implements $LessonSchedulePartCopyWith<$Res> {
  _$LessonSchedulePartCopyWithImpl(this._self, this._then);

  final LessonSchedulePart _self;
  final $Res Function(LessonSchedulePart) _then;

/// Create a copy of LessonSchedulePart
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? subject = null,Object? lessonType = null,Object? teachers = null,Object? classrooms = null,Object? lessonBells = null,Object? dates = null,Object? groups = freezed,Object? groupEntities = freezed,Object? uid = freezed,Object? color = freezed,Object? reminderMinutes = freezed,Object? type = null,}) {
  return _then(_self.copyWith(
subject: null == subject ? _self.subject : subject // ignore: cast_nullable_to_non_nullable
as String,lessonType: null == lessonType ? _self.lessonType : lessonType // ignore: cast_nullable_to_non_nullable
as LessonType,teachers: null == teachers ? _self.teachers : teachers // ignore: cast_nullable_to_non_nullable
as List<Teacher>,classrooms: null == classrooms ? _self.classrooms : classrooms // ignore: cast_nullable_to_non_nullable
as List<Classroom>,lessonBells: null == lessonBells ? _self.lessonBells : lessonBells // ignore: cast_nullable_to_non_nullable
as LessonBells,dates: null == dates ? _self.dates : dates // ignore: cast_nullable_to_non_nullable
as List<DateTime>,groups: freezed == groups ? _self.groups : groups // ignore: cast_nullable_to_non_nullable
as List<String>?,groupEntities: freezed == groupEntities ? _self.groupEntities : groupEntities // ignore: cast_nullable_to_non_nullable
as List<Group>?,uid: freezed == uid ? _self.uid : uid // ignore: cast_nullable_to_non_nullable
as String?,color: freezed == color ? _self.color : color // ignore: cast_nullable_to_non_nullable
as int?,reminderMinutes: freezed == reminderMinutes ? _self.reminderMinutes : reminderMinutes // ignore: cast_nullable_to_non_nullable
as int?,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String,
  ));
}
/// Create a copy of LessonSchedulePart
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$LessonBellsCopyWith<$Res> get lessonBells {

  return $LessonBellsCopyWith<$Res>(_self.lessonBells, (value) {
    return _then(_self.copyWith(lessonBells: value));
  });
}
}


/// Adds pattern-matching-related methods to [LessonSchedulePart].
extension LessonSchedulePartPatterns on LessonSchedulePart {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _LessonSchedulePart value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _LessonSchedulePart() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _LessonSchedulePart value)  $default,){
final _that = this;
switch (_that) {
case _LessonSchedulePart():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _LessonSchedulePart value)?  $default,){
final _that = this;
switch (_that) {
case _LessonSchedulePart() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String subject,  LessonType lessonType,  List<Teacher> teachers,  List<Classroom> classrooms,  LessonBells lessonBells, @DatesConverter()  List<DateTime> dates,  List<String>? groups,  List<Group>? groupEntities,  String? uid,  int? color,  int? reminderMinutes,  String type)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _LessonSchedulePart() when $default != null:
return $default(_that.subject,_that.lessonType,_that.teachers,_that.classrooms,_that.lessonBells,_that.dates,_that.groups,_that.groupEntities,_that.uid,_that.color,_that.reminderMinutes,_that.type);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String subject,  LessonType lessonType,  List<Teacher> teachers,  List<Classroom> classrooms,  LessonBells lessonBells, @DatesConverter()  List<DateTime> dates,  List<String>? groups,  List<Group>? groupEntities,  String? uid,  int? color,  int? reminderMinutes,  String type)  $default,) {final _that = this;
switch (_that) {
case _LessonSchedulePart():
return $default(_that.subject,_that.lessonType,_that.teachers,_that.classrooms,_that.lessonBells,_that.dates,_that.groups,_that.groupEntities,_that.uid,_that.color,_that.reminderMinutes,_that.type);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String subject,  LessonType lessonType,  List<Teacher> teachers,  List<Classroom> classrooms,  LessonBells lessonBells, @DatesConverter()  List<DateTime> dates,  List<String>? groups,  List<Group>? groupEntities,  String? uid,  int? color,  int? reminderMinutes,  String type)?  $default,) {final _that = this;
switch (_that) {
case _LessonSchedulePart() when $default != null:
return $default(_that.subject,_that.lessonType,_that.teachers,_that.classrooms,_that.lessonBells,_that.dates,_that.groups,_that.groupEntities,_that.uid,_that.color,_that.reminderMinutes,_that.type);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _LessonSchedulePart extends LessonSchedulePart {
  const _LessonSchedulePart({required this.subject, required this.lessonType, required final  List<Teacher> teachers, required final  List<Classroom> classrooms, required this.lessonBells, @DatesConverter() required final  List<DateTime> dates, final  List<String>? groups, final  List<Group>? groupEntities, this.uid, this.color, this.reminderMinutes, this.type = LessonSchedulePart.identifier}): _teachers = teachers,_classrooms = classrooms,_dates = dates,_groups = groups,_groupEntities = groupEntities,super._();
  factory _LessonSchedulePart.fromJson(Map<String, dynamic> json) => _$LessonSchedulePartFromJson(json);

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
 final  List<DateTime> _dates;
@override@DatesConverter() List<DateTime> get dates {
  if (_dates is EqualUnmodifiableListView) return _dates;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_dates);
}

 final  List<String>? _groups;
@override List<String>? get groups {
  final value = _groups;
  if (value == null) return null;
  if (_groups is EqualUnmodifiableListView) return _groups;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(value);
}

 final  List<Group>? _groupEntities;
@override List<Group>? get groupEntities {
  final value = _groupEntities;
  if (value == null) return null;
  if (_groupEntities is EqualUnmodifiableListView) return _groupEntities;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(value);
}

@override final  String? uid;
@override final  int? color;
@override final  int? reminderMinutes;
@override@JsonKey() final  String type;

/// Create a copy of LessonSchedulePart
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$LessonSchedulePartCopyWith<_LessonSchedulePart> get copyWith => __$LessonSchedulePartCopyWithImpl<_LessonSchedulePart>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$LessonSchedulePartToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _LessonSchedulePart&&(identical(other.subject, subject) || other.subject == subject)&&(identical(other.lessonType, lessonType) || other.lessonType == lessonType)&&const DeepCollectionEquality().equals(other._teachers, _teachers)&&const DeepCollectionEquality().equals(other._classrooms, _classrooms)&&(identical(other.lessonBells, lessonBells) || other.lessonBells == lessonBells)&&const DeepCollectionEquality().equals(other._dates, _dates)&&const DeepCollectionEquality().equals(other._groups, _groups)&&const DeepCollectionEquality().equals(other._groupEntities, _groupEntities)&&(identical(other.uid, uid) || other.uid == uid)&&(identical(other.color, color) || other.color == color)&&(identical(other.reminderMinutes, reminderMinutes) || other.reminderMinutes == reminderMinutes)&&(identical(other.type, type) || other.type == type));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,subject,lessonType,const DeepCollectionEquality().hash(_teachers),const DeepCollectionEquality().hash(_classrooms),lessonBells,const DeepCollectionEquality().hash(_dates),const DeepCollectionEquality().hash(_groups),const DeepCollectionEquality().hash(_groupEntities),uid,color,reminderMinutes,type);

@override
String toString() {
  return 'LessonSchedulePart(subject: $subject, lessonType: $lessonType, teachers: $teachers, classrooms: $classrooms, lessonBells: $lessonBells, dates: $dates, groups: $groups, groupEntities: $groupEntities, uid: $uid, color: $color, reminderMinutes: $reminderMinutes, type: $type)';
}


}

/// @nodoc
abstract mixin class _$LessonSchedulePartCopyWith<$Res> implements $LessonSchedulePartCopyWith<$Res> {
  factory _$LessonSchedulePartCopyWith(_LessonSchedulePart value, $Res Function(_LessonSchedulePart) _then) = __$LessonSchedulePartCopyWithImpl;
@override @useResult
$Res call({
 String subject, LessonType lessonType, List<Teacher> teachers, List<Classroom> classrooms, LessonBells lessonBells,@DatesConverter() List<DateTime> dates, List<String>? groups, List<Group>? groupEntities, String? uid, int? color, int? reminderMinutes, String type
});


@override $LessonBellsCopyWith<$Res> get lessonBells;

}
/// @nodoc
class __$LessonSchedulePartCopyWithImpl<$Res>
    implements _$LessonSchedulePartCopyWith<$Res> {
  __$LessonSchedulePartCopyWithImpl(this._self, this._then);

  final _LessonSchedulePart _self;
  final $Res Function(_LessonSchedulePart) _then;

/// Create a copy of LessonSchedulePart
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? subject = null,Object? lessonType = null,Object? teachers = null,Object? classrooms = null,Object? lessonBells = null,Object? dates = null,Object? groups = freezed,Object? groupEntities = freezed,Object? uid = freezed,Object? color = freezed,Object? reminderMinutes = freezed,Object? type = null,}) {
  return _then(_LessonSchedulePart(
subject: null == subject ? _self.subject : subject // ignore: cast_nullable_to_non_nullable
as String,lessonType: null == lessonType ? _self.lessonType : lessonType // ignore: cast_nullable_to_non_nullable
as LessonType,teachers: null == teachers ? _self._teachers : teachers // ignore: cast_nullable_to_non_nullable
as List<Teacher>,classrooms: null == classrooms ? _self._classrooms : classrooms // ignore: cast_nullable_to_non_nullable
as List<Classroom>,lessonBells: null == lessonBells ? _self.lessonBells : lessonBells // ignore: cast_nullable_to_non_nullable
as LessonBells,dates: null == dates ? _self._dates : dates // ignore: cast_nullable_to_non_nullable
as List<DateTime>,groups: freezed == groups ? _self._groups : groups // ignore: cast_nullable_to_non_nullable
as List<String>?,groupEntities: freezed == groupEntities ? _self._groupEntities : groupEntities // ignore: cast_nullable_to_non_nullable
as List<Group>?,uid: freezed == uid ? _self.uid : uid // ignore: cast_nullable_to_non_nullable
as String?,color: freezed == color ? _self.color : color // ignore: cast_nullable_to_non_nullable
as int?,reminderMinutes: freezed == reminderMinutes ? _self.reminderMinutes : reminderMinutes // ignore: cast_nullable_to_non_nullable
as int?,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

/// Create a copy of LessonSchedulePart
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$LessonBellsCopyWith<$Res> get lessonBells {

  return $LessonBellsCopyWith<$Res>(_self.lessonBells, (value) {
    return _then(_self.copyWith(lessonBells: value));
  });
}
}

// dart format on
