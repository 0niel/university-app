// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'video_introduction_block.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$VideoIntroductionBlock {

 String get categoryId; String get title; String get videoUrl; String get type;
/// Create a copy of VideoIntroductionBlock
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$VideoIntroductionBlockCopyWith<VideoIntroductionBlock> get copyWith => _$VideoIntroductionBlockCopyWithImpl<VideoIntroductionBlock>(this as VideoIntroductionBlock, _$identity);

  /// Serializes this VideoIntroductionBlock to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is VideoIntroductionBlock&&(identical(other.categoryId, categoryId) || other.categoryId == categoryId)&&(identical(other.title, title) || other.title == title)&&(identical(other.videoUrl, videoUrl) || other.videoUrl == videoUrl)&&(identical(other.type, type) || other.type == type));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,categoryId,title,videoUrl,type);

@override
String toString() {
  return 'VideoIntroductionBlock(categoryId: $categoryId, title: $title, videoUrl: $videoUrl, type: $type)';
}


}

/// @nodoc
abstract mixin class $VideoIntroductionBlockCopyWith<$Res>  {
  factory $VideoIntroductionBlockCopyWith(VideoIntroductionBlock value, $Res Function(VideoIntroductionBlock) _then) = _$VideoIntroductionBlockCopyWithImpl;
@useResult
$Res call({
 String categoryId, String title, String videoUrl, String type
});




}
/// @nodoc
class _$VideoIntroductionBlockCopyWithImpl<$Res>
    implements $VideoIntroductionBlockCopyWith<$Res> {
  _$VideoIntroductionBlockCopyWithImpl(this._self, this._then);

  final VideoIntroductionBlock _self;
  final $Res Function(VideoIntroductionBlock) _then;

/// Create a copy of VideoIntroductionBlock
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? categoryId = null,Object? title = null,Object? videoUrl = null,Object? type = null,}) {
  return _then(_self.copyWith(
categoryId: null == categoryId ? _self.categoryId : categoryId // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,videoUrl: null == videoUrl ? _self.videoUrl : videoUrl // ignore: cast_nullable_to_non_nullable
as String,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [VideoIntroductionBlock].
extension VideoIntroductionBlockPatterns on VideoIntroductionBlock {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _VideoIntroductionBlock value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _VideoIntroductionBlock() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _VideoIntroductionBlock value)  $default,){
final _that = this;
switch (_that) {
case _VideoIntroductionBlock():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _VideoIntroductionBlock value)?  $default,){
final _that = this;
switch (_that) {
case _VideoIntroductionBlock() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String categoryId,  String title,  String videoUrl,  String type)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _VideoIntroductionBlock() when $default != null:
return $default(_that.categoryId,_that.title,_that.videoUrl,_that.type);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String categoryId,  String title,  String videoUrl,  String type)  $default,) {final _that = this;
switch (_that) {
case _VideoIntroductionBlock():
return $default(_that.categoryId,_that.title,_that.videoUrl,_that.type);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String categoryId,  String title,  String videoUrl,  String type)?  $default,) {final _that = this;
switch (_that) {
case _VideoIntroductionBlock() when $default != null:
return $default(_that.categoryId,_that.title,_that.videoUrl,_that.type);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _VideoIntroductionBlock implements VideoIntroductionBlock {
  const _VideoIntroductionBlock({required this.categoryId, required this.title, required this.videoUrl, this.type = VideoIntroductionBlock.identifier});
  factory _VideoIntroductionBlock.fromJson(Map<String, dynamic> json) => _$VideoIntroductionBlockFromJson(json);

@override final  String categoryId;
@override final  String title;
@override final  String videoUrl;
@override@JsonKey() final  String type;

/// Create a copy of VideoIntroductionBlock
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$VideoIntroductionBlockCopyWith<_VideoIntroductionBlock> get copyWith => __$VideoIntroductionBlockCopyWithImpl<_VideoIntroductionBlock>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$VideoIntroductionBlockToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _VideoIntroductionBlock&&(identical(other.categoryId, categoryId) || other.categoryId == categoryId)&&(identical(other.title, title) || other.title == title)&&(identical(other.videoUrl, videoUrl) || other.videoUrl == videoUrl)&&(identical(other.type, type) || other.type == type));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,categoryId,title,videoUrl,type);

@override
String toString() {
  return 'VideoIntroductionBlock(categoryId: $categoryId, title: $title, videoUrl: $videoUrl, type: $type)';
}


}

/// @nodoc
abstract mixin class _$VideoIntroductionBlockCopyWith<$Res> implements $VideoIntroductionBlockCopyWith<$Res> {
  factory _$VideoIntroductionBlockCopyWith(_VideoIntroductionBlock value, $Res Function(_VideoIntroductionBlock) _then) = __$VideoIntroductionBlockCopyWithImpl;
@override @useResult
$Res call({
 String categoryId, String title, String videoUrl, String type
});




}
/// @nodoc
class __$VideoIntroductionBlockCopyWithImpl<$Res>
    implements _$VideoIntroductionBlockCopyWith<$Res> {
  __$VideoIntroductionBlockCopyWithImpl(this._self, this._then);

  final _VideoIntroductionBlock _self;
  final $Res Function(_VideoIntroductionBlock) _then;

/// Create a copy of VideoIntroductionBlock
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? categoryId = null,Object? title = null,Object? videoUrl = null,Object? type = null,}) {
  return _then(_VideoIntroductionBlock(
categoryId: null == categoryId ? _self.categoryId : categoryId // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,videoUrl: null == videoUrl ? _self.videoUrl : videoUrl // ignore: cast_nullable_to_non_nullable
as String,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
