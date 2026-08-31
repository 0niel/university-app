// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'divider_horizontal_block.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$DividerHorizontalBlock {

 String get type;
/// Create a copy of DividerHorizontalBlock
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DividerHorizontalBlockCopyWith<DividerHorizontalBlock> get copyWith => _$DividerHorizontalBlockCopyWithImpl<DividerHorizontalBlock>(this as DividerHorizontalBlock, _$identity);

  /// Serializes this DividerHorizontalBlock to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DividerHorizontalBlock&&(identical(other.type, type) || other.type == type));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,type);

@override
String toString() {
  return 'DividerHorizontalBlock(type: $type)';
}


}

/// @nodoc
abstract mixin class $DividerHorizontalBlockCopyWith<$Res>  {
  factory $DividerHorizontalBlockCopyWith(DividerHorizontalBlock value, $Res Function(DividerHorizontalBlock) _then) = _$DividerHorizontalBlockCopyWithImpl;
@useResult
$Res call({
 String type
});




}
/// @nodoc
class _$DividerHorizontalBlockCopyWithImpl<$Res>
    implements $DividerHorizontalBlockCopyWith<$Res> {
  _$DividerHorizontalBlockCopyWithImpl(this._self, this._then);

  final DividerHorizontalBlock _self;
  final $Res Function(DividerHorizontalBlock) _then;

/// Create a copy of DividerHorizontalBlock
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? type = null,}) {
  return _then(_self.copyWith(
type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [DividerHorizontalBlock].
extension DividerHorizontalBlockPatterns on DividerHorizontalBlock {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _DividerHorizontalBlock value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _DividerHorizontalBlock() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _DividerHorizontalBlock value)  $default,){
final _that = this;
switch (_that) {
case _DividerHorizontalBlock():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _DividerHorizontalBlock value)?  $default,){
final _that = this;
switch (_that) {
case _DividerHorizontalBlock() when $default != null:
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
case _DividerHorizontalBlock() when $default != null:
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
case _DividerHorizontalBlock():
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
case _DividerHorizontalBlock() when $default != null:
return $default(_that.type);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _DividerHorizontalBlock implements DividerHorizontalBlock {
  const _DividerHorizontalBlock({this.type = DividerHorizontalBlock.identifier});
  factory _DividerHorizontalBlock.fromJson(Map<String, dynamic> json) => _$DividerHorizontalBlockFromJson(json);

@override@JsonKey() final  String type;

/// Create a copy of DividerHorizontalBlock
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DividerHorizontalBlockCopyWith<_DividerHorizontalBlock> get copyWith => __$DividerHorizontalBlockCopyWithImpl<_DividerHorizontalBlock>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$DividerHorizontalBlockToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _DividerHorizontalBlock&&(identical(other.type, type) || other.type == type));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,type);

@override
String toString() {
  return 'DividerHorizontalBlock(type: $type)';
}


}

/// @nodoc
abstract mixin class _$DividerHorizontalBlockCopyWith<$Res> implements $DividerHorizontalBlockCopyWith<$Res> {
  factory _$DividerHorizontalBlockCopyWith(_DividerHorizontalBlock value, $Res Function(_DividerHorizontalBlock) _then) = __$DividerHorizontalBlockCopyWithImpl;
@override @useResult
$Res call({
 String type
});




}
/// @nodoc
class __$DividerHorizontalBlockCopyWithImpl<$Res>
    implements _$DividerHorizontalBlockCopyWith<$Res> {
  __$DividerHorizontalBlockCopyWithImpl(this._self, this._then);

  final _DividerHorizontalBlock _self;
  final $Res Function(_DividerHorizontalBlock) _then;

/// Create a copy of DividerHorizontalBlock
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? type = null,}) {
  return _then(_DividerHorizontalBlock(
type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
