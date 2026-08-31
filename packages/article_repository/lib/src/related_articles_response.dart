import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:news_blocks/news_blocks.dart';

part 'related_articles_response.freezed.dart';

@freezed
abstract class RelatedArticlesResponse with _$RelatedArticlesResponse {
  const factory RelatedArticlesResponse({
    required List<NewsBlock> relatedArticles,
    required int totalCount,
  }) = _RelatedArticlesResponse;
}
