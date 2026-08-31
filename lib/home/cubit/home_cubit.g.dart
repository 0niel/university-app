// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'home_cubit.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_HomeState _$HomeStateFromJson(Map<String, dynamic> json) => _HomeState(
  settings: json['settings'] == null
      ? const AppSettings(onboardingShown: false)
      : AppSettings.fromJson(json['settings'] as Map<String, dynamic>),
  searchCoachShown: json['search_coach_shown'] as bool? ?? false,
);

Map<String, dynamic> _$HomeStateToJson(_HomeState instance) =>
    <String, dynamic>{
      'settings': instance.settings.toJson(),
      'search_coach_shown': instance.searchCoachShown,
    };
