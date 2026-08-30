// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'html_block.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$HtmlBlock {

 String get content; String get type;
/// Create a copy of HtmlBlock
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$HtmlBlockCopyWith<HtmlBlock> get copyWith => _$HtmlBlockCopyWithImpl<HtmlBlock>(this as HtmlBlock, _$identity);

  /// Serializes this HtmlBlock to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is HtmlBlock&&(identical(other.content, content) || other.content == content)&&(identical(other.type, type) || other.type == type));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,content,type);

@override
String toString() {
  return 'HtmlBlock(content: $content, type: $type)';
}


}

/// @nodoc
abstract mixin class $HtmlBlockCopyWith<$Res>  {
  factory $HtmlBlockCopyWith(HtmlBlock value, $Res Function(HtmlBlock) _then) = _$HtmlBlockCopyWithImpl;
@useResult
$Res call({
 String content, String type
});




}
/// @nodoc
class _$HtmlBlockCopyWithImpl<$Res>
    implements $HtmlBlockCopyWith<$Res> {
  _$HtmlBlockCopyWithImpl(this._self, this._then);

  final HtmlBlock _self;
  final $Res Function(HtmlBlock) _then;

/// Create a copy of HtmlBlock
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? content = null,Object? type = null,}) {
  return _then(_self.copyWith(
content: null == content ? _self.content : content // ignore: cast_nullable_to_non_nullable
as String,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [HtmlBlock].
extension HtmlBlockPatterns on HtmlBlock {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _HtmlBlock value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _HtmlBlock() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _HtmlBlock value)  $default,){
final _that = this;
switch (_that) {
case _HtmlBlock():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _HtmlBlock value)?  $default,){
final _that = this;
switch (_that) {
case _HtmlBlock() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String content,  String type)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _HtmlBlock() when $default != null:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String content,  String type)  $default,) {final _that = this;
switch (_that) {
case _HtmlBlock():
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String content,  String type)?  $default,) {final _that = this;
switch (_that) {
case _HtmlBlock() when $default != null:
return $default(_that.content,_that.type);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _HtmlBlock implements HtmlBlock {
  const _HtmlBlock({required this.content, this.type = HtmlBlock.identifier});
  factory _HtmlBlock.fromJson(Map<String, dynamic> json) => _$HtmlBlockFromJson(json);

@override final  String content;
@override@JsonKey() final  String type;

/// Create a copy of HtmlBlock
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$HtmlBlockCopyWith<_HtmlBlock> get copyWith => __$HtmlBlockCopyWithImpl<_HtmlBlock>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$HtmlBlockToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _HtmlBlock&&(identical(other.content, content) || other.content == content)&&(identical(other.type, type) || other.type == type));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,content,type);

@override
String toString() {
  return 'HtmlBlock(content: $content, type: $type)';
}


}

/// @nodoc
abstract mixin class _$HtmlBlockCopyWith<$Res> implements $HtmlBlockCopyWith<$Res> {
  factory _$HtmlBlockCopyWith(_HtmlBlock value, $Res Function(_HtmlBlock) _then) = __$HtmlBlockCopyWithImpl;
@override @useResult
$Res call({
 String content, String type
});




}
/// @nodoc
class __$HtmlBlockCopyWithImpl<$Res>
    implements _$HtmlBlockCopyWith<$Res> {
  __$HtmlBlockCopyWithImpl(this._self, this._then);

  final _HtmlBlock _self;
  final $Res Function(_HtmlBlock) _then;

/// Create a copy of HtmlBlock
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? content = null,Object? type = null,}) {
  return _then(_HtmlBlock(
content: null == content ? _self.content : content // ignore: cast_nullable_to_non_nullable
as String,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
