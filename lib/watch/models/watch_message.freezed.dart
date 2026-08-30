// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'watch_message.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$WatchMessage {

@JsonKey(unknownEnumValue: WatchMessageAction.unknown) WatchMessageAction get action; Map<String, dynamic> get data;
/// Create a copy of WatchMessage
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$WatchMessageCopyWith<WatchMessage> get copyWith => _$WatchMessageCopyWithImpl<WatchMessage>(this as WatchMessage, _$identity);

  /// Serializes this WatchMessage to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is WatchMessage&&(identical(other.action, action) || other.action == action)&&const DeepCollectionEquality().equals(other.data, data));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,action,const DeepCollectionEquality().hash(data));

@override
String toString() {
  return 'WatchMessage(action: $action, data: $data)';
}


}

/// @nodoc
abstract mixin class $WatchMessageCopyWith<$Res>  {
  factory $WatchMessageCopyWith(WatchMessage value, $Res Function(WatchMessage) _then) = _$WatchMessageCopyWithImpl;
@useResult
$Res call({
@JsonKey(unknownEnumValue: WatchMessageAction.unknown) WatchMessageAction action, Map<String, dynamic> data
});




}
/// @nodoc
class _$WatchMessageCopyWithImpl<$Res>
    implements $WatchMessageCopyWith<$Res> {
  _$WatchMessageCopyWithImpl(this._self, this._then);

  final WatchMessage _self;
  final $Res Function(WatchMessage) _then;

/// Create a copy of WatchMessage
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? action = null,Object? data = null,}) {
  return _then(_self.copyWith(
action: null == action ? _self.action : action // ignore: cast_nullable_to_non_nullable
as WatchMessageAction,data: null == data ? _self.data : data // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>,
  ));
}

}


/// Adds pattern-matching-related methods to [WatchMessage].
extension WatchMessagePatterns on WatchMessage {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _WatchMessage value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _WatchMessage() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _WatchMessage value)  $default,){
final _that = this;
switch (_that) {
case _WatchMessage():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _WatchMessage value)?  $default,){
final _that = this;
switch (_that) {
case _WatchMessage() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(unknownEnumValue: WatchMessageAction.unknown)  WatchMessageAction action,  Map<String, dynamic> data)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _WatchMessage() when $default != null:
return $default(_that.action,_that.data);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(unknownEnumValue: WatchMessageAction.unknown)  WatchMessageAction action,  Map<String, dynamic> data)  $default,) {final _that = this;
switch (_that) {
case _WatchMessage():
return $default(_that.action,_that.data);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(unknownEnumValue: WatchMessageAction.unknown)  WatchMessageAction action,  Map<String, dynamic> data)?  $default,) {final _that = this;
switch (_that) {
case _WatchMessage() when $default != null:
return $default(_that.action,_that.data);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _WatchMessage extends WatchMessage {
  const _WatchMessage({@JsonKey(unknownEnumValue: WatchMessageAction.unknown) required this.action, final  Map<String, dynamic> data = const <String, dynamic>{}}): _data = data,super._();
  factory _WatchMessage.fromJson(Map<String, dynamic> json) => _$WatchMessageFromJson(json);

@override@JsonKey(unknownEnumValue: WatchMessageAction.unknown) final  WatchMessageAction action;
 final  Map<String, dynamic> _data;
@override@JsonKey() Map<String, dynamic> get data {
  if (_data is EqualUnmodifiableMapView) return _data;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_data);
}


/// Create a copy of WatchMessage
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$WatchMessageCopyWith<_WatchMessage> get copyWith => __$WatchMessageCopyWithImpl<_WatchMessage>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$WatchMessageToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _WatchMessage&&(identical(other.action, action) || other.action == action)&&const DeepCollectionEquality().equals(other._data, _data));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,action,const DeepCollectionEquality().hash(_data));

@override
String toString() {
  return 'WatchMessage(action: $action, data: $data)';
}


}

/// @nodoc
abstract mixin class _$WatchMessageCopyWith<$Res> implements $WatchMessageCopyWith<$Res> {
  factory _$WatchMessageCopyWith(_WatchMessage value, $Res Function(_WatchMessage) _then) = __$WatchMessageCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(unknownEnumValue: WatchMessageAction.unknown) WatchMessageAction action, Map<String, dynamic> data
});




}
/// @nodoc
class __$WatchMessageCopyWithImpl<$Res>
    implements _$WatchMessageCopyWith<$Res> {
  __$WatchMessageCopyWithImpl(this._self, this._then);

  final _WatchMessage _self;
  final $Res Function(_WatchMessage) _then;

/// Create a copy of WatchMessage
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? action = null,Object? data = null,}) {
  return _then(_WatchMessage(
action: null == action ? _self.action : action // ignore: cast_nullable_to_non_nullable
as WatchMessageAction,data: null == data ? _self._data : data // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>,
  ));
}


}

// dart format on
