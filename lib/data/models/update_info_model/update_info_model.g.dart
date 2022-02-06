// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'update_info_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_UpdateInfoModel _$$_UpdateInfoModelFromJson(Map<String, dynamic> json) =>
    _$_UpdateInfoModel(
      title: json['title'] as String,
      description: json['description'] as String,
      changeLog: json['text'] as String,
      serverVersion: json['appVersion'] as String,
    );

Map<String, dynamic> _$$_UpdateInfoModelToJson(_$_UpdateInfoModel instance) =>
    <String, dynamic>{
      'title': instance.title,
      'description': instance.description,
      'text': instance.changeLog,
      'appVersion': instance.serverVersion,
    };
