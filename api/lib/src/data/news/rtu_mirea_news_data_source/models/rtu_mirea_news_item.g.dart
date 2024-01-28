// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'rtu_mirea_news_item.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RtuMireaNewsItem _$RtuMireaNewsItemFromJson(Map<String, dynamic> json) => RtuMireaNewsItem(
      title: json['NAME'] as String,
      text: json['DETAIL_TEXT'] as String,
      date: RtuMireaNewsItem._dateFromJson(json['DATE_ACTIVE_FROM'] as String),
      images: (json['PROPERTY_MY_GALLERY_VALUE'] as List<dynamic>?)?.map((e) => e as String).toList() ?? [],
      tags: json['TAGS'] == null ? [] : RtuMireaNewsItem._tagsFromJson(json['TAGS'] as String),
      coverImage: json['DETAIL_PICTURE'] as String,
      detailPageUrl: json['DETAIL_PAGE_URL'] as String,
    );

Map<String, dynamic> _$RtuMireaNewsItemToJson(RtuMireaNewsItem instance) => <String, dynamic>{
      'NAME': instance.title,
      'DETAIL_TEXT': instance.text,
      'DATE_ACTIVE_FROM': instance.date.toIso8601String(),
      'PROPERTY_MY_GALLERY_VALUE': instance.images,
      'DETAIL_PICTURE': instance.coverImage,
      'TAGS': RtuMireaNewsItem._tagsToJson(instance.tags),
      'DETAIL_PAGE_URL': instance.detailPageUrl,
    };
