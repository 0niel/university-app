import 'package:freezed_annotation/freezed_annotation.dart';

part 'news_feed_item.freezed.dart';
part 'news_feed_item.g.dart';

@freezed
/// News record returned by the source-ingestion RPC.
abstract class NewsFeedItem with _$NewsFeedItem {
  /// Creates a news record with its source and renderable blocks.
  const factory NewsFeedItem({
    required String id,
    required String title,
    required DateTime publishedAt,
    @Default('') String sourceName,
    @Default('social') String sourceType,
    String? sourceId,
    String? originalUrl,
    @Default(<Map<String, dynamic>>[]) List<Map<String, dynamic>> newsBlocks,
    @Default(0) int totalCount,
  }) = _NewsFeedItem;

  /// Restores a news record from the RPC JSON representation.
  factory NewsFeedItem.fromJson(Map<String, dynamic> json) =>
      _$NewsFeedItemFromJson(json);
}

@freezed
/// Lightweight source descriptor returned by the news repository.
abstract class NewsSourceItem with _$NewsSourceItem {
  /// Creates a source descriptor.
  const factory NewsSourceItem({
    required String sourceType,
    required String sourceId,
    @Default('') String sourceName,
    String? sourceUrl,
    String? avatarUrl,
    String? subscribers,
  }) = _NewsSourceItem;

  /// Restores a source descriptor from the RPC JSON representation.
  factory NewsSourceItem.fromJson(Map<String, dynamic> json) =>
      _$NewsSourceItemFromJson(json);
}
