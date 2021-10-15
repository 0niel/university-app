import 'package:equatable/equatable.dart';

class NewsItem extends Equatable {
  final String title;
  final String text;
  final DateTime date;
  final List<String> images;
  final List<String> tags;

  const NewsItem({
    required this.title,
    required this.text,
    required this.date,
    required this.images,
    required this.tags,
  });

  @override
  List<Object?> get props => [title, text, date, images, tags];
}
