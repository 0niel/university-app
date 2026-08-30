// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'trending_story_block.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$TrendingStoryBlock {

 PostSmallBlock get content; String get type;
/// Create a copy of TrendingStoryBlock
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TrendingStoryBlockCopyWith<TrendingStoryBlock> get copyWith => _$TrendingStoryBlockCopyWithImpl<TrendingStoryBlock>(this as TrendingStoryBlock, _$identity);

  /// Serializes this TrendingStoryBlock to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TrendingStoryBlock&&(identical(other.content, content) || other.content == content)&&(identical(other.type, type) || other.type == type));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,content,type);

@override
String toString() {
  return 'TrendingStoryBlock(content: $content, type: $type)';
}


}

/// @nodoc
abstract mixin class $TrendingStoryBlockCopyWith<$Res>  {
  factory $TrendingStoryBlockCopyWith(TrendingStoryBlock value, $Res Function(TrendingStoryBlock) _then) = _$TrendingStoryBlockCopyWithImpl;
@useResult
$Res call({
 PostSmallBlock content, String type
});


$PostSmallBlockCopyWith<$Res> get content;

}
/// @nodoc
class _$TrendingStoryBlockCopyWithImpl<$Res>
    implements $TrendingStoryBlockCopyWith<$Res> {
  _$TrendingStoryBlockCopyWithImpl(this._self, this._then);

  final TrendingStoryBlock _self;
  final $Res Function(TrendingStoryBlock) _then;

/// Create a copy of TrendingStoryBlock
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? content = null,Object? type = null,}) {
  return _then(_self.copyWith(
content: null == content ? _self.content : content // ignore: cast_nullable_to_non_nullable
as PostSmallBlock,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String,
  ));
}
/// Create a copy of TrendingStoryBlock
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$PostSmallBlockCopyWith<$Res> get content {

  return $PostSmallBlockCopyWith<$Res>(_self.content, (value) {
    return _then(_self.copyWith(content: value));
  });
}
}


/// Adds pattern-matching-related methods to [TrendingStoryBlock].
extension TrendingStoryBlockPatterns on TrendingStoryBlock {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TrendingStoryBlock value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TrendingStoryBlock() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TrendingStoryBlock value)  $default,){
final _that = this;
switch (_that) {
case _TrendingStoryBlock():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TrendingStoryBlock value)?  $default,){
final _that = this;
switch (_that) {
case _TrendingStoryBlock() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( PostSmallBlock content,  String type)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _TrendingStoryBlock() when $default != null:
return $default(_that.content,_that.type);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( PostSmallBlock content,  String type)  $default,) {final _that = this;
switch (_that) {
case _TrendingStoryBlock():
return $default(_that.content,_that.type);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( PostSmallBlock content,  String type)?  $default,) {final _that = this;
switch (_that) {
case _TrendingStoryBlock() when $default != null:
return $default(_that.content,_that.type);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _TrendingStoryBlock implements TrendingStoryBlock {
  const _TrendingStoryBlock({required this.content, this.type = TrendingStoryBlock.identifier});
  factory _TrendingStoryBlock.fromJson(Map<String, dynamic> json) => _$TrendingStoryBlockFromJson(json);

@override final  PostSmallBlock content;
@override@JsonKey() final  String type;

/// Create a copy of TrendingStoryBlock
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TrendingStoryBlockCopyWith<_TrendingStoryBlock> get copyWith => __$TrendingStoryBlockCopyWithImpl<_TrendingStoryBlock>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$TrendingStoryBlockToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _TrendingStoryBlock&&(identical(other.content, content) || other.content == content)&&(identical(other.type, type) || other.type == type));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,content,type);

@override
String toString() {
  return 'TrendingStoryBlock(content: $content, type: $type)';
}


}

/// @nodoc
abstract mixin class _$TrendingStoryBlockCopyWith<$Res> implements $TrendingStoryBlockCopyWith<$Res> {
  factory _$TrendingStoryBlockCopyWith(_TrendingStoryBlock value, $Res Function(_TrendingStoryBlock) _then) = __$TrendingStoryBlockCopyWithImpl;
@override @useResult
$Res call({
 PostSmallBlock content, String type
});


@override $PostSmallBlockCopyWith<$Res> get content;

}
/// @nodoc
class __$TrendingStoryBlockCopyWithImpl<$Res>
    implements _$TrendingStoryBlockCopyWith<$Res> {
  __$TrendingStoryBlockCopyWithImpl(this._self, this._then);

  final _TrendingStoryBlock _self;
  final $Res Function(_TrendingStoryBlock) _then;

/// Create a copy of TrendingStoryBlock
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? content = null,Object? type = null,}) {
  return _then(_TrendingStoryBlock(
content: null == content ? _self.content : content // ignore: cast_nullable_to_non_nullable
as PostSmallBlock,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

/// Create a copy of TrendingStoryBlock
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$PostSmallBlockCopyWith<$Res> get content {

  return $PostSmallBlockCopyWith<$Res>(_self.content, (value) {
    return _then(_self.copyWith(content: value));
  });
}
}

// dart format on
