// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'stac_app_toggle.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_StacAppToggle _$StacAppToggleFromJson(Map<String, dynamic> json) =>
    _StacAppToggle(
      value: json['value'] == null ? false : boolOrFalse(json['value']),
      actionJson: json['onChange'],
    );

Map<String, dynamic> _$StacAppToggleToJson(_StacAppToggle instance) =>
    <String, dynamic>{'value': instance.value, 'onChange': instance.actionJson};
