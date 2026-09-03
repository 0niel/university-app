import 'package:news_blocks/news_blocks.dart';
import 'package:news_repository/news_repository.dart';
import 'package:test/test.dart';

void main() {
  group('NewsRepository.getFeed', () {
    test('video-only items preserve article identity in the feed', () async {
      final repository = NewsRepository(
        dataSource: _FakeNewsRemoteDataSource(
          feed: [
            {
              ..._feedItem(),
              'newsBlocks': [
                {
                  'type': '__video__',
                  'video_url': 'https://cdn.example/story.mp4',
                },
              ],
            },
          ],
        ),
        organizationId: 'university',
      );
      final response = await repository.getFeed();
      final post = response.feed.single as PostBlock;
      expect(post.id, 'article-id');
      expect(
        post.action,
        const NavigateToArticleAction(articleId: 'article-id'),
      );
    });

    test(
      'raw Telegram IDs and videos are not rendered as image URLs',
      () async {
        for (final invalid in [
          'story:42',
          '123456789',
          'https://cdn.example/story.mp4',
        ]) {
          final repository = NewsRepository(
            dataSource: _FakeNewsRemoteDataSource(
              feed: [
                {
                  ..._feedItem(),
                  'newsBlocks': [
                    {'type': '__article_introduction__', 'image_url': invalid},
                  ],
                },
              ],
            ),
            organizationId: 'university',
          );
          final response = await repository.getFeed();
          expect((response.feed.single as PostBlock).imageUrl, isNull);
        }
      },
    );

    test('uses the total count returned by the RPC', () async {
      final dataSource = _FakeNewsRemoteDataSource(
        feed: [_feedItem(totalCount: 42)],
      );
      final repository = NewsRepository(
        dataSource: dataSource,
        organizationId: 'university',
      );

      final response = await repository.getFeed(offset: 20);

      expect(response.totalCount, 42);
      expect(response.feed, hasLength(1));
      final [feedItem] = response.feed;
      expect(feedItem, isA<PostSmallBlock>());
      expect(dataSource.lastOrganizationId, 'university');
      expect(dataSource.lastOffset, 20);
    });

    test('falls back to the observed count for an old RPC response', () async {
      final repository = NewsRepository(
        dataSource: _FakeNewsRemoteDataSource(feed: [_feedItem()]),
        organizationId: 'university',
      );

      final response = await repository.getFeed(offset: 20);

      expect(response.totalCount, 21);
    });

    test('wraps invalid wire data without losing its type', () async {
      final repository = NewsRepository(
        dataSource: _FakeNewsRemoteDataSource(
          feed: [
            {'id': 'invalid'},
          ],
        ),
        organizationId: 'university',
      );

      await expectLater(repository.getFeed(), throwsA(isA<GetFeedFailure>()));
    });

    test('does not hide an unexpected top-level RPC response', () async {
      final repository = NewsRepository(
        dataSource: _FakeNewsRemoteDataSource(feed: {'items': <Object?>[]}),
        organizationId: 'university',
      );

      await expectLater(repository.getFeed(), throwsA(isA<GetFeedFailure>()));
    });
  });

  test('getCategories skips the type tab for a single source type', () async {
    final repository = NewsRepository(
      dataSource: _FakeNewsRemoteDataSource(
        categories: [
          {
            'sourceType': 'telegram',
            'sourceId': 'first',
            'sourceName': 'First',
          },
          {
            'sourceType': 'telegram',
            'sourceId': 'second',
            'sourceName': 'Second',
          },
        ],
      ),
      organizationId: 'university',
    );

    final response = await repository.getCategories();

    expect(response.categories.map((category) => category.id), [
      'all',
      'source:telegram:first',
      'source:telegram:second',
    ]);
    expect(response.sources, hasLength(2));
  });

  test('getCategories adds de-duplicated type tabs for mixed types', () async {
    final repository = NewsRepository(
      dataSource: _FakeNewsRemoteDataSource(
        categories: [
          {
            'sourceType': 'telegram',
            'sourceId': 'first',
            'sourceName': 'First',
          },
          {
            'sourceType': 'telegram',
            'sourceId': 'second',
            'sourceName': 'Second',
          },
          {
            'sourceType': 'official',
            'sourceId': 'site',
            'sourceName': 'Site',
          },
        ],
      ),
      organizationId: 'university',
    );

    final response = await repository.getCategories();

    expect(response.categories.map((category) => category.id), [
      'all',
      'telegram',
      'official',
      'source:telegram:first',
      'source:telegram:second',
      'source:official:site',
    ]);
    final telegramTab = response.categories.firstWhere(
      (category) => category.id == 'telegram',
    );
    expect(telegramTab.name, 'Telegram');
  });
}

Map<String, Object?> _feedItem({int? totalCount}) {
  return {
    'id': 'article-id',
    'title': 'Article',
    'publishedAt': '2026-07-10T10:00:00.000Z',
    'sourceName': 'University',
    'sourceType': 'website',
    'sourceId': 'official',
    'newsBlocks': <Map<String, Object?>>[],
    'totalCount': ?totalCount,
  };
}

final class _FakeNewsRemoteDataSource implements NewsRemoteDataSource {
  _FakeNewsRemoteDataSource({this.feed = const [], this.categories = const []});

  final Object? feed;
  final Object? categories;
  String? lastOrganizationId;
  int? lastOffset;

  @override
  Future<Object?> fetchFeed({
    required String organizationId,
    required String category,
    required int limit,
    required int offset,
  }) async {
    lastOrganizationId = organizationId;
    lastOffset = offset;
    return feed;
  }

  @override
  Future<Object?> fetchCategories({required String organizationId}) async {
    lastOrganizationId = organizationId;
    return categories;
  }
}
