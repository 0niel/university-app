// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'profile_cubit.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$ProfileState {

 ProfileStatus get status; User get user; UserGamificationProfile get gamificationProfile; ProfileOverview get overview; List<GamificationQuest> get quests; List<LeaderboardEntry> get leaderboard; List<GamificationBadge> get badges; List<ActivityDay> get activityCalendar; UserSettings get settings; Set<ProfileSection> get failedSections; List<GamificationBadge> get newlyEarnedBadges;
/// Create a copy of ProfileState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ProfileStateCopyWith<ProfileState> get copyWith => _$ProfileStateCopyWithImpl<ProfileState>(this as ProfileState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ProfileState&&(identical(other.status, status) || other.status == status)&&(identical(other.user, user) || other.user == user)&&(identical(other.gamificationProfile, gamificationProfile) || other.gamificationProfile == gamificationProfile)&&(identical(other.overview, overview) || other.overview == overview)&&const DeepCollectionEquality().equals(other.quests, quests)&&const DeepCollectionEquality().equals(other.leaderboard, leaderboard)&&const DeepCollectionEquality().equals(other.badges, badges)&&const DeepCollectionEquality().equals(other.activityCalendar, activityCalendar)&&(identical(other.settings, settings) || other.settings == settings)&&const DeepCollectionEquality().equals(other.failedSections, failedSections)&&const DeepCollectionEquality().equals(other.newlyEarnedBadges, newlyEarnedBadges));
}


@override
int get hashCode => Object.hash(runtimeType,status,user,gamificationProfile,overview,const DeepCollectionEquality().hash(quests),const DeepCollectionEquality().hash(leaderboard),const DeepCollectionEquality().hash(badges),const DeepCollectionEquality().hash(activityCalendar),settings,const DeepCollectionEquality().hash(failedSections),const DeepCollectionEquality().hash(newlyEarnedBadges));

@override
String toString() {
  return 'ProfileState(status: $status, user: $user, gamificationProfile: $gamificationProfile, overview: $overview, quests: $quests, leaderboard: $leaderboard, badges: $badges, activityCalendar: $activityCalendar, settings: $settings, failedSections: $failedSections, newlyEarnedBadges: $newlyEarnedBadges)';
}


}

/// @nodoc
abstract mixin class $ProfileStateCopyWith<$Res>  {
  factory $ProfileStateCopyWith(ProfileState value, $Res Function(ProfileState) _then) = _$ProfileStateCopyWithImpl;
@useResult
$Res call({
 ProfileStatus status, User user, UserGamificationProfile gamificationProfile, ProfileOverview overview, List<GamificationQuest> quests, List<LeaderboardEntry> leaderboard, List<GamificationBadge> badges, List<ActivityDay> activityCalendar, UserSettings settings, Set<ProfileSection> failedSections, List<GamificationBadge> newlyEarnedBadges
});


$UserCopyWith<$Res> get user;$UserGamificationProfileCopyWith<$Res> get gamificationProfile;$ProfileOverviewCopyWith<$Res> get overview;$UserSettingsCopyWith<$Res> get settings;

}
/// @nodoc
class _$ProfileStateCopyWithImpl<$Res>
    implements $ProfileStateCopyWith<$Res> {
  _$ProfileStateCopyWithImpl(this._self, this._then);

  final ProfileState _self;
  final $Res Function(ProfileState) _then;

/// Create a copy of ProfileState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? status = null,Object? user = null,Object? gamificationProfile = null,Object? overview = null,Object? quests = null,Object? leaderboard = null,Object? badges = null,Object? activityCalendar = null,Object? settings = null,Object? failedSections = null,Object? newlyEarnedBadges = null,}) {
  return _then(_self.copyWith(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as ProfileStatus,user: null == user ? _self.user : user // ignore: cast_nullable_to_non_nullable
as User,gamificationProfile: null == gamificationProfile ? _self.gamificationProfile : gamificationProfile // ignore: cast_nullable_to_non_nullable
as UserGamificationProfile,overview: null == overview ? _self.overview : overview // ignore: cast_nullable_to_non_nullable
as ProfileOverview,quests: null == quests ? _self.quests : quests // ignore: cast_nullable_to_non_nullable
as List<GamificationQuest>,leaderboard: null == leaderboard ? _self.leaderboard : leaderboard // ignore: cast_nullable_to_non_nullable
as List<LeaderboardEntry>,badges: null == badges ? _self.badges : badges // ignore: cast_nullable_to_non_nullable
as List<GamificationBadge>,activityCalendar: null == activityCalendar ? _self.activityCalendar : activityCalendar // ignore: cast_nullable_to_non_nullable
as List<ActivityDay>,settings: null == settings ? _self.settings : settings // ignore: cast_nullable_to_non_nullable
as UserSettings,failedSections: null == failedSections ? _self.failedSections : failedSections // ignore: cast_nullable_to_non_nullable
as Set<ProfileSection>,newlyEarnedBadges: null == newlyEarnedBadges ? _self.newlyEarnedBadges : newlyEarnedBadges // ignore: cast_nullable_to_non_nullable
as List<GamificationBadge>,
  ));
}
/// Create a copy of ProfileState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$UserCopyWith<$Res> get user {

  return $UserCopyWith<$Res>(_self.user, (value) {
    return _then(_self.copyWith(user: value));
  });
}/// Create a copy of ProfileState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$UserGamificationProfileCopyWith<$Res> get gamificationProfile {

  return $UserGamificationProfileCopyWith<$Res>(_self.gamificationProfile, (value) {
    return _then(_self.copyWith(gamificationProfile: value));
  });
}/// Create a copy of ProfileState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ProfileOverviewCopyWith<$Res> get overview {

  return $ProfileOverviewCopyWith<$Res>(_self.overview, (value) {
    return _then(_self.copyWith(overview: value));
  });
}/// Create a copy of ProfileState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$UserSettingsCopyWith<$Res> get settings {

  return $UserSettingsCopyWith<$Res>(_self.settings, (value) {
    return _then(_self.copyWith(settings: value));
  });
}
}


/// Adds pattern-matching-related methods to [ProfileState].
extension ProfileStatePatterns on ProfileState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ProfileState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ProfileState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ProfileState value)  $default,){
final _that = this;
switch (_that) {
case _ProfileState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ProfileState value)?  $default,){
final _that = this;
switch (_that) {
case _ProfileState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( ProfileStatus status,  User user,  UserGamificationProfile gamificationProfile,  ProfileOverview overview,  List<GamificationQuest> quests,  List<LeaderboardEntry> leaderboard,  List<GamificationBadge> badges,  List<ActivityDay> activityCalendar,  UserSettings settings,  Set<ProfileSection> failedSections,  List<GamificationBadge> newlyEarnedBadges)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ProfileState() when $default != null:
return $default(_that.status,_that.user,_that.gamificationProfile,_that.overview,_that.quests,_that.leaderboard,_that.badges,_that.activityCalendar,_that.settings,_that.failedSections,_that.newlyEarnedBadges);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( ProfileStatus status,  User user,  UserGamificationProfile gamificationProfile,  ProfileOverview overview,  List<GamificationQuest> quests,  List<LeaderboardEntry> leaderboard,  List<GamificationBadge> badges,  List<ActivityDay> activityCalendar,  UserSettings settings,  Set<ProfileSection> failedSections,  List<GamificationBadge> newlyEarnedBadges)  $default,) {final _that = this;
switch (_that) {
case _ProfileState():
return $default(_that.status,_that.user,_that.gamificationProfile,_that.overview,_that.quests,_that.leaderboard,_that.badges,_that.activityCalendar,_that.settings,_that.failedSections,_that.newlyEarnedBadges);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( ProfileStatus status,  User user,  UserGamificationProfile gamificationProfile,  ProfileOverview overview,  List<GamificationQuest> quests,  List<LeaderboardEntry> leaderboard,  List<GamificationBadge> badges,  List<ActivityDay> activityCalendar,  UserSettings settings,  Set<ProfileSection> failedSections,  List<GamificationBadge> newlyEarnedBadges)?  $default,) {final _that = this;
switch (_that) {
case _ProfileState() when $default != null:
return $default(_that.status,_that.user,_that.gamificationProfile,_that.overview,_that.quests,_that.leaderboard,_that.badges,_that.activityCalendar,_that.settings,_that.failedSections,_that.newlyEarnedBadges);case _:
  return null;

}
}

}

/// @nodoc


class _ProfileState extends ProfileState {
  const _ProfileState({this.status = ProfileStatus.initial, this.user = User.anonymous, this.gamificationProfile = UserGamificationProfile.empty, this.overview = ProfileOverview.empty, final  List<GamificationQuest> quests = const <GamificationQuest>[], final  List<LeaderboardEntry> leaderboard = const <LeaderboardEntry>[], final  List<GamificationBadge> badges = const <GamificationBadge>[], final  List<ActivityDay> activityCalendar = const <ActivityDay>[], this.settings = const UserSettings(), final  Set<ProfileSection> failedSections = const <ProfileSection>{}, final  List<GamificationBadge> newlyEarnedBadges = const <GamificationBadge>[]}): _quests = quests,_leaderboard = leaderboard,_badges = badges,_activityCalendar = activityCalendar,_failedSections = failedSections,_newlyEarnedBadges = newlyEarnedBadges,super._();


@override@JsonKey() final  ProfileStatus status;
@override@JsonKey() final  User user;
@override@JsonKey() final  UserGamificationProfile gamificationProfile;
@override@JsonKey() final  ProfileOverview overview;
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

 final  List<GamificationBadge> _badges;
@override@JsonKey() List<GamificationBadge> get badges {
  if (_badges is EqualUnmodifiableListView) return _badges;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_badges);
}

 final  List<ActivityDay> _activityCalendar;
@override@JsonKey() List<ActivityDay> get activityCalendar {
  if (_activityCalendar is EqualUnmodifiableListView) return _activityCalendar;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_activityCalendar);
}

@override@JsonKey() final  UserSettings settings;
 final  Set<ProfileSection> _failedSections;
@override@JsonKey() Set<ProfileSection> get failedSections {
  if (_failedSections is EqualUnmodifiableSetView) return _failedSections;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableSetView(_failedSections);
}

 final  List<GamificationBadge> _newlyEarnedBadges;
@override@JsonKey() List<GamificationBadge> get newlyEarnedBadges {
  if (_newlyEarnedBadges is EqualUnmodifiableListView) return _newlyEarnedBadges;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_newlyEarnedBadges);
}


/// Create a copy of ProfileState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ProfileStateCopyWith<_ProfileState> get copyWith => __$ProfileStateCopyWithImpl<_ProfileState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ProfileState&&(identical(other.status, status) || other.status == status)&&(identical(other.user, user) || other.user == user)&&(identical(other.gamificationProfile, gamificationProfile) || other.gamificationProfile == gamificationProfile)&&(identical(other.overview, overview) || other.overview == overview)&&const DeepCollectionEquality().equals(other._quests, _quests)&&const DeepCollectionEquality().equals(other._leaderboard, _leaderboard)&&const DeepCollectionEquality().equals(other._badges, _badges)&&const DeepCollectionEquality().equals(other._activityCalendar, _activityCalendar)&&(identical(other.settings, settings) || other.settings == settings)&&const DeepCollectionEquality().equals(other._failedSections, _failedSections)&&const DeepCollectionEquality().equals(other._newlyEarnedBadges, _newlyEarnedBadges));
}


@override
int get hashCode => Object.hash(runtimeType,status,user,gamificationProfile,overview,const DeepCollectionEquality().hash(_quests),const DeepCollectionEquality().hash(_leaderboard),const DeepCollectionEquality().hash(_badges),const DeepCollectionEquality().hash(_activityCalendar),settings,const DeepCollectionEquality().hash(_failedSections),const DeepCollectionEquality().hash(_newlyEarnedBadges));

@override
String toString() {
  return 'ProfileState(status: $status, user: $user, gamificationProfile: $gamificationProfile, overview: $overview, quests: $quests, leaderboard: $leaderboard, badges: $badges, activityCalendar: $activityCalendar, settings: $settings, failedSections: $failedSections, newlyEarnedBadges: $newlyEarnedBadges)';
}


}

/// @nodoc
abstract mixin class _$ProfileStateCopyWith<$Res> implements $ProfileStateCopyWith<$Res> {
  factory _$ProfileStateCopyWith(_ProfileState value, $Res Function(_ProfileState) _then) = __$ProfileStateCopyWithImpl;
@override @useResult
$Res call({
 ProfileStatus status, User user, UserGamificationProfile gamificationProfile, ProfileOverview overview, List<GamificationQuest> quests, List<LeaderboardEntry> leaderboard, List<GamificationBadge> badges, List<ActivityDay> activityCalendar, UserSettings settings, Set<ProfileSection> failedSections, List<GamificationBadge> newlyEarnedBadges
});


@override $UserCopyWith<$Res> get user;@override $UserGamificationProfileCopyWith<$Res> get gamificationProfile;@override $ProfileOverviewCopyWith<$Res> get overview;@override $UserSettingsCopyWith<$Res> get settings;

}
/// @nodoc
class __$ProfileStateCopyWithImpl<$Res>
    implements _$ProfileStateCopyWith<$Res> {
  __$ProfileStateCopyWithImpl(this._self, this._then);

  final _ProfileState _self;
  final $Res Function(_ProfileState) _then;

/// Create a copy of ProfileState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? status = null,Object? user = null,Object? gamificationProfile = null,Object? overview = null,Object? quests = null,Object? leaderboard = null,Object? badges = null,Object? activityCalendar = null,Object? settings = null,Object? failedSections = null,Object? newlyEarnedBadges = null,}) {
  return _then(_ProfileState(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as ProfileStatus,user: null == user ? _self.user : user // ignore: cast_nullable_to_non_nullable
as User,gamificationProfile: null == gamificationProfile ? _self.gamificationProfile : gamificationProfile // ignore: cast_nullable_to_non_nullable
as UserGamificationProfile,overview: null == overview ? _self.overview : overview // ignore: cast_nullable_to_non_nullable
as ProfileOverview,quests: null == quests ? _self._quests : quests // ignore: cast_nullable_to_non_nullable
as List<GamificationQuest>,leaderboard: null == leaderboard ? _self._leaderboard : leaderboard // ignore: cast_nullable_to_non_nullable
as List<LeaderboardEntry>,badges: null == badges ? _self._badges : badges // ignore: cast_nullable_to_non_nullable
as List<GamificationBadge>,activityCalendar: null == activityCalendar ? _self._activityCalendar : activityCalendar // ignore: cast_nullable_to_non_nullable
as List<ActivityDay>,settings: null == settings ? _self.settings : settings // ignore: cast_nullable_to_non_nullable
as UserSettings,failedSections: null == failedSections ? _self._failedSections : failedSections // ignore: cast_nullable_to_non_nullable
as Set<ProfileSection>,newlyEarnedBadges: null == newlyEarnedBadges ? _self._newlyEarnedBadges : newlyEarnedBadges // ignore: cast_nullable_to_non_nullable
as List<GamificationBadge>,
  ));
}

/// Create a copy of ProfileState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$UserCopyWith<$Res> get user {

  return $UserCopyWith<$Res>(_self.user, (value) {
    return _then(_self.copyWith(user: value));
  });
}/// Create a copy of ProfileState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$UserGamificationProfileCopyWith<$Res> get gamificationProfile {

  return $UserGamificationProfileCopyWith<$Res>(_self.gamificationProfile, (value) {
    return _then(_self.copyWith(gamificationProfile: value));
  });
}/// Create a copy of ProfileState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ProfileOverviewCopyWith<$Res> get overview {

  return $ProfileOverviewCopyWith<$Res>(_self.overview, (value) {
    return _then(_self.copyWith(overview: value));
  });
}/// Create a copy of ProfileState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$UserSettingsCopyWith<$Res> get settings {

  return $UserSettingsCopyWith<$Res>(_self.settings, (value) {
    return _then(_self.copyWith(settings: value));
  });
}
}

// dart format on
