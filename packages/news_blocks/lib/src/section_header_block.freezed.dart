// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'section_header_block.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$SectionHeaderBlock {

 String get title;@BlockActionConverter() BlockAction? get action; String get type;
/// Create a copy of SectionHeaderBlock
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SectionHeaderBlockCopyWith<SectionHeaderBlock> get copyWith => _$SectionHeaderBlockCopyWithImpl<SectionHeaderBlock>(this as SectionHeaderBlock, _$identity);

  /// Serializes this SectionHeaderBlock to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SectionHeaderBlock&&(identical(other.title, title) || other.title == title)&&(identical(other.action, action) || other.action == action)&&(identical(other.type, type) || other.type == type));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,title,action,type);

@override
String toString() {
  return 'SectionHeaderBlock(title: $title, action: $action, type: $type)';
}


}

/// @nodoc
abstract mixin class $SectionHeaderBlockCopyWith<$Res>  {
  factory $SectionHeaderBlockCopyWith(SectionHeaderBlock value, $Res Function(SectionHeaderBlock) _then) = _$SectionHeaderBlockCopyWithImpl;
@useResult
$Res call({
 String title,@BlockActionConverter() BlockAction? action, String type
});




}
/// @nodoc
class _$SectionHeaderBlockCopyWithImpl<$Res>
    implements $SectionHeaderBlockCopyWith<$Res> {
  _$SectionHeaderBlockCopyWithImpl(this._self, this._then);

  final SectionHeaderBlock _self;
  final $Res Function(SectionHeaderBlock) _then;

/// Create a copy of SectionHeaderBlock
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? title = null,Object? action = freezed,Object? type = null,}) {
  return _then(_self.copyWith(
title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,action: freezed == action ? _self.action : action // ignore: cast_nullable_to_non_nullable
as BlockAction?,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [SectionHeaderBlock].
extension SectionHeaderBlockPatterns on SectionHeaderBlock {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SectionHeaderBlock value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SectionHeaderBlock() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SectionHeaderBlock value)  $default,){
final _that = this;
switch (_that) {
case _SectionHeaderBlock():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SectionHeaderBlock value)?  $default,){
final _that = this;
switch (_that) {
case _SectionHeaderBlock() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String title, @BlockActionConverter()  BlockAction? action,  String type)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SectionHeaderBlock() when $default != null:
return $default(_that.title,_that.action,_that.type);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String title, @BlockActionConverter()  BlockAction? action,  String type)  $default,) {final _that = this;
switch (_that) {
case _SectionHeaderBlock():
return $default(_that.title,_that.action,_that.type);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String title, @BlockActionConverter()  BlockAction? action,  String type)?  $default,) {final _that = this;
switch (_that) {
case _SectionHeaderBlock() when $default != null:
return $default(_that.title,_that.action,_that.type);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _SectionHeaderBlock implements SectionHeaderBlock {
  const _SectionHeaderBlock({required this.title, @BlockActionConverter() this.action, this.type = SectionHeaderBlock.identifier});
  factory _SectionHeaderBlock.fromJson(Map<String, dynamic> json) => _$SectionHeaderBlockFromJson(json);

@override final  String title;
@override@BlockActionConverter() final  BlockAction? action;
@override@JsonKey() final  String type;

/// Create a copy of SectionHeaderBlock
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SectionHeaderBlockCopyWith<_SectionHeaderBlock> get copyWith => __$SectionHeaderBlockCopyWithImpl<_SectionHeaderBlock>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$SectionHeaderBlockToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SectionHeaderBlock&&(identical(other.title, title) || other.title == title)&&(identical(other.action, action) || other.action == action)&&(identical(other.type, type) || other.type == type));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,title,action,type);

@override
String toString() {
  return 'SectionHeaderBlock(title: $title, action: $action, type: $type)';
}


}

/// @nodoc
abstract mixin class _$SectionHeaderBlockCopyWith<$Res> implements $SectionHeaderBlockCopyWith<$Res> {
  factory _$SectionHeaderBlockCopyWith(_SectionHeaderBlock value, $Res Function(_SectionHeaderBlock) _then) = __$SectionHeaderBlockCopyWithImpl;
@override @useResult
$Res call({
 String title,@BlockActionConverter() BlockAction? action, String type
});




}
/// @nodoc
class __$SectionHeaderBlockCopyWithImpl<$Res>
    implements _$SectionHeaderBlockCopyWith<$Res> {
  __$SectionHeaderBlockCopyWithImpl(this._self, this._then);

  final _SectionHeaderBlock _self;
  final $Res Function(_SectionHeaderBlock) _then;

/// Create a copy of SectionHeaderBlock
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? title = null,Object? action = freezed,Object? type = null,}) {
  return _then(_SectionHeaderBlock(
title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,action: freezed == action ? _self.action : action // ignore: cast_nullable_to_non_nullable
as BlockAction?,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
