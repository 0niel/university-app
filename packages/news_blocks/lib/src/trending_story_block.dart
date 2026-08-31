import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:news_blocks/news_blocks.dart';
import 'package:news_blocks/src/post_small_block.dart';

part 'trending_story_block.freezed.dart';
part 'trending_story_block.g.dart';

/// A compact link to a trending story.
@freezed
abstract class TrendingStoryBlock
    with _$TrendingStoryBlock
    implements NewsBlock {
  /// Creates a trending-story block.
  const factory TrendingStoryBlock({
    required PostSmallBlock content,
    @Default(TrendingStoryBlock.identifier) String type,
  }) = _TrendingStoryBlock;

  /// Deserializes a trending-story block from [json].
  factory TrendingStoryBlock.fromJson(Map<String, dynamic> json) =>
      _$TrendingStoryBlockFromJson(json);

  /// The serialized discriminator for this block.
  static const identifier = '__trending_story__';
}
