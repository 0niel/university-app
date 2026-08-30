// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'banner_ad_block.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$BannerAdBlock {

 BannerSize get size; String get type;
/// Create a copy of BannerAdBlock
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$BannerAdBlockCopyWith<BannerAdBlock> get copyWith => _$BannerAdBlockCopyWithImpl<BannerAdBlock>(this as BannerAdBlock, _$identity);

  /// Serializes this BannerAdBlock to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is BannerAdBlock&&(identical(other.size, size) || other.size == size)&&(identical(other.type, type) || other.type == type));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,size,type);

@override
String toString() {
  return 'BannerAdBlock(size: $size, type: $type)';
}


}

/// @nodoc
abstract mixin class $BannerAdBlockCopyWith<$Res>  {
  factory $BannerAdBlockCopyWith(BannerAdBlock value, $Res Function(BannerAdBlock) _then) = _$BannerAdBlockCopyWithImpl;
@useResult
$Res call({
 BannerSize size, String type
});




}
/// @nodoc
class _$BannerAdBlockCopyWithImpl<$Res>
    implements $BannerAdBlockCopyWith<$Res> {
  _$BannerAdBlockCopyWithImpl(this._self, this._then);

  final BannerAdBlock _self;
  final $Res Function(BannerAdBlock) _then;

/// Create a copy of BannerAdBlock
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? size = null,Object? type = null,}) {
  return _then(_self.copyWith(
size: null == size ? _self.size : size // ignore: cast_nullable_to_non_nullable
as BannerSize,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [BannerAdBlock].
extension BannerAdBlockPatterns on BannerAdBlock {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _BannerAdBlock value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _BannerAdBlock() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _BannerAdBlock value)  $default,){
final _that = this;
switch (_that) {
case _BannerAdBlock():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _BannerAdBlock value)?  $default,){
final _that = this;
switch (_that) {
case _BannerAdBlock() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( BannerSize size,  String type)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _BannerAdBlock() when $default != null:
return $default(_that.size,_that.type);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( BannerSize size,  String type)  $default,) {final _that = this;
switch (_that) {
case _BannerAdBlock():
return $default(_that.size,_that.type);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( BannerSize size,  String type)?  $default,) {final _that = this;
switch (_that) {
case _BannerAdBlock() when $default != null:
return $default(_that.size,_that.type);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _BannerAdBlock implements BannerAdBlock {
  const _BannerAdBlock({required this.size, this.type = BannerAdBlock.identifier});
  factory _BannerAdBlock.fromJson(Map<String, dynamic> json) => _$BannerAdBlockFromJson(json);

@override final  BannerSize size;
@override@JsonKey() final  String type;

/// Create a copy of BannerAdBlock
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$BannerAdBlockCopyWith<_BannerAdBlock> get copyWith => __$BannerAdBlockCopyWithImpl<_BannerAdBlock>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$BannerAdBlockToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _BannerAdBlock&&(identical(other.size, size) || other.size == size)&&(identical(other.type, type) || other.type == type));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,size,type);

@override
String toString() {
  return 'BannerAdBlock(size: $size, type: $type)';
}


}

/// @nodoc
abstract mixin class _$BannerAdBlockCopyWith<$Res> implements $BannerAdBlockCopyWith<$Res> {
  factory _$BannerAdBlockCopyWith(_BannerAdBlock value, $Res Function(_BannerAdBlock) _then) = __$BannerAdBlockCopyWithImpl;
@override @useResult
$Res call({
 BannerSize size, String type
});




}
/// @nodoc
class __$BannerAdBlockCopyWithImpl<$Res>
    implements _$BannerAdBlockCopyWith<$Res> {
  __$BannerAdBlockCopyWithImpl(this._self, this._then);

  final _BannerAdBlock _self;
  final $Res Function(_BannerAdBlock) _then;

/// Create a copy of BannerAdBlock
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? size = null,Object? type = null,}) {
  return _then(_BannerAdBlock(
size: null == size ? _self.size : size // ignore: cast_nullable_to_non_nullable
as BannerSize,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
