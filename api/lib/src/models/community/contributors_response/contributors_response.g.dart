// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'contributors_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ContributorsResponse _$ContributorsResponseFromJson(
        Map<String, dynamic> json) =>
    ContributorsResponse(
      contributors: (json['contributors'] as List<dynamic>)
          .map((e) => Contributor.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$ContributorsResponseToJson(
        ContributorsResponse instance) =>
    <String, dynamic>{
      'contributors': instance.contributors,
    };
