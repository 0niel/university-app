import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:news_blocks/news_blocks.dart';
import 'package:news_blocks/src/slideshow_block.dart';

part 'block_action.freezed.dart';
part 'block_action.g.dart';

/// The different types of actions.
enum BlockActionType {
  /// A navigation action represents an internal navigation to the provided uri.
  navigation,

  /// An unknown action type.
  unknown,
}

/// {@template block_action}
/// A class which represents an action that can occur
/// when interacting with a block.
/// {@endtemplate}
abstract class BlockAction {
  /// {@macro block_action}
  const BlockAction({required this.type, required this.actionType});

  /// The type key used to identify the type of this action.
  final String type;

  /// The type of this action.
  final BlockActionType actionType;

  /// Converts the current instance to a `Map<String, dynamic>`.
  Map<String, dynamic> toJson();

  /// Deserialize [json] into a [BlockAction] instance.
  /// Returns [UnknownBlockAction] when the [json] is not a recognized type.
  static BlockAction fromJson(Map<String, dynamic> json) {
    final type = json['type'] as String?;
    switch (type) {
      case NavigateToArticleAction.identifier:
        return NavigateToArticleAction.fromJson(json);
      case NavigateToVideoArticleAction.identifier:
        return NavigateToVideoArticleAction.fromJson(json);
      case NavigateToFeedCategoryAction.identifier:
        return NavigateToFeedCategoryAction.fromJson(json);
      case NavigateToSlideshowAction.identifier:
        return NavigateToSlideshowAction.fromJson(json);
    }
    return const UnknownBlockAction();
  }
}

/// Navigates to an article.
@freezed
abstract class NavigateToArticleAction
    with _$NavigateToArticleAction
    implements BlockAction {
  /// Creates an article-navigation action.
  const factory NavigateToArticleAction({
    required String articleId,
    @Default(NavigateToArticleAction.identifier) String type,
    @JsonKey(includeFromJson: false, includeToJson: false)
    @Default(BlockActionType.navigation)
    BlockActionType actionType,
  }) = _NavigateToArticleAction;

  /// Deserializes an article-navigation action from [json].
  factory NavigateToArticleAction.fromJson(Map<String, dynamic> json) =>
      _$NavigateToArticleActionFromJson(json);

  /// The serialized discriminator for this action.
  static const identifier = '__navigate_to_article__';
}

/// Navigates to a video article.
@freezed
abstract class NavigateToVideoArticleAction
    with _$NavigateToVideoArticleAction
    implements BlockAction {
  /// Creates a video-article navigation action.
  const factory NavigateToVideoArticleAction({
    required String articleId,
    @Default(NavigateToVideoArticleAction.identifier) String type,
    @JsonKey(includeFromJson: false, includeToJson: false)
    @Default(BlockActionType.navigation)
    BlockActionType actionType,
  }) = _NavigateToVideoArticleAction;

  /// Deserializes a video-article navigation action from [json].
  factory NavigateToVideoArticleAction.fromJson(Map<String, dynamic> json) =>
      _$NavigateToVideoArticleActionFromJson(json);

  /// The serialized discriminator for this action.
  static const identifier = '__navigate_to_video_article__';
}

/// Navigates to a category feed.
@freezed
abstract class NavigateToFeedCategoryAction
    with _$NavigateToFeedCategoryAction
    implements BlockAction {
  /// Creates a feed-category navigation action.
  const factory NavigateToFeedCategoryAction({
    required Category category,
    @Default(NavigateToFeedCategoryAction.identifier) String type,
    @JsonKey(includeFromJson: false, includeToJson: false)
    @Default(BlockActionType.navigation)
    BlockActionType actionType,
  }) = _NavigateToFeedCategoryAction;

  /// Deserializes a feed-category navigation action from [json].
  factory NavigateToFeedCategoryAction.fromJson(Map<String, dynamic> json) =>
      _$NavigateToFeedCategoryActionFromJson(json);

  /// The serialized discriminator for this action.
  static const identifier = '__navigate_to_feed_category__';
}

/// Navigates to a slideshow article.
@freezed
abstract class NavigateToSlideshowAction
    with _$NavigateToSlideshowAction
    implements BlockAction {
  /// Creates a slideshow-navigation action.
  const factory NavigateToSlideshowAction({
    required String articleId,
    required SlideshowBlock slideshow,
    @Default(NavigateToSlideshowAction.identifier) String type,
    @JsonKey(includeFromJson: false, includeToJson: false)
    @Default(BlockActionType.navigation)
    BlockActionType actionType,
  }) = _NavigateToSlideshowAction;

  /// Deserializes a slideshow-navigation action from [json].
  factory NavigateToSlideshowAction.fromJson(Map<String, dynamic> json) =>
      _$NavigateToSlideshowActionFromJson(json);

  /// The serialized discriminator for this action.
  static const identifier = '__navigate_to_slideshow__';
}

/// Safe fallback for an unsupported action.
@freezed
abstract class UnknownBlockAction
    with _$UnknownBlockAction
    implements BlockAction {
  /// Creates an unknown action.
  const factory UnknownBlockAction({
    @Default(UnknownBlockAction.identifier) String type,
    @JsonKey(includeFromJson: false, includeToJson: false)
    @Default(BlockActionType.unknown)
    BlockActionType actionType,
  }) = _UnknownBlockAction;

  /// Deserializes an unknown action from [json].
  factory UnknownBlockAction.fromJson(Map<String, dynamic> json) =>
      _$UnknownBlockActionFromJson(json);

  /// The serialized discriminator for this action.
  static const identifier = '__unknown__';
}
