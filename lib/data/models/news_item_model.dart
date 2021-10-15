import 'package:rtu_mirea_app/domain/entities/news_item.dart';

class NewsItemModel extends NewsItem {
  const NewsItemModel({
    required title,
    required text,
    required date,
    required images,
    required tags,
  }) : super(
          title: title,
          text: text,
          date: date,
          images: images,
          tags: tags,
        );

  factory NewsItemModel.fromJson(Map<String, dynamic> json) {
    return NewsItemModel(
      title: json['title'],
      text: json['text'],
      date: DateTime.parse(json['date']),
      images: List<String>.from(json["images"].map((x) => x['name'])),
      tags: List<String>.from(json["tags"].map((x) => x['name'])),
    );
  }

  @override
  List<Object?> get props => [title, text, date, images, tags];
}
