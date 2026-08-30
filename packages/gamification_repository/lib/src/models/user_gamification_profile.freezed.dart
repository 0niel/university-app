// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'user_gamification_profile.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$UserGamificationProfile {

 String get userId; int get xp; int get level; int get shurikens; int get streakDays; int get longestStreak;@JsonKey(fromJson: dateTimeFromJson, toJson: dateTimeToJson) DateTime? get lastActiveDate; GamificationBadgeSummary? get recentBadge;
/// Create a copy of UserGamificationProfile
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$UserGamificationProfileCopyWith<UserGamificationProfile> get copyWith => _$UserGamificationProfileCopyWithImpl<UserGamificationProfile>(this as UserGamificationProfile, _$identity);

  /// Serializes this UserGamificationProfile to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is UserGamificationProfile&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.xp, xp) || other.xp == xp)&&(identical(other.level, level) || other.level == level)&&(identical(other.shurikens, shurikens) || other.shurikens == shurikens)&&(identical(other.streakDays, streakDays) || other.streakDays == streakDays)&&(identical(other.longestStreak, longestStreak) || other.longestStreak == longestStreak)&&(identical(other.lastActiveDate, lastActiveDate) || other.lastActiveDate == lastActiveDate)&&(identical(other.recentBadge, recentBadge) || other.recentBadge == recentBadge));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,userId,xp,level,shurikens,streakDays,longestStreak,lastActiveDate,recentBadge);

@override
String toString() {
  return 'UserGamificationProfile(userId: $userId, xp: $xp, level: $level, shurikens: $shurikens, streakDays: $streakDays, longestStreak: $longestStreak, lastActiveDate: $lastActiveDate, recentBadge: $recentBadge)';
}


}

/// @nodoc
abstract mixin class $UserGamificationProfileCopyWith<$Res>  {
  factory $UserGamificationProfileCopyWith(UserGamificationProfile value, $Res Function(UserGamificationProfile) _then) = _$UserGamificationProfileCopyWithImpl;
@useResult
$Res call({
 String userId, int xp, int level, int shurikens, int streakDays, int longestStreak,@JsonKey(fromJson: dateTimeFromJson, toJson: dateTimeToJson) DateTime? lastActiveDate, GamificationBadgeSummary? recentBadge
});


$GamificationBadgeSummaryCopyWith<$Res>? get recentBadge;

}
/// @nodoc
class _$UserGamificationProfileCopyWithImpl<$Res>
    implements $UserGamificationProfileCopyWith<$Res> {
  _$UserGamificationProfileCopyWithImpl(this._self, this._then);

  final UserGamificationProfile _self;
  final $Res Function(UserGamificationProfile) _then;

/// Create a copy of UserGamificationProfile
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? userId = null,Object? xp = null,Object? level = null,Object? shurikens = null,Object? streakDays = null,Object? longestStreak = null,Object? lastActiveDate = freezed,Object? recentBadge = freezed,}) {
  return _then(_self.copyWith(
userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,xp: null == xp ? _self.xp : xp // ignore: cast_nullable_to_non_nullable
as int,level: null == level ? _self.level : level // ignore: cast_nullable_to_non_nullable
as int,shurikens: null == shurikens ? _self.shurikens : shurikens // ignore: cast_nullable_to_non_nullable
as int,streakDays: null == streakDays ? _self.streakDays : streakDays // ignore: cast_nullable_to_non_nullable
as int,longestStreak: null == longestStreak ? _self.longestStreak : longestStreak // ignore: cast_nullable_to_non_nullable
as int,lastActiveDate: freezed == lastActiveDate ? _self.lastActiveDate : lastActiveDate // ignore: cast_nullable_to_non_nullable
as DateTime?,recentBadge: freezed == recentBadge ? _self.recentBadge : recentBadge // ignore: cast_nullable_to_non_nullable
as GamificationBadgeSummary?,
  ));
}
/// Create a copy of UserGamificationProfile
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$GamificationBadgeSummaryCopyWith<$Res>? get recentBadge {
    if (_self.recentBadge == null) {
    return null;
  }

  return $GamificationBadgeSummaryCopyWith<$Res>(_self.recentBadge!, (value) {
    return _then(_self.copyWith(recentBadge: value));
  });
}
}


/// Adds pattern-matching-related methods to [UserGamificationProfile].
extension UserGamificationProfilePatterns on UserGamificationProfile {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _UserGamificationProfile value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _UserGamificationProfile() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _UserGamificationProfile value)  $default,){
final _that = this;
switch (_that) {
case _UserGamificationProfile():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _UserGamificationProfile value)?  $default,){
final _that = this;
switch (_that) {
case _UserGamificationProfile() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String userId,  int xp,  int level,  int shurikens,  int streakDays,  int longestStreak, @JsonKey(fromJson: dateTimeFromJson, toJson: dateTimeToJson)  DateTime? lastActiveDate,  GamificationBadgeSummary? recentBadge)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _UserGamificationProfile() when $default != null:
return $default(_that.userId,_that.xp,_that.level,_that.shurikens,_that.streakDays,_that.longestStreak,_that.lastActiveDate,_that.recentBadge);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String userId,  int xp,  int level,  int shurikens,  int streakDays,  int longestStreak, @JsonKey(fromJson: dateTimeFromJson, toJson: dateTimeToJson)  DateTime? lastActiveDate,  GamificationBadgeSummary? recentBadge)  $default,) {final _that = this;
switch (_that) {
case _UserGamificationProfile():
return $default(_that.userId,_that.xp,_that.level,_that.shurikens,_that.streakDays,_that.longestStreak,_that.lastActiveDate,_that.recentBadge);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String userId,  int xp,  int level,  int shurikens,  int streakDays,  int longestStreak, @JsonKey(fromJson: dateTimeFromJson, toJson: dateTimeToJson)  DateTime? lastActiveDate,  GamificationBadgeSummary? recentBadge)?  $default,) {final _that = this;
switch (_that) {
case _UserGamificationProfile() when $default != null:
return $default(_that.userId,_that.xp,_that.level,_that.shurikens,_that.streakDays,_that.longestStreak,_that.lastActiveDate,_that.recentBadge);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(explicitToJson: true)
class _UserGamificationProfile extends UserGamificationProfile {
  const _UserGamificationProfile({this.userId = '', this.xp = 0, this.level = 1, this.shurikens = 0, this.streakDays = 0, this.longestStreak = 0, @JsonKey(fromJson: dateTimeFromJson, toJson: dateTimeToJson) this.lastActiveDate, this.recentBadge}): super._();
  factory _UserGamificationProfile.fromJson(Map<String, dynamic> json) => _$UserGamificationProfileFromJson(json);

@override@JsonKey() final  String userId;
@override@JsonKey() final  int xp;
@override@JsonKey() final  int level;
@override@JsonKey() final  int shurikens;
@override@JsonKey() final  int streakDays;
@override@JsonKey() final  int longestStreak;
@override@JsonKey(fromJson: dateTimeFromJson, toJson: dateTimeToJson) final  DateTime? lastActiveDate;
@override final  GamificationBadgeSummary? recentBadge;

/// Create a copy of UserGamificationProfile
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$UserGamificationProfileCopyWith<_UserGamificationProfile> get copyWith => __$UserGamificationProfileCopyWithImpl<_UserGamificationProfile>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$UserGamificationProfileToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _UserGamificationProfile&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.xp, xp) || other.xp == xp)&&(identical(other.level, level) || other.level == level)&&(identical(other.shurikens, shurikens) || other.shurikens == shurikens)&&(identical(other.streakDays, streakDays) || other.streakDays == streakDays)&&(identical(other.longestStreak, longestStreak) || other.longestStreak == longestStreak)&&(identical(other.lastActiveDate, lastActiveDate) || other.lastActiveDate == lastActiveDate)&&(identical(other.recentBadge, recentBadge) || other.recentBadge == recentBadge));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,userId,xp,level,shurikens,streakDays,longestStreak,lastActiveDate,recentBadge);

@override
String toString() {
  return 'UserGamificationProfile(userId: $userId, xp: $xp, level: $level, shurikens: $shurikens, streakDays: $streakDays, longestStreak: $longestStreak, lastActiveDate: $lastActiveDate, recentBadge: $recentBadge)';
}


}

/// @nodoc
abstract mixin class _$UserGamificationProfileCopyWith<$Res> implements $UserGamificationProfileCopyWith<$Res> {
  factory _$UserGamificationProfileCopyWith(_UserGamificationProfile value, $Res Function(_UserGamificationProfile) _then) = __$UserGamificationProfileCopyWithImpl;
@override @useResult
$Res call({
 String userId, int xp, int level, int shurikens, int streakDays, int longestStreak,@JsonKey(fromJson: dateTimeFromJson, toJson: dateTimeToJson) DateTime? lastActiveDate, GamificationBadgeSummary? recentBadge
});


@override $GamificationBadgeSummaryCopyWith<$Res>? get recentBadge;

}
/// @nodoc
class __$UserGamificationProfileCopyWithImpl<$Res>
    implements _$UserGamificationProfileCopyWith<$Res> {
  __$UserGamificationProfileCopyWithImpl(this._self, this._then);

  final _UserGamificationProfile _self;
  final $Res Function(_UserGamificationProfile) _then;

/// Create a copy of UserGamificationProfile
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? userId = null,Object? xp = null,Object? level = null,Object? shurikens = null,Object? streakDays = null,Object? longestStreak = null,Object? lastActiveDate = freezed,Object? recentBadge = freezed,}) {
  return _then(_UserGamificationProfile(
userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,xp: null == xp ? _self.xp : xp // ignore: cast_nullable_to_non_nullable
as int,level: null == level ? _self.level : level // ignore: cast_nullable_to_non_nullable
as int,shurikens: null == shurikens ? _self.shurikens : shurikens // ignore: cast_nullable_to_non_nullable
as int,streakDays: null == streakDays ? _self.streakDays : streakDays // ignore: cast_nullable_to_non_nullable
as int,longestStreak: null == longestStreak ? _self.longestStreak : longestStreak // ignore: cast_nullable_to_non_nullable
as int,lastActiveDate: freezed == lastActiveDate ? _self.lastActiveDate : lastActiveDate // ignore: cast_nullable_to_non_nullable
as DateTime?,recentBadge: freezed == recentBadge ? _self.recentBadge : recentBadge // ignore: cast_nullable_to_non_nullable
as GamificationBadgeSummary?,
  ));
}

/// Create a copy of UserGamificationProfile
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$GamificationBadgeSummaryCopyWith<$Res>? get recentBadge {
    if (_self.recentBadge == null) {
    return null;
  }

  return $GamificationBadgeSummaryCopyWith<$Res>(_self.recentBadge!, (value) {
    return _then(_self.copyWith(recentBadge: value));
  });
}
}

// dart format on
