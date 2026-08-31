// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'text_lead_paragraph_block.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$TextLeadParagraphBlock {

 String get text; String get type;
/// Create a copy of TextLeadParagraphBlock
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TextLeadParagraphBlockCopyWith<TextLeadParagraphBlock> get copyWith => _$TextLeadParagraphBlockCopyWithImpl<TextLeadParagraphBlock>(this as TextLeadParagraphBlock, _$identity);

  /// Serializes this TextLeadParagraphBlock to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TextLeadParagraphBlock&&(identical(other.text, text) || other.text == text)&&(identical(other.type, type) || other.type == type));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,text,type);

@override
String toString() {
  return 'TextLeadParagraphBlock(text: $text, type: $type)';
}


}

/// @nodoc
abstract mixin class $TextLeadParagraphBlockCopyWith<$Res>  {
  factory $TextLeadParagraphBlockCopyWith(TextLeadParagraphBlock value, $Res Function(TextLeadParagraphBlock) _then) = _$TextLeadParagraphBlockCopyWithImpl;
@useResult
$Res call({
 String text, String type
});




}
/// @nodoc
class _$TextLeadParagraphBlockCopyWithImpl<$Res>
    implements $TextLeadParagraphBlockCopyWith<$Res> {
  _$TextLeadParagraphBlockCopyWithImpl(this._self, this._then);

  final TextLeadParagraphBlock _self;
  final $Res Function(TextLeadParagraphBlock) _then;

/// Create a copy of TextLeadParagraphBlock
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? text = null,Object? type = null,}) {
  return _then(_self.copyWith(
text: null == text ? _self.text : text // ignore: cast_nullable_to_non_nullable
as String,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [TextLeadParagraphBlock].
extension TextLeadParagraphBlockPatterns on TextLeadParagraphBlock {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TextLeadParagraphBlock value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TextLeadParagraphBlock() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TextLeadParagraphBlock value)  $default,){
final _that = this;
switch (_that) {
case _TextLeadParagraphBlock():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TextLeadParagraphBlock value)?  $default,){
final _that = this;
switch (_that) {
case _TextLeadParagraphBlock() when $default != null:
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
case _TextLeadParagraphBlock() when $default != null:
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
case _TextLeadParagraphBlock():
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
case _TextLeadParagraphBlock() when $default != null:
return $default(_that.text,_that.type);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _TextLeadParagraphBlock implements TextLeadParagraphBlock {
  const _TextLeadParagraphBlock({required this.text, this.type = TextLeadParagraphBlock.identifier});
  factory _TextLeadParagraphBlock.fromJson(Map<String, dynamic> json) => _$TextLeadParagraphBlockFromJson(json);

@override final  String text;
@override@JsonKey() final  String type;

/// Create a copy of TextLeadParagraphBlock
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TextLeadParagraphBlockCopyWith<_TextLeadParagraphBlock> get copyWith => __$TextLeadParagraphBlockCopyWithImpl<_TextLeadParagraphBlock>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$TextLeadParagraphBlockToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _TextLeadParagraphBlock&&(identical(other.text, text) || other.text == text)&&(identical(other.type, type) || other.type == type));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,text,type);

@override
String toString() {
  return 'TextLeadParagraphBlock(text: $text, type: $type)';
}


}

/// @nodoc
abstract mixin class _$TextLeadParagraphBlockCopyWith<$Res> implements $TextLeadParagraphBlockCopyWith<$Res> {
  factory _$TextLeadParagraphBlockCopyWith(_TextLeadParagraphBlock value, $Res Function(_TextLeadParagraphBlock) _then) = __$TextLeadParagraphBlockCopyWithImpl;
@override @useResult
$Res call({
 String text, String type
});




}
/// @nodoc
class __$TextLeadParagraphBlockCopyWithImpl<$Res>
    implements _$TextLeadParagraphBlockCopyWith<$Res> {
  __$TextLeadParagraphBlockCopyWithImpl(this._self, this._then);

  final _TextLeadParagraphBlock _self;
  final $Res Function(_TextLeadParagraphBlock) _then;

/// Create a copy of TextLeadParagraphBlock
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? text = null,Object? type = null,}) {
  return _then(_TextLeadParagraphBlock(
text: null == text ? _self.text : text // ignore: cast_nullable_to_non_nullable
as String,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
