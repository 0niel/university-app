// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'pass_security_cubit.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$PassSecurityState {

 bool get enabled; bool get available; BiometricKind get kind;
/// Create a copy of PassSecurityState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PassSecurityStateCopyWith<PassSecurityState> get copyWith => _$PassSecurityStateCopyWithImpl<PassSecurityState>(this as PassSecurityState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PassSecurityState&&(identical(other.enabled, enabled) || other.enabled == enabled)&&(identical(other.available, available) || other.available == available)&&(identical(other.kind, kind) || other.kind == kind));
}


@override
int get hashCode => Object.hash(runtimeType,enabled,available,kind);

@override
String toString() {
  return 'PassSecurityState(enabled: $enabled, available: $available, kind: $kind)';
}


}

/// @nodoc
abstract mixin class $PassSecurityStateCopyWith<$Res>  {
  factory $PassSecurityStateCopyWith(PassSecurityState value, $Res Function(PassSecurityState) _then) = _$PassSecurityStateCopyWithImpl;
@useResult
$Res call({
 bool enabled, bool available, BiometricKind kind
});




}
/// @nodoc
class _$PassSecurityStateCopyWithImpl<$Res>
    implements $PassSecurityStateCopyWith<$Res> {
  _$PassSecurityStateCopyWithImpl(this._self, this._then);

  final PassSecurityState _self;
  final $Res Function(PassSecurityState) _then;

/// Create a copy of PassSecurityState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? enabled = null,Object? available = null,Object? kind = null,}) {
  return _then(_self.copyWith(
enabled: null == enabled ? _self.enabled : enabled // ignore: cast_nullable_to_non_nullable
as bool,available: null == available ? _self.available : available // ignore: cast_nullable_to_non_nullable
as bool,kind: null == kind ? _self.kind : kind // ignore: cast_nullable_to_non_nullable
as BiometricKind,
  ));
}

}


/// Adds pattern-matching-related methods to [PassSecurityState].
extension PassSecurityStatePatterns on PassSecurityState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PassSecurityState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PassSecurityState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PassSecurityState value)  $default,){
final _that = this;
switch (_that) {
case _PassSecurityState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PassSecurityState value)?  $default,){
final _that = this;
switch (_that) {
case _PassSecurityState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( bool enabled,  bool available,  BiometricKind kind)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PassSecurityState() when $default != null:
return $default(_that.enabled,_that.available,_that.kind);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( bool enabled,  bool available,  BiometricKind kind)  $default,) {final _that = this;
switch (_that) {
case _PassSecurityState():
return $default(_that.enabled,_that.available,_that.kind);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( bool enabled,  bool available,  BiometricKind kind)?  $default,) {final _that = this;
switch (_that) {
case _PassSecurityState() when $default != null:
return $default(_that.enabled,_that.available,_that.kind);case _:
  return null;

}
}

}

/// @nodoc


class _PassSecurityState extends PassSecurityState {
  const _PassSecurityState({this.enabled = false, this.available = false, this.kind = BiometricKind.none}): super._();


@override@JsonKey() final  bool enabled;
@override@JsonKey() final  bool available;
@override@JsonKey() final  BiometricKind kind;

/// Create a copy of PassSecurityState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PassSecurityStateCopyWith<_PassSecurityState> get copyWith => __$PassSecurityStateCopyWithImpl<_PassSecurityState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PassSecurityState&&(identical(other.enabled, enabled) || other.enabled == enabled)&&(identical(other.available, available) || other.available == available)&&(identical(other.kind, kind) || other.kind == kind));
}


@override
int get hashCode => Object.hash(runtimeType,enabled,available,kind);

@override
String toString() {
  return 'PassSecurityState(enabled: $enabled, available: $available, kind: $kind)';
}


}

/// @nodoc
abstract mixin class _$PassSecurityStateCopyWith<$Res> implements $PassSecurityStateCopyWith<$Res> {
  factory _$PassSecurityStateCopyWith(_PassSecurityState value, $Res Function(_PassSecurityState) _then) = __$PassSecurityStateCopyWithImpl;
@override @useResult
$Res call({
 bool enabled, bool available, BiometricKind kind
});




}
/// @nodoc
class __$PassSecurityStateCopyWithImpl<$Res>
    implements _$PassSecurityStateCopyWith<$Res> {
  __$PassSecurityStateCopyWithImpl(this._self, this._then);

  final _PassSecurityState _self;
  final $Res Function(_PassSecurityState) _then;

/// Create a copy of PassSecurityState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? enabled = null,Object? available = null,Object? kind = null,}) {
  return _then(_PassSecurityState(
enabled: null == enabled ? _self.enabled : enabled // ignore: cast_nullable_to_non_nullable
as bool,available: null == available ? _self.available : available // ignore: cast_nullable_to_non_nullable
as bool,kind: null == kind ? _self.kind : kind // ignore: cast_nullable_to_non_nullable
as BiometricKind,
  ));
}


}

// dart format on
