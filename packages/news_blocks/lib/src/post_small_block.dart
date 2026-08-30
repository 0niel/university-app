import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:news_blocks/news_blocks.dart';

part 'post_small_block.freezed.dart';
part 'post_small_block.g.dart';

/// A compact article card.
@freezed
abstract class PostSmallBlock with _$PostSmallBlock implements PostBlock {
  /// Creates a small post card.
  const factory PostSmallBlock({
    required String id,
    required String categoryId,
    required String author,
    required DateTime publishedAt,
    required String title,
    String? imageUrl,
    String? description,
    @BlockActionConverter() BlockAction? action,
    @Default(false) bool isContentOverlaid,
    @Default(PostSmallBlock.identifier) String type,
  }) = _PostSmallBlock;

  /// Deserializes a small post card from [json].
  factory PostSmallBlock.fromJson(Map<String, dynamic> json) =>
      _$PostSmallBlockFromJson(json);

  /// The serialized discriminator for this block.
  static const identifier = '__post_small__';
}
