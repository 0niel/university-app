// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_User _$UserFromJson(Map<String, dynamic> json) => _User(
  id: (json['id'] as num).toInt(),
  username: json['username'] as String,
  name: json['name'] as String?,
  avatarTemplate: json['avatar_template'] as String,
  trustLevel: (json['trust_level'] as num).toInt(),
  admin: json['admin'] as bool?,
  moderator: json['moderator'] as bool?,
  customFields: json['custom_fields'] as Map<String, dynamic>?,
);

Map<String, dynamic> _$UserToJson(_User instance) => <String, dynamic>{
  'id': instance.id,
  'username': instance.username,
  'name': instance.name,
  'avatar_template': instance.avatarTemplate,
  'trust_level': instance.trustLevel,
  'admin': instance.admin,
  'moderator': instance.moderator,
  'custom_fields': instance.customFields,
};
