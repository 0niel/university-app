import 'package:intl/intl.dart';
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
      title: json['NAME'],
      text: json['DETAIL_TEXT'],
      date: DateFormat("dd.MM.yyyy").parse(json['DATE_ACTIVE_FROM']),
      images: List<String>.from(json['PROPERTY_MY_GALLERY_VALUE'] ?? [])..add(json['DETAIL_PICTURE']),
      tags: List<String>.from(json['TAGS'].toString().split(',').map((x) => x.trim())),
    );
  }

  @override
  List<Object?> get props => [title, text, date, images, tags];
}
