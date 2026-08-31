// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'stac_app_toggle.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$StacAppToggle {

@JsonKey(fromJson: boolOrFalse) bool get value;@JsonKey(name: 'onChange') Object? get actionJson;
/// Create a copy of StacAppToggle
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$StacAppToggleCopyWith<StacAppToggle> get copyWith => _$StacAppToggleCopyWithImpl<StacAppToggle>(this as StacAppToggle, _$identity);

  /// Serializes this StacAppToggle to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is StacAppToggle&&(identical(other.value, value) || other.value == value)&&const DeepCollectionEquality().equals(other.actionJson, actionJson));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,value,const DeepCollectionEquality().hash(actionJson));

@override
String toString() {
  return 'StacAppToggle(value: $value, actionJson: $actionJson)';
}


}

/// @nodoc
abstract mixin class $StacAppToggleCopyWith<$Res>  {
  factory $StacAppToggleCopyWith(StacAppToggle value, $Res Function(StacAppToggle) _then) = _$StacAppToggleCopyWithImpl;
@useResult
$Res call({
@JsonKey(fromJson: boolOrFalse) bool value,@JsonKey(name: 'onChange') Object? actionJson
});




}
/// @nodoc
class _$StacAppToggleCopyWithImpl<$Res>
    implements $StacAppToggleCopyWith<$Res> {
  _$StacAppToggleCopyWithImpl(this._self, this._then);

  final StacAppToggle _self;
  final $Res Function(StacAppToggle) _then;

/// Create a copy of StacAppToggle
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? value = null,Object? actionJson = freezed,}) {
  return _then(_self.copyWith(
value: null == value ? _self.value : value // ignore: cast_nullable_to_non_nullable
as bool,actionJson: freezed == actionJson ? _self.actionJson : actionJson ,
  ));
}

}


/// Adds pattern-matching-related methods to [StacAppToggle].
extension StacAppTogglePatterns on StacAppToggle {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _StacAppToggle value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _StacAppToggle() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _StacAppToggle value)  $default,){
final _that = this;
switch (_that) {
case _StacAppToggle():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _StacAppToggle value)?  $default,){
final _that = this;
switch (_that) {
case _StacAppToggle() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(fromJson: boolOrFalse)  bool value, @JsonKey(name: 'onChange')  Object? actionJson)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _StacAppToggle() when $default != null:
return $default(_that.value,_that.actionJson);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(fromJson: boolOrFalse)  bool value, @JsonKey(name: 'onChange')  Object? actionJson)  $default,) {final _that = this;
switch (_that) {
case _StacAppToggle():
return $default(_that.value,_that.actionJson);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(fromJson: boolOrFalse)  bool value, @JsonKey(name: 'onChange')  Object? actionJson)?  $default,) {final _that = this;
switch (_that) {
case _StacAppToggle() when $default != null:
return $default(_that.value,_that.actionJson);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _StacAppToggle implements StacAppToggle {
  const _StacAppToggle({@JsonKey(fromJson: boolOrFalse) this.value = false, @JsonKey(name: 'onChange') this.actionJson});
  factory _StacAppToggle.fromJson(Map<String, dynamic> json) => _$StacAppToggleFromJson(json);

@override@JsonKey(fromJson: boolOrFalse) final  bool value;
@override@JsonKey(name: 'onChange') final  Object? actionJson;

/// Create a copy of StacAppToggle
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$StacAppToggleCopyWith<_StacAppToggle> get copyWith => __$StacAppToggleCopyWithImpl<_StacAppToggle>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$StacAppToggleToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _StacAppToggle&&(identical(other.value, value) || other.value == value)&&const DeepCollectionEquality().equals(other.actionJson, actionJson));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,value,const DeepCollectionEquality().hash(actionJson));

@override
String toString() {
  return 'StacAppToggle(value: $value, actionJson: $actionJson)';
}


}

/// @nodoc
abstract mixin class _$StacAppToggleCopyWith<$Res> implements $StacAppToggleCopyWith<$Res> {
  factory _$StacAppToggleCopyWith(_StacAppToggle value, $Res Function(_StacAppToggle) _then) = __$StacAppToggleCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(fromJson: boolOrFalse) bool value,@JsonKey(name: 'onChange') Object? actionJson
});




}
/// @nodoc
class __$StacAppToggleCopyWithImpl<$Res>
    implements _$StacAppToggleCopyWith<$Res> {
  __$StacAppToggleCopyWithImpl(this._self, this._then);

  final _StacAppToggle _self;
  final $Res Function(_StacAppToggle) _then;

/// Create a copy of StacAppToggle
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? value = null,Object? actionJson = freezed,}) {
  return _then(_StacAppToggle(
value: null == value ? _self.value : value // ignore: cast_nullable_to_non_nullable
as bool,actionJson: freezed == actionJson ? _self.actionJson : actionJson ,
  ));
}


}

// dart format on
