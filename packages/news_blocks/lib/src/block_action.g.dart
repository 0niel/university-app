// GENERATED CODE - DO NOT MODIFY BY HAND

// ignore_for_file: cast_nullable_to_non_nullable, implicit_dynamic_parameter, lines_longer_than_80_chars, prefer_const_constructors, require_trailing_commas

part of 'block_action.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_NavigateToArticleAction _$NavigateToArticleActionFromJson(
  Map<String, dynamic> json,
) => $checkedCreate('_NavigateToArticleAction', json, ($checkedConvert) {
  final val = _NavigateToArticleAction(
    articleId: $checkedConvert('article_id', (v) => v as String),
    type: $checkedConvert(
      'type',
      (v) => v as String? ?? NavigateToArticleAction.identifier,
    ),
  );
  return val;
}, fieldKeyMap: const {'articleId': 'article_id'});

Map<String, dynamic> _$NavigateToArticleActionToJson(
  _NavigateToArticleAction instance,
) => <String, dynamic>{'article_id': instance.articleId, 'type': instance.type};

_NavigateToVideoArticleAction _$NavigateToVideoArticleActionFromJson(
  Map<String, dynamic> json,
) => $checkedCreate(
  '_NavigateToVideoArticleAction',
  json,
  ($checkedConvert) {
    final val = _NavigateToVideoArticleAction(
      articleId: $checkedConvert('article_id', (v) => v as String),
      type: $checkedConvert(
        'type',
        (v) => v as String? ?? NavigateToVideoArticleAction.identifier,
      ),
    );
    return val;
  },
  fieldKeyMap: const {'articleId': 'article_id'},
);

Map<String, dynamic> _$NavigateToVideoArticleActionToJson(
  _NavigateToVideoArticleAction instance,
) => <String, dynamic>{'article_id': instance.articleId, 'type': instance.type};

_NavigateToFeedCategoryAction _$NavigateToFeedCategoryActionFromJson(
  Map<String, dynamic> json,
) => $checkedCreate('_NavigateToFeedCategoryAction', json, ($checkedConvert) {
  final val = _NavigateToFeedCategoryAction(
    category: $checkedConvert(
      'category',
      (v) => Category.fromJson(v as Map<String, dynamic>),
    ),
    type: $checkedConvert(
      'type',
      (v) => v as String? ?? NavigateToFeedCategoryAction.identifier,
    ),
  );
  return val;
});

Map<String, dynamic> _$NavigateToFeedCategoryActionToJson(
  _NavigateToFeedCategoryAction instance,
) => <String, dynamic>{
  'category': instance.category.toJson(),
  'type': instance.type,
};

_NavigateToSlideshowAction _$NavigateToSlideshowActionFromJson(
  Map<String, dynamic> json,
) => $checkedCreate('_NavigateToSlideshowAction', json, ($checkedConvert) {
  final val = _NavigateToSlideshowAction(
    articleId: $checkedConvert('article_id', (v) => v as String),
    slideshow: $checkedConvert(
      'slideshow',
      (v) => SlideshowBlock.fromJson(v as Map<String, dynamic>),
    ),
    type: $checkedConvert(
      'type',
      (v) => v as String? ?? NavigateToSlideshowAction.identifier,
    ),
  );
  return val;
}, fieldKeyMap: const {'articleId': 'article_id'});

Map<String, dynamic> _$NavigateToSlideshowActionToJson(
  _NavigateToSlideshowAction instance,
) => <String, dynamic>{
  'article_id': instance.articleId,
  'slideshow': instance.slideshow.toJson(),
  'type': instance.type,
};

_UnknownBlockAction _$UnknownBlockActionFromJson(Map<String, dynamic> json) =>
    $checkedCreate('_UnknownBlockAction', json, ($checkedConvert) {
      final val = _UnknownBlockAction(
        type: $checkedConvert(
          'type',
          (v) => v as String? ?? UnknownBlockAction.identifier,
        ),
      );
      return val;
    });

Map<String, dynamic> _$UnknownBlockActionToJson(_UnknownBlockAction instance) =>
    <String, dynamic>{'type': instance.type};
