// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'stac_app_line_icon.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_StacAppLineIcon _$StacAppLineIconFromJson(Map<String, dynamic> json) =>
    _StacAppLineIcon(
      icon: stringOrEmpty(json['icon']),
      size: json['size'] == null ? 22 : _iconSizeFromJson(json['size']),
      color: stringOrNull(json['color']),
    );

Map<String, dynamic> _$StacAppLineIconToJson(_StacAppLineIcon instance) =>
    <String, dynamic>{
      'icon': instance.icon,
      'size': instance.size,
      'color': instance.color,
    };
