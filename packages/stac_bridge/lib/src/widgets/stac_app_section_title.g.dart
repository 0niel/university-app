// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'stac_app_section_title.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_StacAppSectionTitle _$StacAppSectionTitleFromJson(Map<String, dynamic> json) =>
    _StacAppSectionTitle(
      title: json['title'] as String,
      subtitle: json['subtitle'] as String?,
      action: json['action'] as String?,
      actionJson: json['onActionTap'],
    );

Map<String, dynamic> _$StacAppSectionTitleToJson(
  _StacAppSectionTitle instance,
) => <String, dynamic>{
  'title': instance.title,
  'subtitle': instance.subtitle,
  'action': instance.action,
  'onActionTap': instance.actionJson,
};
