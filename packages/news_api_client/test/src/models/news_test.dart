import 'dart:convert';

import 'package:news_api_client/api_client.dart';
import 'package:test/test.dart';

void main() {
  group('News', () {
    test('can be (de)serialized', () {
      final news = NewsResponse(
        title: 'title',
        text: 'text',
        coverImage: 'https://localhost/png.png',
        images: const ['1', 'qwe', 'asd'],
        date: DateTime(2023, 1, 9),
        tags: const [
          'hello',
          'world',
        ],
      );

      expect(NewsResponse.fromJson(news.toJson()), equals(news));
    });

    test('can be deserialized from raw text', () {
      const raw = '''
        {
          "NAME": "Test title",
          "DATE_ACTIVE_FROM": "19.09.2023",
          "DETAIL_TEXT": "Hello world",
          "DETAIL_PICTURE": "https://www.mirea.ru/IMG.jpeg",
          "TAGS": "студентам, спорт, достижения Университета",
          "PROPERTY_MY_GALLERY_VALUE": [
            "https://www.mirea.ru/IMG.jpeg"
          ],
          "ACTIVE_FROM": "19.09.2023"
        }
      ''';

      final news = NewsResponse(
        title: 'Test title',
        text: 'Hello world',
        coverImage: 'https://www.mirea.ru/IMG.jpeg',
        images: const ['https://www.mirea.ru/IMG.jpeg'],
        date: DateTime(2023, 9, 19),
        tags: const ['студентам', 'спорт', 'достижения Университета'],
      );

      expect(
        NewsResponse.fromJson(jsonDecode(raw) as Map<String, dynamic>),
        equals(news),
      );
    });
  });
}
