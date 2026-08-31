import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:news_blocks/news_blocks.dart';

part 'slideshow_block.freezed.dart';
part 'slideshow_block.g.dart';

/// A slideshow embedded in article content.
@freezed
abstract class SlideshowBlock with _$SlideshowBlock implements NewsBlock {
  /// Creates a slideshow block.
  const factory SlideshowBlock({
    required String title,
    required List<SlideBlock> slides,
    @Default(SlideshowBlock.identifier) String type,
  }) = _SlideshowBlock;

  /// Deserializes a slideshow block from [json].
  factory SlideshowBlock.fromJson(Map<String, dynamic> json) =>
      _$SlideshowBlockFromJson(json);

  /// The serialized discriminator for this block.
  static const identifier = '__slideshow__';
}
