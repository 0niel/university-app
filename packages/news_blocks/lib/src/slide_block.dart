import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:news_blocks/news_blocks.dart';

part 'slide_block.freezed.dart';
part 'slide_block.g.dart';

/// A single slide in a slideshow.
@freezed
abstract class SlideBlock with _$SlideBlock implements NewsBlock {
  /// Creates a slideshow slide.
  const factory SlideBlock({
    required String caption,
    required String description,
    required String photoCredit,
    required String imageUrl,
    @Default(SlideBlock.identifier) String type,
  }) = _SlideBlock;

  /// Deserializes a slideshow slide from [json].
  factory SlideBlock.fromJson(Map<String, dynamic> json) =>
      _$SlideBlockFromJson(json);

  /// The serialized discriminator for this block.
  static const identifier = '__slide_block__';
}
