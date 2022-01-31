import 'package:equatable/equatable.dart';
import 'package:rtu_mirea_app/domain/entities/strapi_media.dart';

class NewsItem extends Equatable {
  final String title;
  final String text;
  final DateTime date;
  final List<StrapiMedia> images;
  final List<String> tags;
  final bool isImportant;

  const NewsItem({
    required this.title,
    required this.text,
    required this.date,
    required this.images,
    required this.tags,
    required this.isImportant,
  });

  @override
  List<Object?> get props => [title, text, date, images, tags, isImportant];
}
