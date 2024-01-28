import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'news_item_response.g.dart';

@JsonSerializable()
class NewsItemResponse extends Equatable {
  const NewsItemResponse({
    required this.title,
    required this.htmlContent,
    required this.publishedAt,
    required this.imageUrls,
    required this.categories,
    this.url,
  });

  factory NewsItemResponse.fromJson(Map<String, dynamic> json) => _$NewsItemResponseFromJson(json);

  final String title;

  final String htmlContent;

  final DateTime publishedAt;

  final List<String> imageUrls;

  final List<String> categories;

  final String? url;

  Map<String, dynamic> toJson() => _$NewsItemResponseToJson(this);

  @override
  List<Object> get props => [title, htmlContent, publishedAt, imageUrls, categories];
}
