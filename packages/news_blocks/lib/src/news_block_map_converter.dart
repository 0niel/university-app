import 'package:json_annotation/json_annotation.dart';
import 'package:news_blocks/news_blocks.dart';

/// Converts keyed news feeds to and from the normalized block payload.
class NewsBlockMapConverter
    implements
        JsonConverter<Map<String, List<NewsBlock>>, Map<String, dynamic>> {
  /// Creates a keyed news-feed converter.
  const NewsBlockMapConverter();

  @override
  Map<String, List<NewsBlock>> fromJson(Map<String, dynamic> json) => {
    for (final entry in json.entries)
      entry.key: const NewsBlocksConverter().fromJson(
        entry.value as List<dynamic>,
      ),
  };

  @override
  Map<String, dynamic> toJson(Map<String, List<NewsBlock>> value) => {
    for (final entry in value.entries)
      entry.key: const NewsBlocksConverter().toJson(entry.value),
  };
}
