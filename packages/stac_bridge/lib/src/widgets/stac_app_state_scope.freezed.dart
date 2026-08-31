// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'stac_app_state_scope.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$StacAppStateScope {

 Map<String, Object?> get initial; Map<String, Object?>? get child;
/// Create a copy of StacAppStateScope
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$StacAppStateScopeCopyWith<StacAppStateScope> get copyWith => _$StacAppStateScopeCopyWithImpl<StacAppStateScope>(this as StacAppStateScope, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is StacAppStateScope&&const DeepCollectionEquality().equals(other.initial, initial)&&const DeepCollectionEquality().equals(other.child, child));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(initial),const DeepCollectionEquality().hash(child));

@override
String toString() {
  return 'StacAppStateScope(initial: $initial, child: $child)';
}


}

/// @nodoc
abstract mixin class $StacAppStateScopeCopyWith<$Res>  {
  factory $StacAppStateScopeCopyWith(StacAppStateScope value, $Res Function(StacAppStateScope) _then) = _$StacAppStateScopeCopyWithImpl;
@useResult
$Res call({
 Map<String, Object?> initial, Map<String, Object?>? child
});




}
/// @nodoc
class _$StacAppStateScopeCopyWithImpl<$Res>
    implements $StacAppStateScopeCopyWith<$Res> {
  _$StacAppStateScopeCopyWithImpl(this._self, this._then);

  final StacAppStateScope _self;
  final $Res Function(StacAppStateScope) _then;

/// Create a copy of StacAppStateScope
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? initial = null,Object? child = freezed,}) {
  return _then(_self.copyWith(
initial: null == initial ? _self.initial : initial // ignore: cast_nullable_to_non_nullable
as Map<String, Object?>,child: freezed == child ? _self.child : child // ignore: cast_nullable_to_non_nullable
as Map<String, Object?>?,
  ));
}

}


/// Adds pattern-matching-related methods to [StacAppStateScope].
extension StacAppStateScopePatterns on StacAppStateScope {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _StacAppStateScope value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _StacAppStateScope() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _StacAppStateScope value)  $default,){
final _that = this;
switch (_that) {
case _StacAppStateScope():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _StacAppStateScope value)?  $default,){
final _that = this;
switch (_that) {
case _StacAppStateScope() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( Map<String, Object?> initial,  Map<String, Object?>? child)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _StacAppStateScope() when $default != null:
return $default(_that.initial,_that.child);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( Map<String, Object?> initial,  Map<String, Object?>? child)  $default,) {final _that = this;
switch (_that) {
case _StacAppStateScope():
return $default(_that.initial,_that.child);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( Map<String, Object?> initial,  Map<String, Object?>? child)?  $default,) {final _that = this;
switch (_that) {
case _StacAppStateScope() when $default != null:
return $default(_that.initial,_that.child);case _:
  return null;

}
}

}

/// @nodoc


class _StacAppStateScope implements StacAppStateScope {
  const _StacAppStateScope({required final  Map<String, Object?> initial, final  Map<String, Object?>? child}): _initial = initial,_child = child;


 final  Map<String, Object?> _initial;
@override Map<String, Object?> get initial {
  if (_initial is EqualUnmodifiableMapView) return _initial;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_initial);
}

 final  Map<String, Object?>? _child;
@override Map<String, Object?>? get child {
  final value = _child;
  if (value == null) return null;
  if (_child is EqualUnmodifiableMapView) return _child;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(value);
}


/// Create a copy of StacAppStateScope
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$StacAppStateScopeCopyWith<_StacAppStateScope> get copyWith => __$StacAppStateScopeCopyWithImpl<_StacAppStateScope>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _StacAppStateScope&&const DeepCollectionEquality().equals(other._initial, _initial)&&const DeepCollectionEquality().equals(other._child, _child));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_initial),const DeepCollectionEquality().hash(_child));

@override
String toString() {
  return 'StacAppStateScope(initial: $initial, child: $child)';
}


}

/// @nodoc
abstract mixin class _$StacAppStateScopeCopyWith<$Res> implements $StacAppStateScopeCopyWith<$Res> {
  factory _$StacAppStateScopeCopyWith(_StacAppStateScope value, $Res Function(_StacAppStateScope) _then) = __$StacAppStateScopeCopyWithImpl;
@override @useResult
$Res call({
 Map<String, Object?> initial, Map<String, Object?>? child
});




}
/// @nodoc
class __$StacAppStateScopeCopyWithImpl<$Res>
    implements _$StacAppStateScopeCopyWith<$Res> {
  __$StacAppStateScopeCopyWithImpl(this._self, this._then);

  final _StacAppStateScope _self;
  final $Res Function(_StacAppStateScope) _then;

/// Create a copy of StacAppStateScope
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? initial = null,Object? child = freezed,}) {
  return _then(_StacAppStateScope(
initial: null == initial ? _self._initial : initial // ignore: cast_nullable_to_non_nullable
as Map<String, Object?>,child: freezed == child ? _self._child : child // ignore: cast_nullable_to_non_nullable
as Map<String, Object?>?,
  ));
}


}

// dart format on
