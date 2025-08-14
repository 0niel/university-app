// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sponsors_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SponsorsResponse _$SponsorsResponseFromJson(Map<String, dynamic> json) => SponsorsResponse(
      sponsors: (json['sponsors'] as List<dynamic>).map((e) => Sponsor.fromJson(e as Map<String, dynamic>)).toList(),
    );

Map<String, dynamic> _$SponsorsResponseToJson(SponsorsResponse instance) => <String, dynamic>{
      'sponsors': instance.sponsors,
    };
