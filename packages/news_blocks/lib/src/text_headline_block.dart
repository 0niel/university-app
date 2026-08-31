import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:news_blocks/news_blocks.dart';

part 'text_headline_block.freezed.dart';
part 'text_headline_block.g.dart';

/// A headline in article content.
@freezed
abstract class TextHeadlineBlock with _$TextHeadlineBlock implements NewsBlock {
  /// Creates a headline block.
  const factory TextHeadlineBlock({
    required String text,
    @Default(TextHeadlineBlock.identifier) String type,
  }) = _TextHeadlineBlock;

  /// Deserializes a headline block from [json].
  factory TextHeadlineBlock.fromJson(Map<String, dynamic> json) =>
      _$TextHeadlineBlockFromJson(json);

  /// The serialized discriminator for this block.
  static const identifier = '__text_headline__';
}
