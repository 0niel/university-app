// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'stac_app_progress_ring.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$StacAppProgressRing {

@JsonKey(fromJson: _zeroWhenNotNumber) double get value;@JsonKey(fromJson: _ringSizeFromJson) double get size;@JsonKey(fromJson: _strokeWidthFromJson) double get strokeWidth;@JsonKey(fromJson: stringOrNull) String? get color;@JsonKey(fromJson: stringOrNull) String? get label;@JsonKey(fromJson: stringOrNull) String? get sublabel;
/// Create a copy of StacAppProgressRing
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$StacAppProgressRingCopyWith<StacAppProgressRing> get copyWith => _$StacAppProgressRingCopyWithImpl<StacAppProgressRing>(this as StacAppProgressRing, _$identity);

  /// Serializes this StacAppProgressRing to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is StacAppProgressRing&&(identical(other.value, value) || other.value == value)&&(identical(other.size, size) || other.size == size)&&(identical(other.strokeWidth, strokeWidth) || other.strokeWidth == strokeWidth)&&(identical(other.color, color) || other.color == color)&&(identical(other.label, label) || other.label == label)&&(identical(other.sublabel, sublabel) || other.sublabel == sublabel));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,value,size,strokeWidth,color,label,sublabel);

@override
String toString() {
  return 'StacAppProgressRing(value: $value, size: $size, strokeWidth: $strokeWidth, color: $color, label: $label, sublabel: $sublabel)';
}


}

/// @nodoc
abstract mixin class $StacAppProgressRingCopyWith<$Res>  {
  factory $StacAppProgressRingCopyWith(StacAppProgressRing value, $Res Function(StacAppProgressRing) _then) = _$StacAppProgressRingCopyWithImpl;
@useResult
$Res call({
@JsonKey(fromJson: _zeroWhenNotNumber) double value,@JsonKey(fromJson: _ringSizeFromJson) double size,@JsonKey(fromJson: _strokeWidthFromJson) double strokeWidth,@JsonKey(fromJson: stringOrNull) String? color,@JsonKey(fromJson: stringOrNull) String? label,@JsonKey(fromJson: stringOrNull) String? sublabel
});




}
/// @nodoc
class _$StacAppProgressRingCopyWithImpl<$Res>
    implements $StacAppProgressRingCopyWith<$Res> {
  _$StacAppProgressRingCopyWithImpl(this._self, this._then);

  final StacAppProgressRing _self;
  final $Res Function(StacAppProgressRing) _then;

/// Create a copy of StacAppProgressRing
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? value = null,Object? size = null,Object? strokeWidth = null,Object? color = freezed,Object? label = freezed,Object? sublabel = freezed,}) {
  return _then(_self.copyWith(
value: null == value ? _self.value : value // ignore: cast_nullable_to_non_nullable
as double,size: null == size ? _self.size : size // ignore: cast_nullable_to_non_nullable
as double,strokeWidth: null == strokeWidth ? _self.strokeWidth : strokeWidth // ignore: cast_nullable_to_non_nullable
as double,color: freezed == color ? _self.color : color // ignore: cast_nullable_to_non_nullable
as String?,label: freezed == label ? _self.label : label // ignore: cast_nullable_to_non_nullable
as String?,sublabel: freezed == sublabel ? _self.sublabel : sublabel // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [StacAppProgressRing].
extension StacAppProgressRingPatterns on StacAppProgressRing {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _StacAppProgressRing value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _StacAppProgressRing() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _StacAppProgressRing value)  $default,){
final _that = this;
switch (_that) {
case _StacAppProgressRing():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _StacAppProgressRing value)?  $default,){
final _that = this;
switch (_that) {
case _StacAppProgressRing() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(fromJson: _zeroWhenNotNumber)  double value, @JsonKey(fromJson: _ringSizeFromJson)  double size, @JsonKey(fromJson: _strokeWidthFromJson)  double strokeWidth, @JsonKey(fromJson: stringOrNull)  String? color, @JsonKey(fromJson: stringOrNull)  String? label, @JsonKey(fromJson: stringOrNull)  String? sublabel)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _StacAppProgressRing() when $default != null:
return $default(_that.value,_that.size,_that.strokeWidth,_that.color,_that.label,_that.sublabel);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(fromJson: _zeroWhenNotNumber)  double value, @JsonKey(fromJson: _ringSizeFromJson)  double size, @JsonKey(fromJson: _strokeWidthFromJson)  double strokeWidth, @JsonKey(fromJson: stringOrNull)  String? color, @JsonKey(fromJson: stringOrNull)  String? label, @JsonKey(fromJson: stringOrNull)  String? sublabel)  $default,) {final _that = this;
switch (_that) {
case _StacAppProgressRing():
return $default(_that.value,_that.size,_that.strokeWidth,_that.color,_that.label,_that.sublabel);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(fromJson: _zeroWhenNotNumber)  double value, @JsonKey(fromJson: _ringSizeFromJson)  double size, @JsonKey(fromJson: _strokeWidthFromJson)  double strokeWidth, @JsonKey(fromJson: stringOrNull)  String? color, @JsonKey(fromJson: stringOrNull)  String? label, @JsonKey(fromJson: stringOrNull)  String? sublabel)?  $default,) {final _that = this;
switch (_that) {
case _StacAppProgressRing() when $default != null:
return $default(_that.value,_that.size,_that.strokeWidth,_that.color,_that.label,_that.sublabel);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _StacAppProgressRing implements StacAppProgressRing {
  const _StacAppProgressRing({@JsonKey(fromJson: _zeroWhenNotNumber) required this.value, @JsonKey(fromJson: _ringSizeFromJson) this.size = 56, @JsonKey(fromJson: _strokeWidthFromJson) this.strokeWidth = 5, @JsonKey(fromJson: stringOrNull) this.color, @JsonKey(fromJson: stringOrNull) this.label, @JsonKey(fromJson: stringOrNull) this.sublabel});
  factory _StacAppProgressRing.fromJson(Map<String, dynamic> json) => _$StacAppProgressRingFromJson(json);

@override@JsonKey(fromJson: _zeroWhenNotNumber) final  double value;
@override@JsonKey(fromJson: _ringSizeFromJson) final  double size;
@override@JsonKey(fromJson: _strokeWidthFromJson) final  double strokeWidth;
@override@JsonKey(fromJson: stringOrNull) final  String? color;
@override@JsonKey(fromJson: stringOrNull) final  String? label;
@override@JsonKey(fromJson: stringOrNull) final  String? sublabel;

/// Create a copy of StacAppProgressRing
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$StacAppProgressRingCopyWith<_StacAppProgressRing> get copyWith => __$StacAppProgressRingCopyWithImpl<_StacAppProgressRing>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$StacAppProgressRingToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _StacAppProgressRing&&(identical(other.value, value) || other.value == value)&&(identical(other.size, size) || other.size == size)&&(identical(other.strokeWidth, strokeWidth) || other.strokeWidth == strokeWidth)&&(identical(other.color, color) || other.color == color)&&(identical(other.label, label) || other.label == label)&&(identical(other.sublabel, sublabel) || other.sublabel == sublabel));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,value,size,strokeWidth,color,label,sublabel);

@override
String toString() {
  return 'StacAppProgressRing(value: $value, size: $size, strokeWidth: $strokeWidth, color: $color, label: $label, sublabel: $sublabel)';
}


}

/// @nodoc
abstract mixin class _$StacAppProgressRingCopyWith<$Res> implements $StacAppProgressRingCopyWith<$Res> {
  factory _$StacAppProgressRingCopyWith(_StacAppProgressRing value, $Res Function(_StacAppProgressRing) _then) = __$StacAppProgressRingCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(fromJson: _zeroWhenNotNumber) double value,@JsonKey(fromJson: _ringSizeFromJson) double size,@JsonKey(fromJson: _strokeWidthFromJson) double strokeWidth,@JsonKey(fromJson: stringOrNull) String? color,@JsonKey(fromJson: stringOrNull) String? label,@JsonKey(fromJson: stringOrNull) String? sublabel
});




}
/// @nodoc
class __$StacAppProgressRingCopyWithImpl<$Res>
    implements _$StacAppProgressRingCopyWith<$Res> {
  __$StacAppProgressRingCopyWithImpl(this._self, this._then);

  final _StacAppProgressRing _self;
  final $Res Function(_StacAppProgressRing) _then;

/// Create a copy of StacAppProgressRing
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? value = null,Object? size = null,Object? strokeWidth = null,Object? color = freezed,Object? label = freezed,Object? sublabel = freezed,}) {
  return _then(_StacAppProgressRing(
value: null == value ? _self.value : value // ignore: cast_nullable_to_non_nullable
as double,size: null == size ? _self.size : size // ignore: cast_nullable_to_non_nullable
as double,strokeWidth: null == strokeWidth ? _self.strokeWidth : strokeWidth // ignore: cast_nullable_to_non_nullable
as double,color: freezed == color ? _self.color : color // ignore: cast_nullable_to_non_nullable
as String?,label: freezed == label ? _self.label : label // ignore: cast_nullable_to_non_nullable
as String?,sublabel: freezed == sublabel ? _self.sublabel : sublabel // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
