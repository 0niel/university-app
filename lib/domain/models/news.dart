import 'package:equatable/equatable.dart';
import 'package:news_page/domain/models/image.dart';
import 'package:news_page/domain/models/tag.dart';

class News_model extends Equatable {
  final int id;
  final String title;
  final String text;
  final DateTime date;
  final List<Image_model> images;
  final List<Tag> tags;

  News_model(
      {required this.title,
      required this.text,
      required this.id,
      required this.date,
      required this.images,
      required this.tags});

  factory News_model.from_json(Map<String, dynamic> json) {
    return News_model(
      title: json['title'],
      text: json['text'],
      id: json['id'],
      date: DateTime.parse(json['date']),
      images: json['images']
          .map<Image_model>((image) => Image_model.from_json(image))
          .toList(),
      tags: json['tags'].map<Tag>((tag) => Tag.from_json(tag)).toList(),
    );
  }

  @override
  List<Object?> get props => [id];
}
