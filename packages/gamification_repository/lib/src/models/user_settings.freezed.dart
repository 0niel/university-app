// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'user_settings.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$UserSettings {

 bool get notificationsEnabled; bool get scheduleChangeAlerts; bool get questReminders; bool get achievementAlerts; bool get leaderboardUpdates; String get themeMode; String get accentColor; String get density; bool get showMascot;@JsonKey(unknownEnumValue: ProfileVisibility.everyone) ProfileVisibility get profileVisibility; bool get anonymousReactions;
/// Create a copy of UserSettings
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$UserSettingsCopyWith<UserSettings> get copyWith => _$UserSettingsCopyWithImpl<UserSettings>(this as UserSettings, _$identity);

  /// Serializes this UserSettings to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is UserSettings&&(identical(other.notificationsEnabled, notificationsEnabled) || other.notificationsEnabled == notificationsEnabled)&&(identical(other.scheduleChangeAlerts, scheduleChangeAlerts) || other.scheduleChangeAlerts == scheduleChangeAlerts)&&(identical(other.questReminders, questReminders) || other.questReminders == questReminders)&&(identical(other.achievementAlerts, achievementAlerts) || other.achievementAlerts == achievementAlerts)&&(identical(other.leaderboardUpdates, leaderboardUpdates) || other.leaderboardUpdates == leaderboardUpdates)&&(identical(other.themeMode, themeMode) || other.themeMode == themeMode)&&(identical(other.accentColor, accentColor) || other.accentColor == accentColor)&&(identical(other.density, density) || other.density == density)&&(identical(other.showMascot, showMascot) || other.showMascot == showMascot)&&(identical(other.profileVisibility, profileVisibility) || other.profileVisibility == profileVisibility)&&(identical(other.anonymousReactions, anonymousReactions) || other.anonymousReactions == anonymousReactions));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,notificationsEnabled,scheduleChangeAlerts,questReminders,achievementAlerts,leaderboardUpdates,themeMode,accentColor,density,showMascot,profileVisibility,anonymousReactions);

@override
String toString() {
  return 'UserSettings(notificationsEnabled: $notificationsEnabled, scheduleChangeAlerts: $scheduleChangeAlerts, questReminders: $questReminders, achievementAlerts: $achievementAlerts, leaderboardUpdates: $leaderboardUpdates, themeMode: $themeMode, accentColor: $accentColor, density: $density, showMascot: $showMascot, profileVisibility: $profileVisibility, anonymousReactions: $anonymousReactions)';
}


}

/// @nodoc
abstract mixin class $UserSettingsCopyWith<$Res>  {
  factory $UserSettingsCopyWith(UserSettings value, $Res Function(UserSettings) _then) = _$UserSettingsCopyWithImpl;
@useResult
$Res call({
 bool notificationsEnabled, bool scheduleChangeAlerts, bool questReminders, bool achievementAlerts, bool leaderboardUpdates, String themeMode, String accentColor, String density, bool showMascot,@JsonKey(unknownEnumValue: ProfileVisibility.everyone) ProfileVisibility profileVisibility, bool anonymousReactions
});




}
/// @nodoc
class _$UserSettingsCopyWithImpl<$Res>
    implements $UserSettingsCopyWith<$Res> {
  _$UserSettingsCopyWithImpl(this._self, this._then);

  final UserSettings _self;
  final $Res Function(UserSettings) _then;

/// Create a copy of UserSettings
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? notificationsEnabled = null,Object? scheduleChangeAlerts = null,Object? questReminders = null,Object? achievementAlerts = null,Object? leaderboardUpdates = null,Object? themeMode = null,Object? accentColor = null,Object? density = null,Object? showMascot = null,Object? profileVisibility = null,Object? anonymousReactions = null,}) {
  return _then(_self.copyWith(
notificationsEnabled: null == notificationsEnabled ? _self.notificationsEnabled : notificationsEnabled // ignore: cast_nullable_to_non_nullable
as bool,scheduleChangeAlerts: null == scheduleChangeAlerts ? _self.scheduleChangeAlerts : scheduleChangeAlerts // ignore: cast_nullable_to_non_nullable
as bool,questReminders: null == questReminders ? _self.questReminders : questReminders // ignore: cast_nullable_to_non_nullable
as bool,achievementAlerts: null == achievementAlerts ? _self.achievementAlerts : achievementAlerts // ignore: cast_nullable_to_non_nullable
as bool,leaderboardUpdates: null == leaderboardUpdates ? _self.leaderboardUpdates : leaderboardUpdates // ignore: cast_nullable_to_non_nullable
as bool,themeMode: null == themeMode ? _self.themeMode : themeMode // ignore: cast_nullable_to_non_nullable
as String,accentColor: null == accentColor ? _self.accentColor : accentColor // ignore: cast_nullable_to_non_nullable
as String,density: null == density ? _self.density : density // ignore: cast_nullable_to_non_nullable
as String,showMascot: null == showMascot ? _self.showMascot : showMascot // ignore: cast_nullable_to_non_nullable
as bool,profileVisibility: null == profileVisibility ? _self.profileVisibility : profileVisibility // ignore: cast_nullable_to_non_nullable
as ProfileVisibility,anonymousReactions: null == anonymousReactions ? _self.anonymousReactions : anonymousReactions // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [UserSettings].
extension UserSettingsPatterns on UserSettings {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _UserSettings value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _UserSettings() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _UserSettings value)  $default,){
final _that = this;
switch (_that) {
case _UserSettings():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _UserSettings value)?  $default,){
final _that = this;
switch (_that) {
case _UserSettings() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( bool notificationsEnabled,  bool scheduleChangeAlerts,  bool questReminders,  bool achievementAlerts,  bool leaderboardUpdates,  String themeMode,  String accentColor,  String density,  bool showMascot, @JsonKey(unknownEnumValue: ProfileVisibility.everyone)  ProfileVisibility profileVisibility,  bool anonymousReactions)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _UserSettings() when $default != null:
return $default(_that.notificationsEnabled,_that.scheduleChangeAlerts,_that.questReminders,_that.achievementAlerts,_that.leaderboardUpdates,_that.themeMode,_that.accentColor,_that.density,_that.showMascot,_that.profileVisibility,_that.anonymousReactions);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( bool notificationsEnabled,  bool scheduleChangeAlerts,  bool questReminders,  bool achievementAlerts,  bool leaderboardUpdates,  String themeMode,  String accentColor,  String density,  bool showMascot, @JsonKey(unknownEnumValue: ProfileVisibility.everyone)  ProfileVisibility profileVisibility,  bool anonymousReactions)  $default,) {final _that = this;
switch (_that) {
case _UserSettings():
return $default(_that.notificationsEnabled,_that.scheduleChangeAlerts,_that.questReminders,_that.achievementAlerts,_that.leaderboardUpdates,_that.themeMode,_that.accentColor,_that.density,_that.showMascot,_that.profileVisibility,_that.anonymousReactions);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( bool notificationsEnabled,  bool scheduleChangeAlerts,  bool questReminders,  bool achievementAlerts,  bool leaderboardUpdates,  String themeMode,  String accentColor,  String density,  bool showMascot, @JsonKey(unknownEnumValue: ProfileVisibility.everyone)  ProfileVisibility profileVisibility,  bool anonymousReactions)?  $default,) {final _that = this;
switch (_that) {
case _UserSettings() when $default != null:
return $default(_that.notificationsEnabled,_that.scheduleChangeAlerts,_that.questReminders,_that.achievementAlerts,_that.leaderboardUpdates,_that.themeMode,_that.accentColor,_that.density,_that.showMascot,_that.profileVisibility,_that.anonymousReactions);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _UserSettings implements UserSettings {
  const _UserSettings({this.notificationsEnabled = true, this.scheduleChangeAlerts = true, this.questReminders = true, this.achievementAlerts = true, this.leaderboardUpdates = false, this.themeMode = 'system', this.accentColor = 'blue', this.density = 'default', this.showMascot = true, @JsonKey(unknownEnumValue: ProfileVisibility.everyone) this.profileVisibility = ProfileVisibility.everyone, this.anonymousReactions = true});
  factory _UserSettings.fromJson(Map<String, dynamic> json) => _$UserSettingsFromJson(json);

@override@JsonKey() final  bool notificationsEnabled;
@override@JsonKey() final  bool scheduleChangeAlerts;
@override@JsonKey() final  bool questReminders;
@override@JsonKey() final  bool achievementAlerts;
@override@JsonKey() final  bool leaderboardUpdates;
@override@JsonKey() final  String themeMode;
@override@JsonKey() final  String accentColor;
@override@JsonKey() final  String density;
@override@JsonKey() final  bool showMascot;
@override@JsonKey(unknownEnumValue: ProfileVisibility.everyone) final  ProfileVisibility profileVisibility;
@override@JsonKey() final  bool anonymousReactions;

/// Create a copy of UserSettings
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$UserSettingsCopyWith<_UserSettings> get copyWith => __$UserSettingsCopyWithImpl<_UserSettings>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$UserSettingsToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _UserSettings&&(identical(other.notificationsEnabled, notificationsEnabled) || other.notificationsEnabled == notificationsEnabled)&&(identical(other.scheduleChangeAlerts, scheduleChangeAlerts) || other.scheduleChangeAlerts == scheduleChangeAlerts)&&(identical(other.questReminders, questReminders) || other.questReminders == questReminders)&&(identical(other.achievementAlerts, achievementAlerts) || other.achievementAlerts == achievementAlerts)&&(identical(other.leaderboardUpdates, leaderboardUpdates) || other.leaderboardUpdates == leaderboardUpdates)&&(identical(other.themeMode, themeMode) || other.themeMode == themeMode)&&(identical(other.accentColor, accentColor) || other.accentColor == accentColor)&&(identical(other.density, density) || other.density == density)&&(identical(other.showMascot, showMascot) || other.showMascot == showMascot)&&(identical(other.profileVisibility, profileVisibility) || other.profileVisibility == profileVisibility)&&(identical(other.anonymousReactions, anonymousReactions) || other.anonymousReactions == anonymousReactions));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,notificationsEnabled,scheduleChangeAlerts,questReminders,achievementAlerts,leaderboardUpdates,themeMode,accentColor,density,showMascot,profileVisibility,anonymousReactions);

@override
String toString() {
  return 'UserSettings(notificationsEnabled: $notificationsEnabled, scheduleChangeAlerts: $scheduleChangeAlerts, questReminders: $questReminders, achievementAlerts: $achievementAlerts, leaderboardUpdates: $leaderboardUpdates, themeMode: $themeMode, accentColor: $accentColor, density: $density, showMascot: $showMascot, profileVisibility: $profileVisibility, anonymousReactions: $anonymousReactions)';
}


}

/// @nodoc
abstract mixin class _$UserSettingsCopyWith<$Res> implements $UserSettingsCopyWith<$Res> {
  factory _$UserSettingsCopyWith(_UserSettings value, $Res Function(_UserSettings) _then) = __$UserSettingsCopyWithImpl;
@override @useResult
$Res call({
 bool notificationsEnabled, bool scheduleChangeAlerts, bool questReminders, bool achievementAlerts, bool leaderboardUpdates, String themeMode, String accentColor, String density, bool showMascot,@JsonKey(unknownEnumValue: ProfileVisibility.everyone) ProfileVisibility profileVisibility, bool anonymousReactions
});




}
/// @nodoc
class __$UserSettingsCopyWithImpl<$Res>
    implements _$UserSettingsCopyWith<$Res> {
  __$UserSettingsCopyWithImpl(this._self, this._then);

  final _UserSettings _self;
  final $Res Function(_UserSettings) _then;

/// Create a copy of UserSettings
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? notificationsEnabled = null,Object? scheduleChangeAlerts = null,Object? questReminders = null,Object? achievementAlerts = null,Object? leaderboardUpdates = null,Object? themeMode = null,Object? accentColor = null,Object? density = null,Object? showMascot = null,Object? profileVisibility = null,Object? anonymousReactions = null,}) {
  return _then(_UserSettings(
notificationsEnabled: null == notificationsEnabled ? _self.notificationsEnabled : notificationsEnabled // ignore: cast_nullable_to_non_nullable
as bool,scheduleChangeAlerts: null == scheduleChangeAlerts ? _self.scheduleChangeAlerts : scheduleChangeAlerts // ignore: cast_nullable_to_non_nullable
as bool,questReminders: null == questReminders ? _self.questReminders : questReminders // ignore: cast_nullable_to_non_nullable
as bool,achievementAlerts: null == achievementAlerts ? _self.achievementAlerts : achievementAlerts // ignore: cast_nullable_to_non_nullable
as bool,leaderboardUpdates: null == leaderboardUpdates ? _self.leaderboardUpdates : leaderboardUpdates // ignore: cast_nullable_to_non_nullable
as bool,themeMode: null == themeMode ? _self.themeMode : themeMode // ignore: cast_nullable_to_non_nullable
as String,accentColor: null == accentColor ? _self.accentColor : accentColor // ignore: cast_nullable_to_non_nullable
as String,density: null == density ? _self.density : density // ignore: cast_nullable_to_non_nullable
as String,showMascot: null == showMascot ? _self.showMascot : showMascot // ignore: cast_nullable_to_non_nullable
as bool,profileVisibility: null == profileVisibility ? _self.profileVisibility : profileVisibility // ignore: cast_nullable_to_non_nullable
as ProfileVisibility,anonymousReactions: null == anonymousReactions ? _self.anonymousReactions : anonymousReactions // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
