// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'stac_app_button.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$StacAppButton {

@JsonKey(fromJson: _emptyWhenNotString) String get label;@JsonKey(fromJson: _primaryWhenNotString) String get variant;@JsonKey(fromJson: _mediumWhenNotString) String get size;@JsonKey(fromJson: _falseWhenNotBool) bool get expanded;@JsonKey(name: 'onPressed') Object? get actionJson;
/// Create a copy of StacAppButton
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$StacAppButtonCopyWith<StacAppButton> get copyWith => _$StacAppButtonCopyWithImpl<StacAppButton>(this as StacAppButton, _$identity);

  /// Serializes this StacAppButton to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is StacAppButton&&(identical(other.label, label) || other.label == label)&&(identical(other.variant, variant) || other.variant == variant)&&(identical(other.size, size) || other.size == size)&&(identical(other.expanded, expanded) || other.expanded == expanded)&&const DeepCollectionEquality().equals(other.actionJson, actionJson));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,label,variant,size,expanded,const DeepCollectionEquality().hash(actionJson));

@override
String toString() {
  return 'StacAppButton(label: $label, variant: $variant, size: $size, expanded: $expanded, actionJson: $actionJson)';
}


}

/// @nodoc
abstract mixin class $StacAppButtonCopyWith<$Res>  {
  factory $StacAppButtonCopyWith(StacAppButton value, $Res Function(StacAppButton) _then) = _$StacAppButtonCopyWithImpl;
@useResult
$Res call({
@JsonKey(fromJson: _emptyWhenNotString) String label,@JsonKey(fromJson: _primaryWhenNotString) String variant,@JsonKey(fromJson: _mediumWhenNotString) String size,@JsonKey(fromJson: _falseWhenNotBool) bool expanded,@JsonKey(name: 'onPressed') Object? actionJson
});




}
/// @nodoc
class _$StacAppButtonCopyWithImpl<$Res>
    implements $StacAppButtonCopyWith<$Res> {
  _$StacAppButtonCopyWithImpl(this._self, this._then);

  final StacAppButton _self;
  final $Res Function(StacAppButton) _then;

/// Create a copy of StacAppButton
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? label = null,Object? variant = null,Object? size = null,Object? expanded = null,Object? actionJson = freezed,}) {
  return _then(_self.copyWith(
label: null == label ? _self.label : label // ignore: cast_nullable_to_non_nullable
as String,variant: null == variant ? _self.variant : variant // ignore: cast_nullable_to_non_nullable
as String,size: null == size ? _self.size : size // ignore: cast_nullable_to_non_nullable
as String,expanded: null == expanded ? _self.expanded : expanded // ignore: cast_nullable_to_non_nullable
as bool,actionJson: freezed == actionJson ? _self.actionJson : actionJson ,
  ));
}

}


/// Adds pattern-matching-related methods to [StacAppButton].
extension StacAppButtonPatterns on StacAppButton {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _StacAppButton value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _StacAppButton() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _StacAppButton value)  $default,){
final _that = this;
switch (_that) {
case _StacAppButton():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _StacAppButton value)?  $default,){
final _that = this;
switch (_that) {
case _StacAppButton() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(fromJson: _emptyWhenNotString)  String label, @JsonKey(fromJson: _primaryWhenNotString)  String variant, @JsonKey(fromJson: _mediumWhenNotString)  String size, @JsonKey(fromJson: _falseWhenNotBool)  bool expanded, @JsonKey(name: 'onPressed')  Object? actionJson)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _StacAppButton() when $default != null:
return $default(_that.label,_that.variant,_that.size,_that.expanded,_that.actionJson);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(fromJson: _emptyWhenNotString)  String label, @JsonKey(fromJson: _primaryWhenNotString)  String variant, @JsonKey(fromJson: _mediumWhenNotString)  String size, @JsonKey(fromJson: _falseWhenNotBool)  bool expanded, @JsonKey(name: 'onPressed')  Object? actionJson)  $default,) {final _that = this;
switch (_that) {
case _StacAppButton():
return $default(_that.label,_that.variant,_that.size,_that.expanded,_that.actionJson);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(fromJson: _emptyWhenNotString)  String label, @JsonKey(fromJson: _primaryWhenNotString)  String variant, @JsonKey(fromJson: _mediumWhenNotString)  String size, @JsonKey(fromJson: _falseWhenNotBool)  bool expanded, @JsonKey(name: 'onPressed')  Object? actionJson)?  $default,) {final _that = this;
switch (_that) {
case _StacAppButton() when $default != null:
return $default(_that.label,_that.variant,_that.size,_that.expanded,_that.actionJson);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _StacAppButton implements StacAppButton {
  const _StacAppButton({@JsonKey(fromJson: _emptyWhenNotString) required this.label, @JsonKey(fromJson: _primaryWhenNotString) this.variant = 'primary', @JsonKey(fromJson: _mediumWhenNotString) this.size = 'medium', @JsonKey(fromJson: _falseWhenNotBool) this.expanded = false, @JsonKey(name: 'onPressed') this.actionJson});
  factory _StacAppButton.fromJson(Map<String, dynamic> json) => _$StacAppButtonFromJson(json);

@override@JsonKey(fromJson: _emptyWhenNotString) final  String label;
@override@JsonKey(fromJson: _primaryWhenNotString) final  String variant;
@override@JsonKey(fromJson: _mediumWhenNotString) final  String size;
@override@JsonKey(fromJson: _falseWhenNotBool) final  bool expanded;
@override@JsonKey(name: 'onPressed') final  Object? actionJson;

/// Create a copy of StacAppButton
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$StacAppButtonCopyWith<_StacAppButton> get copyWith => __$StacAppButtonCopyWithImpl<_StacAppButton>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$StacAppButtonToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _StacAppButton&&(identical(other.label, label) || other.label == label)&&(identical(other.variant, variant) || other.variant == variant)&&(identical(other.size, size) || other.size == size)&&(identical(other.expanded, expanded) || other.expanded == expanded)&&const DeepCollectionEquality().equals(other.actionJson, actionJson));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,label,variant,size,expanded,const DeepCollectionEquality().hash(actionJson));

@override
String toString() {
  return 'StacAppButton(label: $label, variant: $variant, size: $size, expanded: $expanded, actionJson: $actionJson)';
}


}

/// @nodoc
abstract mixin class _$StacAppButtonCopyWith<$Res> implements $StacAppButtonCopyWith<$Res> {
  factory _$StacAppButtonCopyWith(_StacAppButton value, $Res Function(_StacAppButton) _then) = __$StacAppButtonCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(fromJson: _emptyWhenNotString) String label,@JsonKey(fromJson: _primaryWhenNotString) String variant,@JsonKey(fromJson: _mediumWhenNotString) String size,@JsonKey(fromJson: _falseWhenNotBool) bool expanded,@JsonKey(name: 'onPressed') Object? actionJson
});




}
/// @nodoc
class __$StacAppButtonCopyWithImpl<$Res>
    implements _$StacAppButtonCopyWith<$Res> {
  __$StacAppButtonCopyWithImpl(this._self, this._then);

  final _StacAppButton _self;
  final $Res Function(_StacAppButton) _then;

/// Create a copy of StacAppButton
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? label = null,Object? variant = null,Object? size = null,Object? expanded = null,Object? actionJson = freezed,}) {
  return _then(_StacAppButton(
label: null == label ? _self.label : label // ignore: cast_nullable_to_non_nullable
as String,variant: null == variant ? _self.variant : variant // ignore: cast_nullable_to_non_nullable
as String,size: null == size ? _self.size : size // ignore: cast_nullable_to_non_nullable
as String,expanded: null == expanded ? _self.expanded : expanded // ignore: cast_nullable_to_non_nullable
as bool,actionJson: freezed == actionJson ? _self.actionJson : actionJson ,
  ));
}


}

// dart format on
