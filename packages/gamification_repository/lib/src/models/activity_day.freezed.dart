// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'activity_day.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ActivityDay {

@JsonKey(fromJson: dateOnlyFromJson) DateTime get day; int get count;
/// Create a copy of ActivityDay
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ActivityDayCopyWith<ActivityDay> get copyWith => _$ActivityDayCopyWithImpl<ActivityDay>(this as ActivityDay, _$identity);

  /// Serializes this ActivityDay to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ActivityDay&&(identical(other.day, day) || other.day == day)&&(identical(other.count, count) || other.count == count));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,day,count);

@override
String toString() {
  return 'ActivityDay(day: $day, count: $count)';
}


}

/// @nodoc
abstract mixin class $ActivityDayCopyWith<$Res>  {
  factory $ActivityDayCopyWith(ActivityDay value, $Res Function(ActivityDay) _then) = _$ActivityDayCopyWithImpl;
@useResult
$Res call({
@JsonKey(fromJson: dateOnlyFromJson) DateTime day, int count
});




}
/// @nodoc
class _$ActivityDayCopyWithImpl<$Res>
    implements $ActivityDayCopyWith<$Res> {
  _$ActivityDayCopyWithImpl(this._self, this._then);

  final ActivityDay _self;
  final $Res Function(ActivityDay) _then;

/// Create a copy of ActivityDay
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? day = null,Object? count = null,}) {
  return _then(_self.copyWith(
day: null == day ? _self.day : day // ignore: cast_nullable_to_non_nullable
as DateTime,count: null == count ? _self.count : count // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [ActivityDay].
extension ActivityDayPatterns on ActivityDay {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ActivityDay value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ActivityDay() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ActivityDay value)  $default,){
final _that = this;
switch (_that) {
case _ActivityDay():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ActivityDay value)?  $default,){
final _that = this;
switch (_that) {
case _ActivityDay() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(fromJson: dateOnlyFromJson)  DateTime day,  int count)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ActivityDay() when $default != null:
return $default(_that.day,_that.count);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(fromJson: dateOnlyFromJson)  DateTime day,  int count)  $default,) {final _that = this;
switch (_that) {
case _ActivityDay():
return $default(_that.day,_that.count);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(fromJson: dateOnlyFromJson)  DateTime day,  int count)?  $default,) {final _that = this;
switch (_that) {
case _ActivityDay() when $default != null:
return $default(_that.day,_that.count);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ActivityDay extends ActivityDay {
  const _ActivityDay({@JsonKey(fromJson: dateOnlyFromJson) required this.day, this.count = 0}): super._();
  factory _ActivityDay.fromJson(Map<String, dynamic> json) => _$ActivityDayFromJson(json);

@override@JsonKey(fromJson: dateOnlyFromJson) final  DateTime day;
@override@JsonKey() final  int count;

/// Create a copy of ActivityDay
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ActivityDayCopyWith<_ActivityDay> get copyWith => __$ActivityDayCopyWithImpl<_ActivityDay>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ActivityDayToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ActivityDay&&(identical(other.day, day) || other.day == day)&&(identical(other.count, count) || other.count == count));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,day,count);

@override
String toString() {
  return 'ActivityDay(day: $day, count: $count)';
}


}

/// @nodoc
abstract mixin class _$ActivityDayCopyWith<$Res> implements $ActivityDayCopyWith<$Res> {
  factory _$ActivityDayCopyWith(_ActivityDay value, $Res Function(_ActivityDay) _then) = __$ActivityDayCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(fromJson: dateOnlyFromJson) DateTime day, int count
});




}
/// @nodoc
class __$ActivityDayCopyWithImpl<$Res>
    implements _$ActivityDayCopyWith<$Res> {
  __$ActivityDayCopyWithImpl(this._self, this._then);

  final _ActivityDay _self;
  final $Res Function(_ActivityDay) _then;

/// Create a copy of ActivityDay
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? day = null,Object? count = null,}) {
  return _then(_ActivityDay(
day: null == day ? _self.day : day // ignore: cast_nullable_to_non_nullable
as DateTime,count: null == count ? _self.count : count // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
