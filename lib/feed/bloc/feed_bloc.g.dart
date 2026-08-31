// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'feed_bloc.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_FeedState _$FeedStateFromJson(Map<String, dynamic> json) => _FeedState(
  status:
      $enumDecodeNullable(_$FeedStatusEnumMap, json['status']) ??
      FeedStatus.initial,
  feed: json['feed'] == null
      ? const <String, List<NewsBlock>>{}
      : const NewsBlockMapConverter().fromJson(
          json['feed'] as Map<String, dynamic>,
        ),
  hasMoreNews:
      (json['hasMoreNews'] as Map<String, dynamic>?)?.map(
        (k, e) => MapEntry(k, e as bool),
      ) ??
      const <String, bool>{},
);

Map<String, dynamic> _$FeedStateToJson(_FeedState instance) =>
    <String, dynamic>{
      'status': _$FeedStatusEnumMap[instance.status]!,
      'feed': const NewsBlockMapConverter().toJson(instance.feed),
      'hasMoreNews': instance.hasMoreNews,
    };

const _$FeedStatusEnumMap = {
  FeedStatus.initial: 'initial',
  FeedStatus.loading: 'loading',
  FeedStatus.populated: 'populated',
  FeedStatus.failure: 'failure',
};
