// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'stac_app_avatar.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_StacAppAvatar _$StacAppAvatarFromJson(Map<String, dynamic> json) =>
    _StacAppAvatar(
      name: stringOrEmpty(json['name']),
      size: json['size'] == null ? 36 : _avatarSizeFromJson(json['size']),
      color: stringOrNull(json['color']),
    );

Map<String, dynamic> _$StacAppAvatarToJson(_StacAppAvatar instance) =>
    <String, dynamic>{
      'name': instance.name,
      'size': instance.size,
      'color': instance.color,
    };
