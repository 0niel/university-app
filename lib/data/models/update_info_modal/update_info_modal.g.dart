// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'update_info_modal.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_UpdateInfoModal _$$_UpdateInfoModalFromJson(Map<String, dynamic> json) =>
    _$_UpdateInfoModal(
      title: json['title'] as String,
      description: json['description'] as String,
      changeLog: json['text'] as String,
      serverVersion: json['appVersion'] as String,
    );

Map<String, dynamic> _$$_UpdateInfoModalToJson(_$_UpdateInfoModal instance) =>
    <String, dynamic>{
      'title': instance.title,
      'description': instance.description,
      'text': instance.changeLog,
      'appVersion': instance.serverVersion,
    };
