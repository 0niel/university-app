// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'schedule_change.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ScheduleChange {

 String get id; ScheduleChangeKind get kind; String get subject; DateTime get lessonDate; DateTime get createdAt; int? get lessonNumber; ScheduleChangeSlot get oldValue; ScheduleChangeSlot get newValue;
/// Create a copy of ScheduleChange
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ScheduleChangeCopyWith<ScheduleChange> get copyWith => _$ScheduleChangeCopyWithImpl<ScheduleChange>(this as ScheduleChange, _$identity);

  /// Serializes this ScheduleChange to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ScheduleChange&&(identical(other.id, id) || other.id == id)&&(identical(other.kind, kind) || other.kind == kind)&&(identical(other.subject, subject) || other.subject == subject)&&(identical(other.lessonDate, lessonDate) || other.lessonDate == lessonDate)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.lessonNumber, lessonNumber) || other.lessonNumber == lessonNumber)&&(identical(other.oldValue, oldValue) || other.oldValue == oldValue)&&(identical(other.newValue, newValue) || other.newValue == newValue));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,kind,subject,lessonDate,createdAt,lessonNumber,oldValue,newValue);

@override
String toString() {
  return 'ScheduleChange(id: $id, kind: $kind, subject: $subject, lessonDate: $lessonDate, createdAt: $createdAt, lessonNumber: $lessonNumber, oldValue: $oldValue, newValue: $newValue)';
}


}

/// @nodoc
abstract mixin class $ScheduleChangeCopyWith<$Res>  {
  factory $ScheduleChangeCopyWith(ScheduleChange value, $Res Function(ScheduleChange) _then) = _$ScheduleChangeCopyWithImpl;
@useResult
$Res call({
 String id, ScheduleChangeKind kind, String subject, DateTime lessonDate, DateTime createdAt, int? lessonNumber, ScheduleChangeSlot oldValue, ScheduleChangeSlot newValue
});


$ScheduleChangeSlotCopyWith<$Res> get oldValue;$ScheduleChangeSlotCopyWith<$Res> get newValue;

}
/// @nodoc
class _$ScheduleChangeCopyWithImpl<$Res>
    implements $ScheduleChangeCopyWith<$Res> {
  _$ScheduleChangeCopyWithImpl(this._self, this._then);

  final ScheduleChange _self;
  final $Res Function(ScheduleChange) _then;

/// Create a copy of ScheduleChange
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? kind = null,Object? subject = null,Object? lessonDate = null,Object? createdAt = null,Object? lessonNumber = freezed,Object? oldValue = null,Object? newValue = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,kind: null == kind ? _self.kind : kind // ignore: cast_nullable_to_non_nullable
as ScheduleChangeKind,subject: null == subject ? _self.subject : subject // ignore: cast_nullable_to_non_nullable
as String,lessonDate: null == lessonDate ? _self.lessonDate : lessonDate // ignore: cast_nullable_to_non_nullable
as DateTime,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,lessonNumber: freezed == lessonNumber ? _self.lessonNumber : lessonNumber // ignore: cast_nullable_to_non_nullable
as int?,oldValue: null == oldValue ? _self.oldValue : oldValue // ignore: cast_nullable_to_non_nullable
as ScheduleChangeSlot,newValue: null == newValue ? _self.newValue : newValue // ignore: cast_nullable_to_non_nullable
as ScheduleChangeSlot,
  ));
}
/// Create a copy of ScheduleChange
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ScheduleChangeSlotCopyWith<$Res> get oldValue {

  return $ScheduleChangeSlotCopyWith<$Res>(_self.oldValue, (value) {
    return _then(_self.copyWith(oldValue: value));
  });
}/// Create a copy of ScheduleChange
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ScheduleChangeSlotCopyWith<$Res> get newValue {

  return $ScheduleChangeSlotCopyWith<$Res>(_self.newValue, (value) {
    return _then(_self.copyWith(newValue: value));
  });
}
}


/// Adds pattern-matching-related methods to [ScheduleChange].
extension ScheduleChangePatterns on ScheduleChange {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ScheduleChange value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ScheduleChange() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ScheduleChange value)  $default,){
final _that = this;
switch (_that) {
case _ScheduleChange():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ScheduleChange value)?  $default,){
final _that = this;
switch (_that) {
case _ScheduleChange() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  ScheduleChangeKind kind,  String subject,  DateTime lessonDate,  DateTime createdAt,  int? lessonNumber,  ScheduleChangeSlot oldValue,  ScheduleChangeSlot newValue)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ScheduleChange() when $default != null:
return $default(_that.id,_that.kind,_that.subject,_that.lessonDate,_that.createdAt,_that.lessonNumber,_that.oldValue,_that.newValue);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  ScheduleChangeKind kind,  String subject,  DateTime lessonDate,  DateTime createdAt,  int? lessonNumber,  ScheduleChangeSlot oldValue,  ScheduleChangeSlot newValue)  $default,) {final _that = this;
switch (_that) {
case _ScheduleChange():
return $default(_that.id,_that.kind,_that.subject,_that.lessonDate,_that.createdAt,_that.lessonNumber,_that.oldValue,_that.newValue);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  ScheduleChangeKind kind,  String subject,  DateTime lessonDate,  DateTime createdAt,  int? lessonNumber,  ScheduleChangeSlot oldValue,  ScheduleChangeSlot newValue)?  $default,) {final _that = this;
switch (_that) {
case _ScheduleChange() when $default != null:
return $default(_that.id,_that.kind,_that.subject,_that.lessonDate,_that.createdAt,_that.lessonNumber,_that.oldValue,_that.newValue);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ScheduleChange implements ScheduleChange {
  const _ScheduleChange({required this.id, required this.kind, required this.subject, required this.lessonDate, required this.createdAt, this.lessonNumber, this.oldValue = const ScheduleChangeSlot(), this.newValue = const ScheduleChangeSlot()});
  factory _ScheduleChange.fromJson(Map<String, dynamic> json) => _$ScheduleChangeFromJson(json);

@override final  String id;
@override final  ScheduleChangeKind kind;
@override final  String subject;
@override final  DateTime lessonDate;
@override final  DateTime createdAt;
@override final  int? lessonNumber;
@override@JsonKey() final  ScheduleChangeSlot oldValue;
@override@JsonKey() final  ScheduleChangeSlot newValue;

/// Create a copy of ScheduleChange
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ScheduleChangeCopyWith<_ScheduleChange> get copyWith => __$ScheduleChangeCopyWithImpl<_ScheduleChange>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ScheduleChangeToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ScheduleChange&&(identical(other.id, id) || other.id == id)&&(identical(other.kind, kind) || other.kind == kind)&&(identical(other.subject, subject) || other.subject == subject)&&(identical(other.lessonDate, lessonDate) || other.lessonDate == lessonDate)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.lessonNumber, lessonNumber) || other.lessonNumber == lessonNumber)&&(identical(other.oldValue, oldValue) || other.oldValue == oldValue)&&(identical(other.newValue, newValue) || other.newValue == newValue));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,kind,subject,lessonDate,createdAt,lessonNumber,oldValue,newValue);

@override
String toString() {
  return 'ScheduleChange(id: $id, kind: $kind, subject: $subject, lessonDate: $lessonDate, createdAt: $createdAt, lessonNumber: $lessonNumber, oldValue: $oldValue, newValue: $newValue)';
}


}

/// @nodoc
abstract mixin class _$ScheduleChangeCopyWith<$Res> implements $ScheduleChangeCopyWith<$Res> {
  factory _$ScheduleChangeCopyWith(_ScheduleChange value, $Res Function(_ScheduleChange) _then) = __$ScheduleChangeCopyWithImpl;
@override @useResult
$Res call({
 String id, ScheduleChangeKind kind, String subject, DateTime lessonDate, DateTime createdAt, int? lessonNumber, ScheduleChangeSlot oldValue, ScheduleChangeSlot newValue
});


@override $ScheduleChangeSlotCopyWith<$Res> get oldValue;@override $ScheduleChangeSlotCopyWith<$Res> get newValue;

}
/// @nodoc
class __$ScheduleChangeCopyWithImpl<$Res>
    implements _$ScheduleChangeCopyWith<$Res> {
  __$ScheduleChangeCopyWithImpl(this._self, this._then);

  final _ScheduleChange _self;
  final $Res Function(_ScheduleChange) _then;

/// Create a copy of ScheduleChange
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? kind = null,Object? subject = null,Object? lessonDate = null,Object? createdAt = null,Object? lessonNumber = freezed,Object? oldValue = null,Object? newValue = null,}) {
  return _then(_ScheduleChange(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,kind: null == kind ? _self.kind : kind // ignore: cast_nullable_to_non_nullable
as ScheduleChangeKind,subject: null == subject ? _self.subject : subject // ignore: cast_nullable_to_non_nullable
as String,lessonDate: null == lessonDate ? _self.lessonDate : lessonDate // ignore: cast_nullable_to_non_nullable
as DateTime,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,lessonNumber: freezed == lessonNumber ? _self.lessonNumber : lessonNumber // ignore: cast_nullable_to_non_nullable
as int?,oldValue: null == oldValue ? _self.oldValue : oldValue // ignore: cast_nullable_to_non_nullable
as ScheduleChangeSlot,newValue: null == newValue ? _self.newValue : newValue // ignore: cast_nullable_to_non_nullable
as ScheduleChangeSlot,
  ));
}

/// Create a copy of ScheduleChange
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ScheduleChangeSlotCopyWith<$Res> get oldValue {

  return $ScheduleChangeSlotCopyWith<$Res>(_self.oldValue, (value) {
    return _then(_self.copyWith(oldValue: value));
  });
}/// Create a copy of ScheduleChange
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ScheduleChangeSlotCopyWith<$Res> get newValue {

  return $ScheduleChangeSlotCopyWith<$Res>(_self.newValue, (value) {
    return _then(_self.copyWith(newValue: value));
  });
}
}

// dart format on
