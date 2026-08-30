// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'stac_app_card.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$StacAppCard {

@JsonKey(fromJson: _paddingFromJson) double get padding; String? get color;@JsonKey(name: 'onTap') Object? get actionJson; Object? get child;
/// Create a copy of StacAppCard
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$StacAppCardCopyWith<StacAppCard> get copyWith => _$StacAppCardCopyWithImpl<StacAppCard>(this as StacAppCard, _$identity);

  /// Serializes this StacAppCard to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is StacAppCard&&(identical(other.padding, padding) || other.padding == padding)&&(identical(other.color, color) || other.color == color)&&const DeepCollectionEquality().equals(other.actionJson, actionJson)&&const DeepCollectionEquality().equals(other.child, child));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,padding,color,const DeepCollectionEquality().hash(actionJson),const DeepCollectionEquality().hash(child));

@override
String toString() {
  return 'StacAppCard(padding: $padding, color: $color, actionJson: $actionJson, child: $child)';
}


}

/// @nodoc
abstract mixin class $StacAppCardCopyWith<$Res>  {
  factory $StacAppCardCopyWith(StacAppCard value, $Res Function(StacAppCard) _then) = _$StacAppCardCopyWithImpl;
@useResult
$Res call({
@JsonKey(fromJson: _paddingFromJson) double padding, String? color,@JsonKey(name: 'onTap') Object? actionJson, Object? child
});




}
/// @nodoc
class _$StacAppCardCopyWithImpl<$Res>
    implements $StacAppCardCopyWith<$Res> {
  _$StacAppCardCopyWithImpl(this._self, this._then);

  final StacAppCard _self;
  final $Res Function(StacAppCard) _then;

/// Create a copy of StacAppCard
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? padding = null,Object? color = freezed,Object? actionJson = freezed,Object? child = freezed,}) {
  return _then(_self.copyWith(
padding: null == padding ? _self.padding : padding // ignore: cast_nullable_to_non_nullable
as double,color: freezed == color ? _self.color : color // ignore: cast_nullable_to_non_nullable
as String?,actionJson: freezed == actionJson ? _self.actionJson : actionJson ,child: freezed == child ? _self.child : child ,
  ));
}

}


/// Adds pattern-matching-related methods to [StacAppCard].
extension StacAppCardPatterns on StacAppCard {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _StacAppCard value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _StacAppCard() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _StacAppCard value)  $default,){
final _that = this;
switch (_that) {
case _StacAppCard():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _StacAppCard value)?  $default,){
final _that = this;
switch (_that) {
case _StacAppCard() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(fromJson: _paddingFromJson)  double padding,  String? color, @JsonKey(name: 'onTap')  Object? actionJson,  Object? child)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _StacAppCard() when $default != null:
return $default(_that.padding,_that.color,_that.actionJson,_that.child);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(fromJson: _paddingFromJson)  double padding,  String? color, @JsonKey(name: 'onTap')  Object? actionJson,  Object? child)  $default,) {final _that = this;
switch (_that) {
case _StacAppCard():
return $default(_that.padding,_that.color,_that.actionJson,_that.child);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(fromJson: _paddingFromJson)  double padding,  String? color, @JsonKey(name: 'onTap')  Object? actionJson,  Object? child)?  $default,) {final _that = this;
switch (_that) {
case _StacAppCard() when $default != null:
return $default(_that.padding,_that.color,_that.actionJson,_that.child);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _StacAppCard implements StacAppCard {
  const _StacAppCard({@JsonKey(fromJson: _paddingFromJson) this.padding = 16, this.color, @JsonKey(name: 'onTap') this.actionJson, this.child});
  factory _StacAppCard.fromJson(Map<String, dynamic> json) => _$StacAppCardFromJson(json);

@override@JsonKey(fromJson: _paddingFromJson) final  double padding;
@override final  String? color;
@override@JsonKey(name: 'onTap') final  Object? actionJson;
@override final  Object? child;

/// Create a copy of StacAppCard
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$StacAppCardCopyWith<_StacAppCard> get copyWith => __$StacAppCardCopyWithImpl<_StacAppCard>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$StacAppCardToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _StacAppCard&&(identical(other.padding, padding) || other.padding == padding)&&(identical(other.color, color) || other.color == color)&&const DeepCollectionEquality().equals(other.actionJson, actionJson)&&const DeepCollectionEquality().equals(other.child, child));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,padding,color,const DeepCollectionEquality().hash(actionJson),const DeepCollectionEquality().hash(child));

@override
String toString() {
  return 'StacAppCard(padding: $padding, color: $color, actionJson: $actionJson, child: $child)';
}


}

/// @nodoc
abstract mixin class _$StacAppCardCopyWith<$Res> implements $StacAppCardCopyWith<$Res> {
  factory _$StacAppCardCopyWith(_StacAppCard value, $Res Function(_StacAppCard) _then) = __$StacAppCardCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(fromJson: _paddingFromJson) double padding, String? color,@JsonKey(name: 'onTap') Object? actionJson, Object? child
});




}
/// @nodoc
class __$StacAppCardCopyWithImpl<$Res>
    implements _$StacAppCardCopyWith<$Res> {
  __$StacAppCardCopyWithImpl(this._self, this._then);

  final _StacAppCard _self;
  final $Res Function(_StacAppCard) _then;

/// Create a copy of StacAppCard
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? padding = null,Object? color = freezed,Object? actionJson = freezed,Object? child = freezed,}) {
  return _then(_StacAppCard(
padding: null == padding ? _self.padding : padding // ignore: cast_nullable_to_non_nullable
as double,color: freezed == color ? _self.color : color // ignore: cast_nullable_to_non_nullable
as String?,actionJson: freezed == actionJson ? _self.actionJson : actionJson ,child: freezed == child ? _self.child : child ,
  ));
}


}

// dart format on
