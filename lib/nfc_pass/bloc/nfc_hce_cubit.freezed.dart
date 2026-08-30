// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'nfc_hce_cubit.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$NfcHceState {

 bool get available; bool get enabled; bool get loaded;
/// Create a copy of NfcHceState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$NfcHceStateCopyWith<NfcHceState> get copyWith => _$NfcHceStateCopyWithImpl<NfcHceState>(this as NfcHceState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is NfcHceState&&(identical(other.available, available) || other.available == available)&&(identical(other.enabled, enabled) || other.enabled == enabled)&&(identical(other.loaded, loaded) || other.loaded == loaded));
}


@override
int get hashCode => Object.hash(runtimeType,available,enabled,loaded);

@override
String toString() {
  return 'NfcHceState(available: $available, enabled: $enabled, loaded: $loaded)';
}


}

/// @nodoc
abstract mixin class $NfcHceStateCopyWith<$Res>  {
  factory $NfcHceStateCopyWith(NfcHceState value, $Res Function(NfcHceState) _then) = _$NfcHceStateCopyWithImpl;
@useResult
$Res call({
 bool available, bool enabled, bool loaded
});




}
/// @nodoc
class _$NfcHceStateCopyWithImpl<$Res>
    implements $NfcHceStateCopyWith<$Res> {
  _$NfcHceStateCopyWithImpl(this._self, this._then);

  final NfcHceState _self;
  final $Res Function(NfcHceState) _then;

/// Create a copy of NfcHceState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? available = null,Object? enabled = null,Object? loaded = null,}) {
  return _then(_self.copyWith(
available: null == available ? _self.available : available // ignore: cast_nullable_to_non_nullable
as bool,enabled: null == enabled ? _self.enabled : enabled // ignore: cast_nullable_to_non_nullable
as bool,loaded: null == loaded ? _self.loaded : loaded // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [NfcHceState].
extension NfcHceStatePatterns on NfcHceState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _NfcHceState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _NfcHceState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _NfcHceState value)  $default,){
final _that = this;
switch (_that) {
case _NfcHceState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _NfcHceState value)?  $default,){
final _that = this;
switch (_that) {
case _NfcHceState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( bool available,  bool enabled,  bool loaded)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _NfcHceState() when $default != null:
return $default(_that.available,_that.enabled,_that.loaded);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( bool available,  bool enabled,  bool loaded)  $default,) {final _that = this;
switch (_that) {
case _NfcHceState():
return $default(_that.available,_that.enabled,_that.loaded);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( bool available,  bool enabled,  bool loaded)?  $default,) {final _that = this;
switch (_that) {
case _NfcHceState() when $default != null:
return $default(_that.available,_that.enabled,_that.loaded);case _:
  return null;

}
}

}

/// @nodoc


class _NfcHceState implements NfcHceState {
  const _NfcHceState({this.available = false, this.enabled = true, this.loaded = false});


@override@JsonKey() final  bool available;
@override@JsonKey() final  bool enabled;
@override@JsonKey() final  bool loaded;

/// Create a copy of NfcHceState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$NfcHceStateCopyWith<_NfcHceState> get copyWith => __$NfcHceStateCopyWithImpl<_NfcHceState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _NfcHceState&&(identical(other.available, available) || other.available == available)&&(identical(other.enabled, enabled) || other.enabled == enabled)&&(identical(other.loaded, loaded) || other.loaded == loaded));
}


@override
int get hashCode => Object.hash(runtimeType,available,enabled,loaded);

@override
String toString() {
  return 'NfcHceState(available: $available, enabled: $enabled, loaded: $loaded)';
}


}

/// @nodoc
abstract mixin class _$NfcHceStateCopyWith<$Res> implements $NfcHceStateCopyWith<$Res> {
  factory _$NfcHceStateCopyWith(_NfcHceState value, $Res Function(_NfcHceState) _then) = __$NfcHceStateCopyWithImpl;
@override @useResult
$Res call({
 bool available, bool enabled, bool loaded
});




}
/// @nodoc
class __$NfcHceStateCopyWithImpl<$Res>
    implements _$NfcHceStateCopyWith<$Res> {
  __$NfcHceStateCopyWithImpl(this._self, this._then);

  final _NfcHceState _self;
  final $Res Function(_NfcHceState) _then;

/// Create a copy of NfcHceState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? available = null,Object? enabled = null,Object? loaded = null,}) {
  return _then(_NfcHceState(
available: null == available ? _self.available : available // ignore: cast_nullable_to_non_nullable
as bool,enabled: null == enabled ? _self.enabled : enabled // ignore: cast_nullable_to_non_nullable
as bool,loaded: null == loaded ? _self.loaded : loaded // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
