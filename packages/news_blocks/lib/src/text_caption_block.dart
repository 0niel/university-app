import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:news_blocks/news_blocks.dart';

part 'text_caption_block.freezed.dart';
part 'text_caption_block.g.dart';

/// The text color of [TextCaptionBlock].
enum TextCaptionColor {
  /// The normal text color.
  normal,

  /// The light text color.
  light,
}

/// A short caption used in an article layout.
@freezed
abstract class TextCaptionBlock with _$TextCaptionBlock implements NewsBlock {
  /// Creates a text-caption block.
  const factory TextCaptionBlock({
    required String text,
    required TextCaptionColor color,
    @Default(TextCaptionBlock.identifier) String type,
  }) = _TextCaptionBlock;

  /// Deserializes a text-caption block from [json].
  factory TextCaptionBlock.fromJson(Map<String, dynamic> json) =>
      _$TextCaptionBlockFromJson(json);

  /// The serialized discriminator for this block.
  static const identifier = '__text_caption__';
}
