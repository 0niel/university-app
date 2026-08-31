// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'trending_search.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_TrendingSearch _$TrendingSearchFromJson(Map<String, dynamic> json) =>
    $checkedCreate('_TrendingSearch', json, ($checkedConvert) {
      final val = _TrendingSearch(
        query: $checkedConvert('query', (v) => v as String? ?? ''),
        count: $checkedConvert('count', (v) => (v as num?)?.toInt() ?? 0),
      );
      return val;
    });

Map<String, dynamic> _$TrendingSearchToJson(_TrendingSearch instance) =>
    <String, dynamic>{'query': instance.query, 'count': instance.count};
