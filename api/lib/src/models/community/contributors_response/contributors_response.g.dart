// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'contributors_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ContributorsResponse _$ContriubutorsResponseFromJson(Map<String, dynamic> json) => ContributorsResponse(
      contributors:
          (json['contributors'] as List<dynamic>).map((e) => Contributor.fromJson(e as Map<String, dynamic>)).toList(),
    );

Map<String, dynamic> _$ContriubutorsResponseToJson(ContributorsResponse instance) => <String, dynamic>{
      'contributors': instance.contributors,
    };
