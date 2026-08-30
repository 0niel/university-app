// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'spacer_block.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$SpacerBlock {

 Spacing get spacing; String get type;
/// Create a copy of SpacerBlock
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SpacerBlockCopyWith<SpacerBlock> get copyWith => _$SpacerBlockCopyWithImpl<SpacerBlock>(this as SpacerBlock, _$identity);

  /// Serializes this SpacerBlock to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SpacerBlock&&(identical(other.spacing, spacing) || other.spacing == spacing)&&(identical(other.type, type) || other.type == type));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,spacing,type);

@override
String toString() {
  return 'SpacerBlock(spacing: $spacing, type: $type)';
}


}

/// @nodoc
abstract mixin class $SpacerBlockCopyWith<$Res>  {
  factory $SpacerBlockCopyWith(SpacerBlock value, $Res Function(SpacerBlock) _then) = _$SpacerBlockCopyWithImpl;
@useResult
$Res call({
 Spacing spacing, String type
});




}
/// @nodoc
class _$SpacerBlockCopyWithImpl<$Res>
    implements $SpacerBlockCopyWith<$Res> {
  _$SpacerBlockCopyWithImpl(this._self, this._then);

  final SpacerBlock _self;
  final $Res Function(SpacerBlock) _then;

/// Create a copy of SpacerBlock
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? spacing = null,Object? type = null,}) {
  return _then(_self.copyWith(
spacing: null == spacing ? _self.spacing : spacing // ignore: cast_nullable_to_non_nullable
as Spacing,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [SpacerBlock].
extension SpacerBlockPatterns on SpacerBlock {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SpacerBlock value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SpacerBlock() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SpacerBlock value)  $default,){
final _that = this;
switch (_that) {
case _SpacerBlock():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SpacerBlock value)?  $default,){
final _that = this;
switch (_that) {
case _SpacerBlock() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( Spacing spacing,  String type)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SpacerBlock() when $default != null:
return $default(_that.spacing,_that.type);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( Spacing spacing,  String type)  $default,) {final _that = this;
switch (_that) {
case _SpacerBlock():
return $default(_that.spacing,_that.type);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( Spacing spacing,  String type)?  $default,) {final _that = this;
switch (_that) {
case _SpacerBlock() when $default != null:
return $default(_that.spacing,_that.type);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _SpacerBlock implements SpacerBlock {
  const _SpacerBlock({required this.spacing, this.type = SpacerBlock.identifier});
  factory _SpacerBlock.fromJson(Map<String, dynamic> json) => _$SpacerBlockFromJson(json);

@override final  Spacing spacing;
@override@JsonKey() final  String type;

/// Create a copy of SpacerBlock
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SpacerBlockCopyWith<_SpacerBlock> get copyWith => __$SpacerBlockCopyWithImpl<_SpacerBlock>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$SpacerBlockToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SpacerBlock&&(identical(other.spacing, spacing) || other.spacing == spacing)&&(identical(other.type, type) || other.type == type));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,spacing,type);

@override
String toString() {
  return 'SpacerBlock(spacing: $spacing, type: $type)';
}


}

/// @nodoc
abstract mixin class _$SpacerBlockCopyWith<$Res> implements $SpacerBlockCopyWith<$Res> {
  factory _$SpacerBlockCopyWith(_SpacerBlock value, $Res Function(_SpacerBlock) _then) = __$SpacerBlockCopyWithImpl;
@override @useResult
$Res call({
 Spacing spacing, String type
});




}
/// @nodoc
class __$SpacerBlockCopyWithImpl<$Res>
    implements _$SpacerBlockCopyWith<$Res> {
  __$SpacerBlockCopyWithImpl(this._self, this._then);

  final _SpacerBlock _self;
  final $Res Function(_SpacerBlock) _then;

/// Create a copy of SpacerBlock
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? spacing = null,Object? type = null,}) {
  return _then(_SpacerBlock(
spacing: null == spacing ? _self.spacing : spacing // ignore: cast_nullable_to_non_nullable
as Spacing,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
