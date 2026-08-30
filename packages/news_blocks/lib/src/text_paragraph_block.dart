import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:news_blocks/news_blocks.dart';

part 'text_paragraph_block.freezed.dart';
part 'text_paragraph_block.g.dart';

/// A regular paragraph in article content.
@freezed
abstract class TextParagraphBlock
    with _$TextParagraphBlock
    implements NewsBlock {
  /// Creates a paragraph block.
  const factory TextParagraphBlock({
    required String text,
    @Default(TextParagraphBlock.identifier) String type,
  }) = _TextParagraphBlock;

  /// Deserializes a paragraph block from [json].
  factory TextParagraphBlock.fromJson(Map<String, dynamic> json) =>
      _$TextParagraphBlockFromJson(json);

  /// The serialized discriminator for this block.
  static const identifier = '__text_paragraph__';
}
