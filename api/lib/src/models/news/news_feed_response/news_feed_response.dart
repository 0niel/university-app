import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

import 'package:university_app_server_api/src/models/news/news_item_response/news_item_response.dart';

part 'news_feed_response.g.dart';

@JsonSerializable()
class NewsFeedResponse extends Equatable {
  const NewsFeedResponse({
    required this.news,
  });

  factory NewsFeedResponse.fromJson(Map<String, dynamic> json) => _$NewsFeedResponseFromJson(json);

  final List<NewsItemResponse> news;

  Map<String, dynamic> toJson() => _$NewsFeedResponseToJson(this);

  @override
  List<Object> get props => [news];
}
