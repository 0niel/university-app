// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'stac_app_avatar.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$StacAppAvatar {

@JsonKey(fromJson: stringOrEmpty) String get name;@JsonKey(fromJson: _avatarSizeFromJson) double get size;@JsonKey(fromJson: stringOrNull) String? get color;
/// Create a copy of StacAppAvatar
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$StacAppAvatarCopyWith<StacAppAvatar> get copyWith => _$StacAppAvatarCopyWithImpl<StacAppAvatar>(this as StacAppAvatar, _$identity);

  /// Serializes this StacAppAvatar to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is StacAppAvatar&&(identical(other.name, name) || other.name == name)&&(identical(other.size, size) || other.size == size)&&(identical(other.color, color) || other.color == color));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,name,size,color);

@override
String toString() {
  return 'StacAppAvatar(name: $name, size: $size, color: $color)';
}


}

/// @nodoc
abstract mixin class $StacAppAvatarCopyWith<$Res>  {
  factory $StacAppAvatarCopyWith(StacAppAvatar value, $Res Function(StacAppAvatar) _then) = _$StacAppAvatarCopyWithImpl;
@useResult
$Res call({
@JsonKey(fromJson: stringOrEmpty) String name,@JsonKey(fromJson: _avatarSizeFromJson) double size,@JsonKey(fromJson: stringOrNull) String? color
});




}
/// @nodoc
class _$StacAppAvatarCopyWithImpl<$Res>
    implements $StacAppAvatarCopyWith<$Res> {
  _$StacAppAvatarCopyWithImpl(this._self, this._then);

  final StacAppAvatar _self;
  final $Res Function(StacAppAvatar) _then;

/// Create a copy of StacAppAvatar
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? name = null,Object? size = null,Object? color = freezed,}) {
  return _then(_self.copyWith(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,size: null == size ? _self.size : size // ignore: cast_nullable_to_non_nullable
as double,color: freezed == color ? _self.color : color // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [StacAppAvatar].
extension StacAppAvatarPatterns on StacAppAvatar {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _StacAppAvatar value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _StacAppAvatar() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _StacAppAvatar value)  $default,){
final _that = this;
switch (_that) {
case _StacAppAvatar():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _StacAppAvatar value)?  $default,){
final _that = this;
switch (_that) {
case _StacAppAvatar() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(fromJson: stringOrEmpty)  String name, @JsonKey(fromJson: _avatarSizeFromJson)  double size, @JsonKey(fromJson: stringOrNull)  String? color)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _StacAppAvatar() when $default != null:
return $default(_that.name,_that.size,_that.color);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(fromJson: stringOrEmpty)  String name, @JsonKey(fromJson: _avatarSizeFromJson)  double size, @JsonKey(fromJson: stringOrNull)  String? color)  $default,) {final _that = this;
switch (_that) {
case _StacAppAvatar():
return $default(_that.name,_that.size,_that.color);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(fromJson: stringOrEmpty)  String name, @JsonKey(fromJson: _avatarSizeFromJson)  double size, @JsonKey(fromJson: stringOrNull)  String? color)?  $default,) {final _that = this;
switch (_that) {
case _StacAppAvatar() when $default != null:
return $default(_that.name,_that.size,_that.color);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _StacAppAvatar implements StacAppAvatar {
  const _StacAppAvatar({@JsonKey(fromJson: stringOrEmpty) required this.name, @JsonKey(fromJson: _avatarSizeFromJson) this.size = 36, @JsonKey(fromJson: stringOrNull) this.color});
  factory _StacAppAvatar.fromJson(Map<String, dynamic> json) => _$StacAppAvatarFromJson(json);

@override@JsonKey(fromJson: stringOrEmpty) final  String name;
@override@JsonKey(fromJson: _avatarSizeFromJson) final  double size;
@override@JsonKey(fromJson: stringOrNull) final  String? color;

/// Create a copy of StacAppAvatar
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$StacAppAvatarCopyWith<_StacAppAvatar> get copyWith => __$StacAppAvatarCopyWithImpl<_StacAppAvatar>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$StacAppAvatarToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _StacAppAvatar&&(identical(other.name, name) || other.name == name)&&(identical(other.size, size) || other.size == size)&&(identical(other.color, color) || other.color == color));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,name,size,color);

@override
String toString() {
  return 'StacAppAvatar(name: $name, size: $size, color: $color)';
}


}

/// @nodoc
abstract mixin class _$StacAppAvatarCopyWith<$Res> implements $StacAppAvatarCopyWith<$Res> {
  factory _$StacAppAvatarCopyWith(_StacAppAvatar value, $Res Function(_StacAppAvatar) _then) = __$StacAppAvatarCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(fromJson: stringOrEmpty) String name,@JsonKey(fromJson: _avatarSizeFromJson) double size,@JsonKey(fromJson: stringOrNull) String? color
});




}
/// @nodoc
class __$StacAppAvatarCopyWithImpl<$Res>
    implements _$StacAppAvatarCopyWith<$Res> {
  __$StacAppAvatarCopyWithImpl(this._self, this._then);

  final _StacAppAvatar _self;
  final $Res Function(_StacAppAvatar) _then;

/// Create a copy of StacAppAvatar
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? name = null,Object? size = null,Object? color = freezed,}) {
  return _then(_StacAppAvatar(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,size: null == size ? _self.size : size // ignore: cast_nullable_to_non_nullable
as double,color: freezed == color ? _self.color : color // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
