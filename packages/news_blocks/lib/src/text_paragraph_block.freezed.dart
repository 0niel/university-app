// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'text_paragraph_block.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$TextParagraphBlock {

 String get text; String get type;
/// Create a copy of TextParagraphBlock
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TextParagraphBlockCopyWith<TextParagraphBlock> get copyWith => _$TextParagraphBlockCopyWithImpl<TextParagraphBlock>(this as TextParagraphBlock, _$identity);

  /// Serializes this TextParagraphBlock to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TextParagraphBlock&&(identical(other.text, text) || other.text == text)&&(identical(other.type, type) || other.type == type));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,text,type);

@override
String toString() {
  return 'TextParagraphBlock(text: $text, type: $type)';
}


}

/// @nodoc
abstract mixin class $TextParagraphBlockCopyWith<$Res>  {
  factory $TextParagraphBlockCopyWith(TextParagraphBlock value, $Res Function(TextParagraphBlock) _then) = _$TextParagraphBlockCopyWithImpl;
@useResult
$Res call({
 String text, String type
});




}
/// @nodoc
class _$TextParagraphBlockCopyWithImpl<$Res>
    implements $TextParagraphBlockCopyWith<$Res> {
  _$TextParagraphBlockCopyWithImpl(this._self, this._then);

  final TextParagraphBlock _self;
  final $Res Function(TextParagraphBlock) _then;

/// Create a copy of TextParagraphBlock
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? text = null,Object? type = null,}) {
  return _then(_self.copyWith(
text: null == text ? _self.text : text // ignore: cast_nullable_to_non_nullable
as String,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [TextParagraphBlock].
extension TextParagraphBlockPatterns on TextParagraphBlock {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TextParagraphBlock value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TextParagraphBlock() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TextParagraphBlock value)  $default,){
final _that = this;
switch (_that) {
case _TextParagraphBlock():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TextParagraphBlock value)?  $default,){
final _that = this;
switch (_that) {
case _TextParagraphBlock() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String text,  String type)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _TextParagraphBlock() when $default != null:
return $default(_that.text,_that.type);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String text,  String type)  $default,) {final _that = this;
switch (_that) {
case _TextParagraphBlock():
return $default(_that.text,_that.type);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String text,  String type)?  $default,) {final _that = this;
switch (_that) {
case _TextParagraphBlock() when $default != null:
return $default(_that.text,_that.type);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _TextParagraphBlock implements TextParagraphBlock {
  const _TextParagraphBlock({required this.text, this.type = TextParagraphBlock.identifier});
  factory _TextParagraphBlock.fromJson(Map<String, dynamic> json) => _$TextParagraphBlockFromJson(json);

@override final  String text;
@override@JsonKey() final  String type;

/// Create a copy of TextParagraphBlock
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TextParagraphBlockCopyWith<_TextParagraphBlock> get copyWith => __$TextParagraphBlockCopyWithImpl<_TextParagraphBlock>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$TextParagraphBlockToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _TextParagraphBlock&&(identical(other.text, text) || other.text == text)&&(identical(other.type, type) || other.type == type));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,text,type);

@override
String toString() {
  return 'TextParagraphBlock(text: $text, type: $type)';
}


}

/// @nodoc
abstract mixin class _$TextParagraphBlockCopyWith<$Res> implements $TextParagraphBlockCopyWith<$Res> {
  factory _$TextParagraphBlockCopyWith(_TextParagraphBlock value, $Res Function(_TextParagraphBlock) _then) = __$TextParagraphBlockCopyWithImpl;
@override @useResult
$Res call({
 String text, String type
});




}
/// @nodoc
class __$TextParagraphBlockCopyWithImpl<$Res>
    implements _$TextParagraphBlockCopyWith<$Res> {
  __$TextParagraphBlockCopyWithImpl(this._self, this._then);

  final _TextParagraphBlock _self;
  final $Res Function(_TextParagraphBlock) _then;

/// Create a copy of TextParagraphBlock
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? text = null,Object? type = null,}) {
  return _then(_TextParagraphBlock(
text: null == text ? _self.text : text // ignore: cast_nullable_to_non_nullable
as String,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
