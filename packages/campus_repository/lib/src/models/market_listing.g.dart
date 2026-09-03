// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'market_listing.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_MarketListing _$MarketListingFromJson(Map<String, dynamic> json) =>
    $checkedCreate('_MarketListing', json, ($checkedConvert) {
      final val = _MarketListing(
        id: $checkedConvert('id', (v) => v as String),
        title: $checkedConvert('title', (v) => v as String),
        price: $checkedConvert('price', (v) => (v as num).toInt()),
        description: $checkedConvert('description', (v) => v as String? ?? ''),
        category: $checkedConvert('category', (v) => v as String? ?? 'other'),
        emoji: $checkedConvert('emoji', (v) => v as String? ?? '📦'),
        isSold: $checkedConvert('isSold', (v) => v as bool? ?? false),
        isFree: $checkedConvert('isFree', (v) => v as bool? ?? false),
        createdAt: $checkedConvert('createdAt', (v) => dateTimeFromJson(v)),
        isMine: $checkedConvert('isMine', (v) => v as bool? ?? false),
        sellerName: $checkedConvert('sellerName', (v) => v as String? ?? ''),
        showContact: $checkedConvert('showContact', (v) => v as bool? ?? false),
        media: $checkedConvert(
          'media',
          (v) => v == null ? const <MarketMediaItem>[] : _mediaFromJson(v),
        ),
        telegramHandle: $checkedConvert('telegramHandle', (v) => v as String?),
      );
      return val;
    });

Map<String, dynamic> _$MarketListingToJson(_MarketListing instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'price': instance.price,
      'description': instance.description,
      'category': instance.category,
      'emoji': instance.emoji,
      'isSold': instance.isSold,
      'isFree': instance.isFree,
      'createdAt': dateTimeToJson(instance.createdAt),
      'isMine': instance.isMine,
      'sellerName': instance.sellerName,
      'showContact': instance.showContact,
      'media': _mediaToJson(instance.media),
      'telegramHandle': instance.telegramHandle,
    };
