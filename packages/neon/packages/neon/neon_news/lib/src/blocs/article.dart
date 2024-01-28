import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:meta/meta.dart';
import 'package:neon_framework/blocs.dart';
import 'package:neon_framework/models.dart';
import 'package:neon_news/src/blocs/articles.dart';
import 'package:nextcloud/news.dart' as news;
import 'package:rxdart/rxdart.dart';

sealed class NewsArticleBloc implements InteractiveBloc {
  @internal
  factory NewsArticleBloc(
    NewsArticlesBloc articlesBloc,
    Account account,
    news.Article article,
  ) =>
      _NewsArticleBloc(
        articlesBloc,
        account,
        article,
      );

  void markArticleAsRead();

  void markArticleAsUnread();

  void starArticle();

  void unstarArticle();

  BehaviorSubject<bool> get unread;

  BehaviorSubject<bool> get starred;
}

class _NewsArticleBloc extends InteractiveBloc implements NewsArticleBloc {
  _NewsArticleBloc(
    this.newsArticlesBloc,
    this.account,
    news.Article article,
  ) {
    id = article.id;
    unread.add(article.unread);
    starred.add(article.starred);
  }

  final NewsArticlesBloc newsArticlesBloc;
  final Account account;

  late final int id;

  @override
  void dispose() {
    unawaited(starred.close());
    unawaited(unread.close());
    super.dispose();
  }

  @override
  BehaviorSubject<bool> starred = BehaviorSubject<bool>();

  @override
  BehaviorSubject<bool> unread = BehaviorSubject<bool>();

  @override
  Future<void> refresh() async {}

  @override
  void markArticleAsRead() {
    wrapArticleAction(() async {
      await account.client.news.markArticleAsRead(itemId: id);
      unread.add(false);
    });
  }

  @override
  void markArticleAsUnread() {
    wrapArticleAction(() async {
      await account.client.news.markArticleAsUnread(itemId: id);
      unread.add(true);
    });
  }

  @override
  void starArticle() {
    wrapArticleAction(() async {
      await account.client.news.starArticle(itemId: id);
      starred.add(true);
    });
  }

  @override
  void unstarArticle() {
    wrapArticleAction(() async {
      await account.client.news.unstarArticle(itemId: id);
      starred.add(false);
    });
  }

  void wrapArticleAction(AsyncCallback call) => wrapAction(
        call,
        refresh: () async {
          await newsArticlesBloc.refresh();
        },
      );
}
