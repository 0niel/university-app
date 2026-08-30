import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:news_blocks/news_blocks.dart';

part 'text_lead_paragraph_block.freezed.dart';
part 'text_lead_paragraph_block.g.dart';

/// A lead paragraph in article content.
@freezed
abstract class TextLeadParagraphBlock
    with _$TextLeadParagraphBlock
    implements NewsBlock {
  /// Creates a lead-paragraph block.
  const factory TextLeadParagraphBlock({
    required String text,
    @Default(TextLeadParagraphBlock.identifier) String type,
  }) = _TextLeadParagraphBlock;

  /// Deserializes a lead-paragraph block from [json].
  factory TextLeadParagraphBlock.fromJson(Map<String, dynamic> json) =>
      _$TextLeadParagraphBlockFromJson(json);

  /// The serialized discriminator for this block.
  static const identifier = '__text_lead_paragraph__';
}
