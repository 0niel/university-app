// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'teacher_schedule_snapshot.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$TeacherScheduleSnapshot {

 List<SchedulePart> get schedule; DateTime get fetchedAt; TeacherScheduleSource get source;
/// Create a copy of TeacherScheduleSnapshot
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TeacherScheduleSnapshotCopyWith<TeacherScheduleSnapshot> get copyWith => _$TeacherScheduleSnapshotCopyWithImpl<TeacherScheduleSnapshot>(this as TeacherScheduleSnapshot, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TeacherScheduleSnapshot&&const DeepCollectionEquality().equals(other.schedule, schedule)&&(identical(other.fetchedAt, fetchedAt) || other.fetchedAt == fetchedAt)&&(identical(other.source, source) || other.source == source));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(schedule),fetchedAt,source);

@override
String toString() {
  return 'TeacherScheduleSnapshot(schedule: $schedule, fetchedAt: $fetchedAt, source: $source)';
}


}

/// @nodoc
abstract mixin class $TeacherScheduleSnapshotCopyWith<$Res>  {
  factory $TeacherScheduleSnapshotCopyWith(TeacherScheduleSnapshot value, $Res Function(TeacherScheduleSnapshot) _then) = _$TeacherScheduleSnapshotCopyWithImpl;
@useResult
$Res call({
 List<SchedulePart> schedule, DateTime fetchedAt, TeacherScheduleSource source
});




}
/// @nodoc
class _$TeacherScheduleSnapshotCopyWithImpl<$Res>
    implements $TeacherScheduleSnapshotCopyWith<$Res> {
  _$TeacherScheduleSnapshotCopyWithImpl(this._self, this._then);

  final TeacherScheduleSnapshot _self;
  final $Res Function(TeacherScheduleSnapshot) _then;

/// Create a copy of TeacherScheduleSnapshot
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? schedule = null,Object? fetchedAt = null,Object? source = null,}) {
  return _then(_self.copyWith(
schedule: null == schedule ? _self.schedule : schedule // ignore: cast_nullable_to_non_nullable
as List<SchedulePart>,fetchedAt: null == fetchedAt ? _self.fetchedAt : fetchedAt // ignore: cast_nullable_to_non_nullable
as DateTime,source: null == source ? _self.source : source // ignore: cast_nullable_to_non_nullable
as TeacherScheduleSource,
  ));
}

}


/// Adds pattern-matching-related methods to [TeacherScheduleSnapshot].
extension TeacherScheduleSnapshotPatterns on TeacherScheduleSnapshot {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TeacherScheduleSnapshot value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TeacherScheduleSnapshot() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TeacherScheduleSnapshot value)  $default,){
final _that = this;
switch (_that) {
case _TeacherScheduleSnapshot():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TeacherScheduleSnapshot value)?  $default,){
final _that = this;
switch (_that) {
case _TeacherScheduleSnapshot() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<SchedulePart> schedule,  DateTime fetchedAt,  TeacherScheduleSource source)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _TeacherScheduleSnapshot() when $default != null:
return $default(_that.schedule,_that.fetchedAt,_that.source);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<SchedulePart> schedule,  DateTime fetchedAt,  TeacherScheduleSource source)  $default,) {final _that = this;
switch (_that) {
case _TeacherScheduleSnapshot():
return $default(_that.schedule,_that.fetchedAt,_that.source);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<SchedulePart> schedule,  DateTime fetchedAt,  TeacherScheduleSource source)?  $default,) {final _that = this;
switch (_that) {
case _TeacherScheduleSnapshot() when $default != null:
return $default(_that.schedule,_that.fetchedAt,_that.source);case _:
  return null;

}
}

}

/// @nodoc


class _TeacherScheduleSnapshot implements TeacherScheduleSnapshot {
  const _TeacherScheduleSnapshot({required final  List<SchedulePart> schedule, required this.fetchedAt, this.source = TeacherScheduleSource.network}): _schedule = schedule;


 final  List<SchedulePart> _schedule;
@override List<SchedulePart> get schedule {
  if (_schedule is EqualUnmodifiableListView) return _schedule;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_schedule);
}

@override final  DateTime fetchedAt;
@override@JsonKey() final  TeacherScheduleSource source;

/// Create a copy of TeacherScheduleSnapshot
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TeacherScheduleSnapshotCopyWith<_TeacherScheduleSnapshot> get copyWith => __$TeacherScheduleSnapshotCopyWithImpl<_TeacherScheduleSnapshot>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _TeacherScheduleSnapshot&&const DeepCollectionEquality().equals(other._schedule, _schedule)&&(identical(other.fetchedAt, fetchedAt) || other.fetchedAt == fetchedAt)&&(identical(other.source, source) || other.source == source));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_schedule),fetchedAt,source);

@override
String toString() {
  return 'TeacherScheduleSnapshot(schedule: $schedule, fetchedAt: $fetchedAt, source: $source)';
}


}

/// @nodoc
abstract mixin class _$TeacherScheduleSnapshotCopyWith<$Res> implements $TeacherScheduleSnapshotCopyWith<$Res> {
  factory _$TeacherScheduleSnapshotCopyWith(_TeacherScheduleSnapshot value, $Res Function(_TeacherScheduleSnapshot) _then) = __$TeacherScheduleSnapshotCopyWithImpl;
@override @useResult
$Res call({
 List<SchedulePart> schedule, DateTime fetchedAt, TeacherScheduleSource source
});




}
/// @nodoc
class __$TeacherScheduleSnapshotCopyWithImpl<$Res>
    implements _$TeacherScheduleSnapshotCopyWith<$Res> {
  __$TeacherScheduleSnapshotCopyWithImpl(this._self, this._then);

  final _TeacherScheduleSnapshot _self;
  final $Res Function(_TeacherScheduleSnapshot) _then;

/// Create a copy of TeacherScheduleSnapshot
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? schedule = null,Object? fetchedAt = null,Object? source = null,}) {
  return _then(_TeacherScheduleSnapshot(
schedule: null == schedule ? _self._schedule : schedule // ignore: cast_nullable_to_non_nullable
as List<SchedulePart>,fetchedAt: null == fetchedAt ? _self.fetchedAt : fetchedAt // ignore: cast_nullable_to_non_nullable
as DateTime,source: null == source ? _self.source : source // ignore: cast_nullable_to_non_nullable
as TeacherScheduleSource,
  ));
}


}

// dart format on
