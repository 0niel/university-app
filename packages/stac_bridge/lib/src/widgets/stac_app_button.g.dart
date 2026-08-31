// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'stac_app_button.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_StacAppButton _$StacAppButtonFromJson(Map<String, dynamic> json) =>
    _StacAppButton(
      label: _emptyWhenNotString(json['label']),
      variant: json['variant'] == null
          ? 'primary'
          : _primaryWhenNotString(json['variant']),
      size: json['size'] == null
          ? 'medium'
          : _mediumWhenNotString(json['size']),
      expanded: json['expanded'] == null
          ? false
          : _falseWhenNotBool(json['expanded']),
      actionJson: json['onPressed'],
    );

Map<String, dynamic> _$StacAppButtonToJson(_StacAppButton instance) =>
    <String, dynamic>{
      'label': instance.label,
      'variant': instance.variant,
      'size': instance.size,
      'expanded': instance.expanded,
      'onPressed': instance.actionJson,
    };
