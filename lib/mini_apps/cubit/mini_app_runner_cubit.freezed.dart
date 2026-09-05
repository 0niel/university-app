// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'mini_app_runner_cubit.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$MiniAppRunnerState {

 MiniAppRunnerStatus get status; MiniApp? get app; Map<String, dynamic>? get screen; bool get fromCache; bool get refreshing; bool get refreshFailed;
/// Create a copy of MiniAppRunnerState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MiniAppRunnerStateCopyWith<MiniAppRunnerState> get copyWith => _$MiniAppRunnerStateCopyWithImpl<MiniAppRunnerState>(this as MiniAppRunnerState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MiniAppRunnerState&&(identical(other.status, status) || other.status == status)&&(identical(other.app, app) || other.app == app)&&const DeepCollectionEquality().equals(other.screen, screen)&&(identical(other.fromCache, fromCache) || other.fromCache == fromCache)&&(identical(other.refreshing, refreshing) || other.refreshing == refreshing)&&(identical(other.refreshFailed, refreshFailed) || other.refreshFailed == refreshFailed));
}


@override
int get hashCode => Object.hash(runtimeType,status,app,const DeepCollectionEquality().hash(screen),fromCache,refreshing,refreshFailed);

@override
String toString() {
  return 'MiniAppRunnerState(status: $status, app: $app, screen: $screen, fromCache: $fromCache, refreshing: $refreshing, refreshFailed: $refreshFailed)';
}


}

/// @nodoc
abstract mixin class $MiniAppRunnerStateCopyWith<$Res>  {
  factory $MiniAppRunnerStateCopyWith(MiniAppRunnerState value, $Res Function(MiniAppRunnerState) _then) = _$MiniAppRunnerStateCopyWithImpl;
@useResult
$Res call({
 MiniAppRunnerStatus status, MiniApp? app, Map<String, dynamic>? screen, bool fromCache, bool refreshing, bool refreshFailed
});


$MiniAppCopyWith<$Res>? get app;

}
/// @nodoc
class _$MiniAppRunnerStateCopyWithImpl<$Res>
    implements $MiniAppRunnerStateCopyWith<$Res> {
  _$MiniAppRunnerStateCopyWithImpl(this._self, this._then);

  final MiniAppRunnerState _self;
  final $Res Function(MiniAppRunnerState) _then;

/// Create a copy of MiniAppRunnerState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? status = null,Object? app = freezed,Object? screen = freezed,Object? fromCache = null,Object? refreshing = null,Object? refreshFailed = null,}) {
  return _then(_self.copyWith(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as MiniAppRunnerStatus,app: freezed == app ? _self.app : app // ignore: cast_nullable_to_non_nullable
as MiniApp?,screen: freezed == screen ? _self.screen : screen // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>?,fromCache: null == fromCache ? _self.fromCache : fromCache // ignore: cast_nullable_to_non_nullable
as bool,refreshing: null == refreshing ? _self.refreshing : refreshing // ignore: cast_nullable_to_non_nullable
as bool,refreshFailed: null == refreshFailed ? _self.refreshFailed : refreshFailed // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}
/// Create a copy of MiniAppRunnerState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$MiniAppCopyWith<$Res>? get app {
    if (_self.app == null) {
    return null;
  }

  return $MiniAppCopyWith<$Res>(_self.app!, (value) {
    return _then(_self.copyWith(app: value));
  });
}
}


/// Adds pattern-matching-related methods to [MiniAppRunnerState].
extension MiniAppRunnerStatePatterns on MiniAppRunnerState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _MiniAppRunnerState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _MiniAppRunnerState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _MiniAppRunnerState value)  $default,){
final _that = this;
switch (_that) {
case _MiniAppRunnerState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _MiniAppRunnerState value)?  $default,){
final _that = this;
switch (_that) {
case _MiniAppRunnerState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( MiniAppRunnerStatus status,  MiniApp? app,  Map<String, dynamic>? screen,  bool fromCache,  bool refreshing,  bool refreshFailed)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _MiniAppRunnerState() when $default != null:
return $default(_that.status,_that.app,_that.screen,_that.fromCache,_that.refreshing,_that.refreshFailed);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( MiniAppRunnerStatus status,  MiniApp? app,  Map<String, dynamic>? screen,  bool fromCache,  bool refreshing,  bool refreshFailed)  $default,) {final _that = this;
switch (_that) {
case _MiniAppRunnerState():
return $default(_that.status,_that.app,_that.screen,_that.fromCache,_that.refreshing,_that.refreshFailed);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( MiniAppRunnerStatus status,  MiniApp? app,  Map<String, dynamic>? screen,  bool fromCache,  bool refreshing,  bool refreshFailed)?  $default,) {final _that = this;
switch (_that) {
case _MiniAppRunnerState() when $default != null:
return $default(_that.status,_that.app,_that.screen,_that.fromCache,_that.refreshing,_that.refreshFailed);case _:
  return null;

}
}

}

/// @nodoc


class _MiniAppRunnerState implements MiniAppRunnerState {
  const _MiniAppRunnerState({this.status = MiniAppRunnerStatus.initial, this.app, final  Map<String, dynamic>? screen, this.fromCache = false, this.refreshing = false, this.refreshFailed = false}): _screen = screen;


@override@JsonKey() final  MiniAppRunnerStatus status;
@override final  MiniApp? app;
 final  Map<String, dynamic>? _screen;
@override Map<String, dynamic>? get screen {
  final value = _screen;
  if (value == null) return null;
  if (_screen is EqualUnmodifiableMapView) return _screen;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(value);
}

@override@JsonKey() final  bool fromCache;
@override@JsonKey() final  bool refreshing;
@override@JsonKey() final  bool refreshFailed;

/// Create a copy of MiniAppRunnerState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MiniAppRunnerStateCopyWith<_MiniAppRunnerState> get copyWith => __$MiniAppRunnerStateCopyWithImpl<_MiniAppRunnerState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _MiniAppRunnerState&&(identical(other.status, status) || other.status == status)&&(identical(other.app, app) || other.app == app)&&const DeepCollectionEquality().equals(other._screen, _screen)&&(identical(other.fromCache, fromCache) || other.fromCache == fromCache)&&(identical(other.refreshing, refreshing) || other.refreshing == refreshing)&&(identical(other.refreshFailed, refreshFailed) || other.refreshFailed == refreshFailed));
}


@override
int get hashCode => Object.hash(runtimeType,status,app,const DeepCollectionEquality().hash(_screen),fromCache,refreshing,refreshFailed);

@override
String toString() {
  return 'MiniAppRunnerState(status: $status, app: $app, screen: $screen, fromCache: $fromCache, refreshing: $refreshing, refreshFailed: $refreshFailed)';
}


}

/// @nodoc
abstract mixin class _$MiniAppRunnerStateCopyWith<$Res> implements $MiniAppRunnerStateCopyWith<$Res> {
  factory _$MiniAppRunnerStateCopyWith(_MiniAppRunnerState value, $Res Function(_MiniAppRunnerState) _then) = __$MiniAppRunnerStateCopyWithImpl;
@override @useResult
$Res call({
 MiniAppRunnerStatus status, MiniApp? app, Map<String, dynamic>? screen, bool fromCache, bool refreshing, bool refreshFailed
});


@override $MiniAppCopyWith<$Res>? get app;

}
/// @nodoc
class __$MiniAppRunnerStateCopyWithImpl<$Res>
    implements _$MiniAppRunnerStateCopyWith<$Res> {
  __$MiniAppRunnerStateCopyWithImpl(this._self, this._then);

  final _MiniAppRunnerState _self;
  final $Res Function(_MiniAppRunnerState) _then;

/// Create a copy of MiniAppRunnerState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? status = null,Object? app = freezed,Object? screen = freezed,Object? fromCache = null,Object? refreshing = null,Object? refreshFailed = null,}) {
  return _then(_MiniAppRunnerState(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as MiniAppRunnerStatus,app: freezed == app ? _self.app : app // ignore: cast_nullable_to_non_nullable
as MiniApp?,screen: freezed == screen ? _self._screen : screen // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>?,fromCache: null == fromCache ? _self.fromCache : fromCache // ignore: cast_nullable_to_non_nullable
as bool,refreshing: null == refreshing ? _self.refreshing : refreshing // ignore: cast_nullable_to_non_nullable
as bool,refreshFailed: null == refreshFailed ? _self.refreshFailed : refreshFailed // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

/// Create a copy of MiniAppRunnerState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$MiniAppCopyWith<$Res>? get app {
    if (_self.app == null) {
    return null;
  }

  return $MiniAppCopyWith<$Res>(_self.app!, (value) {
    return _then(_self.copyWith(app: value));
  });
}
}

// dart format on
