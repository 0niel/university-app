import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'article.g.dart';

@JsonSerializable()
class Article extends Equatable {
  /// {@macro news_response}
  const Article({
    required this.title,
    required this.htmlContent,
    required this.publishedAt,
    required this.imageUrls,
    required this.categories,
    this.url,
  });

  /// Converts a `Map<String, dynamic>` into a [Article] instance.
  factory Article.fromJson(Map<String, dynamic> json) => _$ArticleFromJson(json);

  final String title;

  final String htmlContent;

  final DateTime publishedAt;

  final List<String> imageUrls;

  final List<String> categories;

  final String? url;

  /// Converts the current instance to a `Map<String, dynamic>`.
  Map<String, dynamic> toJson() => _$ArticleToJson(this);

  @override
  List<Object> get props => [title, htmlContent, publishedAt, imageUrls, categories];
}
