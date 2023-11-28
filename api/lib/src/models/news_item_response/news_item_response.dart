import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:university_app_server_api/src/data/models/models.dart';

part 'news_item_response.g.dart';

@JsonSerializable()
class NewsItemResponse extends Equatable {
  const NewsItemResponse({
    required this.title,
    required this.htmlContent,
    required this.publishedAt,
    required this.imageUrls,
    required this.categories,
  });

  factory NewsItemResponse.fromJson(Map<String, dynamic> json) =>
      _$NewsItemResponseFromJson(json);

  factory NewsItemResponse.fromNewsItem(NewsItem newsItem) => NewsItemResponse(
        title: newsItem.title,
        htmlContent: newsItem.text,
        publishedAt: newsItem.date,
        imageUrls: newsItem.images.isNotEmpty
            ? newsItem.images
            : [newsItem.coverImage],
        categories: newsItem.tags,
      );

  final String title;

  final String htmlContent;

  final DateTime publishedAt;

  final List<String> imageUrls;

  final List<String> categories;

  Map<String, dynamic> toJson() => _$NewsItemResponseToJson(this);

  @override
  List<Object> get props =>
      [title, htmlContent, publishedAt, imageUrls, categories];
}
