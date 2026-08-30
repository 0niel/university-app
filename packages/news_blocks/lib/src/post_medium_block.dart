import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:news_blocks/news_blocks.dart';

part 'post_medium_block.freezed.dart';
part 'post_medium_block.g.dart';

/// A medium-sized article card.
@freezed
abstract class PostMediumBlock with _$PostMediumBlock implements PostBlock {
  /// Creates a medium post card.
  const factory PostMediumBlock({
    required String id,
    required String categoryId,
    required String author,
    required DateTime publishedAt,
    required String imageUrl,
    required String title,
    String? description,
    @BlockActionConverter() BlockAction? action,
    @Default(false) bool isContentOverlaid,
    @Default(PostMediumBlock.identifier) String type,
  }) = _PostMediumBlock;

  /// Deserializes a medium post card from [json].
  factory PostMediumBlock.fromJson(Map<String, dynamic> json) =>
      _$PostMediumBlockFromJson(json);

  /// The serialized discriminator for this block.
  static const identifier = '__post_medium__';
}
