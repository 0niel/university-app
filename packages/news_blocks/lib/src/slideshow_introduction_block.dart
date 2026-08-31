import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:news_blocks/news_blocks.dart';

part 'slideshow_introduction_block.freezed.dart';
part 'slideshow_introduction_block.g.dart';

/// Cover metadata for a slideshow article.
@freezed
abstract class SlideshowIntroductionBlock
    with _$SlideshowIntroductionBlock
    implements NewsBlock {
  /// Creates a slideshow-introduction block.
  const factory SlideshowIntroductionBlock({
    required String title,
    required String coverImageUrl,
    @BlockActionConverter() BlockAction? action,
    @Default(SlideshowIntroductionBlock.identifier) String type,
  }) = _SlideshowIntroductionBlock;

  /// Deserializes a slideshow-introduction block from [json].
  factory SlideshowIntroductionBlock.fromJson(Map<String, dynamic> json) =>
      _$SlideshowIntroductionBlockFromJson(json);

  /// The serialized discriminator for this block.
  static const identifier = '__slideshow_introduction__';
}
