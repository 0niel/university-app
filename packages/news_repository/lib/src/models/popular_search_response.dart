import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:news_blocks/news_blocks.dart';

part 'popular_search_response.freezed.dart';

@freezed
abstract class PopularSearchResponse with _$PopularSearchResponse {
  const factory PopularSearchResponse({
    required List<NewsBlock> articles,
    required List<String> topics,
  }) = _PopularSearchResponse;
}
