// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'slideshow_block.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$SlideshowBlock {

 String get title; List<SlideBlock> get slides; String get type;
/// Create a copy of SlideshowBlock
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SlideshowBlockCopyWith<SlideshowBlock> get copyWith => _$SlideshowBlockCopyWithImpl<SlideshowBlock>(this as SlideshowBlock, _$identity);

  /// Serializes this SlideshowBlock to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SlideshowBlock&&(identical(other.title, title) || other.title == title)&&const DeepCollectionEquality().equals(other.slides, slides)&&(identical(other.type, type) || other.type == type));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,title,const DeepCollectionEquality().hash(slides),type);

@override
String toString() {
  return 'SlideshowBlock(title: $title, slides: $slides, type: $type)';
}


}

/// @nodoc
abstract mixin class $SlideshowBlockCopyWith<$Res>  {
  factory $SlideshowBlockCopyWith(SlideshowBlock value, $Res Function(SlideshowBlock) _then) = _$SlideshowBlockCopyWithImpl;
@useResult
$Res call({
 String title, List<SlideBlock> slides, String type
});




}
/// @nodoc
class _$SlideshowBlockCopyWithImpl<$Res>
    implements $SlideshowBlockCopyWith<$Res> {
  _$SlideshowBlockCopyWithImpl(this._self, this._then);

  final SlideshowBlock _self;
  final $Res Function(SlideshowBlock) _then;

/// Create a copy of SlideshowBlock
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? title = null,Object? slides = null,Object? type = null,}) {
  return _then(_self.copyWith(
title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,slides: null == slides ? _self.slides : slides // ignore: cast_nullable_to_non_nullable
as List<SlideBlock>,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [SlideshowBlock].
extension SlideshowBlockPatterns on SlideshowBlock {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SlideshowBlock value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SlideshowBlock() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SlideshowBlock value)  $default,){
final _that = this;
switch (_that) {
case _SlideshowBlock():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SlideshowBlock value)?  $default,){
final _that = this;
switch (_that) {
case _SlideshowBlock() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String title,  List<SlideBlock> slides,  String type)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SlideshowBlock() when $default != null:
return $default(_that.title,_that.slides,_that.type);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String title,  List<SlideBlock> slides,  String type)  $default,) {final _that = this;
switch (_that) {
case _SlideshowBlock():
return $default(_that.title,_that.slides,_that.type);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String title,  List<SlideBlock> slides,  String type)?  $default,) {final _that = this;
switch (_that) {
case _SlideshowBlock() when $default != null:
return $default(_that.title,_that.slides,_that.type);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _SlideshowBlock implements SlideshowBlock {
  const _SlideshowBlock({required this.title, required final  List<SlideBlock> slides, this.type = SlideshowBlock.identifier}): _slides = slides;
  factory _SlideshowBlock.fromJson(Map<String, dynamic> json) => _$SlideshowBlockFromJson(json);

@override final  String title;
 final  List<SlideBlock> _slides;
@override List<SlideBlock> get slides {
  if (_slides is EqualUnmodifiableListView) return _slides;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_slides);
}

@override@JsonKey() final  String type;

/// Create a copy of SlideshowBlock
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SlideshowBlockCopyWith<_SlideshowBlock> get copyWith => __$SlideshowBlockCopyWithImpl<_SlideshowBlock>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$SlideshowBlockToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SlideshowBlock&&(identical(other.title, title) || other.title == title)&&const DeepCollectionEquality().equals(other._slides, _slides)&&(identical(other.type, type) || other.type == type));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,title,const DeepCollectionEquality().hash(_slides),type);

@override
String toString() {
  return 'SlideshowBlock(title: $title, slides: $slides, type: $type)';
}


}

/// @nodoc
abstract mixin class _$SlideshowBlockCopyWith<$Res> implements $SlideshowBlockCopyWith<$Res> {
  factory _$SlideshowBlockCopyWith(_SlideshowBlock value, $Res Function(_SlideshowBlock) _then) = __$SlideshowBlockCopyWithImpl;
@override @useResult
$Res call({
 String title, List<SlideBlock> slides, String type
});




}
/// @nodoc
class __$SlideshowBlockCopyWithImpl<$Res>
    implements _$SlideshowBlockCopyWith<$Res> {
  __$SlideshowBlockCopyWithImpl(this._self, this._then);

  final _SlideshowBlock _self;
  final $Res Function(_SlideshowBlock) _then;

/// Create a copy of SlideshowBlock
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? title = null,Object? slides = null,Object? type = null,}) {
  return _then(_SlideshowBlock(
title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,slides: null == slides ? _self._slides : slides // ignore: cast_nullable_to_non_nullable
as List<SlideBlock>,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
