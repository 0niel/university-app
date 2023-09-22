import 'package:intl/intl.dart';
import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'news_response.g.dart';

/// {@template news_response}
/// Ответ на запрос новости
/// {@endtemplate}
@JsonSerializable()
class NewsResponse extends Equatable {
  /// {@macro news_response}
  const NewsResponse({
    required this.title,
    required this.text,
    required this.date,
    required this.images,
    required this.tags,
    required this.coverImage,
  });

  /// Конвертирует `Map<String, dynamic>` в [NewsResponse]
  factory NewsResponse.fromJson(Map<String, dynamic> json) =>
      _$NewsResponseFromJson(json);

  /// Заголовок новости.
  @JsonKey(name: 'NAME')
  final String title;

  /// Текст новости. Может содержать HTML-теги.
  @JsonKey(name: 'DETAIL_TEXT')
  final String text;

  static DateTime _dateFromJson(String date) =>
      DateFormat('dd.MM.yyyy').parse(date);

  static String _dateToJson(DateTime date) =>
      DateFormat('dd.MM.yyyy').format(date);

  /// Дата публикации новости.
  @JsonKey(
      name: 'DATE_ACTIVE_FROM', fromJson: _dateFromJson, toJson: _dateToJson,)
  final DateTime date;

  /// Ссылки на изображения новости.
  @JsonKey(name: 'PROPERTY_MY_GALLERY_VALUE')
  final List<String> images;

  /// Обложка новости.
  @JsonKey(name: 'DETAIL_PICTURE')
  final String coverImage;

  static List<String> _tagsFromJson(String tags) =>
      tags.split(',').map((e) => e.trim()).toList();

  static String _tagsToJson(List<String> tags) => tags.join(',');

  /// Теги новости
  @JsonKey(fromJson: _tagsFromJson, name: 'TAGS', toJson: _tagsToJson)
  final List<String> tags;

  /// Конвертирует [NewsResponse] в `Map<String, dynamic>`
  Map<String, dynamic> toJson() => _$NewsResponseToJson(this);

  @override
  List<Object> get props => [title, text, date, images, tags];
}
