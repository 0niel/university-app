// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'stac_app_avatar_stack.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_StacAppAvatarStack _$StacAppAvatarStackFromJson(Map<String, dynamic> json) =>
    _StacAppAvatarStack(
      names: stringListOrEmpty(json['names']),
      size: json['size'] == null ? 36 : _avatarStackSizeFromJson(json['size']),
    );

Map<String, dynamic> _$StacAppAvatarStackToJson(_StacAppAvatarStack instance) =>
    <String, dynamic>{'names': instance.names, 'size': instance.size};
