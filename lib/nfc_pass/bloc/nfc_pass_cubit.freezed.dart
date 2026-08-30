// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'nfc_pass_cubit.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$NfcPassState {

 NfcPassStatus get status; int? get passId; String? get errorMessage; String? get localFilePath;
/// Create a copy of NfcPassState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$NfcPassStateCopyWith<NfcPassState> get copyWith => _$NfcPassStateCopyWithImpl<NfcPassState>(this as NfcPassState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is NfcPassState&&(identical(other.status, status) || other.status == status)&&(identical(other.passId, passId) || other.passId == passId)&&(identical(other.errorMessage, errorMessage) || other.errorMessage == errorMessage)&&(identical(other.localFilePath, localFilePath) || other.localFilePath == localFilePath));
}


@override
int get hashCode => Object.hash(runtimeType,status,passId,errorMessage,localFilePath);

@override
String toString() {
  return 'NfcPassState(status: $status, passId: $passId, errorMessage: $errorMessage, localFilePath: $localFilePath)';
}


}

/// @nodoc
abstract mixin class $NfcPassStateCopyWith<$Res>  {
  factory $NfcPassStateCopyWith(NfcPassState value, $Res Function(NfcPassState) _then) = _$NfcPassStateCopyWithImpl;
@useResult
$Res call({
 NfcPassStatus status, int? passId, String? errorMessage, String? localFilePath
});




}
/// @nodoc
class _$NfcPassStateCopyWithImpl<$Res>
    implements $NfcPassStateCopyWith<$Res> {
  _$NfcPassStateCopyWithImpl(this._self, this._then);

  final NfcPassState _self;
  final $Res Function(NfcPassState) _then;

/// Create a copy of NfcPassState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? status = null,Object? passId = freezed,Object? errorMessage = freezed,Object? localFilePath = freezed,}) {
  return _then(_self.copyWith(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as NfcPassStatus,passId: freezed == passId ? _self.passId : passId // ignore: cast_nullable_to_non_nullable
as int?,errorMessage: freezed == errorMessage ? _self.errorMessage : errorMessage // ignore: cast_nullable_to_non_nullable
as String?,localFilePath: freezed == localFilePath ? _self.localFilePath : localFilePath // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [NfcPassState].
extension NfcPassStatePatterns on NfcPassState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _NfcPassState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _NfcPassState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _NfcPassState value)  $default,){
final _that = this;
switch (_that) {
case _NfcPassState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _NfcPassState value)?  $default,){
final _that = this;
switch (_that) {
case _NfcPassState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( NfcPassStatus status,  int? passId,  String? errorMessage,  String? localFilePath)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _NfcPassState() when $default != null:
return $default(_that.status,_that.passId,_that.errorMessage,_that.localFilePath);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( NfcPassStatus status,  int? passId,  String? errorMessage,  String? localFilePath)  $default,) {final _that = this;
switch (_that) {
case _NfcPassState():
return $default(_that.status,_that.passId,_that.errorMessage,_that.localFilePath);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( NfcPassStatus status,  int? passId,  String? errorMessage,  String? localFilePath)?  $default,) {final _that = this;
switch (_that) {
case _NfcPassState() when $default != null:
return $default(_that.status,_that.passId,_that.errorMessage,_that.localFilePath);case _:
  return null;

}
}

}

/// @nodoc


class _NfcPassState extends NfcPassState {
  const _NfcPassState({this.status = NfcPassStatus.initial, this.passId, this.errorMessage, this.localFilePath}): super._();


@override@JsonKey() final  NfcPassStatus status;
@override final  int? passId;
@override final  String? errorMessage;
@override final  String? localFilePath;

/// Create a copy of NfcPassState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$NfcPassStateCopyWith<_NfcPassState> get copyWith => __$NfcPassStateCopyWithImpl<_NfcPassState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _NfcPassState&&(identical(other.status, status) || other.status == status)&&(identical(other.passId, passId) || other.passId == passId)&&(identical(other.errorMessage, errorMessage) || other.errorMessage == errorMessage)&&(identical(other.localFilePath, localFilePath) || other.localFilePath == localFilePath));
}


@override
int get hashCode => Object.hash(runtimeType,status,passId,errorMessage,localFilePath);

@override
String toString() {
  return 'NfcPassState(status: $status, passId: $passId, errorMessage: $errorMessage, localFilePath: $localFilePath)';
}


}

/// @nodoc
abstract mixin class _$NfcPassStateCopyWith<$Res> implements $NfcPassStateCopyWith<$Res> {
  factory _$NfcPassStateCopyWith(_NfcPassState value, $Res Function(_NfcPassState) _then) = __$NfcPassStateCopyWithImpl;
@override @useResult
$Res call({
 NfcPassStatus status, int? passId, String? errorMessage, String? localFilePath
});




}
/// @nodoc
class __$NfcPassStateCopyWithImpl<$Res>
    implements _$NfcPassStateCopyWith<$Res> {
  __$NfcPassStateCopyWithImpl(this._self, this._then);

  final _NfcPassState _self;
  final $Res Function(_NfcPassState) _then;

/// Create a copy of NfcPassState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? status = null,Object? passId = freezed,Object? errorMessage = freezed,Object? localFilePath = freezed,}) {
  return _then(_NfcPassState(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as NfcPassStatus,passId: freezed == passId ? _self.passId : passId // ignore: cast_nullable_to_non_nullable
as int?,errorMessage: freezed == errorMessage ? _self.errorMessage : errorMessage // ignore: cast_nullable_to_non_nullable
as String?,localFilePath: freezed == localFilePath ? _self.localFilePath : localFilePath // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
