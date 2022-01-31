part of 'news_bloc.dart';

abstract class NewsState extends Equatable {
  const NewsState();

  @override
  List<Object> get props => [];
}

class NewsInitial extends NewsState {}

class NewsLoading extends NewsState {
  final bool isFirstFetch;
  final List<NewsItem> oldNews;

  const NewsLoading({required this.isFirstFetch, required this.oldNews});

  @override
  List<Object> get props => [isFirstFetch, oldNews];
}

class NewsLoaded extends NewsState {
  final List<NewsItem> news;
  final List<String> tags;

  const NewsLoaded({required this.news, required this.tags});

  @override
  List<Object> get props => [news, tags];
}

class NewsLoadError extends NewsState {}
