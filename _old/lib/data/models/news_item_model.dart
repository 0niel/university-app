import 'package:rtu_mirea_app/domain/entities/news_item.dart';

import 'strapi_media_model.dart';

class NewsItemModel extends NewsItem {
  const NewsItemModel({
    required title,
    required text,
    required date,
    required images,
    required tags,
    required isImportant,
  }) : super(
          title: title,
          text: text,
          date: date,
          images: images,
          tags: tags,
          isImportant: isImportant,
        );

  factory NewsItemModel.fromJson(Map<String, dynamic> json) {
    return NewsItemModel(
      title: json['title'],
      text: json['text'],
      date: DateTime.parse(json['date']),
      images: List<StrapiMediaModel>.from(json["images"]["data"]
          .map((x) => StrapiMediaModel.fromJson(x["attributes"]))),
      tags: List<String>.from(
          json["tags"]["data"].map((x) => x["attributes"]['name'])),
      isImportant: json['isImportant'],
    );
  }

  @override
  List<Object?> get props => [title, text, date, images, tags, isImportant];
}
