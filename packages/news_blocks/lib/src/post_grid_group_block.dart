import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:news_blocks/news_blocks.dart';

part 'post_grid_group_block.freezed.dart';
part 'post_grid_group_block.g.dart';

/// A category-specific group of post tiles.
@freezed
abstract class PostGridGroupBlock
    with _$PostGridGroupBlock
    implements NewsBlock {
  /// Creates a post-grid group.
  const factory PostGridGroupBlock({
    required String categoryId,
    @NewsBlocksConverter() required List<PostGridTileBlock> tiles,
    @Default(PostGridGroupBlock.identifier) String type,
  }) = _PostGridGroupBlock;

  /// Deserializes a post-grid group from [json].
  factory PostGridGroupBlock.fromJson(Map<String, dynamic> json) =>
      _$PostGridGroupBlockFromJson(json);

  /// The serialized discriminator for this block.
  static const identifier = '__post_grid_group__';
}
