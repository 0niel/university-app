// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'post_grid_group_block.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$PostGridGroupBlock {

 String get categoryId;@NewsBlocksConverter() List<PostGridTileBlock> get tiles; String get type;
/// Create a copy of PostGridGroupBlock
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PostGridGroupBlockCopyWith<PostGridGroupBlock> get copyWith => _$PostGridGroupBlockCopyWithImpl<PostGridGroupBlock>(this as PostGridGroupBlock, _$identity);

  /// Serializes this PostGridGroupBlock to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PostGridGroupBlock&&(identical(other.categoryId, categoryId) || other.categoryId == categoryId)&&const DeepCollectionEquality().equals(other.tiles, tiles)&&(identical(other.type, type) || other.type == type));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,categoryId,const DeepCollectionEquality().hash(tiles),type);

@override
String toString() {
  return 'PostGridGroupBlock(categoryId: $categoryId, tiles: $tiles, type: $type)';
}


}

/// @nodoc
abstract mixin class $PostGridGroupBlockCopyWith<$Res>  {
  factory $PostGridGroupBlockCopyWith(PostGridGroupBlock value, $Res Function(PostGridGroupBlock) _then) = _$PostGridGroupBlockCopyWithImpl;
@useResult
$Res call({
 String categoryId,@NewsBlocksConverter() List<PostGridTileBlock> tiles, String type
});




}
/// @nodoc
class _$PostGridGroupBlockCopyWithImpl<$Res>
    implements $PostGridGroupBlockCopyWith<$Res> {
  _$PostGridGroupBlockCopyWithImpl(this._self, this._then);

  final PostGridGroupBlock _self;
  final $Res Function(PostGridGroupBlock) _then;

/// Create a copy of PostGridGroupBlock
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? categoryId = null,Object? tiles = null,Object? type = null,}) {
  return _then(_self.copyWith(
categoryId: null == categoryId ? _self.categoryId : categoryId // ignore: cast_nullable_to_non_nullable
as String,tiles: null == tiles ? _self.tiles : tiles // ignore: cast_nullable_to_non_nullable
as List<PostGridTileBlock>,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [PostGridGroupBlock].
extension PostGridGroupBlockPatterns on PostGridGroupBlock {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PostGridGroupBlock value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PostGridGroupBlock() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PostGridGroupBlock value)  $default,){
final _that = this;
switch (_that) {
case _PostGridGroupBlock():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PostGridGroupBlock value)?  $default,){
final _that = this;
switch (_that) {
case _PostGridGroupBlock() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String categoryId, @NewsBlocksConverter()  List<PostGridTileBlock> tiles,  String type)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PostGridGroupBlock() when $default != null:
return $default(_that.categoryId,_that.tiles,_that.type);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String categoryId, @NewsBlocksConverter()  List<PostGridTileBlock> tiles,  String type)  $default,) {final _that = this;
switch (_that) {
case _PostGridGroupBlock():
return $default(_that.categoryId,_that.tiles,_that.type);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String categoryId, @NewsBlocksConverter()  List<PostGridTileBlock> tiles,  String type)?  $default,) {final _that = this;
switch (_that) {
case _PostGridGroupBlock() when $default != null:
return $default(_that.categoryId,_that.tiles,_that.type);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _PostGridGroupBlock implements PostGridGroupBlock {
  const _PostGridGroupBlock({required this.categoryId, @NewsBlocksConverter() required final  List<PostGridTileBlock> tiles, this.type = PostGridGroupBlock.identifier}): _tiles = tiles;
  factory _PostGridGroupBlock.fromJson(Map<String, dynamic> json) => _$PostGridGroupBlockFromJson(json);

@override final  String categoryId;
 final  List<PostGridTileBlock> _tiles;
@override@NewsBlocksConverter() List<PostGridTileBlock> get tiles {
  if (_tiles is EqualUnmodifiableListView) return _tiles;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_tiles);
}

@override@JsonKey() final  String type;

/// Create a copy of PostGridGroupBlock
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PostGridGroupBlockCopyWith<_PostGridGroupBlock> get copyWith => __$PostGridGroupBlockCopyWithImpl<_PostGridGroupBlock>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$PostGridGroupBlockToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PostGridGroupBlock&&(identical(other.categoryId, categoryId) || other.categoryId == categoryId)&&const DeepCollectionEquality().equals(other._tiles, _tiles)&&(identical(other.type, type) || other.type == type));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,categoryId,const DeepCollectionEquality().hash(_tiles),type);

@override
String toString() {
  return 'PostGridGroupBlock(categoryId: $categoryId, tiles: $tiles, type: $type)';
}


}

/// @nodoc
abstract mixin class _$PostGridGroupBlockCopyWith<$Res> implements $PostGridGroupBlockCopyWith<$Res> {
  factory _$PostGridGroupBlockCopyWith(_PostGridGroupBlock value, $Res Function(_PostGridGroupBlock) _then) = __$PostGridGroupBlockCopyWithImpl;
@override @useResult
$Res call({
 String categoryId,@NewsBlocksConverter() List<PostGridTileBlock> tiles, String type
});




}
/// @nodoc
class __$PostGridGroupBlockCopyWithImpl<$Res>
    implements _$PostGridGroupBlockCopyWith<$Res> {
  __$PostGridGroupBlockCopyWithImpl(this._self, this._then);

  final _PostGridGroupBlock _self;
  final $Res Function(_PostGridGroupBlock) _then;

/// Create a copy of PostGridGroupBlock
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? categoryId = null,Object? tiles = null,Object? type = null,}) {
  return _then(_PostGridGroupBlock(
categoryId: null == categoryId ? _self.categoryId : categoryId // ignore: cast_nullable_to_non_nullable
as String,tiles: null == tiles ? _self._tiles : tiles // ignore: cast_nullable_to_non_nullable
as List<PostGridTileBlock>,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
