// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'gamification_badge.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$GamificationBadge {

 String get id; String get category; String get name; String get description; String get emoji; String get rarity; int get xpReward; int get shurikenReward; bool get isEarned; double get progress;@JsonKey(fromJson: dateTimeFromJson, toJson: dateTimeToJson) DateTime? get earnedAt;
/// Create a copy of GamificationBadge
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$GamificationBadgeCopyWith<GamificationBadge> get copyWith => _$GamificationBadgeCopyWithImpl<GamificationBadge>(this as GamificationBadge, _$identity);

  /// Serializes this GamificationBadge to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is GamificationBadge&&(identical(other.id, id) || other.id == id)&&(identical(other.category, category) || other.category == category)&&(identical(other.name, name) || other.name == name)&&(identical(other.description, description) || other.description == description)&&(identical(other.emoji, emoji) || other.emoji == emoji)&&(identical(other.rarity, rarity) || other.rarity == rarity)&&(identical(other.xpReward, xpReward) || other.xpReward == xpReward)&&(identical(other.shurikenReward, shurikenReward) || other.shurikenReward == shurikenReward)&&(identical(other.isEarned, isEarned) || other.isEarned == isEarned)&&(identical(other.progress, progress) || other.progress == progress)&&(identical(other.earnedAt, earnedAt) || other.earnedAt == earnedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,category,name,description,emoji,rarity,xpReward,shurikenReward,isEarned,progress,earnedAt);

@override
String toString() {
  return 'GamificationBadge(id: $id, category: $category, name: $name, description: $description, emoji: $emoji, rarity: $rarity, xpReward: $xpReward, shurikenReward: $shurikenReward, isEarned: $isEarned, progress: $progress, earnedAt: $earnedAt)';
}


}

/// @nodoc
abstract mixin class $GamificationBadgeCopyWith<$Res>  {
  factory $GamificationBadgeCopyWith(GamificationBadge value, $Res Function(GamificationBadge) _then) = _$GamificationBadgeCopyWithImpl;
@useResult
$Res call({
 String id, String category, String name, String description, String emoji, String rarity, int xpReward, int shurikenReward, bool isEarned, double progress,@JsonKey(fromJson: dateTimeFromJson, toJson: dateTimeToJson) DateTime? earnedAt
});




}
/// @nodoc
class _$GamificationBadgeCopyWithImpl<$Res>
    implements $GamificationBadgeCopyWith<$Res> {
  _$GamificationBadgeCopyWithImpl(this._self, this._then);

  final GamificationBadge _self;
  final $Res Function(GamificationBadge) _then;

/// Create a copy of GamificationBadge
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? category = null,Object? name = null,Object? description = null,Object? emoji = null,Object? rarity = null,Object? xpReward = null,Object? shurikenReward = null,Object? isEarned = null,Object? progress = null,Object? earnedAt = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,category: null == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,emoji: null == emoji ? _self.emoji : emoji // ignore: cast_nullable_to_non_nullable
as String,rarity: null == rarity ? _self.rarity : rarity // ignore: cast_nullable_to_non_nullable
as String,xpReward: null == xpReward ? _self.xpReward : xpReward // ignore: cast_nullable_to_non_nullable
as int,shurikenReward: null == shurikenReward ? _self.shurikenReward : shurikenReward // ignore: cast_nullable_to_non_nullable
as int,isEarned: null == isEarned ? _self.isEarned : isEarned // ignore: cast_nullable_to_non_nullable
as bool,progress: null == progress ? _self.progress : progress // ignore: cast_nullable_to_non_nullable
as double,earnedAt: freezed == earnedAt ? _self.earnedAt : earnedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [GamificationBadge].
extension GamificationBadgePatterns on GamificationBadge {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _GamificationBadge value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _GamificationBadge() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _GamificationBadge value)  $default,){
final _that = this;
switch (_that) {
case _GamificationBadge():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _GamificationBadge value)?  $default,){
final _that = this;
switch (_that) {
case _GamificationBadge() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String category,  String name,  String description,  String emoji,  String rarity,  int xpReward,  int shurikenReward,  bool isEarned,  double progress, @JsonKey(fromJson: dateTimeFromJson, toJson: dateTimeToJson)  DateTime? earnedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _GamificationBadge() when $default != null:
return $default(_that.id,_that.category,_that.name,_that.description,_that.emoji,_that.rarity,_that.xpReward,_that.shurikenReward,_that.isEarned,_that.progress,_that.earnedAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String category,  String name,  String description,  String emoji,  String rarity,  int xpReward,  int shurikenReward,  bool isEarned,  double progress, @JsonKey(fromJson: dateTimeFromJson, toJson: dateTimeToJson)  DateTime? earnedAt)  $default,) {final _that = this;
switch (_that) {
case _GamificationBadge():
return $default(_that.id,_that.category,_that.name,_that.description,_that.emoji,_that.rarity,_that.xpReward,_that.shurikenReward,_that.isEarned,_that.progress,_that.earnedAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String category,  String name,  String description,  String emoji,  String rarity,  int xpReward,  int shurikenReward,  bool isEarned,  double progress, @JsonKey(fromJson: dateTimeFromJson, toJson: dateTimeToJson)  DateTime? earnedAt)?  $default,) {final _that = this;
switch (_that) {
case _GamificationBadge() when $default != null:
return $default(_that.id,_that.category,_that.name,_that.description,_that.emoji,_that.rarity,_that.xpReward,_that.shurikenReward,_that.isEarned,_that.progress,_that.earnedAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _GamificationBadge implements GamificationBadge {
  const _GamificationBadge({required this.id, required this.category, required this.name, required this.description, required this.emoji, this.rarity = 'common', this.xpReward = 0, this.shurikenReward = 0, this.isEarned = false, this.progress = 0, @JsonKey(fromJson: dateTimeFromJson, toJson: dateTimeToJson) this.earnedAt});
  factory _GamificationBadge.fromJson(Map<String, dynamic> json) => _$GamificationBadgeFromJson(json);

@override final  String id;
@override final  String category;
@override final  String name;
@override final  String description;
@override final  String emoji;
@override@JsonKey() final  String rarity;
@override@JsonKey() final  int xpReward;
@override@JsonKey() final  int shurikenReward;
@override@JsonKey() final  bool isEarned;
@override@JsonKey() final  double progress;
@override@JsonKey(fromJson: dateTimeFromJson, toJson: dateTimeToJson) final  DateTime? earnedAt;

/// Create a copy of GamificationBadge
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$GamificationBadgeCopyWith<_GamificationBadge> get copyWith => __$GamificationBadgeCopyWithImpl<_GamificationBadge>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$GamificationBadgeToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _GamificationBadge&&(identical(other.id, id) || other.id == id)&&(identical(other.category, category) || other.category == category)&&(identical(other.name, name) || other.name == name)&&(identical(other.description, description) || other.description == description)&&(identical(other.emoji, emoji) || other.emoji == emoji)&&(identical(other.rarity, rarity) || other.rarity == rarity)&&(identical(other.xpReward, xpReward) || other.xpReward == xpReward)&&(identical(other.shurikenReward, shurikenReward) || other.shurikenReward == shurikenReward)&&(identical(other.isEarned, isEarned) || other.isEarned == isEarned)&&(identical(other.progress, progress) || other.progress == progress)&&(identical(other.earnedAt, earnedAt) || other.earnedAt == earnedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,category,name,description,emoji,rarity,xpReward,shurikenReward,isEarned,progress,earnedAt);

@override
String toString() {
  return 'GamificationBadge(id: $id, category: $category, name: $name, description: $description, emoji: $emoji, rarity: $rarity, xpReward: $xpReward, shurikenReward: $shurikenReward, isEarned: $isEarned, progress: $progress, earnedAt: $earnedAt)';
}


}

/// @nodoc
abstract mixin class _$GamificationBadgeCopyWith<$Res> implements $GamificationBadgeCopyWith<$Res> {
  factory _$GamificationBadgeCopyWith(_GamificationBadge value, $Res Function(_GamificationBadge) _then) = __$GamificationBadgeCopyWithImpl;
@override @useResult
$Res call({
 String id, String category, String name, String description, String emoji, String rarity, int xpReward, int shurikenReward, bool isEarned, double progress,@JsonKey(fromJson: dateTimeFromJson, toJson: dateTimeToJson) DateTime? earnedAt
});




}
/// @nodoc
class __$GamificationBadgeCopyWithImpl<$Res>
    implements _$GamificationBadgeCopyWith<$Res> {
  __$GamificationBadgeCopyWithImpl(this._self, this._then);

  final _GamificationBadge _self;
  final $Res Function(_GamificationBadge) _then;

/// Create a copy of GamificationBadge
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? category = null,Object? name = null,Object? description = null,Object? emoji = null,Object? rarity = null,Object? xpReward = null,Object? shurikenReward = null,Object? isEarned = null,Object? progress = null,Object? earnedAt = freezed,}) {
  return _then(_GamificationBadge(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,category: null == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,emoji: null == emoji ? _self.emoji : emoji // ignore: cast_nullable_to_non_nullable
as String,rarity: null == rarity ? _self.rarity : rarity // ignore: cast_nullable_to_non_nullable
as String,xpReward: null == xpReward ? _self.xpReward : xpReward // ignore: cast_nullable_to_non_nullable
as int,shurikenReward: null == shurikenReward ? _self.shurikenReward : shurikenReward // ignore: cast_nullable_to_non_nullable
as int,isEarned: null == isEarned ? _self.isEarned : isEarned // ignore: cast_nullable_to_non_nullable
as bool,progress: null == progress ? _self.progress : progress // ignore: cast_nullable_to_non_nullable
as double,earnedAt: freezed == earnedAt ? _self.earnedAt : earnedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}

// dart format on
