// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'gamification_badge_summary.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$GamificationBadgeSummary {

 String get id; String get name; String get emoji; String get rarity;
/// Create a copy of GamificationBadgeSummary
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$GamificationBadgeSummaryCopyWith<GamificationBadgeSummary> get copyWith => _$GamificationBadgeSummaryCopyWithImpl<GamificationBadgeSummary>(this as GamificationBadgeSummary, _$identity);

  /// Serializes this GamificationBadgeSummary to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is GamificationBadgeSummary&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.emoji, emoji) || other.emoji == emoji)&&(identical(other.rarity, rarity) || other.rarity == rarity));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,emoji,rarity);

@override
String toString() {
  return 'GamificationBadgeSummary(id: $id, name: $name, emoji: $emoji, rarity: $rarity)';
}


}

/// @nodoc
abstract mixin class $GamificationBadgeSummaryCopyWith<$Res>  {
  factory $GamificationBadgeSummaryCopyWith(GamificationBadgeSummary value, $Res Function(GamificationBadgeSummary) _then) = _$GamificationBadgeSummaryCopyWithImpl;
@useResult
$Res call({
 String id, String name, String emoji, String rarity
});




}
/// @nodoc
class _$GamificationBadgeSummaryCopyWithImpl<$Res>
    implements $GamificationBadgeSummaryCopyWith<$Res> {
  _$GamificationBadgeSummaryCopyWithImpl(this._self, this._then);

  final GamificationBadgeSummary _self;
  final $Res Function(GamificationBadgeSummary) _then;

/// Create a copy of GamificationBadgeSummary
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? emoji = null,Object? rarity = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,emoji: null == emoji ? _self.emoji : emoji // ignore: cast_nullable_to_non_nullable
as String,rarity: null == rarity ? _self.rarity : rarity // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [GamificationBadgeSummary].
extension GamificationBadgeSummaryPatterns on GamificationBadgeSummary {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _GamificationBadgeSummary value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _GamificationBadgeSummary() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _GamificationBadgeSummary value)  $default,){
final _that = this;
switch (_that) {
case _GamificationBadgeSummary():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _GamificationBadgeSummary value)?  $default,){
final _that = this;
switch (_that) {
case _GamificationBadgeSummary() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String name,  String emoji,  String rarity)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _GamificationBadgeSummary() when $default != null:
return $default(_that.id,_that.name,_that.emoji,_that.rarity);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String name,  String emoji,  String rarity)  $default,) {final _that = this;
switch (_that) {
case _GamificationBadgeSummary():
return $default(_that.id,_that.name,_that.emoji,_that.rarity);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String name,  String emoji,  String rarity)?  $default,) {final _that = this;
switch (_that) {
case _GamificationBadgeSummary() when $default != null:
return $default(_that.id,_that.name,_that.emoji,_that.rarity);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _GamificationBadgeSummary implements GamificationBadgeSummary {
  const _GamificationBadgeSummary({required this.id, required this.name, required this.emoji, this.rarity = 'common'});
  factory _GamificationBadgeSummary.fromJson(Map<String, dynamic> json) => _$GamificationBadgeSummaryFromJson(json);

@override final  String id;
@override final  String name;
@override final  String emoji;
@override@JsonKey() final  String rarity;

/// Create a copy of GamificationBadgeSummary
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$GamificationBadgeSummaryCopyWith<_GamificationBadgeSummary> get copyWith => __$GamificationBadgeSummaryCopyWithImpl<_GamificationBadgeSummary>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$GamificationBadgeSummaryToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _GamificationBadgeSummary&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.emoji, emoji) || other.emoji == emoji)&&(identical(other.rarity, rarity) || other.rarity == rarity));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,emoji,rarity);

@override
String toString() {
  return 'GamificationBadgeSummary(id: $id, name: $name, emoji: $emoji, rarity: $rarity)';
}


}

/// @nodoc
abstract mixin class _$GamificationBadgeSummaryCopyWith<$Res> implements $GamificationBadgeSummaryCopyWith<$Res> {
  factory _$GamificationBadgeSummaryCopyWith(_GamificationBadgeSummary value, $Res Function(_GamificationBadgeSummary) _then) = __$GamificationBadgeSummaryCopyWithImpl;
@override @useResult
$Res call({
 String id, String name, String emoji, String rarity
});




}
/// @nodoc
class __$GamificationBadgeSummaryCopyWithImpl<$Res>
    implements _$GamificationBadgeSummaryCopyWith<$Res> {
  __$GamificationBadgeSummaryCopyWithImpl(this._self, this._then);

  final _GamificationBadgeSummary _self;
  final $Res Function(_GamificationBadgeSummary) _then;

/// Create a copy of GamificationBadgeSummary
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? emoji = null,Object? rarity = null,}) {
  return _then(_GamificationBadgeSummary(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,emoji: null == emoji ? _self.emoji : emoji // ignore: cast_nullable_to_non_nullable
as String,rarity: null == rarity ? _self.rarity : rarity // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
