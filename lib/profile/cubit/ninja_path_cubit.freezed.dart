// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'ninja_path_cubit.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$NinjaPathState {

 NinjaPathLoadStatus get badgesStatus; NinjaPathLoadStatus get questsStatus; NinjaPathLoadStatus get leaderboardStatus; List<GamificationBadge> get badges; List<GamificationQuest> get quests; List<LeaderboardEntry> get leaderboard; GamificationBadge? get recentlyUnlocked; LeaderboardScope get leaderboardScope;
/// Create a copy of NinjaPathState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$NinjaPathStateCopyWith<NinjaPathState> get copyWith => _$NinjaPathStateCopyWithImpl<NinjaPathState>(this as NinjaPathState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is NinjaPathState&&(identical(other.badgesStatus, badgesStatus) || other.badgesStatus == badgesStatus)&&(identical(other.questsStatus, questsStatus) || other.questsStatus == questsStatus)&&(identical(other.leaderboardStatus, leaderboardStatus) || other.leaderboardStatus == leaderboardStatus)&&const DeepCollectionEquality().equals(other.badges, badges)&&const DeepCollectionEquality().equals(other.quests, quests)&&const DeepCollectionEquality().equals(other.leaderboard, leaderboard)&&(identical(other.recentlyUnlocked, recentlyUnlocked) || other.recentlyUnlocked == recentlyUnlocked)&&(identical(other.leaderboardScope, leaderboardScope) || other.leaderboardScope == leaderboardScope));
}


@override
int get hashCode => Object.hash(runtimeType,badgesStatus,questsStatus,leaderboardStatus,const DeepCollectionEquality().hash(badges),const DeepCollectionEquality().hash(quests),const DeepCollectionEquality().hash(leaderboard),recentlyUnlocked,leaderboardScope);

@override
String toString() {
  return 'NinjaPathState(badgesStatus: $badgesStatus, questsStatus: $questsStatus, leaderboardStatus: $leaderboardStatus, badges: $badges, quests: $quests, leaderboard: $leaderboard, recentlyUnlocked: $recentlyUnlocked, leaderboardScope: $leaderboardScope)';
}


}

/// @nodoc
abstract mixin class $NinjaPathStateCopyWith<$Res>  {
  factory $NinjaPathStateCopyWith(NinjaPathState value, $Res Function(NinjaPathState) _then) = _$NinjaPathStateCopyWithImpl;
@useResult
$Res call({
 NinjaPathLoadStatus badgesStatus, NinjaPathLoadStatus questsStatus, NinjaPathLoadStatus leaderboardStatus, List<GamificationBadge> badges, List<GamificationQuest> quests, List<LeaderboardEntry> leaderboard, GamificationBadge? recentlyUnlocked, LeaderboardScope leaderboardScope
});


$GamificationBadgeCopyWith<$Res>? get recentlyUnlocked;

}
/// @nodoc
class _$NinjaPathStateCopyWithImpl<$Res>
    implements $NinjaPathStateCopyWith<$Res> {
  _$NinjaPathStateCopyWithImpl(this._self, this._then);

  final NinjaPathState _self;
  final $Res Function(NinjaPathState) _then;

/// Create a copy of NinjaPathState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? badgesStatus = null,Object? questsStatus = null,Object? leaderboardStatus = null,Object? badges = null,Object? quests = null,Object? leaderboard = null,Object? recentlyUnlocked = freezed,Object? leaderboardScope = null,}) {
  return _then(_self.copyWith(
badgesStatus: null == badgesStatus ? _self.badgesStatus : badgesStatus // ignore: cast_nullable_to_non_nullable
as NinjaPathLoadStatus,questsStatus: null == questsStatus ? _self.questsStatus : questsStatus // ignore: cast_nullable_to_non_nullable
as NinjaPathLoadStatus,leaderboardStatus: null == leaderboardStatus ? _self.leaderboardStatus : leaderboardStatus // ignore: cast_nullable_to_non_nullable
as NinjaPathLoadStatus,badges: null == badges ? _self.badges : badges // ignore: cast_nullable_to_non_nullable
as List<GamificationBadge>,quests: null == quests ? _self.quests : quests // ignore: cast_nullable_to_non_nullable
as List<GamificationQuest>,leaderboard: null == leaderboard ? _self.leaderboard : leaderboard // ignore: cast_nullable_to_non_nullable
as List<LeaderboardEntry>,recentlyUnlocked: freezed == recentlyUnlocked ? _self.recentlyUnlocked : recentlyUnlocked // ignore: cast_nullable_to_non_nullable
as GamificationBadge?,leaderboardScope: null == leaderboardScope ? _self.leaderboardScope : leaderboardScope // ignore: cast_nullable_to_non_nullable
as LeaderboardScope,
  ));
}
/// Create a copy of NinjaPathState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$GamificationBadgeCopyWith<$Res>? get recentlyUnlocked {
    if (_self.recentlyUnlocked == null) {
    return null;
  }

  return $GamificationBadgeCopyWith<$Res>(_self.recentlyUnlocked!, (value) {
    return _then(_self.copyWith(recentlyUnlocked: value));
  });
}
}


/// Adds pattern-matching-related methods to [NinjaPathState].
extension NinjaPathStatePatterns on NinjaPathState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _NinjaPathState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _NinjaPathState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _NinjaPathState value)  $default,){
final _that = this;
switch (_that) {
case _NinjaPathState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _NinjaPathState value)?  $default,){
final _that = this;
switch (_that) {
case _NinjaPathState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( NinjaPathLoadStatus badgesStatus,  NinjaPathLoadStatus questsStatus,  NinjaPathLoadStatus leaderboardStatus,  List<GamificationBadge> badges,  List<GamificationQuest> quests,  List<LeaderboardEntry> leaderboard,  GamificationBadge? recentlyUnlocked,  LeaderboardScope leaderboardScope)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _NinjaPathState() when $default != null:
return $default(_that.badgesStatus,_that.questsStatus,_that.leaderboardStatus,_that.badges,_that.quests,_that.leaderboard,_that.recentlyUnlocked,_that.leaderboardScope);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( NinjaPathLoadStatus badgesStatus,  NinjaPathLoadStatus questsStatus,  NinjaPathLoadStatus leaderboardStatus,  List<GamificationBadge> badges,  List<GamificationQuest> quests,  List<LeaderboardEntry> leaderboard,  GamificationBadge? recentlyUnlocked,  LeaderboardScope leaderboardScope)  $default,) {final _that = this;
switch (_that) {
case _NinjaPathState():
return $default(_that.badgesStatus,_that.questsStatus,_that.leaderboardStatus,_that.badges,_that.quests,_that.leaderboard,_that.recentlyUnlocked,_that.leaderboardScope);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( NinjaPathLoadStatus badgesStatus,  NinjaPathLoadStatus questsStatus,  NinjaPathLoadStatus leaderboardStatus,  List<GamificationBadge> badges,  List<GamificationQuest> quests,  List<LeaderboardEntry> leaderboard,  GamificationBadge? recentlyUnlocked,  LeaderboardScope leaderboardScope)?  $default,) {final _that = this;
switch (_that) {
case _NinjaPathState() when $default != null:
return $default(_that.badgesStatus,_that.questsStatus,_that.leaderboardStatus,_that.badges,_that.quests,_that.leaderboard,_that.recentlyUnlocked,_that.leaderboardScope);case _:
  return null;

}
}

}

/// @nodoc


class _NinjaPathState implements NinjaPathState {
  const _NinjaPathState({this.badgesStatus = NinjaPathLoadStatus.initial, this.questsStatus = NinjaPathLoadStatus.initial, this.leaderboardStatus = NinjaPathLoadStatus.initial, final  List<GamificationBadge> badges = const <GamificationBadge>[], final  List<GamificationQuest> quests = const <GamificationQuest>[], final  List<LeaderboardEntry> leaderboard = const <LeaderboardEntry>[], this.recentlyUnlocked, this.leaderboardScope = LeaderboardScope.group}): _badges = badges,_quests = quests,_leaderboard = leaderboard;


@override@JsonKey() final  NinjaPathLoadStatus badgesStatus;
@override@JsonKey() final  NinjaPathLoadStatus questsStatus;
@override@JsonKey() final  NinjaPathLoadStatus leaderboardStatus;
 final  List<GamificationBadge> _badges;
@override@JsonKey() List<GamificationBadge> get badges {
  if (_badges is EqualUnmodifiableListView) return _badges;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_badges);
}

 final  List<GamificationQuest> _quests;
@override@JsonKey() List<GamificationQuest> get quests {
  if (_quests is EqualUnmodifiableListView) return _quests;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_quests);
}

 final  List<LeaderboardEntry> _leaderboard;
@override@JsonKey() List<LeaderboardEntry> get leaderboard {
  if (_leaderboard is EqualUnmodifiableListView) return _leaderboard;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_leaderboard);
}

@override final  GamificationBadge? recentlyUnlocked;
@override@JsonKey() final  LeaderboardScope leaderboardScope;

/// Create a copy of NinjaPathState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$NinjaPathStateCopyWith<_NinjaPathState> get copyWith => __$NinjaPathStateCopyWithImpl<_NinjaPathState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _NinjaPathState&&(identical(other.badgesStatus, badgesStatus) || other.badgesStatus == badgesStatus)&&(identical(other.questsStatus, questsStatus) || other.questsStatus == questsStatus)&&(identical(other.leaderboardStatus, leaderboardStatus) || other.leaderboardStatus == leaderboardStatus)&&const DeepCollectionEquality().equals(other._badges, _badges)&&const DeepCollectionEquality().equals(other._quests, _quests)&&const DeepCollectionEquality().equals(other._leaderboard, _leaderboard)&&(identical(other.recentlyUnlocked, recentlyUnlocked) || other.recentlyUnlocked == recentlyUnlocked)&&(identical(other.leaderboardScope, leaderboardScope) || other.leaderboardScope == leaderboardScope));
}


@override
int get hashCode => Object.hash(runtimeType,badgesStatus,questsStatus,leaderboardStatus,const DeepCollectionEquality().hash(_badges),const DeepCollectionEquality().hash(_quests),const DeepCollectionEquality().hash(_leaderboard),recentlyUnlocked,leaderboardScope);

@override
String toString() {
  return 'NinjaPathState(badgesStatus: $badgesStatus, questsStatus: $questsStatus, leaderboardStatus: $leaderboardStatus, badges: $badges, quests: $quests, leaderboard: $leaderboard, recentlyUnlocked: $recentlyUnlocked, leaderboardScope: $leaderboardScope)';
}


}

/// @nodoc
abstract mixin class _$NinjaPathStateCopyWith<$Res> implements $NinjaPathStateCopyWith<$Res> {
  factory _$NinjaPathStateCopyWith(_NinjaPathState value, $Res Function(_NinjaPathState) _then) = __$NinjaPathStateCopyWithImpl;
@override @useResult
$Res call({
 NinjaPathLoadStatus badgesStatus, NinjaPathLoadStatus questsStatus, NinjaPathLoadStatus leaderboardStatus, List<GamificationBadge> badges, List<GamificationQuest> quests, List<LeaderboardEntry> leaderboard, GamificationBadge? recentlyUnlocked, LeaderboardScope leaderboardScope
});


@override $GamificationBadgeCopyWith<$Res>? get recentlyUnlocked;

}
/// @nodoc
class __$NinjaPathStateCopyWithImpl<$Res>
    implements _$NinjaPathStateCopyWith<$Res> {
  __$NinjaPathStateCopyWithImpl(this._self, this._then);

  final _NinjaPathState _self;
  final $Res Function(_NinjaPathState) _then;

/// Create a copy of NinjaPathState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? badgesStatus = null,Object? questsStatus = null,Object? leaderboardStatus = null,Object? badges = null,Object? quests = null,Object? leaderboard = null,Object? recentlyUnlocked = freezed,Object? leaderboardScope = null,}) {
  return _then(_NinjaPathState(
badgesStatus: null == badgesStatus ? _self.badgesStatus : badgesStatus // ignore: cast_nullable_to_non_nullable
as NinjaPathLoadStatus,questsStatus: null == questsStatus ? _self.questsStatus : questsStatus // ignore: cast_nullable_to_non_nullable
as NinjaPathLoadStatus,leaderboardStatus: null == leaderboardStatus ? _self.leaderboardStatus : leaderboardStatus // ignore: cast_nullable_to_non_nullable
as NinjaPathLoadStatus,badges: null == badges ? _self._badges : badges // ignore: cast_nullable_to_non_nullable
as List<GamificationBadge>,quests: null == quests ? _self._quests : quests // ignore: cast_nullable_to_non_nullable
as List<GamificationQuest>,leaderboard: null == leaderboard ? _self._leaderboard : leaderboard // ignore: cast_nullable_to_non_nullable
as List<LeaderboardEntry>,recentlyUnlocked: freezed == recentlyUnlocked ? _self.recentlyUnlocked : recentlyUnlocked // ignore: cast_nullable_to_non_nullable
as GamificationBadge?,leaderboardScope: null == leaderboardScope ? _self.leaderboardScope : leaderboardScope // ignore: cast_nullable_to_non_nullable
as LeaderboardScope,
  ));
}

/// Create a copy of NinjaPathState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$GamificationBadgeCopyWith<$Res>? get recentlyUnlocked {
    if (_self.recentlyUnlocked == null) {
    return null;
  }

  return $GamificationBadgeCopyWith<$Res>(_self.recentlyUnlocked!, (value) {
    return _then(_self.copyWith(recentlyUnlocked: value));
  });
}
}

// dart format on
