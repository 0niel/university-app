// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'theme_state.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ThemeState _$ThemeStateFromJson(Map<String, dynamic> json) => _ThemeState(
  colorScheme:
      $enumDecodeNullable(_$AppColorSchemeEnumMap, json['colorScheme']) ??
      AppColorScheme.blue,
  isAmoled: json['isAmoled'] as bool? ?? false,
);

Map<String, dynamic> _$ThemeStateToJson(_ThemeState instance) =>
    <String, dynamic>{
      'colorScheme': _$AppColorSchemeEnumMap[instance.colorScheme]!,
      'isAmoled': instance.isAmoled,
    };

const _$AppColorSchemeEnumMap = {
  AppColorScheme.blue: 'blue',
  AppColorScheme.violet: 'violet',
  AppColorScheme.yellow: 'yellow',
  AppColorScheme.red: 'red',
  AppColorScheme.green: 'green',
};
