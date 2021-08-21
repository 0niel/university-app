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

  NewsLoading({required this.isFirstFetch, required this.oldNews});
}

class NewsLoaded extends NewsState {
  final List<NewsItem> news;
  final List<String> tags;

  NewsLoaded({required this.news, required this.tags});
}

class NewsLoadError extends NewsState {}
