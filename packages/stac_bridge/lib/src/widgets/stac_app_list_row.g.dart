// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'stac_app_list_row.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_StacAppListRow _$StacAppListRowFromJson(Map<String, dynamic> json) =>
    _StacAppListRow(
      title: stringOrEmpty(json['title']),
      subtitle: stringOrNull(json['subtitle']),
      emoji: stringOrNull(json['emoji']),
      emojiColor: stringOrNull(json['emojiColor']),
      isFirst: json['isFirst'] == null ? false : boolOrFalse(json['isFirst']),
      dense: json['dense'] == null ? false : boolOrFalse(json['dense']),
      trailing: json['trailing'],
      actionJson: json['onTap'],
    );

Map<String, dynamic> _$StacAppListRowToJson(_StacAppListRow instance) =>
    <String, dynamic>{
      'title': instance.title,
      'subtitle': instance.subtitle,
      'emoji': instance.emoji,
      'emojiColor': instance.emojiColor,
      'isFirst': instance.isFirst,
      'dense': instance.dense,
      'trailing': instance.trailing,
      'onTap': instance.actionJson,
    };
