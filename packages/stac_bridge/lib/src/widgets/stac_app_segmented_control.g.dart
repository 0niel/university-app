// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'stac_app_segmented_control.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_StacAppSegmentedControl _$StacAppSegmentedControlFromJson(
  Map<String, dynamic> json,
) => _StacAppSegmentedControl(
  options: mapListOrEmpty(json['options']),
  selectedIndex: json['selectedIndex'] == null
      ? 0
      : intOrZero(json['selectedIndex']),
);

Map<String, dynamic> _$StacAppSegmentedControlToJson(
  _StacAppSegmentedControl instance,
) => <String, dynamic>{
  'options': instance.options,
  'selectedIndex': instance.selectedIndex,
};
