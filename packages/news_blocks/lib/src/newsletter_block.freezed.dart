// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'newsletter_block.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$NewsletterBlock {

 String get type;
/// Create a copy of NewsletterBlock
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$NewsletterBlockCopyWith<NewsletterBlock> get copyWith => _$NewsletterBlockCopyWithImpl<NewsletterBlock>(this as NewsletterBlock, _$identity);

  /// Serializes this NewsletterBlock to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is NewsletterBlock&&(identical(other.type, type) || other.type == type));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,type);

@override
String toString() {
  return 'NewsletterBlock(type: $type)';
}


}

/// @nodoc
abstract mixin class $NewsletterBlockCopyWith<$Res>  {
  factory $NewsletterBlockCopyWith(NewsletterBlock value, $Res Function(NewsletterBlock) _then) = _$NewsletterBlockCopyWithImpl;
@useResult
$Res call({
 String type
});




}
/// @nodoc
class _$NewsletterBlockCopyWithImpl<$Res>
    implements $NewsletterBlockCopyWith<$Res> {
  _$NewsletterBlockCopyWithImpl(this._self, this._then);

  final NewsletterBlock _self;
  final $Res Function(NewsletterBlock) _then;

/// Create a copy of NewsletterBlock
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? type = null,}) {
  return _then(_self.copyWith(
type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [NewsletterBlock].
extension NewsletterBlockPatterns on NewsletterBlock {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _NewsletterBlock value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _NewsletterBlock() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _NewsletterBlock value)  $default,){
final _that = this;
switch (_that) {
case _NewsletterBlock():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _NewsletterBlock value)?  $default,){
final _that = this;
switch (_that) {
case _NewsletterBlock() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String type)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _NewsletterBlock() when $default != null:
return $default(_that.type);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String type)  $default,) {final _that = this;
switch (_that) {
case _NewsletterBlock():
return $default(_that.type);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String type)?  $default,) {final _that = this;
switch (_that) {
case _NewsletterBlock() when $default != null:
return $default(_that.type);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _NewsletterBlock implements NewsletterBlock {
  const _NewsletterBlock({this.type = NewsletterBlock.identifier});
  factory _NewsletterBlock.fromJson(Map<String, dynamic> json) => _$NewsletterBlockFromJson(json);

@override@JsonKey() final  String type;

/// Create a copy of NewsletterBlock
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$NewsletterBlockCopyWith<_NewsletterBlock> get copyWith => __$NewsletterBlockCopyWithImpl<_NewsletterBlock>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$NewsletterBlockToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _NewsletterBlock&&(identical(other.type, type) || other.type == type));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,type);

@override
String toString() {
  return 'NewsletterBlock(type: $type)';
}


}

/// @nodoc
abstract mixin class _$NewsletterBlockCopyWith<$Res> implements $NewsletterBlockCopyWith<$Res> {
  factory _$NewsletterBlockCopyWith(_NewsletterBlock value, $Res Function(_NewsletterBlock) _then) = __$NewsletterBlockCopyWithImpl;
@override @useResult
$Res call({
 String type
});




}
/// @nodoc
class __$NewsletterBlockCopyWithImpl<$Res>
    implements _$NewsletterBlockCopyWith<$Res> {
  __$NewsletterBlockCopyWithImpl(this._self, this._then);

  final _NewsletterBlock _self;
  final $Res Function(_NewsletterBlock) _then;

/// Create a copy of NewsletterBlock
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? type = null,}) {
  return _then(_NewsletterBlock(
type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
