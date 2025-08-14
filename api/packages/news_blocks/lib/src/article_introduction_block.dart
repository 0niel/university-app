import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:news_blocks/news_blocks.dart';

part 'article_introduction_block.g.dart';

/// {@template article_introduction_block}
/// A block which represents the introduction of an article.
/// {@endtemplate}
@JsonSerializable()
class ArticleIntroductionBlock with EquatableMixin implements NewsBlock {
  /// {@macro article_introduction_block}
  const ArticleIntroductionBlock({
    required this.categoryId,
    required this.author,
    required this.publishedAt,
    required this.title,
    this.imageUrl,
    this.type = ArticleIntroductionBlock.identifier,
  });

  /// Converts a `Map<String, dynamic>`
  /// into a [ArticleIntroductionBlock] instance.
  factory ArticleIntroductionBlock.fromJson(Map<String, dynamic> json) => _$ArticleIntroductionBlockFromJson(json);

  /// The article introduction block type identifier.
  static const identifier = '__article_introduction__';

  /// The category id of the associated article.
  final String categoryId;

  /// The author of the associated article.
  final String author;

  /// The date when the associated article was published.
  final DateTime publishedAt;

  /// The image URL of the associated article.
  final String? imageUrl;

  /// The title of the associated article.
  final String title;

  @override
  Map<String, dynamic> toJson() => _$ArticleIntroductionBlockToJson(this);

  @override
  final String type;

  @override
  List<Object?> get props => [
        type,
        categoryId,
        author,
        publishedAt,
        imageUrl,
        title,
      ];
}
