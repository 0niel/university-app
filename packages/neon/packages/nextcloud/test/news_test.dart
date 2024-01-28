import 'dart:async';

import 'package:nextcloud/news.dart' as news;
import 'package:nextcloud/nextcloud.dart';
import 'package:nextcloud_test/nextcloud_test.dart';
import 'package:test/test.dart';
import 'package:test_api/src/backend/invoker.dart';

void main() {
  presets(
    'news',
    'news',
    (preset) {
      late DockerContainer container;
      late NextcloudClient client;
      setUp(() async {
        container = await DockerContainer.create(preset);
        client = await TestNextcloudClient.create(container);
      });
      tearDown(() async {
        if (Invoker.current!.liveTest.errors.isNotEmpty) {
          print(await container.allLogs());
        }
        container.destroy();
      });

      Future<DynamiteResponse<news.ListFeeds, void>> addWikipediaFeed([int? folderID]) async => client.news.addFeed(
            url: 'http://localhost/static/wikipedia.xml',
            folderId: folderID,
          );

      Future<DynamiteResponse<news.ListFeeds, void>> addNasaFeed() async => client.news.addFeed(
            url: 'http://localhost/static/nasa.xml',
          );

      test('Is supported', () async {
        final result = await client.news.getVersionCheck();
        expect(result.versions, isNotNull);
        expect(result.versions, isNotEmpty);
        expect(result.isSupported, isTrue);
      });

      test('Add feed', () async {
        var response = await client.news.listFeeds();
        expect(response.statusCode, 200);
        expect(() => response.headers, isA<void>());

        expect(response.body.starredCount, 0);
        expect(response.body.newestItemId, null);
        expect(response.body.feeds, hasLength(0));

        response = await addWikipediaFeed();
        expect(response.statusCode, 200);
        expect(() => response.headers, isA<void>());

        expect(response.body.starredCount, null);
        expect(response.body.newestItemId, isNotNull);
        expect(response.body.feeds, hasLength(1));
        expect(response.body.feeds[0].url, 'http://localhost/static/wikipedia.xml');

        response = await client.news.listFeeds();
        expect(response.statusCode, 200);
        expect(() => response.headers, isA<void>());

        expect(response.body.starredCount, 0);
        expect(response.body.newestItemId, isNotNull);
        expect(response.body.feeds, hasLength(1));
        expect(response.body.feeds[0].url, 'http://localhost/static/wikipedia.xml');
      });

      test('Delete feed', () async {
        var response = await addWikipediaFeed();
        expect(response.statusCode, 200);
        expect(() => response.headers, isA<void>());

        expect(response.body.feeds, hasLength(1));

        final deleteResponse = await client.news.deleteFeed(feedId: response.body.feeds.single.id);
        expect(deleteResponse.statusCode, 200);
        expect(() => deleteResponse.body, isA<void>());
        expect(() => deleteResponse.headers, isA<void>());

        response = await client.news.listFeeds();
        expect(response.statusCode, 200);
        expect(() => response.headers, isA<void>());

        expect(response.body.feeds, hasLength(0));
      });

      test('Rename feed', () async {
        var response = await addWikipediaFeed();
        expect(response.statusCode, 200);
        expect(() => response.headers, isA<void>());

        expect(response.body.feeds[0].title, 'Wikipedia featured articles feed');

        await client.news.renameFeed(
          feedId: 1,
          feedTitle: 'test1',
        );

        response = await client.news.listFeeds();
        expect(response.statusCode, 200);
        expect(() => response.headers, isA<void>());

        expect(response.body.feeds[0].title, 'test1');
      });

      test('Move feed to folder', () async {
        await client.news.createFolder(name: 'test1');
        await addWikipediaFeed();
        await client.news.moveFeed(
          feedId: 1,
          folderId: 1,
        );

        final response = await client.news.listFolders();
        expect(response.statusCode, 200);
        expect(() => response.headers, isA<void>());

        expect(response.body.folders, hasLength(1));
        expect(response.body.folders[0].id, 1);
        expect(response.body.folders[0].name, 'test1');
        expect(response.body.folders[0].opened, true);
        expect(response.body.folders[0].feeds, hasLength(0));
      });

      test('Mark feed as read', () async {
        final feedsResponse = await addWikipediaFeed();

        var response = await client.news.listArticles(type: news.ListType.unread.index);
        expect(response.statusCode, 200);
        expect(() => response.headers, isA<void>());

        expect(response.body.items.length, greaterThan(0));

        await client.news.markFeedAsRead(
          feedId: feedsResponse.body.feeds[0].id,
          newestItemId: feedsResponse.body.newestItemId!,
        );
        expect(response.statusCode, 200);
        expect(() => response.headers, isA<void>());

        response = await client.news.listArticles(type: news.ListType.unread.index);
        expect(response.statusCode, 200);
        expect(() => response.headers, isA<void>());

        expect(response.body.items, hasLength(0));
      });

      test('List articles', () async {
        var response = await client.news.listArticles();
        expect(response.statusCode, 200);
        expect(() => response.headers, isA<void>());

        expect(response.body.items, hasLength(0));

        await addWikipediaFeed();

        response = await client.news.listArticles();
        expect(response.statusCode, 200);
        expect(() => response.headers, isA<void>());

        expect(response.body.items.length, greaterThan(0));
        expect(response.body.items[0].body, isNotNull);
        expect(response.body.items[0].feedId, 1);
        expect(response.body.items[0].unread, true);
        expect(response.body.items[0].starred, false);
      });

      test('List updated articles', () async {
        // Testing this is not easy, because we can't depend on an external source to update the feed
        // Therefore we just add a second feed and check that the articles returned after a certain modified timestamp
        // are exactly those of the new feed.
        // Now that I think of it, maybe we could host our own feed and update that way, but this works for now.

        await addWikipediaFeed();

        var response = await client.news.listArticles();
        expect(response.statusCode, 200);
        expect(() => response.headers, isA<void>());

        final wikipediaArticles = response.body.items.length;
        expect(wikipediaArticles, greaterThan(0));

        await addNasaFeed();

        response = await client.news.listArticles();
        expect(response.statusCode, 200);
        expect(() => response.headers, isA<void>());

        final nasaArticles = response.body.items.length - wikipediaArticles;
        expect(nasaArticles, greaterThan(0));

        response = await client.news.listUpdatedArticles(
          lastModified: response.body.items[response.body.items.length - 1 - nasaArticles].lastModified,
        );
        expect(response.statusCode, 200);
        expect(() => response.headers, isA<void>());

        expect(response.body.items, hasLength(nasaArticles));
      });

      test('Mark article as read', () async {
        await addWikipediaFeed();

        var response = await client.news.listArticles(type: news.ListType.unread.index);
        expect(response.statusCode, 200);
        expect(() => response.headers, isA<void>());

        final unreadArticles = response.body.items.length;
        expect(unreadArticles, greaterThan(0));

        await client.news.markArticleAsRead(
          itemId: response.body.items[0].id,
        );
        response = await client.news.listArticles(type: news.ListType.unread.index);
        expect(response.statusCode, 200);
        expect(() => response.headers, isA<void>());

        expect(response.body.items, hasLength(unreadArticles - 1));
      });

      test('Mark article as unread', () async {
        await addWikipediaFeed();

        var response = await client.news.listArticles(type: news.ListType.unread.index);
        expect(response.statusCode, 200);
        expect(() => response.headers, isA<void>());

        final readArticle = response.body.items[0];
        await client.news.markArticleAsRead(itemId: readArticle.id);
        response = await client.news.listArticles(type: news.ListType.unread.index);
        expect(response.statusCode, 200);
        expect(() => response.headers, isA<void>());

        final unreadArticles = response.body.items.length;
        expect(unreadArticles, greaterThan(0));

        await client.news.markArticleAsUnread(itemId: readArticle.id);
        response = await client.news.listArticles(type: news.ListType.unread.index);
        expect(response.statusCode, 200);
        expect(() => response.headers, isA<void>());

        expect(response.body.items, hasLength(unreadArticles + 1));
      });

      test('Star article', () async {
        await addWikipediaFeed();

        var response = await client.news.listArticles(type: news.ListType.starred.index);
        expect(response.statusCode, 200);
        expect(() => response.headers, isA<void>());

        final starredArticles = response.body.items.length;
        expect(starredArticles, 0);

        response = await client.news.listArticles();
        expect(response.statusCode, 200);
        expect(() => response.headers, isA<void>());

        await client.news.starArticle(
          itemId: response.body.items[0].id,
        );
        response = await client.news.listArticles(type: news.ListType.starred.index);
        expect(response.statusCode, 200);
        expect(() => response.headers, isA<void>());

        expect(response.body.items, hasLength(1));
      });

      test('Unstar article', () async {
        await addWikipediaFeed();

        var response = await client.news.listArticles();
        expect(response.statusCode, 200);
        expect(() => response.headers, isA<void>());

        final item = response.body.items[0];

        await client.news.starArticle(
          itemId: item.id,
        );
        response = await client.news.listArticles(type: news.ListType.starred.index);
        expect(response.statusCode, 200);
        expect(() => response.headers, isA<void>());

        expect(response.body.items, hasLength(1));

        await client.news.unstarArticle(
          itemId: item.id,
        );
        response = await client.news.listArticles(type: news.ListType.starred.index);
        expect(response.statusCode, 200);
        expect(() => response.headers, isA<void>());

        expect(response.body.items, hasLength(0));
      });

      test('Create folder', () async {
        var response = await client.news.listFolders();
        expect(response.statusCode, 200);
        expect(() => response.headers, isA<void>());

        expect(response.body.folders, hasLength(0));

        response = await client.news.createFolder(name: 'test1');
        expect(response.statusCode, 200);
        expect(() => response.headers, isA<void>());

        expect(response.body.folders, hasLength(1));
        expect(response.body.folders[0].id, 1);
        expect(response.body.folders[0].name, 'test1');
        expect(response.body.folders[0].opened, true);
        expect(response.body.folders[0].feeds, hasLength(0));

        response = await client.news.listFolders();
        expect(response.statusCode, 200);
        expect(() => response.headers, isA<void>());

        expect(response.body.folders, hasLength(1));
        expect(response.body.folders[0].id, 1);
        expect(response.body.folders[0].name, 'test1');
        expect(response.body.folders[0].opened, true);
        expect(response.body.folders[0].feeds, hasLength(0));
      });

      test('Delete folder', () async {
        var response = await client.news.createFolder(name: 'test1');
        expect(response.statusCode, 200);
        expect(() => response.headers, isA<void>());

        expect(response.body.folders, hasLength(1));

        final deleteResponse = await client.news.deleteFolder(folderId: response.body.folders.single.id);
        expect(deleteResponse.statusCode, 200);
        expect(() => deleteResponse.body, isA<void>());
        expect(() => deleteResponse.headers, isA<void>());

        response = await client.news.listFolders();
        expect(response.statusCode, 200);
        expect(() => response.headers, isA<void>());

        expect(response.body.folders, hasLength(0));
      });

      test('Rename folder', () async {
        var response = await client.news.createFolder(name: 'test1');
        expect(response.statusCode, 200);
        expect(() => response.headers, isA<void>());

        expect(response.body.folders, hasLength(1));

        final deleteResponse = await client.news.renameFolder(
          folderId: response.body.folders.single.id,
          name: 'test2',
        );
        expect(deleteResponse.statusCode, 200);
        expect(() => deleteResponse.body, isA<void>());
        expect(() => deleteResponse.headers, isA<void>());

        response = await client.news.listFolders();
        expect(response.statusCode, 200);
        expect(() => response.headers, isA<void>());

        expect(response.body.folders, hasLength(1));
        expect(response.body.folders.single.name, 'test2');
      });

      test('List folders', () async {
        var response = await client.news.listFolders();
        expect(response.statusCode, 200);
        expect(() => response.headers, isA<void>());

        expect(response.body.folders, hasLength(0));

        await client.news.createFolder(name: 'test1');
        await client.news.createFolder(name: 'test2');

        response = response = await client.news.listFolders();
        expect(response.statusCode, 200);
        expect(() => response.headers, isA<void>());

        expect(response.body.folders, hasLength(2));
        expect(response.body.folders[0].id, 1);
        expect(response.body.folders[0].name, 'test1');
        expect(response.body.folders[0].opened, true);
        expect(response.body.folders[0].feeds, hasLength(0));
        expect(response.body.folders[1].id, 2);
        expect(response.body.folders[1].name, 'test2');
        expect(response.body.folders[1].opened, true);
        expect(response.body.folders[1].feeds, hasLength(0));
      });

      test('Add feed to folder', () async {
        await client.news.createFolder(name: 'test1');
        final response = await addWikipediaFeed(1);
        expect(response.statusCode, 200);
        expect(() => response.headers, isA<void>());

        expect(response.body.starredCount, null);
        expect(response.body.newestItemId, isNotNull);
        expect(response.body.feeds, hasLength(1));
        expect(response.body.feeds[0].folderId, 1);
        expect(response.body.feeds[0].url, 'http://localhost/static/wikipedia.xml');
      });

      test('Mark folder as read', () async {
        final foldersResponse = await client.news.createFolder(name: 'test1');
        final feedsResponse = await addWikipediaFeed(1);

        var response = await client.news.listArticles(type: news.ListType.unread.index);
        expect(response.statusCode, 200);
        expect(() => response.headers, isA<void>());

        expect(response.body.items.length, greaterThan(0));

        await client.news.markFolderAsRead(
          folderId: foldersResponse.body.folders[0].id,
          newestItemId: feedsResponse.body.newestItemId!,
        );

        response = await client.news.listArticles(type: news.ListType.unread.index);
        expect(response.statusCode, 200);
        expect(() => response.headers, isA<void>());

        expect(response.body.items, hasLength(0));
      });
    },
    retry: retryCount,
    timeout: timeout,
  );
}
