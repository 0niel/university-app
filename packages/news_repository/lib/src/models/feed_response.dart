import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:news_blocks/news_blocks.dart';

part 'feed_response.freezed.dart';

@freezed
abstract class FeedResponse with _$FeedResponse {
  const factory FeedResponse({
    required List<NewsBlock> feed,
    required int totalCount,
  }) = _FeedResponse;
}
