// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'watch_connectivity_cubit.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$WatchConnectivityState implements DiagnosticableTreeMixin {

 bool get isConnected; WatchMessage? get lastMessage; DateTime? get lastScheduleSyncTime;
/// Create a copy of WatchConnectivityState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$WatchConnectivityStateCopyWith<WatchConnectivityState> get copyWith => _$WatchConnectivityStateCopyWithImpl<WatchConnectivityState>(this as WatchConnectivityState, _$identity);


@override
void debugFillProperties(DiagnosticPropertiesBuilder properties) {
  properties
    ..add(DiagnosticsProperty('type', 'WatchConnectivityState'))
    ..add(DiagnosticsProperty('isConnected', isConnected))..add(DiagnosticsProperty('lastMessage', lastMessage))..add(DiagnosticsProperty('lastScheduleSyncTime', lastScheduleSyncTime));
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is WatchConnectivityState&&(identical(other.isConnected, isConnected) || other.isConnected == isConnected)&&(identical(other.lastMessage, lastMessage) || other.lastMessage == lastMessage)&&(identical(other.lastScheduleSyncTime, lastScheduleSyncTime) || other.lastScheduleSyncTime == lastScheduleSyncTime));
}


@override
int get hashCode => Object.hash(runtimeType,isConnected,lastMessage,lastScheduleSyncTime);

@override
String toString({ DiagnosticLevel minLevel = DiagnosticLevel.info }) {
  return 'WatchConnectivityState(isConnected: $isConnected, lastMessage: $lastMessage, lastScheduleSyncTime: $lastScheduleSyncTime)';
}


}

/// @nodoc
abstract mixin class $WatchConnectivityStateCopyWith<$Res>  {
  factory $WatchConnectivityStateCopyWith(WatchConnectivityState value, $Res Function(WatchConnectivityState) _then) = _$WatchConnectivityStateCopyWithImpl;
@useResult
$Res call({
 bool isConnected, WatchMessage? lastMessage, DateTime? lastScheduleSyncTime
});


$WatchMessageCopyWith<$Res>? get lastMessage;

}
/// @nodoc
class _$WatchConnectivityStateCopyWithImpl<$Res>
    implements $WatchConnectivityStateCopyWith<$Res> {
  _$WatchConnectivityStateCopyWithImpl(this._self, this._then);

  final WatchConnectivityState _self;
  final $Res Function(WatchConnectivityState) _then;

/// Create a copy of WatchConnectivityState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? isConnected = null,Object? lastMessage = freezed,Object? lastScheduleSyncTime = freezed,}) {
  return _then(_self.copyWith(
isConnected: null == isConnected ? _self.isConnected : isConnected // ignore: cast_nullable_to_non_nullable
as bool,lastMessage: freezed == lastMessage ? _self.lastMessage : lastMessage // ignore: cast_nullable_to_non_nullable
as WatchMessage?,lastScheduleSyncTime: freezed == lastScheduleSyncTime ? _self.lastScheduleSyncTime : lastScheduleSyncTime // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}
/// Create a copy of WatchConnectivityState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$WatchMessageCopyWith<$Res>? get lastMessage {
    if (_self.lastMessage == null) {
    return null;
  }

  return $WatchMessageCopyWith<$Res>(_self.lastMessage!, (value) {
    return _then(_self.copyWith(lastMessage: value));
  });
}
}


/// Adds pattern-matching-related methods to [WatchConnectivityState].
extension WatchConnectivityStatePatterns on WatchConnectivityState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _WatchConnectivityState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _WatchConnectivityState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _WatchConnectivityState value)  $default,){
final _that = this;
switch (_that) {
case _WatchConnectivityState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _WatchConnectivityState value)?  $default,){
final _that = this;
switch (_that) {
case _WatchConnectivityState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( bool isConnected,  WatchMessage? lastMessage,  DateTime? lastScheduleSyncTime)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _WatchConnectivityState() when $default != null:
return $default(_that.isConnected,_that.lastMessage,_that.lastScheduleSyncTime);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( bool isConnected,  WatchMessage? lastMessage,  DateTime? lastScheduleSyncTime)  $default,) {final _that = this;
switch (_that) {
case _WatchConnectivityState():
return $default(_that.isConnected,_that.lastMessage,_that.lastScheduleSyncTime);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( bool isConnected,  WatchMessage? lastMessage,  DateTime? lastScheduleSyncTime)?  $default,) {final _that = this;
switch (_that) {
case _WatchConnectivityState() when $default != null:
return $default(_that.isConnected,_that.lastMessage,_that.lastScheduleSyncTime);case _:
  return null;

}
}

}

/// @nodoc


class _WatchConnectivityState with DiagnosticableTreeMixin implements WatchConnectivityState {
  const _WatchConnectivityState({this.isConnected = false, this.lastMessage, this.lastScheduleSyncTime});


@override@JsonKey() final  bool isConnected;
@override final  WatchMessage? lastMessage;
@override final  DateTime? lastScheduleSyncTime;

/// Create a copy of WatchConnectivityState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$WatchConnectivityStateCopyWith<_WatchConnectivityState> get copyWith => __$WatchConnectivityStateCopyWithImpl<_WatchConnectivityState>(this, _$identity);


@override
void debugFillProperties(DiagnosticPropertiesBuilder properties) {
  properties
    ..add(DiagnosticsProperty('type', 'WatchConnectivityState'))
    ..add(DiagnosticsProperty('isConnected', isConnected))..add(DiagnosticsProperty('lastMessage', lastMessage))..add(DiagnosticsProperty('lastScheduleSyncTime', lastScheduleSyncTime));
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _WatchConnectivityState&&(identical(other.isConnected, isConnected) || other.isConnected == isConnected)&&(identical(other.lastMessage, lastMessage) || other.lastMessage == lastMessage)&&(identical(other.lastScheduleSyncTime, lastScheduleSyncTime) || other.lastScheduleSyncTime == lastScheduleSyncTime));
}


@override
int get hashCode => Object.hash(runtimeType,isConnected,lastMessage,lastScheduleSyncTime);

@override
String toString({ DiagnosticLevel minLevel = DiagnosticLevel.info }) {
  return 'WatchConnectivityState(isConnected: $isConnected, lastMessage: $lastMessage, lastScheduleSyncTime: $lastScheduleSyncTime)';
}


}

/// @nodoc
abstract mixin class _$WatchConnectivityStateCopyWith<$Res> implements $WatchConnectivityStateCopyWith<$Res> {
  factory _$WatchConnectivityStateCopyWith(_WatchConnectivityState value, $Res Function(_WatchConnectivityState) _then) = __$WatchConnectivityStateCopyWithImpl;
@override @useResult
$Res call({
 bool isConnected, WatchMessage? lastMessage, DateTime? lastScheduleSyncTime
});


@override $WatchMessageCopyWith<$Res>? get lastMessage;

}
/// @nodoc
class __$WatchConnectivityStateCopyWithImpl<$Res>
    implements _$WatchConnectivityStateCopyWith<$Res> {
  __$WatchConnectivityStateCopyWithImpl(this._self, this._then);

  final _WatchConnectivityState _self;
  final $Res Function(_WatchConnectivityState) _then;

/// Create a copy of WatchConnectivityState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? isConnected = null,Object? lastMessage = freezed,Object? lastScheduleSyncTime = freezed,}) {
  return _then(_WatchConnectivityState(
isConnected: null == isConnected ? _self.isConnected : isConnected // ignore: cast_nullable_to_non_nullable
as bool,lastMessage: freezed == lastMessage ? _self.lastMessage : lastMessage // ignore: cast_nullable_to_non_nullable
as WatchMessage?,lastScheduleSyncTime: freezed == lastScheduleSyncTime ? _self.lastScheduleSyncTime : lastScheduleSyncTime // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

/// Create a copy of WatchConnectivityState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$WatchMessageCopyWith<$Res>? get lastMessage {
    if (_self.lastMessage == null) {
    return null;
  }

  return $WatchMessageCopyWith<$Res>(_self.lastMessage!, (value) {
    return _then(_self.copyWith(lastMessage: value));
  });
}
}

// dart format on
