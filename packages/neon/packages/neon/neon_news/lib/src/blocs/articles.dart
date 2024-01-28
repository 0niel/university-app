import 'dart:async';

import 'package:built_collection/built_collection.dart';
import 'package:meta/meta.dart';
import 'package:neon_framework/blocs.dart';
import 'package:neon_framework/models.dart';
import 'package:neon_framework/utils.dart';
import 'package:neon_news/src/blocs/news.dart';
import 'package:neon_news/src/options.dart';
import 'package:nextcloud/news.dart' as news;
import 'package:rxdart/rxdart.dart';

enum FilterType {
  all,
  unread,
  starred,
}

enum ListType {
  feed,
  folder,
}

sealed class NewsArticlesBloc implements InteractiveBloc {
  @internal
  factory NewsArticlesBloc(
    NewsBloc newsBloc,
    NewsOptions options,
    Account account, {
    int? id,
    ListType? listType,
  }) =>
      _NewsArticlesBloc(
        newsBloc,
        options,
        account,
        id: id,
        listType: listType,
      );

  void setFilterType(FilterType type);

  void markArticleAsRead(news.Article article);

  void markArticleAsUnread(news.Article article);

  void starArticle(news.Article article);

  void unstarArticle(news.Article article);

  BehaviorSubject<Result<BuiltList<news.Article>>> get articles;

  BehaviorSubject<FilterType> get filterType;

  NewsOptions get options;

  ListType? get listType;
}

class NewsMainArticlesBloc extends _NewsArticlesBloc {
  NewsMainArticlesBloc(
    super._newsBloc,
    super.options,
    super.account,
  );
}

class _NewsArticlesBloc extends InteractiveBloc implements NewsArticlesBloc {
  _NewsArticlesBloc(
    this._newsBloc,
    this.options,
    this.account, {
    this.id,
    this.listType,
  }) {
    filterType.add(options.defaultArticlesFilterOption.value);
    if (listType != null && filterType.value == FilterType.starred) {
      filterType.add(FilterType.all);
    }

    if (this is! NewsMainArticlesBloc) {
      unawaited(refresh());
    }
  }

  final NewsBloc _newsBloc;
  @override
  final NewsOptions options;
  final Account account;
  final int? id;
  @override
  final ListType? listType;

  @override
  void dispose() {
    unawaited(articles.close());
    unawaited(filterType.close());
    super.dispose();
  }

  @override
  BehaviorSubject<Result<BuiltList<news.Article>>> articles = BehaviorSubject<Result<BuiltList<news.Article>>>();

  @override
  BehaviorSubject<FilterType> filterType = BehaviorSubject<FilterType>();

  @override
  Future<void> refresh() async {
    if (this is! NewsMainArticlesBloc) {
      await reload();
    }
    await _newsBloc.refresh();
  }

  Future<void> reload() async {
    // The API for pagination is pretty useless in this case sadly. So no pagination for us :(
    // https://github.com/nextcloud/news/blob/master/docs/api/api-v1-2.md#get-items

    // https://github.com/nextcloud/news/blob/48ee5ce4d135da20079961a62ae37958d6a6b628/lib/Db/ListType.php#L21
    late final news.ListType type;
    bool? getRead;
    if (listType != null) {
      switch (filterType.value) {
        case FilterType.all:
          break;
        case FilterType.unread:
          getRead = false;
        default:
          throw Exception('FilterType ${filterType.value} not allowed');
      }
    }
    switch (listType) {
      case ListType.feed:
        type = news.ListType.feed;
      case ListType.folder:
        type = news.ListType.folder;
      case null:
        switch (filterType.value) {
          case FilterType.starred:
            type = news.ListType.starred;
          case FilterType.all:
            type = news.ListType.allItems;
          case FilterType.unread:
            type = news.ListType.unread;
        }
    }

    await RequestManager.instance.wrapNextcloud<BuiltList<news.Article>, news.ListArticles, void>(
      account: account,
      cacheKey: 'news-articles-${type.index}-$id-$getRead',
      subject: articles,
      rawResponse: account.client.news.listArticlesRaw(
        type: type.index,
        id: id ?? 0,
        getRead: getRead ?? true ? 1 : 0,
      ),
      unwrap: (response) => response.body.items,
    );
  }

  @override
  void markArticleAsRead(news.Article article) {
    wrapAction(() async => account.client.news.markArticleAsRead(itemId: article.id));
  }

  @override
  void markArticleAsUnread(news.Article article) {
    wrapAction(() async => account.client.news.markArticleAsUnread(itemId: article.id));
  }

  @override
  void setFilterType(FilterType type) {
    wrapAction(() async => filterType.add(type));
  }

  @override
  void starArticle(news.Article article) {
    wrapAction(() async => account.client.news.starArticle(itemId: article.id));
  }

  @override
  void unstarArticle(news.Article article) {
    wrapAction(() async => account.client.news.unstarArticle(itemId: article.id));
  }
}
