import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:news_blocks/news_blocks.dart';

part 'html_block.freezed.dart';
part 'html_block.g.dart';

/// Sanitized HTML content for an article.
@freezed
abstract class HtmlBlock with _$HtmlBlock implements NewsBlock {
  /// Creates an HTML block.
  const factory HtmlBlock({
    required String content,
    @Default(HtmlBlock.identifier) String type,
  }) = _HtmlBlock;

  /// Deserializes an HTML block from [json].
  factory HtmlBlock.fromJson(Map<String, dynamic> json) =>
      _$HtmlBlockFromJson(json);

  /// The serialized discriminator for this block.
  static const identifier = '__html__';
}
