// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'mini_app_submit_cubit.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$MiniAppSubmitState {

 MiniAppSubmitStatus get status;
/// Create a copy of MiniAppSubmitState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MiniAppSubmitStateCopyWith<MiniAppSubmitState> get copyWith => _$MiniAppSubmitStateCopyWithImpl<MiniAppSubmitState>(this as MiniAppSubmitState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MiniAppSubmitState&&(identical(other.status, status) || other.status == status));
}


@override
int get hashCode => Object.hash(runtimeType,status);

@override
String toString() {
  return 'MiniAppSubmitState(status: $status)';
}


}

/// @nodoc
abstract mixin class $MiniAppSubmitStateCopyWith<$Res>  {
  factory $MiniAppSubmitStateCopyWith(MiniAppSubmitState value, $Res Function(MiniAppSubmitState) _then) = _$MiniAppSubmitStateCopyWithImpl;
@useResult
$Res call({
 MiniAppSubmitStatus status
});




}
/// @nodoc
class _$MiniAppSubmitStateCopyWithImpl<$Res>
    implements $MiniAppSubmitStateCopyWith<$Res> {
  _$MiniAppSubmitStateCopyWithImpl(this._self, this._then);

  final MiniAppSubmitState _self;
  final $Res Function(MiniAppSubmitState) _then;

/// Create a copy of MiniAppSubmitState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? status = null,}) {
  return _then(_self.copyWith(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as MiniAppSubmitStatus,
  ));
}

}


/// Adds pattern-matching-related methods to [MiniAppSubmitState].
extension MiniAppSubmitStatePatterns on MiniAppSubmitState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _MiniAppSubmitState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _MiniAppSubmitState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _MiniAppSubmitState value)  $default,){
final _that = this;
switch (_that) {
case _MiniAppSubmitState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _MiniAppSubmitState value)?  $default,){
final _that = this;
switch (_that) {
case _MiniAppSubmitState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( MiniAppSubmitStatus status)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _MiniAppSubmitState() when $default != null:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( MiniAppSubmitStatus status)  $default,) {final _that = this;
switch (_that) {
case _MiniAppSubmitState():
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( MiniAppSubmitStatus status)?  $default,) {final _that = this;
switch (_that) {
case _MiniAppSubmitState() when $default != null:
return $default(_that.status);case _:
  return null;

}
}

}

/// @nodoc


class _MiniAppSubmitState implements MiniAppSubmitState {
  const _MiniAppSubmitState({this.status = MiniAppSubmitStatus.idle});


@override@JsonKey() final  MiniAppSubmitStatus status;

/// Create a copy of MiniAppSubmitState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MiniAppSubmitStateCopyWith<_MiniAppSubmitState> get copyWith => __$MiniAppSubmitStateCopyWithImpl<_MiniAppSubmitState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _MiniAppSubmitState&&(identical(other.status, status) || other.status == status));
}


@override
int get hashCode => Object.hash(runtimeType,status);

@override
String toString() {
  return 'MiniAppSubmitState(status: $status)';
}


}

/// @nodoc
abstract mixin class _$MiniAppSubmitStateCopyWith<$Res> implements $MiniAppSubmitStateCopyWith<$Res> {
  factory _$MiniAppSubmitStateCopyWith(_MiniAppSubmitState value, $Res Function(_MiniAppSubmitState) _then) = __$MiniAppSubmitStateCopyWithImpl;
@override @useResult
$Res call({
 MiniAppSubmitStatus status
});




}
/// @nodoc
class __$MiniAppSubmitStateCopyWithImpl<$Res>
    implements _$MiniAppSubmitStateCopyWith<$Res> {
  __$MiniAppSubmitStateCopyWithImpl(this._self, this._then);

  final _MiniAppSubmitState _self;
  final $Res Function(_MiniAppSubmitState) _then;

/// Create a copy of MiniAppSubmitState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? status = null,}) {
  return _then(_MiniAppSubmitState(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as MiniAppSubmitStatus,
  ));
}


}

// dart format on
