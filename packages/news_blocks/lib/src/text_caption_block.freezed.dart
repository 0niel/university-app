// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'text_caption_block.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$TextCaptionBlock {

 String get text; TextCaptionColor get color; String get type;
/// Create a copy of TextCaptionBlock
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TextCaptionBlockCopyWith<TextCaptionBlock> get copyWith => _$TextCaptionBlockCopyWithImpl<TextCaptionBlock>(this as TextCaptionBlock, _$identity);

  /// Serializes this TextCaptionBlock to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TextCaptionBlock&&(identical(other.text, text) || other.text == text)&&(identical(other.color, color) || other.color == color)&&(identical(other.type, type) || other.type == type));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,text,color,type);

@override
String toString() {
  return 'TextCaptionBlock(text: $text, color: $color, type: $type)';
}


}

/// @nodoc
abstract mixin class $TextCaptionBlockCopyWith<$Res>  {
  factory $TextCaptionBlockCopyWith(TextCaptionBlock value, $Res Function(TextCaptionBlock) _then) = _$TextCaptionBlockCopyWithImpl;
@useResult
$Res call({
 String text, TextCaptionColor color, String type
});




}
/// @nodoc
class _$TextCaptionBlockCopyWithImpl<$Res>
    implements $TextCaptionBlockCopyWith<$Res> {
  _$TextCaptionBlockCopyWithImpl(this._self, this._then);

  final TextCaptionBlock _self;
  final $Res Function(TextCaptionBlock) _then;

/// Create a copy of TextCaptionBlock
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? text = null,Object? color = null,Object? type = null,}) {
  return _then(_self.copyWith(
text: null == text ? _self.text : text // ignore: cast_nullable_to_non_nullable
as String,color: null == color ? _self.color : color // ignore: cast_nullable_to_non_nullable
as TextCaptionColor,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [TextCaptionBlock].
extension TextCaptionBlockPatterns on TextCaptionBlock {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TextCaptionBlock value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TextCaptionBlock() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TextCaptionBlock value)  $default,){
final _that = this;
switch (_that) {
case _TextCaptionBlock():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TextCaptionBlock value)?  $default,){
final _that = this;
switch (_that) {
case _TextCaptionBlock() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String text,  TextCaptionColor color,  String type)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _TextCaptionBlock() when $default != null:
return $default(_that.text,_that.color,_that.type);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String text,  TextCaptionColor color,  String type)  $default,) {final _that = this;
switch (_that) {
case _TextCaptionBlock():
return $default(_that.text,_that.color,_that.type);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String text,  TextCaptionColor color,  String type)?  $default,) {final _that = this;
switch (_that) {
case _TextCaptionBlock() when $default != null:
return $default(_that.text,_that.color,_that.type);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _TextCaptionBlock implements TextCaptionBlock {
  const _TextCaptionBlock({required this.text, required this.color, this.type = TextCaptionBlock.identifier});
  factory _TextCaptionBlock.fromJson(Map<String, dynamic> json) => _$TextCaptionBlockFromJson(json);

@override final  String text;
@override final  TextCaptionColor color;
@override@JsonKey() final  String type;

/// Create a copy of TextCaptionBlock
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TextCaptionBlockCopyWith<_TextCaptionBlock> get copyWith => __$TextCaptionBlockCopyWithImpl<_TextCaptionBlock>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$TextCaptionBlockToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _TextCaptionBlock&&(identical(other.text, text) || other.text == text)&&(identical(other.color, color) || other.color == color)&&(identical(other.type, type) || other.type == type));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,text,color,type);

@override
String toString() {
  return 'TextCaptionBlock(text: $text, color: $color, type: $type)';
}


}

/// @nodoc
abstract mixin class _$TextCaptionBlockCopyWith<$Res> implements $TextCaptionBlockCopyWith<$Res> {
  factory _$TextCaptionBlockCopyWith(_TextCaptionBlock value, $Res Function(_TextCaptionBlock) _then) = __$TextCaptionBlockCopyWithImpl;
@override @useResult
$Res call({
 String text, TextCaptionColor color, String type
});




}
/// @nodoc
class __$TextCaptionBlockCopyWithImpl<$Res>
    implements _$TextCaptionBlockCopyWith<$Res> {
  __$TextCaptionBlockCopyWithImpl(this._self, this._then);

  final _TextCaptionBlock _self;
  final $Res Function(_TextCaptionBlock) _then;

/// Create a copy of TextCaptionBlock
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? text = null,Object? color = null,Object? type = null,}) {
  return _then(_TextCaptionBlock(
text: null == text ? _self.text : text // ignore: cast_nullable_to_non_nullable
as String,color: null == color ? _self.color : color // ignore: cast_nullable_to_non_nullable
as TextCaptionColor,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
