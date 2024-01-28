import 'dart:async';

import 'package:built_collection/built_collection.dart';
import 'package:meta/meta.dart';
import 'package:neon_framework/blocs.dart';
import 'package:neon_framework/models.dart';
import 'package:neon_framework/utils.dart';
import 'package:neon_news/src/blocs/articles.dart';
import 'package:neon_news/src/options.dart';
import 'package:nextcloud/news.dart' as news;
import 'package:rxdart/rxdart.dart';

sealed class NewsBloc implements InteractiveBloc {
  @internal
  factory NewsBloc(
    NewsOptions options,
    Account account,
  ) =>
      _NewsBloc(
        options,
        account,
      );

  void addFeed(String url, int? folderId);

  void removeFeed(int feedId);

  void renameFeed(int feedId, String feedTitle);

  void moveFeed(int feedId, int? folderId);

  void markFeedAsRead(int feedId);

  void createFolder(String name);

  void deleteFolder(int folderId);

  void renameFolder(int folderId, String name);

  void markFolderAsRead(int folderId);

  BehaviorSubject<Result<BuiltList<news.Folder>>> get folders;

  BehaviorSubject<Result<BuiltList<news.Feed>>> get feeds;

  BehaviorSubject<int> get unreadCounter;

  NewsOptions get options;

  NewsMainArticlesBloc get mainArticlesBloc;
}

class _NewsBloc extends InteractiveBloc implements NewsBloc, NewsMainArticlesBloc {
  _NewsBloc(
    this.options,
    this.account,
  ) {
    mainArticlesBloc.articles.listen((result) {
      if (result.hasData) {
        final type = mainArticlesBloc.filterType.valueOrNull;
        unreadCounter.add(result.requireData.where((a) => type == FilterType.starred ? a.starred : a.unread).length);
      }
    });

    unawaited(mainArticlesBloc.refresh());
  }

  @override
  final NewsOptions options;
  @override
  final Account account;
  @override
  late final mainArticlesBloc = NewsMainArticlesBloc(
    this,
    options,
    account,
  );

  late int newestItemId;
  @override
  int? id;
  @override
  ListType? listType;

  @override
  void dispose() {
    unawaited(feeds.close());
    unawaited(folders.close());
    unawaited(unreadCounter.close());
    unawaited(articles.close());
    unawaited(filterType.close());
    mainArticlesBloc.dispose();
    super.dispose();
  }

  @override
  BehaviorSubject<Result<BuiltList<news.Feed>>> feeds = BehaviorSubject<Result<BuiltList<news.Feed>>>();

  @override
  BehaviorSubject<Result<BuiltList<news.Folder>>> folders = BehaviorSubject<Result<BuiltList<news.Folder>>>();

  @override
  BehaviorSubject<int> unreadCounter = BehaviorSubject<int>();

  @override
  late BehaviorSubject<Result<BuiltList<news.Article>>> articles = mainArticlesBloc.articles;

  @override
  late BehaviorSubject<FilterType> filterType = mainArticlesBloc.filterType;

  @override
  Future<void> refresh() async {
    await Future.wait([
      RequestManager.instance.wrapNextcloud<BuiltList<news.Folder>, news.ListFolders, void>(
        account: account,
        cacheKey: 'news-folders',
        subject: folders,
        rawResponse: account.client.news.listFoldersRaw(),
        unwrap: (response) => response.body.folders,
      ),
      RequestManager.instance.wrapNextcloud<BuiltList<news.Feed>, news.ListFeeds, void>(
        account: account,
        cacheKey: 'news-feeds',
        subject: feeds,
        rawResponse: account.client.news.listFeedsRaw(),
        unwrap: (response) {
          if (response.body.newestItemId != null) {
            newestItemId = response.body.newestItemId!;
          }
          return response.body.feeds;
        },
      ),
      mainArticlesBloc.reload(),
    ]);
  }

  @override
  void addFeed(String url, int? folderId) {
    wrapAction(() async => account.client.news.addFeed(url: url, folderId: folderId));
  }

  @override
  void createFolder(String name) {
    wrapAction(() async => account.client.news.createFolder(name: name));
  }

  @override
  void deleteFolder(int folderId) {
    wrapAction(() async => account.client.news.deleteFolder(folderId: folderId));
  }

  @override
  void markFeedAsRead(int feedId) {
    wrapAction(() async => account.client.news.markFeedAsRead(feedId: feedId, newestItemId: newestItemId));
  }

  @override
  void markFolderAsRead(int folderId) {
    wrapAction(() async => account.client.news.markFolderAsRead(folderId: folderId, newestItemId: newestItemId));
  }

  @override
  void moveFeed(int feedId, int? folderId) {
    wrapAction(() async => account.client.news.moveFeed(feedId: feedId, folderId: folderId));
  }

  @override
  void removeFeed(int feedId) {
    wrapAction(() async => account.client.news.deleteFeed(feedId: feedId));
  }

  @override
  void renameFeed(int feedId, String feedTitle) {
    wrapAction(() async => account.client.news.renameFeed(feedId: feedId, feedTitle: feedTitle));
  }

  @override
  void renameFolder(int folderId, String name) {
    wrapAction(() async => account.client.news.renameFolder(folderId: folderId, name: name));
  }

  @override
  void markArticleAsRead(news.Article article) {
    mainArticlesBloc.markArticleAsRead(article);
  }

  @override
  void markArticleAsUnread(news.Article article) {
    mainArticlesBloc.markArticleAsUnread(article);
  }

  @override
  void setFilterType(FilterType type) {
    mainArticlesBloc.setFilterType(type);
  }

  @override
  void starArticle(news.Article article) {
    mainArticlesBloc.starArticle(article);
  }

  @override
  void unstarArticle(news.Article article) {
    mainArticlesBloc.unstarArticle(article);
  }

  @override
  Future<void> reload() async {
    await mainArticlesBloc.reload();
  }
}
