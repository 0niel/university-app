// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'stac_app_icon_button.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_StacAppIconButton _$StacAppIconButtonFromJson(Map<String, dynamic> json) =>
    _StacAppIconButton(
      icon: stringOrEmpty(json['icon']),
      variant: json['variant'] == null
          ? 'ghost'
          : _ghostWhenNotString(json['variant']),
      size: json['size'] == null
          ? 'medium'
          : _mediumWhenNotString(json['size']),
      tooltip: stringOrNull(json['tooltip']),
      actionJson: json['onPressed'],
    );

Map<String, dynamic> _$StacAppIconButtonToJson(_StacAppIconButton instance) =>
    <String, dynamic>{
      'icon': instance.icon,
      'variant': instance.variant,
      'size': instance.size,
      'tooltip': instance.tooltip,
      'onPressed': instance.actionJson,
    };
