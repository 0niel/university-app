// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'stac_app_chip.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$StacAppChip {

@JsonKey(fromJson: _emptyWhenNotString) String get label;@JsonKey(fromJson: _falseWhenNotBool) bool get selected;@JsonKey(fromJson: _falseWhenNotBool) bool get small; String? get color;@JsonKey(name: 'onTap') Object? get actionJson;
/// Create a copy of StacAppChip
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$StacAppChipCopyWith<StacAppChip> get copyWith => _$StacAppChipCopyWithImpl<StacAppChip>(this as StacAppChip, _$identity);

  /// Serializes this StacAppChip to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is StacAppChip&&(identical(other.label, label) || other.label == label)&&(identical(other.selected, selected) || other.selected == selected)&&(identical(other.small, small) || other.small == small)&&(identical(other.color, color) || other.color == color)&&const DeepCollectionEquality().equals(other.actionJson, actionJson));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,label,selected,small,color,const DeepCollectionEquality().hash(actionJson));

@override
String toString() {
  return 'StacAppChip(label: $label, selected: $selected, small: $small, color: $color, actionJson: $actionJson)';
}


}

/// @nodoc
abstract mixin class $StacAppChipCopyWith<$Res>  {
  factory $StacAppChipCopyWith(StacAppChip value, $Res Function(StacAppChip) _then) = _$StacAppChipCopyWithImpl;
@useResult
$Res call({
@JsonKey(fromJson: _emptyWhenNotString) String label,@JsonKey(fromJson: _falseWhenNotBool) bool selected,@JsonKey(fromJson: _falseWhenNotBool) bool small, String? color,@JsonKey(name: 'onTap') Object? actionJson
});




}
/// @nodoc
class _$StacAppChipCopyWithImpl<$Res>
    implements $StacAppChipCopyWith<$Res> {
  _$StacAppChipCopyWithImpl(this._self, this._then);

  final StacAppChip _self;
  final $Res Function(StacAppChip) _then;

/// Create a copy of StacAppChip
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? label = null,Object? selected = null,Object? small = null,Object? color = freezed,Object? actionJson = freezed,}) {
  return _then(_self.copyWith(
label: null == label ? _self.label : label // ignore: cast_nullable_to_non_nullable
as String,selected: null == selected ? _self.selected : selected // ignore: cast_nullable_to_non_nullable
as bool,small: null == small ? _self.small : small // ignore: cast_nullable_to_non_nullable
as bool,color: freezed == color ? _self.color : color // ignore: cast_nullable_to_non_nullable
as String?,actionJson: freezed == actionJson ? _self.actionJson : actionJson ,
  ));
}

}


/// Adds pattern-matching-related methods to [StacAppChip].
extension StacAppChipPatterns on StacAppChip {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _StacAppChip value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _StacAppChip() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _StacAppChip value)  $default,){
final _that = this;
switch (_that) {
case _StacAppChip():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _StacAppChip value)?  $default,){
final _that = this;
switch (_that) {
case _StacAppChip() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(fromJson: _emptyWhenNotString)  String label, @JsonKey(fromJson: _falseWhenNotBool)  bool selected, @JsonKey(fromJson: _falseWhenNotBool)  bool small,  String? color, @JsonKey(name: 'onTap')  Object? actionJson)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _StacAppChip() when $default != null:
return $default(_that.label,_that.selected,_that.small,_that.color,_that.actionJson);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(fromJson: _emptyWhenNotString)  String label, @JsonKey(fromJson: _falseWhenNotBool)  bool selected, @JsonKey(fromJson: _falseWhenNotBool)  bool small,  String? color, @JsonKey(name: 'onTap')  Object? actionJson)  $default,) {final _that = this;
switch (_that) {
case _StacAppChip():
return $default(_that.label,_that.selected,_that.small,_that.color,_that.actionJson);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(fromJson: _emptyWhenNotString)  String label, @JsonKey(fromJson: _falseWhenNotBool)  bool selected, @JsonKey(fromJson: _falseWhenNotBool)  bool small,  String? color, @JsonKey(name: 'onTap')  Object? actionJson)?  $default,) {final _that = this;
switch (_that) {
case _StacAppChip() when $default != null:
return $default(_that.label,_that.selected,_that.small,_that.color,_that.actionJson);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _StacAppChip implements StacAppChip {
  const _StacAppChip({@JsonKey(fromJson: _emptyWhenNotString) required this.label, @JsonKey(fromJson: _falseWhenNotBool) this.selected = false, @JsonKey(fromJson: _falseWhenNotBool) this.small = false, this.color, @JsonKey(name: 'onTap') this.actionJson});
  factory _StacAppChip.fromJson(Map<String, dynamic> json) => _$StacAppChipFromJson(json);

@override@JsonKey(fromJson: _emptyWhenNotString) final  String label;
@override@JsonKey(fromJson: _falseWhenNotBool) final  bool selected;
@override@JsonKey(fromJson: _falseWhenNotBool) final  bool small;
@override final  String? color;
@override@JsonKey(name: 'onTap') final  Object? actionJson;

/// Create a copy of StacAppChip
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$StacAppChipCopyWith<_StacAppChip> get copyWith => __$StacAppChipCopyWithImpl<_StacAppChip>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$StacAppChipToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _StacAppChip&&(identical(other.label, label) || other.label == label)&&(identical(other.selected, selected) || other.selected == selected)&&(identical(other.small, small) || other.small == small)&&(identical(other.color, color) || other.color == color)&&const DeepCollectionEquality().equals(other.actionJson, actionJson));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,label,selected,small,color,const DeepCollectionEquality().hash(actionJson));

@override
String toString() {
  return 'StacAppChip(label: $label, selected: $selected, small: $small, color: $color, actionJson: $actionJson)';
}


}

/// @nodoc
abstract mixin class _$StacAppChipCopyWith<$Res> implements $StacAppChipCopyWith<$Res> {
  factory _$StacAppChipCopyWith(_StacAppChip value, $Res Function(_StacAppChip) _then) = __$StacAppChipCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(fromJson: _emptyWhenNotString) String label,@JsonKey(fromJson: _falseWhenNotBool) bool selected,@JsonKey(fromJson: _falseWhenNotBool) bool small, String? color,@JsonKey(name: 'onTap') Object? actionJson
});




}
/// @nodoc
class __$StacAppChipCopyWithImpl<$Res>
    implements _$StacAppChipCopyWith<$Res> {
  __$StacAppChipCopyWithImpl(this._self, this._then);

  final _StacAppChip _self;
  final $Res Function(_StacAppChip) _then;

/// Create a copy of StacAppChip
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? label = null,Object? selected = null,Object? small = null,Object? color = freezed,Object? actionJson = freezed,}) {
  return _then(_StacAppChip(
label: null == label ? _self.label : label // ignore: cast_nullable_to_non_nullable
as String,selected: null == selected ? _self.selected : selected // ignore: cast_nullable_to_non_nullable
as bool,small: null == small ? _self.small : small // ignore: cast_nullable_to_non_nullable
as bool,color: freezed == color ? _self.color : color // ignore: cast_nullable_to_non_nullable
as String?,actionJson: freezed == actionJson ? _self.actionJson : actionJson ,
  ));
}


}

// dart format on
