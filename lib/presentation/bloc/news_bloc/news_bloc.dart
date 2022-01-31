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
  }) : super(NewsInitial()) {
    on<NewsLoadEvent>(_onNewsLoadEvent);
  }

  final GetNews getNews;
  final GetNewsTags getNewsTags;

  bool _isFirstFetch = true;
  int _offset = 0;
  String? _selectedTag;

  void _onNewsLoadEvent(NewsLoadEvent event, Emitter<NewsState> emit) async {
    if (state is NewsLoading) return;

    final bool refresh = event.refresh ?? false;
    if (refresh) {
      _isFirstFetch = true;
      _offset = 0;
    }

    List<String> tagsList = [];
    List<NewsItem> oldNews = [];

    // True if the tag list failed to load
    bool hasFetchError = false;

    if (_isFirstFetch) {
      emit(NewsLoading(oldNews: oldNews, isFirstFetch: true));
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
      emit(NewsLoading(oldNews: oldNews, isFirstFetch: false));
    }

    if (hasFetchError) {
      emit(NewsLoadError());
      return;
    }

    if (event.tag == "все") {
      _selectedTag = null;
    } else {
      if ((event.tag != null)) {
        if (_selectedTag == null ||
            (_selectedTag != null && event.tag != _selectedTag)) {
          _selectedTag = event.tag;
        }
      }
    }

    final news = await getNews(GetNewsParams(
        offset: _offset,
        limit: 10,
        isImportant: event.isImportant,
        tag: _selectedTag));
    emit(news.fold((failure) => NewsLoadError(), (r) {
      List<NewsItem> newNews = List.from(oldNews)..addAll(r);
      _offset += r.length;
      return NewsLoaded(news: newNews, tags: tagsList);
    }));
  }
}
