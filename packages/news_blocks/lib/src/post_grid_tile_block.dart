import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:news_blocks/news_blocks.dart';

part 'post_grid_tile_block.freezed.dart';
part 'post_grid_tile_block.g.dart';

/// A post card intended for a grid layout.
@freezed
abstract class PostGridTileBlock with _$PostGridTileBlock implements PostBlock {
  /// Creates a post-grid tile.
  const factory PostGridTileBlock({
    required String id,
    required String categoryId,
    required String author,
    required DateTime publishedAt,
    required String title,
    String? imageUrl,
    String? description,
    @BlockActionConverter() BlockAction? action,
    @Default(false) bool isContentOverlaid,
    @Default(PostGridTileBlock.identifier) String type,
  }) = _PostGridTileBlock;

  /// Deserializes a post-grid tile from [json].
  factory PostGridTileBlock.fromJson(Map<String, dynamic> json) =>
      _$PostGridTileBlockFromJson(json);

  /// The serialized discriminator for this block.
  static const identifier = '__post_grid_tile__';
}

/// {@template post_grid_tile_block_ext}
/// Converts [PostGridTileBlock] into a [PostBlock] instance.
/// {@endtemplate}
extension PostGridTileBlockExt on PostGridTileBlock {
  String get _requiredImageUrl {
    final imageUrl = this.imageUrl;
    if (imageUrl == null) {
      throw StateError('A grid tile needs an image before it can be promoted.');
    }
    return imageUrl;
  }

  /// Converts [PostGridTileBlock] into a [PostLargeBlock] instance.
  PostLargeBlock toPostLargeBlock() => PostLargeBlock(
    id: id,
    categoryId: categoryId,
    author: author,
    publishedAt: publishedAt,
    imageUrl: _requiredImageUrl,
    title: title,
    isContentOverlaid: true,
    description: description,
    action: action,
  );

  /// Converts [PostGridTileBlock] into a [PostMediumBlock] instance.
  PostMediumBlock toPostMediumBlock() => PostMediumBlock(
    id: id,
    categoryId: categoryId,
    author: author,
    publishedAt: publishedAt,
    imageUrl: _requiredImageUrl,
    title: title,
    isContentOverlaid: true,
    description: description,
    action: action,
  );
}
