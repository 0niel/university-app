// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'unknown_schedule_part.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$UnknownSchedulePart {

@DatesConverter() List<DateTime> get dates; String get type;
/// Create a copy of UnknownSchedulePart
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$UnknownSchedulePartCopyWith<UnknownSchedulePart> get copyWith => _$UnknownSchedulePartCopyWithImpl<UnknownSchedulePart>(this as UnknownSchedulePart, _$identity);

  /// Serializes this UnknownSchedulePart to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is UnknownSchedulePart&&const DeepCollectionEquality().equals(other.dates, dates)&&(identical(other.type, type) || other.type == type));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(dates),type);

@override
String toString() {
  return 'UnknownSchedulePart(dates: $dates, type: $type)';
}


}

/// @nodoc
abstract mixin class $UnknownSchedulePartCopyWith<$Res>  {
  factory $UnknownSchedulePartCopyWith(UnknownSchedulePart value, $Res Function(UnknownSchedulePart) _then) = _$UnknownSchedulePartCopyWithImpl;
@useResult
$Res call({
@DatesConverter() List<DateTime> dates, String type
});




}
/// @nodoc
class _$UnknownSchedulePartCopyWithImpl<$Res>
    implements $UnknownSchedulePartCopyWith<$Res> {
  _$UnknownSchedulePartCopyWithImpl(this._self, this._then);

  final UnknownSchedulePart _self;
  final $Res Function(UnknownSchedulePart) _then;

/// Create a copy of UnknownSchedulePart
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? dates = null,Object? type = null,}) {
  return _then(_self.copyWith(
dates: null == dates ? _self.dates : dates // ignore: cast_nullable_to_non_nullable
as List<DateTime>,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [UnknownSchedulePart].
extension UnknownSchedulePartPatterns on UnknownSchedulePart {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _UnknownSchedulePart value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _UnknownSchedulePart() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _UnknownSchedulePart value)  $default,){
final _that = this;
switch (_that) {
case _UnknownSchedulePart():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _UnknownSchedulePart value)?  $default,){
final _that = this;
switch (_that) {
case _UnknownSchedulePart() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@DatesConverter()  List<DateTime> dates,  String type)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _UnknownSchedulePart() when $default != null:
return $default(_that.dates,_that.type);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@DatesConverter()  List<DateTime> dates,  String type)  $default,) {final _that = this;
switch (_that) {
case _UnknownSchedulePart():
return $default(_that.dates,_that.type);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@DatesConverter()  List<DateTime> dates,  String type)?  $default,) {final _that = this;
switch (_that) {
case _UnknownSchedulePart() when $default != null:
return $default(_that.dates,_that.type);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _UnknownSchedulePart implements UnknownSchedulePart {
  const _UnknownSchedulePart({@DatesConverter() final  List<DateTime> dates = const <DateTime>[], this.type = UnknownSchedulePart.identifier}): _dates = dates;
  factory _UnknownSchedulePart.fromJson(Map<String, dynamic> json) => _$UnknownSchedulePartFromJson(json);

 final  List<DateTime> _dates;
@override@JsonKey()@DatesConverter() List<DateTime> get dates {
  if (_dates is EqualUnmodifiableListView) return _dates;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_dates);
}

@override@JsonKey() final  String type;

/// Create a copy of UnknownSchedulePart
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$UnknownSchedulePartCopyWith<_UnknownSchedulePart> get copyWith => __$UnknownSchedulePartCopyWithImpl<_UnknownSchedulePart>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$UnknownSchedulePartToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _UnknownSchedulePart&&const DeepCollectionEquality().equals(other._dates, _dates)&&(identical(other.type, type) || other.type == type));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_dates),type);

@override
String toString() {
  return 'UnknownSchedulePart(dates: $dates, type: $type)';
}


}

/// @nodoc
abstract mixin class _$UnknownSchedulePartCopyWith<$Res> implements $UnknownSchedulePartCopyWith<$Res> {
  factory _$UnknownSchedulePartCopyWith(_UnknownSchedulePart value, $Res Function(_UnknownSchedulePart) _then) = __$UnknownSchedulePartCopyWithImpl;
@override @useResult
$Res call({
@DatesConverter() List<DateTime> dates, String type
});




}
/// @nodoc
class __$UnknownSchedulePartCopyWithImpl<$Res>
    implements _$UnknownSchedulePartCopyWith<$Res> {
  __$UnknownSchedulePartCopyWithImpl(this._self, this._then);

  final _UnknownSchedulePart _self;
  final $Res Function(_UnknownSchedulePart) _then;

/// Create a copy of UnknownSchedulePart
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? dates = null,Object? type = null,}) {
  return _then(_UnknownSchedulePart(
dates: null == dates ? _self._dates : dates // ignore: cast_nullable_to_non_nullable
as List<DateTime>,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
