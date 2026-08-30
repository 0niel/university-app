// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'stac_app_empty_state.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_StacAppEmptyState _$StacAppEmptyStateFromJson(Map<String, dynamic> json) =>
    _StacAppEmptyState(
      emoji: _sparklesWhenNotString(json['emoji']),
      title: stringOrEmpty(json['title']),
      subtitle: json['subtitle'] as String?,
      child: json['child'],
    );

Map<String, dynamic> _$StacAppEmptyStateToJson(_StacAppEmptyState instance) =>
    <String, dynamic>{
      'emoji': instance.emoji,
      'title': instance.title,
      'subtitle': instance.subtitle,
      'child': instance.child,
    };
