// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'holiday_schedule_part.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$HolidaySchedulePart {

 String get title;@DatesConverter() List<DateTime> get dates; String get type;
/// Create a copy of HolidaySchedulePart
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$HolidaySchedulePartCopyWith<HolidaySchedulePart> get copyWith => _$HolidaySchedulePartCopyWithImpl<HolidaySchedulePart>(this as HolidaySchedulePart, _$identity);

  /// Serializes this HolidaySchedulePart to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is HolidaySchedulePart&&(identical(other.title, title) || other.title == title)&&const DeepCollectionEquality().equals(other.dates, dates)&&(identical(other.type, type) || other.type == type));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,title,const DeepCollectionEquality().hash(dates),type);

@override
String toString() {
  return 'HolidaySchedulePart(title: $title, dates: $dates, type: $type)';
}


}

/// @nodoc
abstract mixin class $HolidaySchedulePartCopyWith<$Res>  {
  factory $HolidaySchedulePartCopyWith(HolidaySchedulePart value, $Res Function(HolidaySchedulePart) _then) = _$HolidaySchedulePartCopyWithImpl;
@useResult
$Res call({
 String title,@DatesConverter() List<DateTime> dates, String type
});




}
/// @nodoc
class _$HolidaySchedulePartCopyWithImpl<$Res>
    implements $HolidaySchedulePartCopyWith<$Res> {
  _$HolidaySchedulePartCopyWithImpl(this._self, this._then);

  final HolidaySchedulePart _self;
  final $Res Function(HolidaySchedulePart) _then;

/// Create a copy of HolidaySchedulePart
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? title = null,Object? dates = null,Object? type = null,}) {
  return _then(_self.copyWith(
title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,dates: null == dates ? _self.dates : dates // ignore: cast_nullable_to_non_nullable
as List<DateTime>,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [HolidaySchedulePart].
extension HolidaySchedulePartPatterns on HolidaySchedulePart {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _HolidaySchedulePart value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _HolidaySchedulePart() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _HolidaySchedulePart value)  $default,){
final _that = this;
switch (_that) {
case _HolidaySchedulePart():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _HolidaySchedulePart value)?  $default,){
final _that = this;
switch (_that) {
case _HolidaySchedulePart() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String title, @DatesConverter()  List<DateTime> dates,  String type)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _HolidaySchedulePart() when $default != null:
return $default(_that.title,_that.dates,_that.type);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String title, @DatesConverter()  List<DateTime> dates,  String type)  $default,) {final _that = this;
switch (_that) {
case _HolidaySchedulePart():
return $default(_that.title,_that.dates,_that.type);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String title, @DatesConverter()  List<DateTime> dates,  String type)?  $default,) {final _that = this;
switch (_that) {
case _HolidaySchedulePart() when $default != null:
return $default(_that.title,_that.dates,_that.type);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _HolidaySchedulePart implements HolidaySchedulePart {
  const _HolidaySchedulePart({required this.title, @DatesConverter() required final  List<DateTime> dates, this.type = HolidaySchedulePart.identifier}): _dates = dates;
  factory _HolidaySchedulePart.fromJson(Map<String, dynamic> json) => _$HolidaySchedulePartFromJson(json);

@override final  String title;
 final  List<DateTime> _dates;
@override@DatesConverter() List<DateTime> get dates {
  if (_dates is EqualUnmodifiableListView) return _dates;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_dates);
}

@override@JsonKey() final  String type;

/// Create a copy of HolidaySchedulePart
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$HolidaySchedulePartCopyWith<_HolidaySchedulePart> get copyWith => __$HolidaySchedulePartCopyWithImpl<_HolidaySchedulePart>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$HolidaySchedulePartToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _HolidaySchedulePart&&(identical(other.title, title) || other.title == title)&&const DeepCollectionEquality().equals(other._dates, _dates)&&(identical(other.type, type) || other.type == type));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,title,const DeepCollectionEquality().hash(_dates),type);

@override
String toString() {
  return 'HolidaySchedulePart(title: $title, dates: $dates, type: $type)';
}


}

/// @nodoc
abstract mixin class _$HolidaySchedulePartCopyWith<$Res> implements $HolidaySchedulePartCopyWith<$Res> {
  factory _$HolidaySchedulePartCopyWith(_HolidaySchedulePart value, $Res Function(_HolidaySchedulePart) _then) = __$HolidaySchedulePartCopyWithImpl;
@override @useResult
$Res call({
 String title,@DatesConverter() List<DateTime> dates, String type
});




}
/// @nodoc
class __$HolidaySchedulePartCopyWithImpl<$Res>
    implements _$HolidaySchedulePartCopyWith<$Res> {
  __$HolidaySchedulePartCopyWithImpl(this._self, this._then);

  final _HolidaySchedulePart _self;
  final $Res Function(_HolidaySchedulePart) _then;

/// Create a copy of HolidaySchedulePart
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? title = null,Object? dates = null,Object? type = null,}) {
  return _then(_HolidaySchedulePart(
title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,dates: null == dates ? _self._dates : dates // ignore: cast_nullable_to_non_nullable
as List<DateTime>,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
