// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'stac_app_progress_ring.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_StacAppProgressRing _$StacAppProgressRingFromJson(Map<String, dynamic> json) =>
    _StacAppProgressRing(
      value: _zeroWhenNotNumber(json['value']),
      size: json['size'] == null ? 56 : _ringSizeFromJson(json['size']),
      strokeWidth: json['strokeWidth'] == null
          ? 5
          : _strokeWidthFromJson(json['strokeWidth']),
      color: stringOrNull(json['color']),
      label: stringOrNull(json['label']),
      sublabel: stringOrNull(json['sublabel']),
    );

Map<String, dynamic> _$StacAppProgressRingToJson(
  _StacAppProgressRing instance,
) => <String, dynamic>{
  'value': instance.value,
  'size': instance.size,
  'strokeWidth': instance.strokeWidth,
  'color': instance.color,
  'label': instance.label,
  'sublabel': instance.sublabel,
};
