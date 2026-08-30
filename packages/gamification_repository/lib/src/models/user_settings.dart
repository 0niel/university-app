import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_settings.freezed.dart';
part 'user_settings.g.dart';

@freezed
abstract class UserSettings with _$UserSettings {
  const factory UserSettings({
    @Default(true) bool notificationsEnabled,
    @Default(true) bool scheduleChangeAlerts,
    @Default(true) bool questReminders,
    @Default(true) bool achievementAlerts,
    @Default(false) bool leaderboardUpdates,
    @Default('system') String themeMode,
    @Default('blue') String accentColor,
    @Default('default') String density,
    @Default(true) bool showMascot,
    @JsonKey(unknownEnumValue: ProfileVisibility.everyone)
    @Default(ProfileVisibility.everyone)
    ProfileVisibility profileVisibility,
    @Default(true) bool anonymousReactions,
  }) = _UserSettings;

  factory UserSettings.fromJson(Map<String, Object?> json) =>
      _$UserSettingsFromJson(json);
}

enum ProfileVisibility {
  everyone,
  group,
  nobody;

  static ProfileVisibility fromName(String? name) =>
      values.firstWhereOrNull((value) => value.name == name) ?? everyone;
}

extension<T> on Iterable<T> {
  T? firstWhereOrNull(bool Function(T value) test) {
    for (final value in this) {
      if (test(value)) return value;
    }
    return null;
  }
}
