// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'article_bloc.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ArticleState _$ArticleStateFromJson(Map<String, dynamic> json) => ArticleState(
  status: $enumDecode(_$ArticleStatusEnumMap, json['status']),
  title: json['title'] as String?,
  content:
      (json['content'] as List<dynamic>?)
          ?.map((e) => NewsBlock.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
  contentSeenCount: (json['contentSeenCount'] as num?)?.toInt() ?? 0,
  relatedArticles:
      (json['relatedArticles'] as List<dynamic>?)
          ?.map((e) => NewsBlock.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
  uri: json['uri'] == null ? null : Uri.parse(json['uri'] as String),
  hasReachedArticleViewsLimit:
      json['hasReachedArticleViewsLimit'] as bool? ?? false,
  showInterstitialAd: json['showInterstitialAd'] as bool? ?? false,
);

Map<String, dynamic> _$ArticleStateToJson(
  ArticleState instance,
) => <String, dynamic>{
  'status': _$ArticleStatusEnumMap[instance.status]!,
  'title': instance.title,
  'content': instance.content.map((e) => e.toJson()).toList(),
  'contentSeenCount': instance.contentSeenCount,
  'relatedArticles': instance.relatedArticles.map((e) => e.toJson()).toList(),
  'uri': instance.uri?.toString(),
  'hasReachedArticleViewsLimit': instance.hasReachedArticleViewsLimit,
  'showInterstitialAd': instance.showInterstitialAd,
};

const _$ArticleStatusEnumMap = {
  ArticleStatus.initial: 'initial',
  ArticleStatus.loading: 'loading',
  ArticleStatus.populated: 'populated',
  ArticleStatus.failure: 'failure',
  ArticleStatus.shareFailure: 'shareFailure',
  ArticleStatus.rewardedAdWatchedFailure: 'rewardedAdWatchedFailure',
};
