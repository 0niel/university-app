// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'stac_app_service_tile.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$StacAppServiceTile {

@JsonKey(fromJson: stringOrEmpty) String get emoji; String? get label; String? get color;@JsonKey(fromJson: boolOrFalse) bool get solid;@JsonKey(name: 'onTap') Object? get actionJson;
/// Create a copy of StacAppServiceTile
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$StacAppServiceTileCopyWith<StacAppServiceTile> get copyWith => _$StacAppServiceTileCopyWithImpl<StacAppServiceTile>(this as StacAppServiceTile, _$identity);

  /// Serializes this StacAppServiceTile to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is StacAppServiceTile&&(identical(other.emoji, emoji) || other.emoji == emoji)&&(identical(other.label, label) || other.label == label)&&(identical(other.color, color) || other.color == color)&&(identical(other.solid, solid) || other.solid == solid)&&const DeepCollectionEquality().equals(other.actionJson, actionJson));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,emoji,label,color,solid,const DeepCollectionEquality().hash(actionJson));

@override
String toString() {
  return 'StacAppServiceTile(emoji: $emoji, label: $label, color: $color, solid: $solid, actionJson: $actionJson)';
}


}

/// @nodoc
abstract mixin class $StacAppServiceTileCopyWith<$Res>  {
  factory $StacAppServiceTileCopyWith(StacAppServiceTile value, $Res Function(StacAppServiceTile) _then) = _$StacAppServiceTileCopyWithImpl;
@useResult
$Res call({
@JsonKey(fromJson: stringOrEmpty) String emoji, String? label, String? color,@JsonKey(fromJson: boolOrFalse) bool solid,@JsonKey(name: 'onTap') Object? actionJson
});




}
/// @nodoc
class _$StacAppServiceTileCopyWithImpl<$Res>
    implements $StacAppServiceTileCopyWith<$Res> {
  _$StacAppServiceTileCopyWithImpl(this._self, this._then);

  final StacAppServiceTile _self;
  final $Res Function(StacAppServiceTile) _then;

/// Create a copy of StacAppServiceTile
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? emoji = null,Object? label = freezed,Object? color = freezed,Object? solid = null,Object? actionJson = freezed,}) {
  return _then(_self.copyWith(
emoji: null == emoji ? _self.emoji : emoji // ignore: cast_nullable_to_non_nullable
as String,label: freezed == label ? _self.label : label // ignore: cast_nullable_to_non_nullable
as String?,color: freezed == color ? _self.color : color // ignore: cast_nullable_to_non_nullable
as String?,solid: null == solid ? _self.solid : solid // ignore: cast_nullable_to_non_nullable
as bool,actionJson: freezed == actionJson ? _self.actionJson : actionJson ,
  ));
}

}


/// Adds pattern-matching-related methods to [StacAppServiceTile].
extension StacAppServiceTilePatterns on StacAppServiceTile {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _StacAppServiceTile value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _StacAppServiceTile() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _StacAppServiceTile value)  $default,){
final _that = this;
switch (_that) {
case _StacAppServiceTile():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _StacAppServiceTile value)?  $default,){
final _that = this;
switch (_that) {
case _StacAppServiceTile() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(fromJson: stringOrEmpty)  String emoji,  String? label,  String? color, @JsonKey(fromJson: boolOrFalse)  bool solid, @JsonKey(name: 'onTap')  Object? actionJson)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _StacAppServiceTile() when $default != null:
return $default(_that.emoji,_that.label,_that.color,_that.solid,_that.actionJson);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(fromJson: stringOrEmpty)  String emoji,  String? label,  String? color, @JsonKey(fromJson: boolOrFalse)  bool solid, @JsonKey(name: 'onTap')  Object? actionJson)  $default,) {final _that = this;
switch (_that) {
case _StacAppServiceTile():
return $default(_that.emoji,_that.label,_that.color,_that.solid,_that.actionJson);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(fromJson: stringOrEmpty)  String emoji,  String? label,  String? color, @JsonKey(fromJson: boolOrFalse)  bool solid, @JsonKey(name: 'onTap')  Object? actionJson)?  $default,) {final _that = this;
switch (_that) {
case _StacAppServiceTile() when $default != null:
return $default(_that.emoji,_that.label,_that.color,_that.solid,_that.actionJson);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _StacAppServiceTile implements StacAppServiceTile {
  const _StacAppServiceTile({@JsonKey(fromJson: stringOrEmpty) required this.emoji, this.label, this.color, @JsonKey(fromJson: boolOrFalse) this.solid = false, @JsonKey(name: 'onTap') this.actionJson});
  factory _StacAppServiceTile.fromJson(Map<String, dynamic> json) => _$StacAppServiceTileFromJson(json);

@override@JsonKey(fromJson: stringOrEmpty) final  String emoji;
@override final  String? label;
@override final  String? color;
@override@JsonKey(fromJson: boolOrFalse) final  bool solid;
@override@JsonKey(name: 'onTap') final  Object? actionJson;

/// Create a copy of StacAppServiceTile
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$StacAppServiceTileCopyWith<_StacAppServiceTile> get copyWith => __$StacAppServiceTileCopyWithImpl<_StacAppServiceTile>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$StacAppServiceTileToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _StacAppServiceTile&&(identical(other.emoji, emoji) || other.emoji == emoji)&&(identical(other.label, label) || other.label == label)&&(identical(other.color, color) || other.color == color)&&(identical(other.solid, solid) || other.solid == solid)&&const DeepCollectionEquality().equals(other.actionJson, actionJson));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,emoji,label,color,solid,const DeepCollectionEquality().hash(actionJson));

@override
String toString() {
  return 'StacAppServiceTile(emoji: $emoji, label: $label, color: $color, solid: $solid, actionJson: $actionJson)';
}


}

/// @nodoc
abstract mixin class _$StacAppServiceTileCopyWith<$Res> implements $StacAppServiceTileCopyWith<$Res> {
  factory _$StacAppServiceTileCopyWith(_StacAppServiceTile value, $Res Function(_StacAppServiceTile) _then) = __$StacAppServiceTileCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(fromJson: stringOrEmpty) String emoji, String? label, String? color,@JsonKey(fromJson: boolOrFalse) bool solid,@JsonKey(name: 'onTap') Object? actionJson
});




}
/// @nodoc
class __$StacAppServiceTileCopyWithImpl<$Res>
    implements _$StacAppServiceTileCopyWith<$Res> {
  __$StacAppServiceTileCopyWithImpl(this._self, this._then);

  final _StacAppServiceTile _self;
  final $Res Function(_StacAppServiceTile) _then;

/// Create a copy of StacAppServiceTile
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? emoji = null,Object? label = freezed,Object? color = freezed,Object? solid = null,Object? actionJson = freezed,}) {
  return _then(_StacAppServiceTile(
emoji: null == emoji ? _self.emoji : emoji // ignore: cast_nullable_to_non_nullable
as String,label: freezed == label ? _self.label : label // ignore: cast_nullable_to_non_nullable
as String?,color: freezed == color ? _self.color : color // ignore: cast_nullable_to_non_nullable
as String?,solid: null == solid ? _self.solid : solid // ignore: cast_nullable_to_non_nullable
as bool,actionJson: freezed == actionJson ? _self.actionJson : actionJson ,
  ));
}


}

// dart format on
