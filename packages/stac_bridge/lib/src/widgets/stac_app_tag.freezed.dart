// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'stac_app_tag.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$StacAppTag {

@JsonKey(fromJson: stringOrEmpty) String get label;@JsonKey(fromJson: _muteWhenNotString) String get tone;@JsonKey(fromJson: boolOrFalse) bool get withDot;
/// Create a copy of StacAppTag
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$StacAppTagCopyWith<StacAppTag> get copyWith => _$StacAppTagCopyWithImpl<StacAppTag>(this as StacAppTag, _$identity);

  /// Serializes this StacAppTag to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is StacAppTag&&(identical(other.label, label) || other.label == label)&&(identical(other.tone, tone) || other.tone == tone)&&(identical(other.withDot, withDot) || other.withDot == withDot));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,label,tone,withDot);

@override
String toString() {
  return 'StacAppTag(label: $label, tone: $tone, withDot: $withDot)';
}


}

/// @nodoc
abstract mixin class $StacAppTagCopyWith<$Res>  {
  factory $StacAppTagCopyWith(StacAppTag value, $Res Function(StacAppTag) _then) = _$StacAppTagCopyWithImpl;
@useResult
$Res call({
@JsonKey(fromJson: stringOrEmpty) String label,@JsonKey(fromJson: _muteWhenNotString) String tone,@JsonKey(fromJson: boolOrFalse) bool withDot
});




}
/// @nodoc
class _$StacAppTagCopyWithImpl<$Res>
    implements $StacAppTagCopyWith<$Res> {
  _$StacAppTagCopyWithImpl(this._self, this._then);

  final StacAppTag _self;
  final $Res Function(StacAppTag) _then;

/// Create a copy of StacAppTag
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? label = null,Object? tone = null,Object? withDot = null,}) {
  return _then(_self.copyWith(
label: null == label ? _self.label : label // ignore: cast_nullable_to_non_nullable
as String,tone: null == tone ? _self.tone : tone // ignore: cast_nullable_to_non_nullable
as String,withDot: null == withDot ? _self.withDot : withDot // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [StacAppTag].
extension StacAppTagPatterns on StacAppTag {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _StacAppTag value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _StacAppTag() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _StacAppTag value)  $default,){
final _that = this;
switch (_that) {
case _StacAppTag():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _StacAppTag value)?  $default,){
final _that = this;
switch (_that) {
case _StacAppTag() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(fromJson: stringOrEmpty)  String label, @JsonKey(fromJson: _muteWhenNotString)  String tone, @JsonKey(fromJson: boolOrFalse)  bool withDot)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _StacAppTag() when $default != null:
return $default(_that.label,_that.tone,_that.withDot);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(fromJson: stringOrEmpty)  String label, @JsonKey(fromJson: _muteWhenNotString)  String tone, @JsonKey(fromJson: boolOrFalse)  bool withDot)  $default,) {final _that = this;
switch (_that) {
case _StacAppTag():
return $default(_that.label,_that.tone,_that.withDot);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(fromJson: stringOrEmpty)  String label, @JsonKey(fromJson: _muteWhenNotString)  String tone, @JsonKey(fromJson: boolOrFalse)  bool withDot)?  $default,) {final _that = this;
switch (_that) {
case _StacAppTag() when $default != null:
return $default(_that.label,_that.tone,_that.withDot);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _StacAppTag implements StacAppTag {
  const _StacAppTag({@JsonKey(fromJson: stringOrEmpty) required this.label, @JsonKey(fromJson: _muteWhenNotString) this.tone = 'mute', @JsonKey(fromJson: boolOrFalse) this.withDot = false});
  factory _StacAppTag.fromJson(Map<String, dynamic> json) => _$StacAppTagFromJson(json);

@override@JsonKey(fromJson: stringOrEmpty) final  String label;
@override@JsonKey(fromJson: _muteWhenNotString) final  String tone;
@override@JsonKey(fromJson: boolOrFalse) final  bool withDot;

/// Create a copy of StacAppTag
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$StacAppTagCopyWith<_StacAppTag> get copyWith => __$StacAppTagCopyWithImpl<_StacAppTag>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$StacAppTagToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _StacAppTag&&(identical(other.label, label) || other.label == label)&&(identical(other.tone, tone) || other.tone == tone)&&(identical(other.withDot, withDot) || other.withDot == withDot));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,label,tone,withDot);

@override
String toString() {
  return 'StacAppTag(label: $label, tone: $tone, withDot: $withDot)';
}


}

/// @nodoc
abstract mixin class _$StacAppTagCopyWith<$Res> implements $StacAppTagCopyWith<$Res> {
  factory _$StacAppTagCopyWith(_StacAppTag value, $Res Function(_StacAppTag) _then) = __$StacAppTagCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(fromJson: stringOrEmpty) String label,@JsonKey(fromJson: _muteWhenNotString) String tone,@JsonKey(fromJson: boolOrFalse) bool withDot
});




}
/// @nodoc
class __$StacAppTagCopyWithImpl<$Res>
    implements _$StacAppTagCopyWith<$Res> {
  __$StacAppTagCopyWithImpl(this._self, this._then);

  final _StacAppTag _self;
  final $Res Function(_StacAppTag) _then;

/// Create a copy of StacAppTag
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? label = null,Object? tone = null,Object? withDot = null,}) {
  return _then(_StacAppTag(
label: null == label ? _self.label : label // ignore: cast_nullable_to_non_nullable
as String,tone: null == tone ? _self.tone : tone // ignore: cast_nullable_to_non_nullable
as String,withDot: null == withDot ? _self.withDot : withDot // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
