// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'news_item.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

NewsItem _$NewsItemFromJson(Map<String, dynamic> json) => NewsItem(
      title: json['NAME'] as String,
      text: json['DETAIL_TEXT'] as String,
      date: NewsItem._dateFromJson(json['DATE_ACTIVE_FROM'] as String),
      images: (json['PROPERTY_MY_GALLERY_VALUE'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          [],
      tags: json['TAGS'] == null
          ? []
          : NewsItem._tagsFromJson(json['TAGS'] as String),
      coverImage: json['DETAIL_PICTURE'] as String,
    );

Map<String, dynamic> _$NewsItemToJson(NewsItem instance) => <String, dynamic>{
      'NAME': instance.title,
      'DETAIL_TEXT': instance.text,
      'DATE_ACTIVE_FROM': instance.date.toIso8601String(),
      'PROPERTY_MY_GALLERY_VALUE': instance.images,
      'DETAIL_PICTURE': instance.coverImage,
      'TAGS': NewsItem._tagsToJson(instance.tags),
    };
