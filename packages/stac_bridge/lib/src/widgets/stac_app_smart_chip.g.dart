// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'stac_app_smart_chip.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_StacAppSmartChip _$StacAppSmartChipFromJson(Map<String, dynamic> json) =>
    _StacAppSmartChip(
      emoji: stringOrEmpty(json['emoji']),
      label: stringOrEmpty(json['label']),
      value: stringOrEmpty(json['value']),
      tone: json['tone'] as String?,
    );

Map<String, dynamic> _$StacAppSmartChipToJson(_StacAppSmartChip instance) =>
    <String, dynamic>{
      'emoji': instance.emoji,
      'label': instance.label,
      'value': instance.value,
      'tone': instance.tone,
    };
