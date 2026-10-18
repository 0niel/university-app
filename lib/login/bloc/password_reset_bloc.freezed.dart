// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'password_reset_bloc.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$PasswordResetState {

 PasswordResetStep get step; Email get email; String get code; Password get password; ConfirmedPassword get confirmedPassword; String? get verifiedUserId; FormzSubmissionStatus get status; PasswordResetError? get error; int get resendSeconds;
/// Create a copy of PasswordResetState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PasswordResetStateCopyWith<PasswordResetState> get copyWith => _$PasswordResetStateCopyWithImpl<PasswordResetState>(this as PasswordResetState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PasswordResetState&&(identical(other.step, step) || other.step == step)&&(identical(other.email, email) || other.email == email)&&(identical(other.code, code) || other.code == code)&&(identical(other.password, password) || other.password == password)&&(identical(other.confirmedPassword, confirmedPassword) || other.confirmedPassword == confirmedPassword)&&(identical(other.verifiedUserId, verifiedUserId) || other.verifiedUserId == verifiedUserId)&&(identical(other.status, status) || other.status == status)&&(identical(other.error, error) || other.error == error)&&(identical(other.resendSeconds, resendSeconds) || other.resendSeconds == resendSeconds));
}


@override
int get hashCode => Object.hash(runtimeType,step,email,code,password,confirmedPassword,verifiedUserId,status,error,resendSeconds);

@override
String toString() {
  return 'PasswordResetState(step: $step, email: $email, code: $code, password: $password, confirmedPassword: $confirmedPassword, verifiedUserId: $verifiedUserId, status: $status, error: $error, resendSeconds: $resendSeconds)';
}


}

/// @nodoc
abstract mixin class $PasswordResetStateCopyWith<$Res>  {
  factory $PasswordResetStateCopyWith(PasswordResetState value, $Res Function(PasswordResetState) _then) = _$PasswordResetStateCopyWithImpl;
@useResult
$Res call({
 PasswordResetStep step, Email email, String code, Password password, ConfirmedPassword confirmedPassword, String? verifiedUserId, FormzSubmissionStatus status, PasswordResetError? error, int resendSeconds
});




}
/// @nodoc
class _$PasswordResetStateCopyWithImpl<$Res>
    implements $PasswordResetStateCopyWith<$Res> {
  _$PasswordResetStateCopyWithImpl(this._self, this._then);

  final PasswordResetState _self;
  final $Res Function(PasswordResetState) _then;

/// Create a copy of PasswordResetState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? step = null,Object? email = null,Object? code = null,Object? password = null,Object? confirmedPassword = null,Object? verifiedUserId = freezed,Object? status = null,Object? error = freezed,Object? resendSeconds = null,}) {
  return _then(_self.copyWith(
step: null == step ? _self.step : step // ignore: cast_nullable_to_non_nullable
as PasswordResetStep,email: null == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as Email,code: null == code ? _self.code : code // ignore: cast_nullable_to_non_nullable
as String,password: null == password ? _self.password : password // ignore: cast_nullable_to_non_nullable
as Password,confirmedPassword: null == confirmedPassword ? _self.confirmedPassword : confirmedPassword // ignore: cast_nullable_to_non_nullable
as ConfirmedPassword,verifiedUserId: freezed == verifiedUserId ? _self.verifiedUserId : verifiedUserId // ignore: cast_nullable_to_non_nullable
as String?,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as FormzSubmissionStatus,error: freezed == error ? _self.error : error // ignore: cast_nullable_to_non_nullable
as PasswordResetError?,resendSeconds: null == resendSeconds ? _self.resendSeconds : resendSeconds // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [PasswordResetState].
extension PasswordResetStatePatterns on PasswordResetState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PasswordResetState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PasswordResetState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PasswordResetState value)  $default,){
final _that = this;
switch (_that) {
case _PasswordResetState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PasswordResetState value)?  $default,){
final _that = this;
switch (_that) {
case _PasswordResetState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( PasswordResetStep step,  Email email,  String code,  Password password,  ConfirmedPassword confirmedPassword,  String? verifiedUserId,  FormzSubmissionStatus status,  PasswordResetError? error,  int resendSeconds)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PasswordResetState() when $default != null:
return $default(_that.step,_that.email,_that.code,_that.password,_that.confirmedPassword,_that.verifiedUserId,_that.status,_that.error,_that.resendSeconds);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( PasswordResetStep step,  Email email,  String code,  Password password,  ConfirmedPassword confirmedPassword,  String? verifiedUserId,  FormzSubmissionStatus status,  PasswordResetError? error,  int resendSeconds)  $default,) {final _that = this;
switch (_that) {
case _PasswordResetState():
return $default(_that.step,_that.email,_that.code,_that.password,_that.confirmedPassword,_that.verifiedUserId,_that.status,_that.error,_that.resendSeconds);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( PasswordResetStep step,  Email email,  String code,  Password password,  ConfirmedPassword confirmedPassword,  String? verifiedUserId,  FormzSubmissionStatus status,  PasswordResetError? error,  int resendSeconds)?  $default,) {final _that = this;
switch (_that) {
case _PasswordResetState() when $default != null:
return $default(_that.step,_that.email,_that.code,_that.password,_that.confirmedPassword,_that.verifiedUserId,_that.status,_that.error,_that.resendSeconds);case _:
  return null;

}
}

}

/// @nodoc


class _PasswordResetState extends PasswordResetState {
  const _PasswordResetState({this.step = PasswordResetStep.email, this.email = const Email.pure(), this.code = '', this.password = const Password.pure(), this.confirmedPassword = const ConfirmedPassword.pure(), this.verifiedUserId, this.status = FormzSubmissionStatus.initial, this.error, this.resendSeconds = 0}): super._();


@override@JsonKey() final  PasswordResetStep step;
@override@JsonKey() final  Email email;
@override@JsonKey() final  String code;
@override@JsonKey() final  Password password;
@override@JsonKey() final  ConfirmedPassword confirmedPassword;
@override final  String? verifiedUserId;
@override@JsonKey() final  FormzSubmissionStatus status;
@override final  PasswordResetError? error;
@override@JsonKey() final  int resendSeconds;

/// Create a copy of PasswordResetState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PasswordResetStateCopyWith<_PasswordResetState> get copyWith => __$PasswordResetStateCopyWithImpl<_PasswordResetState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PasswordResetState&&(identical(other.step, step) || other.step == step)&&(identical(other.email, email) || other.email == email)&&(identical(other.code, code) || other.code == code)&&(identical(other.password, password) || other.password == password)&&(identical(other.confirmedPassword, confirmedPassword) || other.confirmedPassword == confirmedPassword)&&(identical(other.verifiedUserId, verifiedUserId) || other.verifiedUserId == verifiedUserId)&&(identical(other.status, status) || other.status == status)&&(identical(other.error, error) || other.error == error)&&(identical(other.resendSeconds, resendSeconds) || other.resendSeconds == resendSeconds));
}


@override
int get hashCode => Object.hash(runtimeType,step,email,code,password,confirmedPassword,verifiedUserId,status,error,resendSeconds);

@override
String toString() {
  return 'PasswordResetState(step: $step, email: $email, code: $code, password: $password, confirmedPassword: $confirmedPassword, verifiedUserId: $verifiedUserId, status: $status, error: $error, resendSeconds: $resendSeconds)';
}


}

/// @nodoc
abstract mixin class _$PasswordResetStateCopyWith<$Res> implements $PasswordResetStateCopyWith<$Res> {
  factory _$PasswordResetStateCopyWith(_PasswordResetState value, $Res Function(_PasswordResetState) _then) = __$PasswordResetStateCopyWithImpl;
@override @useResult
$Res call({
 PasswordResetStep step, Email email, String code, Password password, ConfirmedPassword confirmedPassword, String? verifiedUserId, FormzSubmissionStatus status, PasswordResetError? error, int resendSeconds
});




}
/// @nodoc
class __$PasswordResetStateCopyWithImpl<$Res>
    implements _$PasswordResetStateCopyWith<$Res> {
  __$PasswordResetStateCopyWithImpl(this._self, this._then);

  final _PasswordResetState _self;
  final $Res Function(_PasswordResetState) _then;

/// Create a copy of PasswordResetState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? step = null,Object? email = null,Object? code = null,Object? password = null,Object? confirmedPassword = null,Object? verifiedUserId = freezed,Object? status = null,Object? error = freezed,Object? resendSeconds = null,}) {
  return _then(_PasswordResetState(
step: null == step ? _self.step : step // ignore: cast_nullable_to_non_nullable
as PasswordResetStep,email: null == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as Email,code: null == code ? _self.code : code // ignore: cast_nullable_to_non_nullable
as String,password: null == password ? _self.password : password // ignore: cast_nullable_to_non_nullable
as Password,confirmedPassword: null == confirmedPassword ? _self.confirmedPassword : confirmedPassword // ignore: cast_nullable_to_non_nullable
as ConfirmedPassword,verifiedUserId: freezed == verifiedUserId ? _self.verifiedUserId : verifiedUserId // ignore: cast_nullable_to_non_nullable
as String?,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as FormzSubmissionStatus,error: freezed == error ? _self.error : error // ignore: cast_nullable_to_non_nullable
as PasswordResetError?,resendSeconds: null == resendSeconds ? _self.resendSeconds : resendSeconds // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
