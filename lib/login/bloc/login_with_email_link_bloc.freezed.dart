// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'login_with_email_link_bloc.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$LoginWithEmailLinkState {

 LoginWithEmailLinkStatus get status;
/// Create a copy of LoginWithEmailLinkState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$LoginWithEmailLinkStateCopyWith<LoginWithEmailLinkState> get copyWith => _$LoginWithEmailLinkStateCopyWithImpl<LoginWithEmailLinkState>(this as LoginWithEmailLinkState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is LoginWithEmailLinkState&&(identical(other.status, status) || other.status == status));
}


@override
int get hashCode => Object.hash(runtimeType,status);

@override
String toString() {
  return 'LoginWithEmailLinkState(status: $status)';
}


}

/// @nodoc
abstract mixin class $LoginWithEmailLinkStateCopyWith<$Res>  {
  factory $LoginWithEmailLinkStateCopyWith(LoginWithEmailLinkState value, $Res Function(LoginWithEmailLinkState) _then) = _$LoginWithEmailLinkStateCopyWithImpl;
@useResult
$Res call({
 LoginWithEmailLinkStatus status
});




}
/// @nodoc
class _$LoginWithEmailLinkStateCopyWithImpl<$Res>
    implements $LoginWithEmailLinkStateCopyWith<$Res> {
  _$LoginWithEmailLinkStateCopyWithImpl(this._self, this._then);

  final LoginWithEmailLinkState _self;
  final $Res Function(LoginWithEmailLinkState) _then;

/// Create a copy of LoginWithEmailLinkState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? status = null,}) {
  return _then(_self.copyWith(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as LoginWithEmailLinkStatus,
  ));
}

}


/// Adds pattern-matching-related methods to [LoginWithEmailLinkState].
extension LoginWithEmailLinkStatePatterns on LoginWithEmailLinkState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _LoginWithEmailLinkState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _LoginWithEmailLinkState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _LoginWithEmailLinkState value)  $default,){
final _that = this;
switch (_that) {
case _LoginWithEmailLinkState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _LoginWithEmailLinkState value)?  $default,){
final _that = this;
switch (_that) {
case _LoginWithEmailLinkState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( LoginWithEmailLinkStatus status)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _LoginWithEmailLinkState() when $default != null:
return $default(_that.status);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( LoginWithEmailLinkStatus status)  $default,) {final _that = this;
switch (_that) {
case _LoginWithEmailLinkState():
return $default(_that.status);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( LoginWithEmailLinkStatus status)?  $default,) {final _that = this;
switch (_that) {
case _LoginWithEmailLinkState() when $default != null:
return $default(_that.status);case _:
  return null;

}
}

}

/// @nodoc


class _LoginWithEmailLinkState extends LoginWithEmailLinkState {
  const _LoginWithEmailLinkState({this.status = LoginWithEmailLinkStatus.initial}): super._();


@override@JsonKey() final  LoginWithEmailLinkStatus status;

/// Create a copy of LoginWithEmailLinkState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$LoginWithEmailLinkStateCopyWith<_LoginWithEmailLinkState> get copyWith => __$LoginWithEmailLinkStateCopyWithImpl<_LoginWithEmailLinkState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _LoginWithEmailLinkState&&(identical(other.status, status) || other.status == status));
}


@override
int get hashCode => Object.hash(runtimeType,status);

@override
String toString() {
  return 'LoginWithEmailLinkState(status: $status)';
}


}

/// @nodoc
abstract mixin class _$LoginWithEmailLinkStateCopyWith<$Res> implements $LoginWithEmailLinkStateCopyWith<$Res> {
  factory _$LoginWithEmailLinkStateCopyWith(_LoginWithEmailLinkState value, $Res Function(_LoginWithEmailLinkState) _then) = __$LoginWithEmailLinkStateCopyWithImpl;
@override @useResult
$Res call({
 LoginWithEmailLinkStatus status
});




}
/// @nodoc
class __$LoginWithEmailLinkStateCopyWithImpl<$Res>
    implements _$LoginWithEmailLinkStateCopyWith<$Res> {
  __$LoginWithEmailLinkStateCopyWithImpl(this._self, this._then);

  final _LoginWithEmailLinkState _self;
  final $Res Function(_LoginWithEmailLinkState) _then;

/// Create a copy of LoginWithEmailLinkState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? status = null,}) {
  return _then(_LoginWithEmailLinkState(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as LoginWithEmailLinkStatus,
  ));
}


}

// dart format on
