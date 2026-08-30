// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'lost_found_item.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_LostFoundItem _$LostFoundItemFromJson(Map<String, dynamic> json) =>
    $checkedCreate('_LostFoundItem', json, ($checkedConvert) {
      final val = _LostFoundItem(
        id: $checkedConvert('id', (v) => v as String),
        authorId: $checkedConvert('authorId', (v) => v as String),
        itemName: $checkedConvert('itemName', (v) => v as String),
        status: $checkedConvert(
          'status',
          (v) => $enumDecode(_$LostFoundItemStatusEnumMap, v),
        ),
        createdAt: $checkedConvert(
          'createdAt',
          (v) => DateTime.parse(v as String),
        ),
        authorName: $checkedConvert('authorName', (v) => v as String? ?? ''),
        description: $checkedConvert('description', (v) => v as String?),
        category: $checkedConvert('category', (v) => v as String? ?? 'other'),
        location: $checkedConvert('location', (v) => v as String? ?? ''),
        imagePaths: $checkedConvert(
          'images',
          (v) =>
              (v as List<dynamic>?)?.map((e) => e as String).toList() ??
              const <String>[],
        ),
        showContact: $checkedConvert('showContact', (v) => v as bool? ?? false),
        telegramContactInfo: $checkedConvert(
          'telegramContactInfo',
          (v) => v as String?,
        ),
        phoneNumberContactInfo: $checkedConvert(
          'phoneNumberContactInfo',
          (v) => v as String?,
        ),
        isMine: $checkedConvert('isMine', (v) => v as bool? ?? false),
      );
      return val;
    }, fieldKeyMap: const {'imagePaths': 'images'});

Map<String, dynamic> _$LostFoundItemToJson(_LostFoundItem instance) =>
    <String, dynamic>{
      'id': instance.id,
      'authorId': instance.authorId,
      'itemName': instance.itemName,
      'status': _$LostFoundItemStatusEnumMap[instance.status]!,
      'createdAt': instance.createdAt.toIso8601String(),
      'authorName': instance.authorName,
      'description': instance.description,
      'category': instance.category,
      'location': instance.location,
      'images': instance.imagePaths,
      'showContact': instance.showContact,
      'telegramContactInfo': instance.telegramContactInfo,
      'phoneNumberContactInfo': instance.phoneNumberContactInfo,
      'isMine': instance.isMine,
    };

const _$LostFoundItemStatusEnumMap = {
  LostFoundItemStatus.lost: 'lost',
  LostFoundItemStatus.found: 'found',
};
