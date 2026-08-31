// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_settings.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_AppSettings _$AppSettingsFromJson(Map<String, dynamic> json) => _AppSettings(
  onboardingShown: json['onboarding_shown'] as bool,
  theme: json['theme'] as String? ?? 'system',
);

Map<String, dynamic> _$AppSettingsToJson(_AppSettings instance) =>
    <String, dynamic>{
      'onboarding_shown': instance.onboardingShown,
      'theme': instance.theme,
    };
