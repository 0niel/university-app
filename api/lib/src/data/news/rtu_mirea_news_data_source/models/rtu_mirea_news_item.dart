import 'package:equatable/equatable.dart';
import 'package:intl/intl.dart';
import 'package:json_annotation/json_annotation.dart';

import 'package:university_app_server_api/src/data/news/models/models.dart';

part 'rtu_mirea_news_item.g.dart';

@JsonSerializable()
class RtuMireaNewsItem extends Equatable {
  /// {@macro news_response}
  const RtuMireaNewsItem({
    required this.title,
    required this.text,
    required this.date,
    required this.images,
    required this.tags,
    required this.coverImage,
    required this.detailPageUrl,
  });

  /// Конвертирует `Map<String, dynamic>` в [RtuMireaNewsItem]
  factory RtuMireaNewsItem.fromJson(Map<String, dynamic> json) => _$RtuMireaNewsItemFromJson(json);

  /// Заголовок новости.
  @JsonKey(name: 'NAME')
  final String title;

  /// Текст новости. Может содержать HTML-теги.
  @JsonKey(name: 'DETAIL_TEXT')
  final String text;

  static DateTime _dateFromJson(String date) => DateFormat('dd.MM.yyyy').parse(date);

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

  static List<String> _tagsFromJson(String tags) => tags.split(',').map((e) => e.trim()).toList();

  static String _tagsToJson(List<String> tags) => tags.join(',');

  /// Теги новости
  @JsonKey(
    fromJson: _tagsFromJson,
    name: 'TAGS',
    toJson: _tagsToJson,
    defaultValue: [],
  )
  final List<String> tags;

  /// Ссылка на страницу новости.
  @JsonKey(name: 'DETAIL_PAGE_URL')
  final String detailPageUrl;

  /// Конвертирует [RtuMireaNewsItem] в `Map<String, dynamic>`
  Map<String, dynamic> toJson() => _$RtuMireaNewsItemToJson(this);

  // to Article converter
  Article toArticle() => Article(
        title: title,
        htmlContent: text,
        publishedAt: date,
        imageUrls: images,
        categories: tags.where((element) => element.isNotEmpty).toList(),
        url: detailPageUrl,
      );

  @override
  List<Object> get props => [title, text, date, images, tags, coverImage, detailPageUrl];
}
