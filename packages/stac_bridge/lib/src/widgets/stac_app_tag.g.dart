// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'stac_app_tag.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_StacAppTag _$StacAppTagFromJson(Map<String, dynamic> json) => _StacAppTag(
  label: stringOrEmpty(json['label']),
  tone: json['tone'] == null ? 'mute' : _muteWhenNotString(json['tone']),
  withDot: json['withDot'] == null ? false : boolOrFalse(json['withDot']),
);

Map<String, dynamic> _$StacAppTagToJson(_StacAppTag instance) =>
    <String, dynamic>{
      'label': instance.label,
      'tone': instance.tone,
      'withDot': instance.withDot,
    };
