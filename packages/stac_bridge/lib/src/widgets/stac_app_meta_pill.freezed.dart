// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'stac_app_meta_pill.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$StacAppMetaPill {

 String get text; bool get strong;
/// Create a copy of StacAppMetaPill
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$StacAppMetaPillCopyWith<StacAppMetaPill> get copyWith => _$StacAppMetaPillCopyWithImpl<StacAppMetaPill>(this as StacAppMetaPill, _$identity);

  /// Serializes this StacAppMetaPill to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is StacAppMetaPill&&(identical(other.text, text) || other.text == text)&&(identical(other.strong, strong) || other.strong == strong));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,text,strong);

@override
String toString() {
  return 'StacAppMetaPill(text: $text, strong: $strong)';
}


}

/// @nodoc
abstract mixin class $StacAppMetaPillCopyWith<$Res>  {
  factory $StacAppMetaPillCopyWith(StacAppMetaPill value, $Res Function(StacAppMetaPill) _then) = _$StacAppMetaPillCopyWithImpl;
@useResult
$Res call({
 String text, bool strong
});




}
/// @nodoc
class _$StacAppMetaPillCopyWithImpl<$Res>
    implements $StacAppMetaPillCopyWith<$Res> {
  _$StacAppMetaPillCopyWithImpl(this._self, this._then);

  final StacAppMetaPill _self;
  final $Res Function(StacAppMetaPill) _then;

/// Create a copy of StacAppMetaPill
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? text = null,Object? strong = null,}) {
  return _then(_self.copyWith(
text: null == text ? _self.text : text // ignore: cast_nullable_to_non_nullable
as String,strong: null == strong ? _self.strong : strong // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [StacAppMetaPill].
extension StacAppMetaPillPatterns on StacAppMetaPill {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _StacAppMetaPill value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _StacAppMetaPill() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _StacAppMetaPill value)  $default,){
final _that = this;
switch (_that) {
case _StacAppMetaPill():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _StacAppMetaPill value)?  $default,){
final _that = this;
switch (_that) {
case _StacAppMetaPill() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String text,  bool strong)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _StacAppMetaPill() when $default != null:
return $default(_that.text,_that.strong);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String text,  bool strong)  $default,) {final _that = this;
switch (_that) {
case _StacAppMetaPill():
return $default(_that.text,_that.strong);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String text,  bool strong)?  $default,) {final _that = this;
switch (_that) {
case _StacAppMetaPill() when $default != null:
return $default(_that.text,_that.strong);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _StacAppMetaPill implements StacAppMetaPill {
  const _StacAppMetaPill({required this.text, this.strong = false});
  factory _StacAppMetaPill.fromJson(Map<String, dynamic> json) => _$StacAppMetaPillFromJson(json);

@override final  String text;
@override@JsonKey() final  bool strong;

/// Create a copy of StacAppMetaPill
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$StacAppMetaPillCopyWith<_StacAppMetaPill> get copyWith => __$StacAppMetaPillCopyWithImpl<_StacAppMetaPill>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$StacAppMetaPillToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _StacAppMetaPill&&(identical(other.text, text) || other.text == text)&&(identical(other.strong, strong) || other.strong == strong));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,text,strong);

@override
String toString() {
  return 'StacAppMetaPill(text: $text, strong: $strong)';
}


}

/// @nodoc
abstract mixin class _$StacAppMetaPillCopyWith<$Res> implements $StacAppMetaPillCopyWith<$Res> {
  factory _$StacAppMetaPillCopyWith(_StacAppMetaPill value, $Res Function(_StacAppMetaPill) _then) = __$StacAppMetaPillCopyWithImpl;
@override @useResult
$Res call({
 String text, bool strong
});




}
/// @nodoc
class __$StacAppMetaPillCopyWithImpl<$Res>
    implements _$StacAppMetaPillCopyWith<$Res> {
  __$StacAppMetaPillCopyWithImpl(this._self, this._then);

  final _StacAppMetaPill _self;
  final $Res Function(_StacAppMetaPill) _then;

/// Create a copy of StacAppMetaPill
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? text = null,Object? strong = null,}) {
  return _then(_StacAppMetaPill(
text: null == text ? _self.text : text // ignore: cast_nullable_to_non_nullable
as String,strong: null == strong ? _self.strong : strong // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
