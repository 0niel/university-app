// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'stac_app_service_tile.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_StacAppServiceTile _$StacAppServiceTileFromJson(Map<String, dynamic> json) =>
    _StacAppServiceTile(
      emoji: stringOrEmpty(json['emoji']),
      label: json['label'] as String?,
      color: json['color'] as String?,
      solid: json['solid'] == null ? false : boolOrFalse(json['solid']),
      actionJson: json['onTap'],
    );

Map<String, dynamic> _$StacAppServiceTileToJson(_StacAppServiceTile instance) =>
    <String, dynamic>{
      'emoji': instance.emoji,
      'label': instance.label,
      'color': instance.color,
      'solid': instance.solid,
      'onTap': instance.actionJson,
    };
