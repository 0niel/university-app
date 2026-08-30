// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'slide_block.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$SlideBlock {

 String get caption; String get description; String get photoCredit; String get imageUrl; String get type;
/// Create a copy of SlideBlock
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SlideBlockCopyWith<SlideBlock> get copyWith => _$SlideBlockCopyWithImpl<SlideBlock>(this as SlideBlock, _$identity);

  /// Serializes this SlideBlock to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SlideBlock&&(identical(other.caption, caption) || other.caption == caption)&&(identical(other.description, description) || other.description == description)&&(identical(other.photoCredit, photoCredit) || other.photoCredit == photoCredit)&&(identical(other.imageUrl, imageUrl) || other.imageUrl == imageUrl)&&(identical(other.type, type) || other.type == type));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,caption,description,photoCredit,imageUrl,type);

@override
String toString() {
  return 'SlideBlock(caption: $caption, description: $description, photoCredit: $photoCredit, imageUrl: $imageUrl, type: $type)';
}


}

/// @nodoc
abstract mixin class $SlideBlockCopyWith<$Res>  {
  factory $SlideBlockCopyWith(SlideBlock value, $Res Function(SlideBlock) _then) = _$SlideBlockCopyWithImpl;
@useResult
$Res call({
 String caption, String description, String photoCredit, String imageUrl, String type
});




}
/// @nodoc
class _$SlideBlockCopyWithImpl<$Res>
    implements $SlideBlockCopyWith<$Res> {
  _$SlideBlockCopyWithImpl(this._self, this._then);

  final SlideBlock _self;
  final $Res Function(SlideBlock) _then;

/// Create a copy of SlideBlock
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? caption = null,Object? description = null,Object? photoCredit = null,Object? imageUrl = null,Object? type = null,}) {
  return _then(_self.copyWith(
caption: null == caption ? _self.caption : caption // ignore: cast_nullable_to_non_nullable
as String,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,photoCredit: null == photoCredit ? _self.photoCredit : photoCredit // ignore: cast_nullable_to_non_nullable
as String,imageUrl: null == imageUrl ? _self.imageUrl : imageUrl // ignore: cast_nullable_to_non_nullable
as String,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [SlideBlock].
extension SlideBlockPatterns on SlideBlock {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SlideBlock value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SlideBlock() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SlideBlock value)  $default,){
final _that = this;
switch (_that) {
case _SlideBlock():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SlideBlock value)?  $default,){
final _that = this;
switch (_that) {
case _SlideBlock() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String caption,  String description,  String photoCredit,  String imageUrl,  String type)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SlideBlock() when $default != null:
return $default(_that.caption,_that.description,_that.photoCredit,_that.imageUrl,_that.type);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String caption,  String description,  String photoCredit,  String imageUrl,  String type)  $default,) {final _that = this;
switch (_that) {
case _SlideBlock():
return $default(_that.caption,_that.description,_that.photoCredit,_that.imageUrl,_that.type);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String caption,  String description,  String photoCredit,  String imageUrl,  String type)?  $default,) {final _that = this;
switch (_that) {
case _SlideBlock() when $default != null:
return $default(_that.caption,_that.description,_that.photoCredit,_that.imageUrl,_that.type);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _SlideBlock implements SlideBlock {
  const _SlideBlock({required this.caption, required this.description, required this.photoCredit, required this.imageUrl, this.type = SlideBlock.identifier});
  factory _SlideBlock.fromJson(Map<String, dynamic> json) => _$SlideBlockFromJson(json);

@override final  String caption;
@override final  String description;
@override final  String photoCredit;
@override final  String imageUrl;
@override@JsonKey() final  String type;

/// Create a copy of SlideBlock
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SlideBlockCopyWith<_SlideBlock> get copyWith => __$SlideBlockCopyWithImpl<_SlideBlock>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$SlideBlockToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SlideBlock&&(identical(other.caption, caption) || other.caption == caption)&&(identical(other.description, description) || other.description == description)&&(identical(other.photoCredit, photoCredit) || other.photoCredit == photoCredit)&&(identical(other.imageUrl, imageUrl) || other.imageUrl == imageUrl)&&(identical(other.type, type) || other.type == type));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,caption,description,photoCredit,imageUrl,type);

@override
String toString() {
  return 'SlideBlock(caption: $caption, description: $description, photoCredit: $photoCredit, imageUrl: $imageUrl, type: $type)';
}


}

/// @nodoc
abstract mixin class _$SlideBlockCopyWith<$Res> implements $SlideBlockCopyWith<$Res> {
  factory _$SlideBlockCopyWith(_SlideBlock value, $Res Function(_SlideBlock) _then) = __$SlideBlockCopyWithImpl;
@override @useResult
$Res call({
 String caption, String description, String photoCredit, String imageUrl, String type
});




}
/// @nodoc
class __$SlideBlockCopyWithImpl<$Res>
    implements _$SlideBlockCopyWith<$Res> {
  __$SlideBlockCopyWithImpl(this._self, this._then);

  final _SlideBlock _self;
  final $Res Function(_SlideBlock) _then;

/// Create a copy of SlideBlock
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? caption = null,Object? description = null,Object? photoCredit = null,Object? imageUrl = null,Object? type = null,}) {
  return _then(_SlideBlock(
caption: null == caption ? _self.caption : caption // ignore: cast_nullable_to_non_nullable
as String,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,photoCredit: null == photoCredit ? _self.photoCredit : photoCredit // ignore: cast_nullable_to_non_nullable
as String,imageUrl: null == imageUrl ? _self.imageUrl : imageUrl // ignore: cast_nullable_to_non_nullable
as String,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
