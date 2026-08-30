import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:news_blocks/news_blocks.dart';

part 'article_response.freezed.dart';

@freezed
abstract class ArticleResponse with _$ArticleResponse {
  const factory ArticleResponse({
    required String title,
    required List<NewsBlock> content,
    required Uri url,
  }) = _ArticleResponse;
}
