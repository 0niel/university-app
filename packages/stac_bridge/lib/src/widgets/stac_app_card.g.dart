// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'stac_app_card.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_StacAppCard _$StacAppCardFromJson(Map<String, dynamic> json) => _StacAppCard(
  padding: json['padding'] == null ? 16 : _paddingFromJson(json['padding']),
  color: json['color'] as String?,
  actionJson: json['onTap'],
  child: json['child'],
);

Map<String, dynamic> _$StacAppCardToJson(_StacAppCard instance) =>
    <String, dynamic>{
      'padding': instance.padding,
      'color': instance.color,
      'onTap': instance.actionJson,
      'child': instance.child,
    };
