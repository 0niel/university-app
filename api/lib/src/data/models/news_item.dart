import 'package:equatable/equatable.dart';
import 'package:intl/intl.dart';
import 'package:json_annotation/json_annotation.dart';

part 'news_item.g.dart';

@JsonSerializable()
class NewsItem extends Equatable {
  /// {@macro news_response}
  const NewsItem({
    required this.title,
    required this.text,
    required this.date,
    required this.images,
    required this.tags,
    required this.coverImage,
  });

  /// Конвертирует `Map<String, dynamic>` в [NewsItem]
  factory NewsItem.fromJson(Map<String, dynamic> json) =>
      _$NewsItemFromJson(json);

  /// Заголовок новости.
  @JsonKey(name: 'NAME')
  final String title;

  /// Текст новости. Может содержать HTML-теги.
  @JsonKey(name: 'DETAIL_TEXT')
  final String text;

  static DateTime _dateFromJson(String date) =>
      DateFormat('dd.MM.yyyy').parse(date);

  /// Дата публикации новости.
  @JsonKey(
    name: 'DATE_ACTIVE_FROM',
    fromJson: _dateFromJson,
  )
  final DateTime date;

  /// Ссылки на изображения новости.
  @JsonKey(name: 'PROPERTY_MY_GALLERY_VALUE', defaultValue: [])
  final List<String> images;

  /// Обложка новости.
  @JsonKey(name: 'DETAIL_PICTURE')
  final String coverImage;

  static List<String> _tagsFromJson(String tags) =>
      tags.split(',').map((e) => e.trim()).toList();

  static String _tagsToJson(List<String> tags) => tags.join(',');

  /// Теги новости
  @JsonKey(
    fromJson: _tagsFromJson,
    name: 'TAGS',
    toJson: _tagsToJson,
    defaultValue: [],
  )
  final List<String> tags;

  /// Конвертирует [NewsItem] в `Map<String, dynamic>`
  Map<String, dynamic> toJson() => _$NewsItemToJson(this);

  @override
  List<Object> get props => [title, text, date, images, tags];
}
