// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'selected_schedule.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$SelectedSchedule {

@SchedulePartsConverter() List<SchedulePart> get schedule;
/// Create a copy of SelectedSchedule
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SelectedScheduleCopyWith<SelectedSchedule> get copyWith => _$SelectedScheduleCopyWithImpl<SelectedSchedule>(this as SelectedSchedule, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SelectedSchedule&&const DeepCollectionEquality().equals(other.schedule, schedule));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(schedule));

@override
String toString() {
  return 'SelectedSchedule(schedule: $schedule)';
}


}

/// @nodoc
abstract mixin class $SelectedScheduleCopyWith<$Res>  {
  factory $SelectedScheduleCopyWith(SelectedSchedule value, $Res Function(SelectedSchedule) _then) = _$SelectedScheduleCopyWithImpl;
@useResult
$Res call({
@SchedulePartsConverter() List<SchedulePart> schedule
});




}
/// @nodoc
class _$SelectedScheduleCopyWithImpl<$Res>
    implements $SelectedScheduleCopyWith<$Res> {
  _$SelectedScheduleCopyWithImpl(this._self, this._then);

  final SelectedSchedule _self;
  final $Res Function(SelectedSchedule) _then;

/// Create a copy of SelectedSchedule
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? schedule = null,}) {
  return _then(_self.copyWith(
schedule: null == schedule ? _self.schedule : schedule // ignore: cast_nullable_to_non_nullable
as List<SchedulePart>,
  ));
}

}


/// Adds pattern-matching-related methods to [SelectedSchedule].
extension SelectedSchedulePatterns on SelectedSchedule {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( SelectedGroupSchedule value)?  group,TResult Function( SelectedTeacherSchedule value)?  teacher,TResult Function( SelectedClassroomSchedule value)?  classroom,TResult Function( SelectedCustomSchedule value)?  custom,required TResult orElse(),}){
final _that = this;
switch (_that) {
case SelectedGroupSchedule() when group != null:
return group(_that);case SelectedTeacherSchedule() when teacher != null:
return teacher(_that);case SelectedClassroomSchedule() when classroom != null:
return classroom(_that);case SelectedCustomSchedule() when custom != null:
return custom(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( SelectedGroupSchedule value)  group,required TResult Function( SelectedTeacherSchedule value)  teacher,required TResult Function( SelectedClassroomSchedule value)  classroom,required TResult Function( SelectedCustomSchedule value)  custom,}){
final _that = this;
switch (_that) {
case SelectedGroupSchedule():
return group(_that);case SelectedTeacherSchedule():
return teacher(_that);case SelectedClassroomSchedule():
return classroom(_that);case SelectedCustomSchedule():
return custom(_that);}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( SelectedGroupSchedule value)?  group,TResult? Function( SelectedTeacherSchedule value)?  teacher,TResult? Function( SelectedClassroomSchedule value)?  classroom,TResult? Function( SelectedCustomSchedule value)?  custom,}){
final _that = this;
switch (_that) {
case SelectedGroupSchedule() when group != null:
return group(_that);case SelectedTeacherSchedule() when teacher != null:
return teacher(_that);case SelectedClassroomSchedule() when classroom != null:
return classroom(_that);case SelectedCustomSchedule() when custom != null:
return custom(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function( Group group, @SchedulePartsConverter()  List<SchedulePart> schedule)?  group,TResult Function( Teacher teacher, @SchedulePartsConverter()  List<SchedulePart> schedule)?  teacher,TResult Function( Classroom classroom, @SchedulePartsConverter()  List<SchedulePart> schedule)?  classroom,TResult Function( String id,  String name, @SchedulePartsConverter()  List<SchedulePart> schedule,  String? description)?  custom,required TResult orElse(),}) {final _that = this;
switch (_that) {
case SelectedGroupSchedule() when group != null:
return group(_that.group,_that.schedule);case SelectedTeacherSchedule() when teacher != null:
return teacher(_that.teacher,_that.schedule);case SelectedClassroomSchedule() when classroom != null:
return classroom(_that.classroom,_that.schedule);case SelectedCustomSchedule() when custom != null:
return custom(_that.id,_that.name,_that.schedule,_that.description);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function( Group group, @SchedulePartsConverter()  List<SchedulePart> schedule)  group,required TResult Function( Teacher teacher, @SchedulePartsConverter()  List<SchedulePart> schedule)  teacher,required TResult Function( Classroom classroom, @SchedulePartsConverter()  List<SchedulePart> schedule)  classroom,required TResult Function( String id,  String name, @SchedulePartsConverter()  List<SchedulePart> schedule,  String? description)  custom,}) {final _that = this;
switch (_that) {
case SelectedGroupSchedule():
return group(_that.group,_that.schedule);case SelectedTeacherSchedule():
return teacher(_that.teacher,_that.schedule);case SelectedClassroomSchedule():
return classroom(_that.classroom,_that.schedule);case SelectedCustomSchedule():
return custom(_that.id,_that.name,_that.schedule,_that.description);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function( Group group, @SchedulePartsConverter()  List<SchedulePart> schedule)?  group,TResult? Function( Teacher teacher, @SchedulePartsConverter()  List<SchedulePart> schedule)?  teacher,TResult? Function( Classroom classroom, @SchedulePartsConverter()  List<SchedulePart> schedule)?  classroom,TResult? Function( String id,  String name, @SchedulePartsConverter()  List<SchedulePart> schedule,  String? description)?  custom,}) {final _that = this;
switch (_that) {
case SelectedGroupSchedule() when group != null:
return group(_that.group,_that.schedule);case SelectedTeacherSchedule() when teacher != null:
return teacher(_that.teacher,_that.schedule);case SelectedClassroomSchedule() when classroom != null:
return classroom(_that.classroom,_that.schedule);case SelectedCustomSchedule() when custom != null:
return custom(_that.id,_that.name,_that.schedule,_that.description);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(checked: true, explicitToJson: true)
class SelectedGroupSchedule extends SelectedSchedule {
  const SelectedGroupSchedule({required this.group, @SchedulePartsConverter() required final  List<SchedulePart> schedule}): _schedule = schedule,super._();


 final  Group group;
 final  List<SchedulePart> _schedule;
@override@SchedulePartsConverter() List<SchedulePart> get schedule {
  if (_schedule is EqualUnmodifiableListView) return _schedule;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_schedule);
}


/// Create a copy of SelectedSchedule
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SelectedGroupScheduleCopyWith<SelectedGroupSchedule> get copyWith => _$SelectedGroupScheduleCopyWithImpl<SelectedGroupSchedule>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SelectedGroupSchedule&&(identical(other.group, group) || other.group == group)&&const DeepCollectionEquality().equals(other._schedule, _schedule));
}


@override
int get hashCode => Object.hash(runtimeType,group,const DeepCollectionEquality().hash(_schedule));

@override
String toString() {
  return 'SelectedSchedule.group(group: $group, schedule: $schedule)';
}


}

/// @nodoc
abstract mixin class $SelectedGroupScheduleCopyWith<$Res> implements $SelectedScheduleCopyWith<$Res> {
  factory $SelectedGroupScheduleCopyWith(SelectedGroupSchedule value, $Res Function(SelectedGroupSchedule) _then) = _$SelectedGroupScheduleCopyWithImpl;
@override @useResult
$Res call({
 Group group,@SchedulePartsConverter() List<SchedulePart> schedule
});


$GroupCopyWith<$Res> get group;

}
/// @nodoc
class _$SelectedGroupScheduleCopyWithImpl<$Res>
    implements $SelectedGroupScheduleCopyWith<$Res> {
  _$SelectedGroupScheduleCopyWithImpl(this._self, this._then);

  final SelectedGroupSchedule _self;
  final $Res Function(SelectedGroupSchedule) _then;

/// Create a copy of SelectedSchedule
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? group = null,Object? schedule = null,}) {
  return _then(SelectedGroupSchedule(
group: null == group ? _self.group : group // ignore: cast_nullable_to_non_nullable
as Group,schedule: null == schedule ? _self._schedule : schedule // ignore: cast_nullable_to_non_nullable
as List<SchedulePart>,
  ));
}

/// Create a copy of SelectedSchedule
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$GroupCopyWith<$Res> get group {

  return $GroupCopyWith<$Res>(_self.group, (value) {
    return _then(_self.copyWith(group: value));
  });
}
}

/// @nodoc

@JsonSerializable(checked: true, explicitToJson: true)
class SelectedTeacherSchedule extends SelectedSchedule {
  const SelectedTeacherSchedule({required this.teacher, @SchedulePartsConverter() required final  List<SchedulePart> schedule}): _schedule = schedule,super._();


 final  Teacher teacher;
 final  List<SchedulePart> _schedule;
@override@SchedulePartsConverter() List<SchedulePart> get schedule {
  if (_schedule is EqualUnmodifiableListView) return _schedule;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_schedule);
}


/// Create a copy of SelectedSchedule
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SelectedTeacherScheduleCopyWith<SelectedTeacherSchedule> get copyWith => _$SelectedTeacherScheduleCopyWithImpl<SelectedTeacherSchedule>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SelectedTeacherSchedule&&(identical(other.teacher, teacher) || other.teacher == teacher)&&const DeepCollectionEquality().equals(other._schedule, _schedule));
}


@override
int get hashCode => Object.hash(runtimeType,teacher,const DeepCollectionEquality().hash(_schedule));

@override
String toString() {
  return 'SelectedSchedule.teacher(teacher: $teacher, schedule: $schedule)';
}


}

/// @nodoc
abstract mixin class $SelectedTeacherScheduleCopyWith<$Res> implements $SelectedScheduleCopyWith<$Res> {
  factory $SelectedTeacherScheduleCopyWith(SelectedTeacherSchedule value, $Res Function(SelectedTeacherSchedule) _then) = _$SelectedTeacherScheduleCopyWithImpl;
@override @useResult
$Res call({
 Teacher teacher,@SchedulePartsConverter() List<SchedulePart> schedule
});


$TeacherCopyWith<$Res> get teacher;

}
/// @nodoc
class _$SelectedTeacherScheduleCopyWithImpl<$Res>
    implements $SelectedTeacherScheduleCopyWith<$Res> {
  _$SelectedTeacherScheduleCopyWithImpl(this._self, this._then);

  final SelectedTeacherSchedule _self;
  final $Res Function(SelectedTeacherSchedule) _then;

/// Create a copy of SelectedSchedule
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? teacher = null,Object? schedule = null,}) {
  return _then(SelectedTeacherSchedule(
teacher: null == teacher ? _self.teacher : teacher // ignore: cast_nullable_to_non_nullable
as Teacher,schedule: null == schedule ? _self._schedule : schedule // ignore: cast_nullable_to_non_nullable
as List<SchedulePart>,
  ));
}

/// Create a copy of SelectedSchedule
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$TeacherCopyWith<$Res> get teacher {

  return $TeacherCopyWith<$Res>(_self.teacher, (value) {
    return _then(_self.copyWith(teacher: value));
  });
}
}

/// @nodoc

@JsonSerializable(checked: true, explicitToJson: true)
class SelectedClassroomSchedule extends SelectedSchedule {
  const SelectedClassroomSchedule({required this.classroom, @SchedulePartsConverter() required final  List<SchedulePart> schedule}): _schedule = schedule,super._();


 final  Classroom classroom;
 final  List<SchedulePart> _schedule;
@override@SchedulePartsConverter() List<SchedulePart> get schedule {
  if (_schedule is EqualUnmodifiableListView) return _schedule;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_schedule);
}


/// Create a copy of SelectedSchedule
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SelectedClassroomScheduleCopyWith<SelectedClassroomSchedule> get copyWith => _$SelectedClassroomScheduleCopyWithImpl<SelectedClassroomSchedule>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SelectedClassroomSchedule&&(identical(other.classroom, classroom) || other.classroom == classroom)&&const DeepCollectionEquality().equals(other._schedule, _schedule));
}


@override
int get hashCode => Object.hash(runtimeType,classroom,const DeepCollectionEquality().hash(_schedule));

@override
String toString() {
  return 'SelectedSchedule.classroom(classroom: $classroom, schedule: $schedule)';
}


}

/// @nodoc
abstract mixin class $SelectedClassroomScheduleCopyWith<$Res> implements $SelectedScheduleCopyWith<$Res> {
  factory $SelectedClassroomScheduleCopyWith(SelectedClassroomSchedule value, $Res Function(SelectedClassroomSchedule) _then) = _$SelectedClassroomScheduleCopyWithImpl;
@override @useResult
$Res call({
 Classroom classroom,@SchedulePartsConverter() List<SchedulePart> schedule
});


$ClassroomCopyWith<$Res> get classroom;

}
/// @nodoc
class _$SelectedClassroomScheduleCopyWithImpl<$Res>
    implements $SelectedClassroomScheduleCopyWith<$Res> {
  _$SelectedClassroomScheduleCopyWithImpl(this._self, this._then);

  final SelectedClassroomSchedule _self;
  final $Res Function(SelectedClassroomSchedule) _then;

/// Create a copy of SelectedSchedule
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? classroom = null,Object? schedule = null,}) {
  return _then(SelectedClassroomSchedule(
classroom: null == classroom ? _self.classroom : classroom // ignore: cast_nullable_to_non_nullable
as Classroom,schedule: null == schedule ? _self._schedule : schedule // ignore: cast_nullable_to_non_nullable
as List<SchedulePart>,
  ));
}

/// Create a copy of SelectedSchedule
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ClassroomCopyWith<$Res> get classroom {

  return $ClassroomCopyWith<$Res>(_self.classroom, (value) {
    return _then(_self.copyWith(classroom: value));
  });
}
}

/// @nodoc

@JsonSerializable(checked: true, explicitToJson: true)
class SelectedCustomSchedule extends SelectedSchedule {
  const SelectedCustomSchedule({required this.id, required this.name, @SchedulePartsConverter() required final  List<SchedulePart> schedule, this.description}): _schedule = schedule,super._();


 final  String id;
 final  String name;
 final  List<SchedulePart> _schedule;
@override@SchedulePartsConverter() List<SchedulePart> get schedule {
  if (_schedule is EqualUnmodifiableListView) return _schedule;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_schedule);
}

 final  String? description;

/// Create a copy of SelectedSchedule
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SelectedCustomScheduleCopyWith<SelectedCustomSchedule> get copyWith => _$SelectedCustomScheduleCopyWithImpl<SelectedCustomSchedule>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SelectedCustomSchedule&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&const DeepCollectionEquality().equals(other._schedule, _schedule)&&(identical(other.description, description) || other.description == description));
}


@override
int get hashCode => Object.hash(runtimeType,id,name,const DeepCollectionEquality().hash(_schedule),description);

@override
String toString() {
  return 'SelectedSchedule.custom(id: $id, name: $name, schedule: $schedule, description: $description)';
}


}

/// @nodoc
abstract mixin class $SelectedCustomScheduleCopyWith<$Res> implements $SelectedScheduleCopyWith<$Res> {
  factory $SelectedCustomScheduleCopyWith(SelectedCustomSchedule value, $Res Function(SelectedCustomSchedule) _then) = _$SelectedCustomScheduleCopyWithImpl;
@override @useResult
$Res call({
 String id, String name,@SchedulePartsConverter() List<SchedulePart> schedule, String? description
});




}
/// @nodoc
class _$SelectedCustomScheduleCopyWithImpl<$Res>
    implements $SelectedCustomScheduleCopyWith<$Res> {
  _$SelectedCustomScheduleCopyWithImpl(this._self, this._then);

  final SelectedCustomSchedule _self;
  final $Res Function(SelectedCustomSchedule) _then;

/// Create a copy of SelectedSchedule
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? schedule = null,Object? description = freezed,}) {
  return _then(SelectedCustomSchedule(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,schedule: null == schedule ? _self._schedule : schedule // ignore: cast_nullable_to_non_nullable
as List<SchedulePart>,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
