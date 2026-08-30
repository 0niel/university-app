// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'biometric_capability.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$BiometricCapability {

 bool get available; BiometricKind get kind;
/// Create a copy of BiometricCapability
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$BiometricCapabilityCopyWith<BiometricCapability> get copyWith => _$BiometricCapabilityCopyWithImpl<BiometricCapability>(this as BiometricCapability, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is BiometricCapability&&(identical(other.available, available) || other.available == available)&&(identical(other.kind, kind) || other.kind == kind));
}


@override
int get hashCode => Object.hash(runtimeType,available,kind);

@override
String toString() {
  return 'BiometricCapability(available: $available, kind: $kind)';
}


}

/// @nodoc
abstract mixin class $BiometricCapabilityCopyWith<$Res>  {
  factory $BiometricCapabilityCopyWith(BiometricCapability value, $Res Function(BiometricCapability) _then) = _$BiometricCapabilityCopyWithImpl;
@useResult
$Res call({
 bool available, BiometricKind kind
});




}
/// @nodoc
class _$BiometricCapabilityCopyWithImpl<$Res>
    implements $BiometricCapabilityCopyWith<$Res> {
  _$BiometricCapabilityCopyWithImpl(this._self, this._then);

  final BiometricCapability _self;
  final $Res Function(BiometricCapability) _then;

/// Create a copy of BiometricCapability
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? available = null,Object? kind = null,}) {
  return _then(_self.copyWith(
available: null == available ? _self.available : available // ignore: cast_nullable_to_non_nullable
as bool,kind: null == kind ? _self.kind : kind // ignore: cast_nullable_to_non_nullable
as BiometricKind,
  ));
}

}


/// Adds pattern-matching-related methods to [BiometricCapability].
extension BiometricCapabilityPatterns on BiometricCapability {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _BiometricCapability value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _BiometricCapability() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _BiometricCapability value)  $default,){
final _that = this;
switch (_that) {
case _BiometricCapability():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _BiometricCapability value)?  $default,){
final _that = this;
switch (_that) {
case _BiometricCapability() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( bool available,  BiometricKind kind)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _BiometricCapability() when $default != null:
return $default(_that.available,_that.kind);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( bool available,  BiometricKind kind)  $default,) {final _that = this;
switch (_that) {
case _BiometricCapability():
return $default(_that.available,_that.kind);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( bool available,  BiometricKind kind)?  $default,) {final _that = this;
switch (_that) {
case _BiometricCapability() when $default != null:
return $default(_that.available,_that.kind);case _:
  return null;

}
}

}

/// @nodoc


class _BiometricCapability extends BiometricCapability {
  const _BiometricCapability({required this.available, required this.kind}): super._();


@override final  bool available;
@override final  BiometricKind kind;

/// Create a copy of BiometricCapability
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$BiometricCapabilityCopyWith<_BiometricCapability> get copyWith => __$BiometricCapabilityCopyWithImpl<_BiometricCapability>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _BiometricCapability&&(identical(other.available, available) || other.available == available)&&(identical(other.kind, kind) || other.kind == kind));
}


@override
int get hashCode => Object.hash(runtimeType,available,kind);

@override
String toString() {
  return 'BiometricCapability(available: $available, kind: $kind)';
}


}

/// @nodoc
abstract mixin class _$BiometricCapabilityCopyWith<$Res> implements $BiometricCapabilityCopyWith<$Res> {
  factory _$BiometricCapabilityCopyWith(_BiometricCapability value, $Res Function(_BiometricCapability) _then) = __$BiometricCapabilityCopyWithImpl;
@override @useResult
$Res call({
 bool available, BiometricKind kind
});




}
/// @nodoc
class __$BiometricCapabilityCopyWithImpl<$Res>
    implements _$BiometricCapabilityCopyWith<$Res> {
  __$BiometricCapabilityCopyWithImpl(this._self, this._then);

  final _BiometricCapability _self;
  final $Res Function(_BiometricCapability) _then;

/// Create a copy of BiometricCapability
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? available = null,Object? kind = null,}) {
  return _then(_BiometricCapability(
available: null == available ? _self.available : available // ignore: cast_nullable_to_non_nullable
as bool,kind: null == kind ? _self.kind : kind // ignore: cast_nullable_to_non_nullable
as BiometricKind,
  ));
}


}

// dart format on
