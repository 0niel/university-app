part of 'news_bloc.dart';

abstract class NewsState extends Equatable {
  const NewsState();

  @override
  List<Object> get props => [];
}

class NewsInitial extends NewsState {}

class NewsLoading extends NewsState {
  final bool isFirstFetch;

  const NewsLoading({required this.isFirstFetch});

  @override
  List<Object> get props => [isFirstFetch];
}

class NewsLoaded extends NewsState {
  final List<NewsItem> news;
  final List<String> tags;
  final String? selectedTag;

  final int page;

  const NewsLoaded({
    required this.news,
    required this.tags,
    this.selectedTag,
    required this.page,
  });

  @override
  List<Object> get props => [news, tags, page];
}

class NewsLoadError extends NewsState {}
