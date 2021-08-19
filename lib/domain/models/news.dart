import 'package:equatable/equatable.dart';
import 'package:news_page/domain/models/image.dart';
import 'package:news_page/domain/models/tag.dart';

class NewsModel extends Equatable {
  final int id;
  final String title;
  final String text;
  final DateTime date;
  final List<ImageModel> images;
  final List<Tag> tags;

  NewsModel(
      {required this.title,
      required this.text,
      required this.id,
      required this.date,
      required this.images,
      required this.tags});

  factory NewsModel.from_json(Map<String, dynamic> json) {
    return NewsModel(
      title: json['title'],
      text: json['text'],
      id: json['id'],
      date: DateTime.parse(json['date']),
      images: json['images']
          .map<ImageModel>((image) => ImageModel.from_json(image))
          .toList(),
      tags: json['tags'].map<Tag>((tag) => Tag.from_json(tag)).toList(),
    );
  }

  @override
  List<Object?> get props => [id];
}
