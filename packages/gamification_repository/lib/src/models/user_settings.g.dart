// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_settings.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_UserSettings _$UserSettingsFromJson(
  Map<String, dynamic> json,
) => $checkedCreate('_UserSettings', json, ($checkedConvert) {
  final val = _UserSettings(
    notificationsEnabled: $checkedConvert(
      'notificationsEnabled',
      (v) => v as bool? ?? true,
    ),
    scheduleChangeAlerts: $checkedConvert(
      'scheduleChangeAlerts',
      (v) => v as bool? ?? true,
    ),
    questReminders: $checkedConvert(
      'questReminders',
      (v) => v as bool? ?? true,
    ),
    achievementAlerts: $checkedConvert(
      'achievementAlerts',
      (v) => v as bool? ?? true,
    ),
    leaderboardUpdates: $checkedConvert(
      'leaderboardUpdates',
      (v) => v as bool? ?? false,
    ),
    themeMode: $checkedConvert('themeMode', (v) => v as String? ?? 'system'),
    accentColor: $checkedConvert('accentColor', (v) => v as String? ?? 'blue'),
    density: $checkedConvert('density', (v) => v as String? ?? 'default'),
    showMascot: $checkedConvert('showMascot', (v) => v as bool? ?? true),
    profileVisibility: $checkedConvert(
      'profileVisibility',
      (v) =>
          $enumDecodeNullable(
            _$ProfileVisibilityEnumMap,
            v,
            unknownValue: ProfileVisibility.everyone,
          ) ??
          ProfileVisibility.everyone,
    ),
    anonymousReactions: $checkedConvert(
      'anonymousReactions',
      (v) => v as bool? ?? true,
    ),
  );
  return val;
});

Map<String, dynamic> _$UserSettingsToJson(
  _UserSettings instance,
) => <String, dynamic>{
  'notificationsEnabled': instance.notificationsEnabled,
  'scheduleChangeAlerts': instance.scheduleChangeAlerts,
  'questReminders': instance.questReminders,
  'achievementAlerts': instance.achievementAlerts,
  'leaderboardUpdates': instance.leaderboardUpdates,
  'themeMode': instance.themeMode,
  'accentColor': instance.accentColor,
  'density': instance.density,
  'showMascot': instance.showMascot,
  'profileVisibility': _$ProfileVisibilityEnumMap[instance.profileVisibility]!,
  'anonymousReactions': instance.anonymousReactions,
};

const _$ProfileVisibilityEnumMap = {
  ProfileVisibility.everyone: 'everyone',
  ProfileVisibility.group: 'group',
  ProfileVisibility.nobody: 'nobody',
};
