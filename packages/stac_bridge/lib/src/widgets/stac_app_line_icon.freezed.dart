// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'stac_app_line_icon.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$StacAppLineIcon {

@JsonKey(fromJson: stringOrEmpty) String get icon;@JsonKey(fromJson: _iconSizeFromJson) double get size;@JsonKey(fromJson: stringOrNull) String? get color;
/// Create a copy of StacAppLineIcon
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$StacAppLineIconCopyWith<StacAppLineIcon> get copyWith => _$StacAppLineIconCopyWithImpl<StacAppLineIcon>(this as StacAppLineIcon, _$identity);

  /// Serializes this StacAppLineIcon to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is StacAppLineIcon&&(identical(other.icon, icon) || other.icon == icon)&&(identical(other.size, size) || other.size == size)&&(identical(other.color, color) || other.color == color));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,icon,size,color);

@override
String toString() {
  return 'StacAppLineIcon(icon: $icon, size: $size, color: $color)';
}


}

/// @nodoc
abstract mixin class $StacAppLineIconCopyWith<$Res>  {
  factory $StacAppLineIconCopyWith(StacAppLineIcon value, $Res Function(StacAppLineIcon) _then) = _$StacAppLineIconCopyWithImpl;
@useResult
$Res call({
@JsonKey(fromJson: stringOrEmpty) String icon,@JsonKey(fromJson: _iconSizeFromJson) double size,@JsonKey(fromJson: stringOrNull) String? color
});




}
/// @nodoc
class _$StacAppLineIconCopyWithImpl<$Res>
    implements $StacAppLineIconCopyWith<$Res> {
  _$StacAppLineIconCopyWithImpl(this._self, this._then);

  final StacAppLineIcon _self;
  final $Res Function(StacAppLineIcon) _then;

/// Create a copy of StacAppLineIcon
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? icon = null,Object? size = null,Object? color = freezed,}) {
  return _then(_self.copyWith(
icon: null == icon ? _self.icon : icon // ignore: cast_nullable_to_non_nullable
as String,size: null == size ? _self.size : size // ignore: cast_nullable_to_non_nullable
as double,color: freezed == color ? _self.color : color // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [StacAppLineIcon].
extension StacAppLineIconPatterns on StacAppLineIcon {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _StacAppLineIcon value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _StacAppLineIcon() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _StacAppLineIcon value)  $default,){
final _that = this;
switch (_that) {
case _StacAppLineIcon():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _StacAppLineIcon value)?  $default,){
final _that = this;
switch (_that) {
case _StacAppLineIcon() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(fromJson: stringOrEmpty)  String icon, @JsonKey(fromJson: _iconSizeFromJson)  double size, @JsonKey(fromJson: stringOrNull)  String? color)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _StacAppLineIcon() when $default != null:
return $default(_that.icon,_that.size,_that.color);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(fromJson: stringOrEmpty)  String icon, @JsonKey(fromJson: _iconSizeFromJson)  double size, @JsonKey(fromJson: stringOrNull)  String? color)  $default,) {final _that = this;
switch (_that) {
case _StacAppLineIcon():
return $default(_that.icon,_that.size,_that.color);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(fromJson: stringOrEmpty)  String icon, @JsonKey(fromJson: _iconSizeFromJson)  double size, @JsonKey(fromJson: stringOrNull)  String? color)?  $default,) {final _that = this;
switch (_that) {
case _StacAppLineIcon() when $default != null:
return $default(_that.icon,_that.size,_that.color);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _StacAppLineIcon implements StacAppLineIcon {
  const _StacAppLineIcon({@JsonKey(fromJson: stringOrEmpty) required this.icon, @JsonKey(fromJson: _iconSizeFromJson) this.size = 22, @JsonKey(fromJson: stringOrNull) this.color});
  factory _StacAppLineIcon.fromJson(Map<String, dynamic> json) => _$StacAppLineIconFromJson(json);

@override@JsonKey(fromJson: stringOrEmpty) final  String icon;
@override@JsonKey(fromJson: _iconSizeFromJson) final  double size;
@override@JsonKey(fromJson: stringOrNull) final  String? color;

/// Create a copy of StacAppLineIcon
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$StacAppLineIconCopyWith<_StacAppLineIcon> get copyWith => __$StacAppLineIconCopyWithImpl<_StacAppLineIcon>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$StacAppLineIconToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _StacAppLineIcon&&(identical(other.icon, icon) || other.icon == icon)&&(identical(other.size, size) || other.size == size)&&(identical(other.color, color) || other.color == color));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,icon,size,color);

@override
String toString() {
  return 'StacAppLineIcon(icon: $icon, size: $size, color: $color)';
}


}

/// @nodoc
abstract mixin class _$StacAppLineIconCopyWith<$Res> implements $StacAppLineIconCopyWith<$Res> {
  factory _$StacAppLineIconCopyWith(_StacAppLineIcon value, $Res Function(_StacAppLineIcon) _then) = __$StacAppLineIconCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(fromJson: stringOrEmpty) String icon,@JsonKey(fromJson: _iconSizeFromJson) double size,@JsonKey(fromJson: stringOrNull) String? color
});




}
/// @nodoc
class __$StacAppLineIconCopyWithImpl<$Res>
    implements _$StacAppLineIconCopyWith<$Res> {
  __$StacAppLineIconCopyWithImpl(this._self, this._then);

  final _StacAppLineIcon _self;
  final $Res Function(_StacAppLineIcon) _then;

/// Create a copy of StacAppLineIcon
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? icon = null,Object? size = null,Object? color = freezed,}) {
  return _then(_StacAppLineIcon(
icon: null == icon ? _self.icon : icon // ignore: cast_nullable_to_non_nullable
as String,size: null == size ? _self.size : size // ignore: cast_nullable_to_non_nullable
as double,color: freezed == color ? _self.color : color // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
