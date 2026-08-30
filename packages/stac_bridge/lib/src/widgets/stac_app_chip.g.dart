// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'stac_app_chip.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_StacAppChip _$StacAppChipFromJson(Map<String, dynamic> json) => _StacAppChip(
  label: _emptyWhenNotString(json['label']),
  selected: json['selected'] == null
      ? false
      : _falseWhenNotBool(json['selected']),
  small: json['small'] == null ? false : _falseWhenNotBool(json['small']),
  color: json['color'] as String?,
  actionJson: json['onTap'],
);

Map<String, dynamic> _$StacAppChipToJson(_StacAppChip instance) =>
    <String, dynamic>{
      'label': instance.label,
      'selected': instance.selected,
      'small': instance.small,
      'color': instance.color,
      'onTap': instance.actionJson,
    };
