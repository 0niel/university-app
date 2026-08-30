// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'video_block.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$VideoBlock {

 String get videoUrl; String get type;
/// Create a copy of VideoBlock
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$VideoBlockCopyWith<VideoBlock> get copyWith => _$VideoBlockCopyWithImpl<VideoBlock>(this as VideoBlock, _$identity);

  /// Serializes this VideoBlock to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is VideoBlock&&(identical(other.videoUrl, videoUrl) || other.videoUrl == videoUrl)&&(identical(other.type, type) || other.type == type));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,videoUrl,type);

@override
String toString() {
  return 'VideoBlock(videoUrl: $videoUrl, type: $type)';
}


}

/// @nodoc
abstract mixin class $VideoBlockCopyWith<$Res>  {
  factory $VideoBlockCopyWith(VideoBlock value, $Res Function(VideoBlock) _then) = _$VideoBlockCopyWithImpl;
@useResult
$Res call({
 String videoUrl, String type
});




}
/// @nodoc
class _$VideoBlockCopyWithImpl<$Res>
    implements $VideoBlockCopyWith<$Res> {
  _$VideoBlockCopyWithImpl(this._self, this._then);

  final VideoBlock _self;
  final $Res Function(VideoBlock) _then;

/// Create a copy of VideoBlock
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? videoUrl = null,Object? type = null,}) {
  return _then(_self.copyWith(
videoUrl: null == videoUrl ? _self.videoUrl : videoUrl // ignore: cast_nullable_to_non_nullable
as String,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [VideoBlock].
extension VideoBlockPatterns on VideoBlock {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _VideoBlock value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _VideoBlock() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _VideoBlock value)  $default,){
final _that = this;
switch (_that) {
case _VideoBlock():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _VideoBlock value)?  $default,){
final _that = this;
switch (_that) {
case _VideoBlock() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String videoUrl,  String type)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _VideoBlock() when $default != null:
return $default(_that.videoUrl,_that.type);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String videoUrl,  String type)  $default,) {final _that = this;
switch (_that) {
case _VideoBlock():
return $default(_that.videoUrl,_that.type);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String videoUrl,  String type)?  $default,) {final _that = this;
switch (_that) {
case _VideoBlock() when $default != null:
return $default(_that.videoUrl,_that.type);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _VideoBlock implements VideoBlock {
  const _VideoBlock({required this.videoUrl, this.type = VideoBlock.identifier});
  factory _VideoBlock.fromJson(Map<String, dynamic> json) => _$VideoBlockFromJson(json);

@override final  String videoUrl;
@override@JsonKey() final  String type;

/// Create a copy of VideoBlock
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$VideoBlockCopyWith<_VideoBlock> get copyWith => __$VideoBlockCopyWithImpl<_VideoBlock>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$VideoBlockToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _VideoBlock&&(identical(other.videoUrl, videoUrl) || other.videoUrl == videoUrl)&&(identical(other.type, type) || other.type == type));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,videoUrl,type);

@override
String toString() {
  return 'VideoBlock(videoUrl: $videoUrl, type: $type)';
}


}

/// @nodoc
abstract mixin class _$VideoBlockCopyWith<$Res> implements $VideoBlockCopyWith<$Res> {
  factory _$VideoBlockCopyWith(_VideoBlock value, $Res Function(_VideoBlock) _then) = __$VideoBlockCopyWithImpl;
@override @useResult
$Res call({
 String videoUrl, String type
});




}
/// @nodoc
class __$VideoBlockCopyWithImpl<$Res>
    implements _$VideoBlockCopyWith<$Res> {
  __$VideoBlockCopyWithImpl(this._self, this._then);

  final _VideoBlock _self;
  final $Res Function(_VideoBlock) _then;

/// Create a copy of VideoBlock
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? videoUrl = null,Object? type = null,}) {
  return _then(_VideoBlock(
videoUrl: null == videoUrl ? _self.videoUrl : videoUrl // ignore: cast_nullable_to_non_nullable
as String,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
