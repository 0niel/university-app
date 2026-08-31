import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:news_blocks/news_blocks.dart';

part 'post_large_block.freezed.dart';
part 'post_large_block.g.dart';

/// A prominent article card.
@freezed
abstract class PostLargeBlock with _$PostLargeBlock implements PostBlock {
  /// Creates a large post card.
  const factory PostLargeBlock({
    required String id,
    required String categoryId,
    required String author,
    required DateTime publishedAt,
    required String imageUrl,
    required String title,
    String? description,
    @BlockActionConverter() BlockAction? action,
    @Default(false) bool isContentOverlaid,
    @Default(PostLargeBlock.identifier) String type,
  }) = _PostLargeBlock;

  /// Deserializes a large post card from [json].
  factory PostLargeBlock.fromJson(Map<String, dynamic> json) =>
      _$PostLargeBlockFromJson(json);

  /// The serialized discriminator for this block.
  static const identifier = '__post_large__';
}
