import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:lost_and_found_repository/lost_and_found_repository.dart';
import 'package:test/test.dart';

void main() {
  group('LostFoundItem', () {
    test('maps every wire field', () {
      final item = LostFoundItem.fromJson(const {
        'id': 'item-1',
        'authorId': 'user-1',
        'authorName': 'Аня К.',
        'itemName': 'Наушники AirPods',
        'description': 'Под партой в Г-407',
        'category': 'tech',
        'location': 'Г-407',
        'status': 'found',
        'images': ['user-1/a.jpg', 'user-1/b.jpg'],
        'showContact': true,
        'telegramContactInfo': '@anya_user',
        'phoneNumberContactInfo': '+70000000000',
        'createdAt': '2026-06-12T10:40:00Z',
        'isMine': true,
      });

      expect(item.id, 'item-1');
      expect(item.authorId, 'user-1');
      expect(item.authorName, 'Аня К.');
      expect(item.itemName, 'Наушники AirPods');
      expect(item.description, 'Под партой в Г-407');
      expect(item.category, 'tech');
      expect(item.location, 'Г-407');
      expect(item.status, LostFoundItemStatus.found);
      expect(item.imagePaths, ['user-1/a.jpg', 'user-1/b.jpg']);
      expect(item.showContact, isTrue);
      expect(item.telegramContactInfo, '@anya_user');
      expect(item.phoneNumberContactInfo, '+70000000000');
      expect(item.createdAt, DateTime.parse('2026-06-12T10:40:00Z'));
      expect(item.isMine, isTrue);
    });

    test('defaults only optional fields', () {
      final item = LostFoundItem.fromJson(const {
        'id': 'item-1',
        'authorId': 'user-1',
        'itemName': 'Наушники',
        'status': 'lost',
        'createdAt': '2026-06-12T10:40:00Z',
      });

      expect(item.authorName, '');
      expect(item.description, isNull);
      expect(item.category, 'other');
      expect(item.location, '');
      expect(item.imagePaths, isEmpty);
      expect(item.imageUrls, isEmpty);
      expect(item.showContact, isFalse);
      expect(item.telegramContactInfo, isNull);
      expect(item.phoneNumberContactInfo, isNull);
      expect(item.isMine, isFalse);
    });

    test('rejects missing identity and malformed enum fields', () {
      expect(
        () => LostFoundItem.fromJson(const {}),
        throwsA(isA<CheckedFromJsonException>()),
      );
      expect(
        () => LostFoundItem.fromJson(const {
          'id': 'item-1',
          'authorId': 'user-1',
          'itemName': 'Наушники',
          'status': 'unknown',
          'createdAt': '2026-06-12T10:40:00Z',
        }),
        throwsA(isA<CheckedFromJsonException>()),
      );
    });

    test('uses signed URLs without losing storage paths', () {
      final item = LostFoundItem(
        id: 'item-1',
        authorId: 'user-1',
        itemName: 'AirPods',
        status: .found,
        createdAt: DateTime.utc(2026),
        imagePaths: const ['user-1/a.jpg'],
      );

      expect(item.images, ['user-1/a.jpg']);
      final signed = item.copyWith(imageUrls: ['https://signed.test/a.jpg']);
      expect(signed.images, ['https://signed.test/a.jpg']);
      expect(signed.imagePaths, ['user-1/a.jpg']);
    });
  });
}
