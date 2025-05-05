// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'lost_and_found_item.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LostFoundItem _$LostFoundItemFromJson(Map<String, dynamic> json) =>
    LostFoundItem(
      authorId: json['author_id'] as String,
      itemName: json['item_name'] as String,
      authorEmail: json['author_email'] as String,
      createdAt: DateTime.parse(json['created_at'] as String),
      status: _statusFromJson(json['status'] as String),
      id: json['id'] as String?,
      description: json['description'] as String?,
      telegramContactInfo: json['telegram_contact_info'] as String?,
      phoneNumberContactInfo: json['phone_number_contact_info'] as String?,
      updatedAt: json['updated_at'] == null
          ? null
          : DateTime.parse(json['updated_at'] as String),
      images:
          (json['images'] as List<dynamic>?)?.map((e) => e as String).toList(),
    );

Map<String, dynamic> _$LostFoundItemToJson(LostFoundItem instance) =>
    <String, dynamic>{
      'id': instance.id,
      'author_id': instance.authorId,
      'item_name': instance.itemName,
      'author_email': instance.authorEmail,
      'created_at': instance.createdAt.toIso8601String(),
      'status': _statusToJson(instance.status),
      'description': instance.description,
      'telegram_contact_info': instance.telegramContactInfo,
      'phone_number_contact_info': instance.phoneNumberContactInfo,
      'updated_at': instance.updatedAt?.toIso8601String(),
      'images': instance.images,
    };
