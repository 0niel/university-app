// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

User _$UserFromJson(Map<String, dynamic> json) => User(
      id: json['id'] as int,
      username: json['username'] as String,
      name: json['name'] as String?,
      avatarTemplate: json['avatar_template'] as String,
      admin: json['admin'] as bool?,
      moderator: json['moderator'] as bool?,
      trustLevel: json['trust_level'] as int,
      customFields: json['custom_fields'] as Map<String, dynamic>?,
    );

Map<String, dynamic> _$UserToJson(User instance) => <String, dynamic>{
      'id': instance.id,
      'username': instance.username,
      'name': instance.name,
      'avatar_template': instance.avatarTemplate,
      'admin': instance.admin,
      'moderator': instance.moderator,
      'trust_level': instance.trustLevel,
      'custom_fields': instance.customFields,
    };
