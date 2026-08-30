// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'stac_app_segmented_control.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$StacAppSegmentedControl {

@JsonKey(fromJson: mapListOrEmpty) List<Map<String, Object?>> get options;@JsonKey(fromJson: intOrZero) int get selectedIndex;
/// Create a copy of StacAppSegmentedControl
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$StacAppSegmentedControlCopyWith<StacAppSegmentedControl> get copyWith => _$StacAppSegmentedControlCopyWithImpl<StacAppSegmentedControl>(this as StacAppSegmentedControl, _$identity);

  /// Serializes this StacAppSegmentedControl to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is StacAppSegmentedControl&&const DeepCollectionEquality().equals(other.options, options)&&(identical(other.selectedIndex, selectedIndex) || other.selectedIndex == selectedIndex));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(options),selectedIndex);

@override
String toString() {
  return 'StacAppSegmentedControl(options: $options, selectedIndex: $selectedIndex)';
}


}

/// @nodoc
abstract mixin class $StacAppSegmentedControlCopyWith<$Res>  {
  factory $StacAppSegmentedControlCopyWith(StacAppSegmentedControl value, $Res Function(StacAppSegmentedControl) _then) = _$StacAppSegmentedControlCopyWithImpl;
@useResult
$Res call({
@JsonKey(fromJson: mapListOrEmpty) List<Map<String, Object?>> options,@JsonKey(fromJson: intOrZero) int selectedIndex
});




}
/// @nodoc
class _$StacAppSegmentedControlCopyWithImpl<$Res>
    implements $StacAppSegmentedControlCopyWith<$Res> {
  _$StacAppSegmentedControlCopyWithImpl(this._self, this._then);

  final StacAppSegmentedControl _self;
  final $Res Function(StacAppSegmentedControl) _then;

/// Create a copy of StacAppSegmentedControl
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? options = null,Object? selectedIndex = null,}) {
  return _then(_self.copyWith(
options: null == options ? _self.options : options // ignore: cast_nullable_to_non_nullable
as List<Map<String, Object?>>,selectedIndex: null == selectedIndex ? _self.selectedIndex : selectedIndex // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [StacAppSegmentedControl].
extension StacAppSegmentedControlPatterns on StacAppSegmentedControl {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _StacAppSegmentedControl value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _StacAppSegmentedControl() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _StacAppSegmentedControl value)  $default,){
final _that = this;
switch (_that) {
case _StacAppSegmentedControl():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _StacAppSegmentedControl value)?  $default,){
final _that = this;
switch (_that) {
case _StacAppSegmentedControl() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(fromJson: mapListOrEmpty)  List<Map<String, Object?>> options, @JsonKey(fromJson: intOrZero)  int selectedIndex)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _StacAppSegmentedControl() when $default != null:
return $default(_that.options,_that.selectedIndex);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(fromJson: mapListOrEmpty)  List<Map<String, Object?>> options, @JsonKey(fromJson: intOrZero)  int selectedIndex)  $default,) {final _that = this;
switch (_that) {
case _StacAppSegmentedControl():
return $default(_that.options,_that.selectedIndex);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(fromJson: mapListOrEmpty)  List<Map<String, Object?>> options, @JsonKey(fromJson: intOrZero)  int selectedIndex)?  $default,) {final _that = this;
switch (_that) {
case _StacAppSegmentedControl() when $default != null:
return $default(_that.options,_that.selectedIndex);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _StacAppSegmentedControl implements StacAppSegmentedControl {
  const _StacAppSegmentedControl({@JsonKey(fromJson: mapListOrEmpty) required final  List<Map<String, Object?>> options, @JsonKey(fromJson: intOrZero) this.selectedIndex = 0}): _options = options;
  factory _StacAppSegmentedControl.fromJson(Map<String, dynamic> json) => _$StacAppSegmentedControlFromJson(json);

 final  List<Map<String, Object?>> _options;
@override@JsonKey(fromJson: mapListOrEmpty) List<Map<String, Object?>> get options {
  if (_options is EqualUnmodifiableListView) return _options;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_options);
}

@override@JsonKey(fromJson: intOrZero) final  int selectedIndex;

/// Create a copy of StacAppSegmentedControl
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$StacAppSegmentedControlCopyWith<_StacAppSegmentedControl> get copyWith => __$StacAppSegmentedControlCopyWithImpl<_StacAppSegmentedControl>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$StacAppSegmentedControlToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _StacAppSegmentedControl&&const DeepCollectionEquality().equals(other._options, _options)&&(identical(other.selectedIndex, selectedIndex) || other.selectedIndex == selectedIndex));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_options),selectedIndex);

@override
String toString() {
  return 'StacAppSegmentedControl(options: $options, selectedIndex: $selectedIndex)';
}


}

/// @nodoc
abstract mixin class _$StacAppSegmentedControlCopyWith<$Res> implements $StacAppSegmentedControlCopyWith<$Res> {
  factory _$StacAppSegmentedControlCopyWith(_StacAppSegmentedControl value, $Res Function(_StacAppSegmentedControl) _then) = __$StacAppSegmentedControlCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(fromJson: mapListOrEmpty) List<Map<String, Object?>> options,@JsonKey(fromJson: intOrZero) int selectedIndex
});




}
/// @nodoc
class __$StacAppSegmentedControlCopyWithImpl<$Res>
    implements _$StacAppSegmentedControlCopyWith<$Res> {
  __$StacAppSegmentedControlCopyWithImpl(this._self, this._then);

  final _StacAppSegmentedControl _self;
  final $Res Function(_StacAppSegmentedControl) _then;

/// Create a copy of StacAppSegmentedControl
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? options = null,Object? selectedIndex = null,}) {
  return _then(_StacAppSegmentedControl(
options: null == options ? _self._options : options // ignore: cast_nullable_to_non_nullable
as List<Map<String, Object?>>,selectedIndex: null == selectedIndex ? _self.selectedIndex : selectedIndex // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
