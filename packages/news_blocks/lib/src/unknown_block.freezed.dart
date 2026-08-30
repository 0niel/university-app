// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'unknown_block.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$UnknownBlock {

 Map<String, dynamic> get rawJson;
/// Create a copy of UnknownBlock
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$UnknownBlockCopyWith<UnknownBlock> get copyWith => _$UnknownBlockCopyWithImpl<UnknownBlock>(this as UnknownBlock, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is UnknownBlock&&const DeepCollectionEquality().equals(other.rawJson, rawJson));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(rawJson));

@override
String toString() {
  return 'UnknownBlock(rawJson: $rawJson)';
}


}

/// @nodoc
abstract mixin class $UnknownBlockCopyWith<$Res>  {
  factory $UnknownBlockCopyWith(UnknownBlock value, $Res Function(UnknownBlock) _then) = _$UnknownBlockCopyWithImpl;
@useResult
$Res call({
 Map<String, dynamic> rawJson
});




}
/// @nodoc
class _$UnknownBlockCopyWithImpl<$Res>
    implements $UnknownBlockCopyWith<$Res> {
  _$UnknownBlockCopyWithImpl(this._self, this._then);

  final UnknownBlock _self;
  final $Res Function(UnknownBlock) _then;

/// Create a copy of UnknownBlock
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? rawJson = null,}) {
  return _then(_self.copyWith(
rawJson: null == rawJson ? _self.rawJson : rawJson // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>,
  ));
}

}


/// Adds pattern-matching-related methods to [UnknownBlock].
extension UnknownBlockPatterns on UnknownBlock {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _UnknownBlock value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _UnknownBlock() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _UnknownBlock value)  $default,){
final _that = this;
switch (_that) {
case _UnknownBlock():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _UnknownBlock value)?  $default,){
final _that = this;
switch (_that) {
case _UnknownBlock() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( Map<String, dynamic> rawJson)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _UnknownBlock() when $default != null:
return $default(_that.rawJson);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( Map<String, dynamic> rawJson)  $default,) {final _that = this;
switch (_that) {
case _UnknownBlock():
return $default(_that.rawJson);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( Map<String, dynamic> rawJson)?  $default,) {final _that = this;
switch (_that) {
case _UnknownBlock() when $default != null:
return $default(_that.rawJson);case _:
  return null;

}
}

}

/// @nodoc


class _UnknownBlock extends UnknownBlock {
  const _UnknownBlock({final  Map<String, dynamic> rawJson = const <String, dynamic>{'type' : UnknownBlock.identifier}}): _rawJson = rawJson,super._();


 final  Map<String, dynamic> _rawJson;
@override@JsonKey() Map<String, dynamic> get rawJson {
  if (_rawJson is EqualUnmodifiableMapView) return _rawJson;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_rawJson);
}


/// Create a copy of UnknownBlock
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$UnknownBlockCopyWith<_UnknownBlock> get copyWith => __$UnknownBlockCopyWithImpl<_UnknownBlock>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _UnknownBlock&&const DeepCollectionEquality().equals(other._rawJson, _rawJson));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_rawJson));

@override
String toString() {
  return 'UnknownBlock(rawJson: $rawJson)';
}


}

/// @nodoc
abstract mixin class _$UnknownBlockCopyWith<$Res> implements $UnknownBlockCopyWith<$Res> {
  factory _$UnknownBlockCopyWith(_UnknownBlock value, $Res Function(_UnknownBlock) _then) = __$UnknownBlockCopyWithImpl;
@override @useResult
$Res call({
 Map<String, dynamic> rawJson
});




}
/// @nodoc
class __$UnknownBlockCopyWithImpl<$Res>
    implements _$UnknownBlockCopyWith<$Res> {
  __$UnknownBlockCopyWithImpl(this._self, this._then);

  final _UnknownBlock _self;
  final $Res Function(_UnknownBlock) _then;

/// Create a copy of UnknownBlock
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? rawJson = null,}) {
  return _then(_UnknownBlock(
rawJson: null == rawJson ? _self._rawJson : rawJson // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>,
  ));
}


}

// dart format on
