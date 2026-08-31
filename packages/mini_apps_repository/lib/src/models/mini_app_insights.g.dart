// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'mini_app_insights.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_MiniAppDailyStat _$MiniAppDailyStatFromJson(Map<String, dynamic> json) =>
    _MiniAppDailyStat(
      day: _dayFromJson(json['day']),
      launches: json['launches'] == null ? 0 : _intFromJson(json['launches']),
      uniqueUsers: json['uniqueUsers'] == null
          ? 0
          : _intFromJson(json['uniqueUsers']),
    );

Map<String, dynamic> _$MiniAppDailyStatToJson(_MiniAppDailyStat instance) =>
    <String, dynamic>{
      'day': _dateToJson(instance.day),
      'launches': instance.launches,
      'uniqueUsers': instance.uniqueUsers,
    };

_MiniAppRevision _$MiniAppRevisionFromJson(Map<String, dynamic> json) =>
    _MiniAppRevision(
      version: json['version'] == null ? 0 : _intFromJson(json['version']),
      createdAt: _localDateFromJson(json['createdAt']),
      screens:
          (json['screens'] as List<dynamic>?)
              ?.map((e) => MiniAppScreen.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const <MiniAppScreen>[],
    );

Map<String, dynamic> _$MiniAppRevisionToJson(_MiniAppRevision instance) =>
    <String, dynamic>{
      'version': instance.version,
      'createdAt': _dateToJson(instance.createdAt),
      'screens': instance.screens,
    };

_MiniAppDeployToken _$MiniAppDeployTokenFromJson(Map<String, dynamic> json) =>
    _MiniAppDeployToken(
      id: json['id'] as String? ?? '',
      name: json['name'] as String? ?? '',
      createdAt: _localDateFromJson(json['createdAt']),
      lastUsedAt: _localDateFromJson(json['lastUsedAt']),
    );

Map<String, dynamic> _$MiniAppDeployTokenToJson(_MiniAppDeployToken instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'createdAt': _dateToJson(instance.createdAt),
      'lastUsedAt': _dateToJson(instance.lastUsedAt),
    };

_MiniAppSigningSecretInfo _$MiniAppSigningSecretInfoFromJson(
  Map<String, dynamic> json,
) => _MiniAppSigningSecretInfo(
  hasSecret: json['hasSecret'] as bool? ?? false,
  fingerprint: json['fingerprint'] as String?,
  createdAt: _localDateFromJson(json['createdAt']),
  rotatedAt: _localDateFromJson(json['rotatedAt']),
  previousActive: json['previousActive'] as bool? ?? false,
  previousExpiresAt: _localDateFromJson(json['previousExpiresAt']),
);

Map<String, dynamic> _$MiniAppSigningSecretInfoToJson(
  _MiniAppSigningSecretInfo instance,
) => <String, dynamic>{
  'hasSecret': instance.hasSecret,
  'fingerprint': instance.fingerprint,
  'createdAt': _dateToJson(instance.createdAt),
  'rotatedAt': _dateToJson(instance.rotatedAt),
  'previousActive': instance.previousActive,
  'previousExpiresAt': _dateToJson(instance.previousExpiresAt),
};

_MiniAppValidation _$MiniAppValidationFromJson(Map<String, dynamic> json) =>
    _MiniAppValidation(
      unknownWidgets: json['unknownWidgets'] == null
          ? const <String>[]
          : _stringsFromJson(json['unknownWidgets']),
      unknownActions: json['unknownActions'] == null
          ? const <String>[]
          : _stringsFromJson(json['unknownActions']),
    );

Map<String, dynamic> _$MiniAppValidationToJson(_MiniAppValidation instance) =>
    <String, dynamic>{
      'unknownWidgets': instance.unknownWidgets,
      'unknownActions': instance.unknownActions,
    };
