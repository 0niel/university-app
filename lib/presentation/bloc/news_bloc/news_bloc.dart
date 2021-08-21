import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:rtu_mirea_app/domain/entities/news_item.dart';
import 'package:rtu_mirea_app/domain/usecases/get_news.dart';
import 'package:rtu_mirea_app/domain/usecases/get_news_tags.dart';

part 'news_event.dart';
part 'news_state.dart';

class NewsBloc extends Bloc<NewsEvent, NewsState> {
  NewsBloc({
    required this.getNews,
    required this.getNewsTags,
  }) : super(NewsInitial());

  final GetNews getNews;
  final GetNewsTags getNewsTags;

  bool _isFirstFetch = true;
  int _offset = 0;

  @override
  Stream<NewsState> mapEventToState(
    NewsEvent event,
  ) async* {
    if (event is NewsLoadEvent) {
      List<String> tagsList = [];
      List<NewsItem> oldNews = [];

      bool hasFetchError = false;

      if (_isFirstFetch) {
        yield NewsLoading(oldNews: oldNews, isFirstFetch: true);
        _isFirstFetch = false;
        final tags = await getNewsTags();
        tags.fold((failure) {
          hasFetchError = true;
        }, (r) {
          tagsList = r;
        });
      } else {
        if (state is NewsLoaded) {
          tagsList = (state as NewsLoaded).tags;
          oldNews = (state as NewsLoaded).news;
        }
        yield NewsLoading(oldNews: oldNews, isFirstFetch: false);
      }

      if (hasFetchError) {
        yield NewsLoadError();
        return;
      }

      final news = await getNews(GetNewsParams(offset: _offset, limit: 10));
      yield news.fold((failure) => NewsLoadError(), (r) {
        _offset += r.length - 1;
        List<NewsItem> newNews = List.from(oldNews)..addAll(r);
        return NewsLoaded(news: newNews, tags: tagsList);
      });
    }
  }
}
