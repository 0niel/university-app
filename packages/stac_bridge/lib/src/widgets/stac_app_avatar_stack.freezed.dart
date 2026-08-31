// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'stac_app_avatar_stack.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$StacAppAvatarStack {

@JsonKey(fromJson: stringListOrEmpty) List<String> get names;@JsonKey(fromJson: _avatarStackSizeFromJson) double get size;
/// Create a copy of StacAppAvatarStack
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$StacAppAvatarStackCopyWith<StacAppAvatarStack> get copyWith => _$StacAppAvatarStackCopyWithImpl<StacAppAvatarStack>(this as StacAppAvatarStack, _$identity);

  /// Serializes this StacAppAvatarStack to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is StacAppAvatarStack&&const DeepCollectionEquality().equals(other.names, names)&&(identical(other.size, size) || other.size == size));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(names),size);

@override
String toString() {
  return 'StacAppAvatarStack(names: $names, size: $size)';
}


}

/// @nodoc
abstract mixin class $StacAppAvatarStackCopyWith<$Res>  {
  factory $StacAppAvatarStackCopyWith(StacAppAvatarStack value, $Res Function(StacAppAvatarStack) _then) = _$StacAppAvatarStackCopyWithImpl;
@useResult
$Res call({
@JsonKey(fromJson: stringListOrEmpty) List<String> names,@JsonKey(fromJson: _avatarStackSizeFromJson) double size
});




}
/// @nodoc
class _$StacAppAvatarStackCopyWithImpl<$Res>
    implements $StacAppAvatarStackCopyWith<$Res> {
  _$StacAppAvatarStackCopyWithImpl(this._self, this._then);

  final StacAppAvatarStack _self;
  final $Res Function(StacAppAvatarStack) _then;

/// Create a copy of StacAppAvatarStack
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? names = null,Object? size = null,}) {
  return _then(_self.copyWith(
names: null == names ? _self.names : names // ignore: cast_nullable_to_non_nullable
as List<String>,size: null == size ? _self.size : size // ignore: cast_nullable_to_non_nullable
as double,
  ));
}

}


/// Adds pattern-matching-related methods to [StacAppAvatarStack].
extension StacAppAvatarStackPatterns on StacAppAvatarStack {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _StacAppAvatarStack value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _StacAppAvatarStack() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _StacAppAvatarStack value)  $default,){
final _that = this;
switch (_that) {
case _StacAppAvatarStack():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _StacAppAvatarStack value)?  $default,){
final _that = this;
switch (_that) {
case _StacAppAvatarStack() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(fromJson: stringListOrEmpty)  List<String> names, @JsonKey(fromJson: _avatarStackSizeFromJson)  double size)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _StacAppAvatarStack() when $default != null:
return $default(_that.names,_that.size);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(fromJson: stringListOrEmpty)  List<String> names, @JsonKey(fromJson: _avatarStackSizeFromJson)  double size)  $default,) {final _that = this;
switch (_that) {
case _StacAppAvatarStack():
return $default(_that.names,_that.size);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(fromJson: stringListOrEmpty)  List<String> names, @JsonKey(fromJson: _avatarStackSizeFromJson)  double size)?  $default,) {final _that = this;
switch (_that) {
case _StacAppAvatarStack() when $default != null:
return $default(_that.names,_that.size);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _StacAppAvatarStack implements StacAppAvatarStack {
  const _StacAppAvatarStack({@JsonKey(fromJson: stringListOrEmpty) required final  List<String> names, @JsonKey(fromJson: _avatarStackSizeFromJson) this.size = 36}): _names = names;
  factory _StacAppAvatarStack.fromJson(Map<String, dynamic> json) => _$StacAppAvatarStackFromJson(json);

 final  List<String> _names;
@override@JsonKey(fromJson: stringListOrEmpty) List<String> get names {
  if (_names is EqualUnmodifiableListView) return _names;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_names);
}

@override@JsonKey(fromJson: _avatarStackSizeFromJson) final  double size;

/// Create a copy of StacAppAvatarStack
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$StacAppAvatarStackCopyWith<_StacAppAvatarStack> get copyWith => __$StacAppAvatarStackCopyWithImpl<_StacAppAvatarStack>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$StacAppAvatarStackToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _StacAppAvatarStack&&const DeepCollectionEquality().equals(other._names, _names)&&(identical(other.size, size) || other.size == size));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_names),size);

@override
String toString() {
  return 'StacAppAvatarStack(names: $names, size: $size)';
}


}

/// @nodoc
abstract mixin class _$StacAppAvatarStackCopyWith<$Res> implements $StacAppAvatarStackCopyWith<$Res> {
  factory _$StacAppAvatarStackCopyWith(_StacAppAvatarStack value, $Res Function(_StacAppAvatarStack) _then) = __$StacAppAvatarStackCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(fromJson: stringListOrEmpty) List<String> names,@JsonKey(fromJson: _avatarStackSizeFromJson) double size
});




}
/// @nodoc
class __$StacAppAvatarStackCopyWithImpl<$Res>
    implements _$StacAppAvatarStackCopyWith<$Res> {
  __$StacAppAvatarStackCopyWithImpl(this._self, this._then);

  final _StacAppAvatarStack _self;
  final $Res Function(_StacAppAvatarStack) _then;

/// Create a copy of StacAppAvatarStack
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? names = null,Object? size = null,}) {
  return _then(_StacAppAvatarStack(
names: null == names ? _self._names : names // ignore: cast_nullable_to_non_nullable
as List<String>,size: null == size ? _self.size : size // ignore: cast_nullable_to_non_nullable
as double,
  ));
}


}

// dart format on
