import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:news_blocks/news_blocks.dart';

part 'image_block.freezed.dart';
part 'image_block.g.dart';

/// An image embedded in article content.
@freezed
abstract class ImageBlock with _$ImageBlock implements NewsBlock {
  /// Creates an image block.
  const factory ImageBlock({
    required String imageUrl,
    @Default(ImageBlock.identifier) String type,
  }) = _ImageBlock;

  /// Deserializes an image block from [json].
  factory ImageBlock.fromJson(Map<String, dynamic> json) =>
      _$ImageBlockFromJson(json);

  /// The serialized discriminator for this block.
  static const identifier = '__image__';
}
