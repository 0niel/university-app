import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:news_blocks/news_blocks.dart';

part 'newsletter_block.freezed.dart';
part 'newsletter_block.g.dart';

/// A newsletter subscription prompt.
@freezed
abstract class NewsletterBlock with _$NewsletterBlock implements NewsBlock {
  /// Creates a newsletter block.
  const factory NewsletterBlock({
    @Default(NewsletterBlock.identifier) String type,
  }) = _NewsletterBlock;

  /// Deserializes a newsletter block from [json].
  factory NewsletterBlock.fromJson(Map<String, dynamic> json) =>
      _$NewsletterBlockFromJson(json);

  /// The serialized discriminator for this block.
  static const identifier = '__newsletter__';
}
