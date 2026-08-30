import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:news_blocks/news_blocks.dart';

part 'relevant_search_response.freezed.dart';

@freezed
abstract class RelevantSearchResponse with _$RelevantSearchResponse {
  const factory RelevantSearchResponse({
    required List<NewsBlock> articles,
    required List<String> topics,
  }) = _RelevantSearchResponse;
}
