// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'slideshow_introduction_block.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$SlideshowIntroductionBlock {

 String get title; String get coverImageUrl;@BlockActionConverter() BlockAction? get action; String get type;
/// Create a copy of SlideshowIntroductionBlock
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SlideshowIntroductionBlockCopyWith<SlideshowIntroductionBlock> get copyWith => _$SlideshowIntroductionBlockCopyWithImpl<SlideshowIntroductionBlock>(this as SlideshowIntroductionBlock, _$identity);

  /// Serializes this SlideshowIntroductionBlock to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SlideshowIntroductionBlock&&(identical(other.title, title) || other.title == title)&&(identical(other.coverImageUrl, coverImageUrl) || other.coverImageUrl == coverImageUrl)&&(identical(other.action, action) || other.action == action)&&(identical(other.type, type) || other.type == type));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,title,coverImageUrl,action,type);

@override
String toString() {
  return 'SlideshowIntroductionBlock(title: $title, coverImageUrl: $coverImageUrl, action: $action, type: $type)';
}


}

/// @nodoc
abstract mixin class $SlideshowIntroductionBlockCopyWith<$Res>  {
  factory $SlideshowIntroductionBlockCopyWith(SlideshowIntroductionBlock value, $Res Function(SlideshowIntroductionBlock) _then) = _$SlideshowIntroductionBlockCopyWithImpl;
@useResult
$Res call({
 String title, String coverImageUrl,@BlockActionConverter() BlockAction? action, String type
});




}
/// @nodoc
class _$SlideshowIntroductionBlockCopyWithImpl<$Res>
    implements $SlideshowIntroductionBlockCopyWith<$Res> {
  _$SlideshowIntroductionBlockCopyWithImpl(this._self, this._then);

  final SlideshowIntroductionBlock _self;
  final $Res Function(SlideshowIntroductionBlock) _then;

/// Create a copy of SlideshowIntroductionBlock
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? title = null,Object? coverImageUrl = null,Object? action = freezed,Object? type = null,}) {
  return _then(_self.copyWith(
title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,coverImageUrl: null == coverImageUrl ? _self.coverImageUrl : coverImageUrl // ignore: cast_nullable_to_non_nullable
as String,action: freezed == action ? _self.action : action // ignore: cast_nullable_to_non_nullable
as BlockAction?,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [SlideshowIntroductionBlock].
extension SlideshowIntroductionBlockPatterns on SlideshowIntroductionBlock {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SlideshowIntroductionBlock value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SlideshowIntroductionBlock() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SlideshowIntroductionBlock value)  $default,){
final _that = this;
switch (_that) {
case _SlideshowIntroductionBlock():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SlideshowIntroductionBlock value)?  $default,){
final _that = this;
switch (_that) {
case _SlideshowIntroductionBlock() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String title,  String coverImageUrl, @BlockActionConverter()  BlockAction? action,  String type)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SlideshowIntroductionBlock() when $default != null:
return $default(_that.title,_that.coverImageUrl,_that.action,_that.type);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String title,  String coverImageUrl, @BlockActionConverter()  BlockAction? action,  String type)  $default,) {final _that = this;
switch (_that) {
case _SlideshowIntroductionBlock():
return $default(_that.title,_that.coverImageUrl,_that.action,_that.type);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String title,  String coverImageUrl, @BlockActionConverter()  BlockAction? action,  String type)?  $default,) {final _that = this;
switch (_that) {
case _SlideshowIntroductionBlock() when $default != null:
return $default(_that.title,_that.coverImageUrl,_that.action,_that.type);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _SlideshowIntroductionBlock implements SlideshowIntroductionBlock {
  const _SlideshowIntroductionBlock({required this.title, required this.coverImageUrl, @BlockActionConverter() this.action, this.type = SlideshowIntroductionBlock.identifier});
  factory _SlideshowIntroductionBlock.fromJson(Map<String, dynamic> json) => _$SlideshowIntroductionBlockFromJson(json);

@override final  String title;
@override final  String coverImageUrl;
@override@BlockActionConverter() final  BlockAction? action;
@override@JsonKey() final  String type;

/// Create a copy of SlideshowIntroductionBlock
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SlideshowIntroductionBlockCopyWith<_SlideshowIntroductionBlock> get copyWith => __$SlideshowIntroductionBlockCopyWithImpl<_SlideshowIntroductionBlock>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$SlideshowIntroductionBlockToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SlideshowIntroductionBlock&&(identical(other.title, title) || other.title == title)&&(identical(other.coverImageUrl, coverImageUrl) || other.coverImageUrl == coverImageUrl)&&(identical(other.action, action) || other.action == action)&&(identical(other.type, type) || other.type == type));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,title,coverImageUrl,action,type);

@override
String toString() {
  return 'SlideshowIntroductionBlock(title: $title, coverImageUrl: $coverImageUrl, action: $action, type: $type)';
}


}

/// @nodoc
abstract mixin class _$SlideshowIntroductionBlockCopyWith<$Res> implements $SlideshowIntroductionBlockCopyWith<$Res> {
  factory _$SlideshowIntroductionBlockCopyWith(_SlideshowIntroductionBlock value, $Res Function(_SlideshowIntroductionBlock) _then) = __$SlideshowIntroductionBlockCopyWithImpl;
@override @useResult
$Res call({
 String title, String coverImageUrl,@BlockActionConverter() BlockAction? action, String type
});




}
/// @nodoc
class __$SlideshowIntroductionBlockCopyWithImpl<$Res>
    implements _$SlideshowIntroductionBlockCopyWith<$Res> {
  __$SlideshowIntroductionBlockCopyWithImpl(this._self, this._then);

  final _SlideshowIntroductionBlock _self;
  final $Res Function(_SlideshowIntroductionBlock) _then;

/// Create a copy of SlideshowIntroductionBlock
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? title = null,Object? coverImageUrl = null,Object? action = freezed,Object? type = null,}) {
  return _then(_SlideshowIntroductionBlock(
title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,coverImageUrl: null == coverImageUrl ? _self.coverImageUrl : coverImageUrl // ignore: cast_nullable_to_non_nullable
as String,action: freezed == action ? _self.action : action // ignore: cast_nullable_to_non_nullable
as BlockAction?,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
