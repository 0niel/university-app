import 'package:campus_repository/campus_repository.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:test/test.dart';

void main() {
  group('MarketListing', () {
    test('fromJson maps all fields', () {
      final m = MarketListing.fromJson(const <String, dynamic>{
        'id': 'm1',
        'title': 'Laptop',
        'price': 5000,
        'description': 'desc',
        'category': 'electronics',
        'emoji': '💻',
        'isSold': true,
        'isFree': false,
        'createdAt': '2026-01-02T03:04:05Z',
        'isMine': true,
        'sellerName': 'Ivan',
        'showContact': true,
        'telegramHandle': 'ivan_dev',
        'media': [
          {
            'path': 'user-1/a.jpg',
            'kind': 'image',
            'width': 800,
            'height': 600,
          },
          {'path': 'user-1/b.mp4', 'kind': 'video', 'duration': 12},
        ],
      });

      expect(m.id, 'm1');
      expect(m.title, 'Laptop');
      expect(m.price, 5000);
      expect(m.description, 'desc');
      expect(m.category, 'electronics');
      expect(m.emoji, '💻');
      expect(m.isSold, isTrue);
      expect(m.isFree, isFalse);
      expect(m.createdAt, isNotNull);
      expect(m.isMine, isTrue);
      expect(m.sellerName, 'Ivan');
      expect(m.showContact, isTrue);
      expect(m.telegramHandle, 'ivan_dev');
      expect(m.media, hasLength(2));
      expect(m.media.first.kind, MarketMediaKind.image);
      expect(m.media.last.kind, MarketMediaKind.video);
      expect(m.media.last.duration, 12);
      expect(m.cover, m.media.first);
    });

    test('fromJson defaults optional fields', () {
      final m = MarketListing.fromJson(const <String, dynamic>{
        'id': 'm1',
        'title': 'Laptop',
        'price': 5000,
      });
      expect(m.description, '');
      expect(m.category, 'other');
      expect(m.emoji, '📦');
      expect(m.isSold, isFalse);
      expect(m.isFree, isFalse);
      expect(m.createdAt, isNull);
      expect(m.isMine, isFalse);
      expect(m.sellerName, '');
      expect(m.showContact, isFalse);
      expect(m.telegramHandle, isNull);
      expect(m.media, isEmpty);
      expect(m.cover, isNull);
    });

    test('fromJson rejects missing identity and price fields', () {
      expect(
        () => MarketListing.fromJson(const <String, dynamic>{}),
        throwsA(isA<CheckedFromJsonException>()),
      );
    });

    test('missing, null and non-list media decode as an empty collection', () {
      for (final media in <Object?>[null, 'legacy', 42, <String, Object?>{}]) {
        final listing = MarketListing.fromJson({
          'id': 'm1',
          'title': 'Book',
          'price': 100,
          'media': media,
        });
        expect(listing.media, isEmpty);
        expect(listing.cover, isNull);
      }
    });

    test('media skips non-map entries and accepts object-keyed maps', () {
      final listing = MarketListing.fromJson({
        'id': 'm1',
        'title': 'Book',
        'price': 100,
        'media': <Object?>[
          null,
          'legacy',
          42,
          <Object?, Object?>{'path': 'owner/image.jpg', 'kind': 'image'},
          <Object?, Object?>{'path': 'owner/video.mp4', 'kind': 'video'},
        ],
      });
      expect(listing.media.map((item) => item.path), [
        'owner/image.jpg',
        'owner/video.mp4',
      ]);
      expect(listing.cover, listing.media.first);
      expect(listing.toJson()['media'], isA<List<Map<String, Object?>>>());
      expect(MarketListing.fromJson(listing.toJson()), listing);
    });

    test('isFree comes from the server flag, not a client computation', () {
      expect(
        MarketListing.fromJson(
          const {'id': 'm1', 'title': 'Gift', 'price': 0, 'isFree': true},
        ).isFree,
        isTrue,
      );
      expect(
        MarketListing.fromJson(
          const {'id': 'm2', 'title': 'Book', 'price': 100},
        ).isFree,
        isFalse,
      );
    });

    test('round-trips through toJson', () {
      const listing = MarketListing(
        id: 'm1',
        title: 'Book',
        price: 0,
        isFree: true,
        telegramHandle: 'seller',
        media: [
          MarketMediaItem(path: 'user-1/a.jpg', kind: MarketMediaKind.image),
        ],
      );
      expect(MarketListing.fromJson(listing.toJson()), listing);
      expect(listing.toJson()['media'], isA<List<Map<String, Object?>>>());
    });
  });

  group('MarketMediaItem', () {
    test('fromJson maps kind and dimensions', () {
      final item = MarketMediaItem.fromJson(const {
        'path': 'user-1/clip.mp4',
        'kind': 'video',
        'width': 1080,
        'height': 1920,
        'duration': 45,
      });
      expect(item.path, 'user-1/clip.mp4');
      expect(item.kind, MarketMediaKind.video);
      expect(item.isVideo, isTrue);
      expect(item.width, 1080);
      expect(item.height, 1920);
      expect(item.duration, 45);
      expect(item.url, '');
    });

    test('the resolved url is never serialized', () {
      const item = MarketMediaItem(
        path: 'user-1/a.jpg',
        kind: MarketMediaKind.image,
        url: 'https://cdn.example/user-1/a.jpg',
      );
      expect(item.toJson(), isNot(contains('url')));
    });
  });
}
