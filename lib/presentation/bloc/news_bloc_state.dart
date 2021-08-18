import 'package:equatable/equatable.dart';
import 'package:news_page/domain/models/news.dart';
import 'package:news_page/domain/models/tag.dart';

class NewsState extends Equatable {
  final List<News_model> news;
  final List<Tag> tags;
  final int offset;
  NewsState({
    this.news = const [],
    this.offset = 0,
    this.tags = const [],
  });

  @override
  List<Object> get props => [news, tags, offset];
}

class NewsSearch extends NewsState {
  final List<News_model> news;
  final List<Tag> tags;
  final int offset;

  NewsSearch({
    required this.news,
    required this.offset,
    required this.tags,
  });

  @override
  List<Object> get props => [];
}

class NewsSearchInitial extends NewsState {
  @override
  List<Object> get props => [];
}
