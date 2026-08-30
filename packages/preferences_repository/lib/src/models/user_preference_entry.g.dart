// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_preference_entry.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_UserPreferenceEntry _$UserPreferenceEntryFromJson(Map<String, dynamic> json) =>
    _UserPreferenceEntry(
      key: json['key'] as String,
      value: json['value'] as Map<String, dynamic>,
      revision: (json['revision'] as num).toInt(),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$UserPreferenceEntryToJson(
  _UserPreferenceEntry instance,
) => <String, dynamic>{
  'key': instance.key,
  'value': instance.value,
  'revision': instance.revision,
  'updatedAt': instance.updatedAt.toIso8601String(),
};
