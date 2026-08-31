// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'article_bloc.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ArticleState _$ArticleStateFromJson(Map<String, dynamic> json) =>
    _ArticleState(
      status:
          $enumDecodeNullable(_$ArticleStatusEnumMap, json['status']) ??
          ArticleStatus.initial,
      title: json['title'] as String?,
      content: json['content'] == null
          ? const <NewsBlock>[]
          : const NewsBlocksConverter().fromJson(json['content'] as List),
      contentSeenCount: (json['contentSeenCount'] as num?)?.toInt() ?? 0,
      relatedArticles: json['relatedArticles'] == null
          ? const <NewsBlock>[]
          : const NewsBlocksConverter().fromJson(
              json['relatedArticles'] as List,
            ),
      uri: json['uri'] == null ? null : Uri.parse(json['uri'] as String),
      hasReachedArticleViewsLimit:
          json['hasReachedArticleViewsLimit'] as bool? ?? false,
      showInterstitialAd: json['showInterstitialAd'] as bool? ?? false,
    );

Map<String, dynamic> _$ArticleStateToJson(_ArticleState instance) =>
    <String, dynamic>{
      'status': _$ArticleStatusEnumMap[instance.status]!,
      'title': instance.title,
      'content': const NewsBlocksConverter().toJson(instance.content),
      'contentSeenCount': instance.contentSeenCount,
      'relatedArticles': const NewsBlocksConverter().toJson(
        instance.relatedArticles,
      ),
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
