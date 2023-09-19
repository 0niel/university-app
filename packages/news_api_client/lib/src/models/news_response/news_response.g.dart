// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'news_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

NewsResponse _$NewsResponseFromJson(Map<String, dynamic> json) => NewsResponse(
      title: json['NAME'] as String,
      text: json['DETAIL_TEXT'] as String,
      date: NewsResponse._dateFromJson(json['DATE_ACTIVE_FROM'] as String),
      images: (json['PROPERTY_MY_GALLERY_VALUE'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      tags: NewsResponse._tagsFromJson(json['TAGS'] as String),
      coverImage: json['DETAIL_PICTURE'] as String,
    );

Map<String, dynamic> _$NewsResponseToJson(NewsResponse instance) =>
    <String, dynamic>{
      'NAME': instance.title,
      'DETAIL_TEXT': instance.text,
      'DATE_ACTIVE_FROM': NewsResponse._dateToJson(instance.date),
      'PROPERTY_MY_GALLERY_VALUE': instance.images,
      'DETAIL_PICTURE': instance.coverImage,
      'TAGS': NewsResponse._tagsToJson(instance.tags),
    };
