import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:news_blocks/news_blocks.dart';

part 'article_introduction_block.freezed.dart';
part 'article_introduction_block.g.dart';

@freezed
/// Immutable content for the introductory block of an article.
abstract class ArticleIntroductionBlock
    with _$ArticleIntroductionBlock
    implements NewsBlock {
  /// Creates article introduction content.
  const factory ArticleIntroductionBlock({
    required String categoryId,
    required String author,
    required DateTime publishedAt,
    required String title,
    String? imageUrl,
    @Default(ArticleIntroductionBlock.identifier) String type,
  }) = _ArticleIntroductionBlock;

  /// Deserializes article introduction content from [json].
  factory ArticleIntroductionBlock.fromJson(Map<String, dynamic> json) =>
      _$ArticleIntroductionBlockFromJson(json);

  /// The serialized discriminator for this block.
  static const identifier = '__article_introduction__';
}
