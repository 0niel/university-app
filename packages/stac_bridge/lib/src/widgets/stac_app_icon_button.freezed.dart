// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'stac_app_icon_button.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$StacAppIconButton {

@JsonKey(fromJson: stringOrEmpty) String get icon;@JsonKey(fromJson: _ghostWhenNotString) String get variant;@JsonKey(fromJson: _mediumWhenNotString) String get size;@JsonKey(fromJson: stringOrNull) String? get tooltip;@JsonKey(name: 'onPressed') Object? get actionJson;
/// Create a copy of StacAppIconButton
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$StacAppIconButtonCopyWith<StacAppIconButton> get copyWith => _$StacAppIconButtonCopyWithImpl<StacAppIconButton>(this as StacAppIconButton, _$identity);

  /// Serializes this StacAppIconButton to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is StacAppIconButton&&(identical(other.icon, icon) || other.icon == icon)&&(identical(other.variant, variant) || other.variant == variant)&&(identical(other.size, size) || other.size == size)&&(identical(other.tooltip, tooltip) || other.tooltip == tooltip)&&const DeepCollectionEquality().equals(other.actionJson, actionJson));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,icon,variant,size,tooltip,const DeepCollectionEquality().hash(actionJson));

@override
String toString() {
  return 'StacAppIconButton(icon: $icon, variant: $variant, size: $size, tooltip: $tooltip, actionJson: $actionJson)';
}


}

/// @nodoc
abstract mixin class $StacAppIconButtonCopyWith<$Res>  {
  factory $StacAppIconButtonCopyWith(StacAppIconButton value, $Res Function(StacAppIconButton) _then) = _$StacAppIconButtonCopyWithImpl;
@useResult
$Res call({
@JsonKey(fromJson: stringOrEmpty) String icon,@JsonKey(fromJson: _ghostWhenNotString) String variant,@JsonKey(fromJson: _mediumWhenNotString) String size,@JsonKey(fromJson: stringOrNull) String? tooltip,@JsonKey(name: 'onPressed') Object? actionJson
});




}
/// @nodoc
class _$StacAppIconButtonCopyWithImpl<$Res>
    implements $StacAppIconButtonCopyWith<$Res> {
  _$StacAppIconButtonCopyWithImpl(this._self, this._then);

  final StacAppIconButton _self;
  final $Res Function(StacAppIconButton) _then;

/// Create a copy of StacAppIconButton
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? icon = null,Object? variant = null,Object? size = null,Object? tooltip = freezed,Object? actionJson = freezed,}) {
  return _then(_self.copyWith(
icon: null == icon ? _self.icon : icon // ignore: cast_nullable_to_non_nullable
as String,variant: null == variant ? _self.variant : variant // ignore: cast_nullable_to_non_nullable
as String,size: null == size ? _self.size : size // ignore: cast_nullable_to_non_nullable
as String,tooltip: freezed == tooltip ? _self.tooltip : tooltip // ignore: cast_nullable_to_non_nullable
as String?,actionJson: freezed == actionJson ? _self.actionJson : actionJson ,
  ));
}

}


/// Adds pattern-matching-related methods to [StacAppIconButton].
extension StacAppIconButtonPatterns on StacAppIconButton {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _StacAppIconButton value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _StacAppIconButton() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _StacAppIconButton value)  $default,){
final _that = this;
switch (_that) {
case _StacAppIconButton():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _StacAppIconButton value)?  $default,){
final _that = this;
switch (_that) {
case _StacAppIconButton() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(fromJson: stringOrEmpty)  String icon, @JsonKey(fromJson: _ghostWhenNotString)  String variant, @JsonKey(fromJson: _mediumWhenNotString)  String size, @JsonKey(fromJson: stringOrNull)  String? tooltip, @JsonKey(name: 'onPressed')  Object? actionJson)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _StacAppIconButton() when $default != null:
return $default(_that.icon,_that.variant,_that.size,_that.tooltip,_that.actionJson);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(fromJson: stringOrEmpty)  String icon, @JsonKey(fromJson: _ghostWhenNotString)  String variant, @JsonKey(fromJson: _mediumWhenNotString)  String size, @JsonKey(fromJson: stringOrNull)  String? tooltip, @JsonKey(name: 'onPressed')  Object? actionJson)  $default,) {final _that = this;
switch (_that) {
case _StacAppIconButton():
return $default(_that.icon,_that.variant,_that.size,_that.tooltip,_that.actionJson);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(fromJson: stringOrEmpty)  String icon, @JsonKey(fromJson: _ghostWhenNotString)  String variant, @JsonKey(fromJson: _mediumWhenNotString)  String size, @JsonKey(fromJson: stringOrNull)  String? tooltip, @JsonKey(name: 'onPressed')  Object? actionJson)?  $default,) {final _that = this;
switch (_that) {
case _StacAppIconButton() when $default != null:
return $default(_that.icon,_that.variant,_that.size,_that.tooltip,_that.actionJson);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _StacAppIconButton implements StacAppIconButton {
  const _StacAppIconButton({@JsonKey(fromJson: stringOrEmpty) required this.icon, @JsonKey(fromJson: _ghostWhenNotString) this.variant = 'ghost', @JsonKey(fromJson: _mediumWhenNotString) this.size = 'medium', @JsonKey(fromJson: stringOrNull) this.tooltip, @JsonKey(name: 'onPressed') this.actionJson});
  factory _StacAppIconButton.fromJson(Map<String, dynamic> json) => _$StacAppIconButtonFromJson(json);

@override@JsonKey(fromJson: stringOrEmpty) final  String icon;
@override@JsonKey(fromJson: _ghostWhenNotString) final  String variant;
@override@JsonKey(fromJson: _mediumWhenNotString) final  String size;
@override@JsonKey(fromJson: stringOrNull) final  String? tooltip;
@override@JsonKey(name: 'onPressed') final  Object? actionJson;

/// Create a copy of StacAppIconButton
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$StacAppIconButtonCopyWith<_StacAppIconButton> get copyWith => __$StacAppIconButtonCopyWithImpl<_StacAppIconButton>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$StacAppIconButtonToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _StacAppIconButton&&(identical(other.icon, icon) || other.icon == icon)&&(identical(other.variant, variant) || other.variant == variant)&&(identical(other.size, size) || other.size == size)&&(identical(other.tooltip, tooltip) || other.tooltip == tooltip)&&const DeepCollectionEquality().equals(other.actionJson, actionJson));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,icon,variant,size,tooltip,const DeepCollectionEquality().hash(actionJson));

@override
String toString() {
  return 'StacAppIconButton(icon: $icon, variant: $variant, size: $size, tooltip: $tooltip, actionJson: $actionJson)';
}


}

/// @nodoc
abstract mixin class _$StacAppIconButtonCopyWith<$Res> implements $StacAppIconButtonCopyWith<$Res> {
  factory _$StacAppIconButtonCopyWith(_StacAppIconButton value, $Res Function(_StacAppIconButton) _then) = __$StacAppIconButtonCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(fromJson: stringOrEmpty) String icon,@JsonKey(fromJson: _ghostWhenNotString) String variant,@JsonKey(fromJson: _mediumWhenNotString) String size,@JsonKey(fromJson: stringOrNull) String? tooltip,@JsonKey(name: 'onPressed') Object? actionJson
});




}
/// @nodoc
class __$StacAppIconButtonCopyWithImpl<$Res>
    implements _$StacAppIconButtonCopyWith<$Res> {
  __$StacAppIconButtonCopyWithImpl(this._self, this._then);

  final _StacAppIconButton _self;
  final $Res Function(_StacAppIconButton) _then;

/// Create a copy of StacAppIconButton
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? icon = null,Object? variant = null,Object? size = null,Object? tooltip = freezed,Object? actionJson = freezed,}) {
  return _then(_StacAppIconButton(
icon: null == icon ? _self.icon : icon // ignore: cast_nullable_to_non_nullable
as String,variant: null == variant ? _self.variant : variant // ignore: cast_nullable_to_non_nullable
as String,size: null == size ? _self.size : size // ignore: cast_nullable_to_non_nullable
as String,tooltip: freezed == tooltip ? _self.tooltip : tooltip // ignore: cast_nullable_to_non_nullable
as String?,actionJson: freezed == actionJson ? _self.actionJson : actionJson ,
  ));
}


}

// dart format on
