// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'lesson_bells.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$LessonBells {

@JsonKey(fromJson: _timeFromJson, toJson: _timeToJson) TimeOfDay get startTime;@JsonKey(fromJson: _timeFromJson, toJson: _timeToJson) TimeOfDay get endTime; int? get number;
/// Create a copy of LessonBells
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$LessonBellsCopyWith<LessonBells> get copyWith => _$LessonBellsCopyWithImpl<LessonBells>(this as LessonBells, _$identity);

  /// Serializes this LessonBells to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is LessonBells&&(identical(other.startTime, startTime) || other.startTime == startTime)&&(identical(other.endTime, endTime) || other.endTime == endTime)&&(identical(other.number, number) || other.number == number));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,startTime,endTime,number);



}

/// @nodoc
abstract mixin class $LessonBellsCopyWith<$Res>  {
  factory $LessonBellsCopyWith(LessonBells value, $Res Function(LessonBells) _then) = _$LessonBellsCopyWithImpl;
@useResult
$Res call({
@JsonKey(fromJson: _timeFromJson, toJson: _timeToJson) TimeOfDay startTime,@JsonKey(fromJson: _timeFromJson, toJson: _timeToJson) TimeOfDay endTime, int? number
});




}
/// @nodoc
class _$LessonBellsCopyWithImpl<$Res>
    implements $LessonBellsCopyWith<$Res> {
  _$LessonBellsCopyWithImpl(this._self, this._then);

  final LessonBells _self;
  final $Res Function(LessonBells) _then;

/// Create a copy of LessonBells
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? startTime = null,Object? endTime = null,Object? number = freezed,}) {
  return _then(_self.copyWith(
startTime: null == startTime ? _self.startTime : startTime // ignore: cast_nullable_to_non_nullable
as TimeOfDay,endTime: null == endTime ? _self.endTime : endTime // ignore: cast_nullable_to_non_nullable
as TimeOfDay,number: freezed == number ? _self.number : number // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}

}


/// Adds pattern-matching-related methods to [LessonBells].
extension LessonBellsPatterns on LessonBells {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _LessonBells value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _LessonBells() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _LessonBells value)  $default,){
final _that = this;
switch (_that) {
case _LessonBells():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _LessonBells value)?  $default,){
final _that = this;
switch (_that) {
case _LessonBells() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(fromJson: _timeFromJson, toJson: _timeToJson)  TimeOfDay startTime, @JsonKey(fromJson: _timeFromJson, toJson: _timeToJson)  TimeOfDay endTime,  int? number)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _LessonBells() when $default != null:
return $default(_that.startTime,_that.endTime,_that.number);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(fromJson: _timeFromJson, toJson: _timeToJson)  TimeOfDay startTime, @JsonKey(fromJson: _timeFromJson, toJson: _timeToJson)  TimeOfDay endTime,  int? number)  $default,) {final _that = this;
switch (_that) {
case _LessonBells():
return $default(_that.startTime,_that.endTime,_that.number);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(fromJson: _timeFromJson, toJson: _timeToJson)  TimeOfDay startTime, @JsonKey(fromJson: _timeFromJson, toJson: _timeToJson)  TimeOfDay endTime,  int? number)?  $default,) {final _that = this;
switch (_that) {
case _LessonBells() when $default != null:
return $default(_that.startTime,_that.endTime,_that.number);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _LessonBells extends LessonBells {
  const _LessonBells({@JsonKey(fromJson: _timeFromJson, toJson: _timeToJson) required this.startTime, @JsonKey(fromJson: _timeFromJson, toJson: _timeToJson) required this.endTime, this.number}): assert(number == null || number > 0, 'Lesson number must be greater than 0'),assert(startTime < endTime, 'Lesson start time must be less than lesson end time'),super._();
  factory _LessonBells.fromJson(Map<String, dynamic> json) => _$LessonBellsFromJson(json);

@override@JsonKey(fromJson: _timeFromJson, toJson: _timeToJson) final  TimeOfDay startTime;
@override@JsonKey(fromJson: _timeFromJson, toJson: _timeToJson) final  TimeOfDay endTime;
@override final  int? number;

/// Create a copy of LessonBells
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$LessonBellsCopyWith<_LessonBells> get copyWith => __$LessonBellsCopyWithImpl<_LessonBells>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$LessonBellsToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _LessonBells&&(identical(other.startTime, startTime) || other.startTime == startTime)&&(identical(other.endTime, endTime) || other.endTime == endTime)&&(identical(other.number, number) || other.number == number));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,startTime,endTime,number);



}

/// @nodoc
abstract mixin class _$LessonBellsCopyWith<$Res> implements $LessonBellsCopyWith<$Res> {
  factory _$LessonBellsCopyWith(_LessonBells value, $Res Function(_LessonBells) _then) = __$LessonBellsCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(fromJson: _timeFromJson, toJson: _timeToJson) TimeOfDay startTime,@JsonKey(fromJson: _timeFromJson, toJson: _timeToJson) TimeOfDay endTime, int? number
});




}
/// @nodoc
class __$LessonBellsCopyWithImpl<$Res>
    implements _$LessonBellsCopyWith<$Res> {
  __$LessonBellsCopyWithImpl(this._self, this._then);

  final _LessonBells _self;
  final $Res Function(_LessonBells) _then;

/// Create a copy of LessonBells
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? startTime = null,Object? endTime = null,Object? number = freezed,}) {
  return _then(_LessonBells(
startTime: null == startTime ? _self.startTime : startTime // ignore: cast_nullable_to_non_nullable
as TimeOfDay,endTime: null == endTime ? _self.endTime : endTime // ignore: cast_nullable_to_non_nullable
as TimeOfDay,number: freezed == number ? _self.number : number // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}


}

// dart format on
