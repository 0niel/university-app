// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'stac_app_smart_chip.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$StacAppSmartChip {

@JsonKey(fromJson: stringOrEmpty) String get emoji;@JsonKey(fromJson: stringOrEmpty) String get label;@JsonKey(fromJson: stringOrEmpty) String get value; String? get tone;
/// Create a copy of StacAppSmartChip
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$StacAppSmartChipCopyWith<StacAppSmartChip> get copyWith => _$StacAppSmartChipCopyWithImpl<StacAppSmartChip>(this as StacAppSmartChip, _$identity);

  /// Serializes this StacAppSmartChip to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is StacAppSmartChip&&(identical(other.emoji, emoji) || other.emoji == emoji)&&(identical(other.label, label) || other.label == label)&&(identical(other.value, value) || other.value == value)&&(identical(other.tone, tone) || other.tone == tone));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,emoji,label,value,tone);

@override
String toString() {
  return 'StacAppSmartChip(emoji: $emoji, label: $label, value: $value, tone: $tone)';
}


}

/// @nodoc
abstract mixin class $StacAppSmartChipCopyWith<$Res>  {
  factory $StacAppSmartChipCopyWith(StacAppSmartChip value, $Res Function(StacAppSmartChip) _then) = _$StacAppSmartChipCopyWithImpl;
@useResult
$Res call({
@JsonKey(fromJson: stringOrEmpty) String emoji,@JsonKey(fromJson: stringOrEmpty) String label,@JsonKey(fromJson: stringOrEmpty) String value, String? tone
});




}
/// @nodoc
class _$StacAppSmartChipCopyWithImpl<$Res>
    implements $StacAppSmartChipCopyWith<$Res> {
  _$StacAppSmartChipCopyWithImpl(this._self, this._then);

  final StacAppSmartChip _self;
  final $Res Function(StacAppSmartChip) _then;

/// Create a copy of StacAppSmartChip
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? emoji = null,Object? label = null,Object? value = null,Object? tone = freezed,}) {
  return _then(_self.copyWith(
emoji: null == emoji ? _self.emoji : emoji // ignore: cast_nullable_to_non_nullable
as String,label: null == label ? _self.label : label // ignore: cast_nullable_to_non_nullable
as String,value: null == value ? _self.value : value // ignore: cast_nullable_to_non_nullable
as String,tone: freezed == tone ? _self.tone : tone // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [StacAppSmartChip].
extension StacAppSmartChipPatterns on StacAppSmartChip {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _StacAppSmartChip value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _StacAppSmartChip() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _StacAppSmartChip value)  $default,){
final _that = this;
switch (_that) {
case _StacAppSmartChip():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _StacAppSmartChip value)?  $default,){
final _that = this;
switch (_that) {
case _StacAppSmartChip() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(fromJson: stringOrEmpty)  String emoji, @JsonKey(fromJson: stringOrEmpty)  String label, @JsonKey(fromJson: stringOrEmpty)  String value,  String? tone)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _StacAppSmartChip() when $default != null:
return $default(_that.emoji,_that.label,_that.value,_that.tone);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(fromJson: stringOrEmpty)  String emoji, @JsonKey(fromJson: stringOrEmpty)  String label, @JsonKey(fromJson: stringOrEmpty)  String value,  String? tone)  $default,) {final _that = this;
switch (_that) {
case _StacAppSmartChip():
return $default(_that.emoji,_that.label,_that.value,_that.tone);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(fromJson: stringOrEmpty)  String emoji, @JsonKey(fromJson: stringOrEmpty)  String label, @JsonKey(fromJson: stringOrEmpty)  String value,  String? tone)?  $default,) {final _that = this;
switch (_that) {
case _StacAppSmartChip() when $default != null:
return $default(_that.emoji,_that.label,_that.value,_that.tone);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _StacAppSmartChip implements StacAppSmartChip {
  const _StacAppSmartChip({@JsonKey(fromJson: stringOrEmpty) required this.emoji, @JsonKey(fromJson: stringOrEmpty) required this.label, @JsonKey(fromJson: stringOrEmpty) required this.value, this.tone});
  factory _StacAppSmartChip.fromJson(Map<String, dynamic> json) => _$StacAppSmartChipFromJson(json);

@override@JsonKey(fromJson: stringOrEmpty) final  String emoji;
@override@JsonKey(fromJson: stringOrEmpty) final  String label;
@override@JsonKey(fromJson: stringOrEmpty) final  String value;
@override final  String? tone;

/// Create a copy of StacAppSmartChip
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$StacAppSmartChipCopyWith<_StacAppSmartChip> get copyWith => __$StacAppSmartChipCopyWithImpl<_StacAppSmartChip>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$StacAppSmartChipToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _StacAppSmartChip&&(identical(other.emoji, emoji) || other.emoji == emoji)&&(identical(other.label, label) || other.label == label)&&(identical(other.value, value) || other.value == value)&&(identical(other.tone, tone) || other.tone == tone));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,emoji,label,value,tone);

@override
String toString() {
  return 'StacAppSmartChip(emoji: $emoji, label: $label, value: $value, tone: $tone)';
}


}

/// @nodoc
abstract mixin class _$StacAppSmartChipCopyWith<$Res> implements $StacAppSmartChipCopyWith<$Res> {
  factory _$StacAppSmartChipCopyWith(_StacAppSmartChip value, $Res Function(_StacAppSmartChip) _then) = __$StacAppSmartChipCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(fromJson: stringOrEmpty) String emoji,@JsonKey(fromJson: stringOrEmpty) String label,@JsonKey(fromJson: stringOrEmpty) String value, String? tone
});




}
/// @nodoc
class __$StacAppSmartChipCopyWithImpl<$Res>
    implements _$StacAppSmartChipCopyWith<$Res> {
  __$StacAppSmartChipCopyWithImpl(this._self, this._then);

  final _StacAppSmartChip _self;
  final $Res Function(_StacAppSmartChip) _then;

/// Create a copy of StacAppSmartChip
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? emoji = null,Object? label = null,Object? value = null,Object? tone = freezed,}) {
  return _then(_StacAppSmartChip(
emoji: null == emoji ? _self.emoji : emoji // ignore: cast_nullable_to_non_nullable
as String,label: null == label ? _self.label : label // ignore: cast_nullable_to_non_nullable
as String,value: null == value ? _self.value : value // ignore: cast_nullable_to_non_nullable
as String,tone: freezed == tone ? _self.tone : tone // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
