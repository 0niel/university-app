import 'package:equatable/equatable.dart';

import 'package:rtu_mirea_app/domain/entities/strapi_media.dart';

class Story extends Equatable {
  const Story({
    required this.title,
    required this.pages,
    required this.stopShowDate,
    required this.preview,
    required this.author,
    required this.publishedAt,
  });

  final String title;
  final List<StoryPage> pages;
  final StrapiMedia preview;
  final Author author;
  final DateTime stopShowDate;
  final DateTime publishedAt;

  @override
  List<Object> get props {
    return [
      title,
      pages,
      stopShowDate,
      preview,
      author,
      publishedAt,
    ];
  }
}

class StoryPage extends Equatable {
  const StoryPage({
    required this.title,
    required this.text,
    required this.media,
    required this.actions,
  });

  final String? title;
  final String? text;
  final StrapiMedia media;
  final List<StoryPageAction> actions;

  @override
  List<Object> get props => [media, actions];
}

class Author extends Equatable {
  const Author({
    required this.name,
    required this.url,
    required this.logo,
  });

  final String name;
  final String url;
  final StrapiMedia logo;

  @override
  List<Object> get props => [name, url, logo];
}

class StoryPageAction extends Equatable {
  final String title;
  final String url;

  const StoryPageAction({
    required this.title,
    required this.url,
  });

  @override
  List<Object?> get props => [title, url];
}
